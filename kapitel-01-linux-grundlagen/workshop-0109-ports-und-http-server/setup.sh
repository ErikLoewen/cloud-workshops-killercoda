#!/usr/bin/env bash
set -Eeuo pipefail

python3 - <<'PY'
from __future__ import annotations

import errno
import os
from pathlib import Path
import shutil
import signal
import socket
import subprocess
import sys
import time
import urllib.request

LOCAL_OPENER = urllib.request.build_opener(urllib.request.ProxyHandler({}))

LAB_ROOT = Path("/root/httplabor")
DEMO_DIR = LAB_ROOT / "demo"
FINAL_DIR = LAB_ROOT / "abschluss"
FINAL_FILE = FINAL_DIR / "index.html"
STATE_DIR = Path("/var/lib/labforge/ports-und-http-server")
DEMO_LOG = STATE_DIR / "demo-server.log"
DEMO_PID = STATE_DIR / "demo-server.pid"
DEMO_SID = STATE_DIR / "demo-server.sid"

DEMO_BYTES = b"Demo-Server erreichbar\n"
DEMO_PORT = 8000
FINAL_PORT = 8080
LOOPBACK = "127.0.0.1"


class SetupError(RuntimeError):
    pass


def fail(message: str) -> None:
    raise SetupError(message)


def require_command(name: str) -> str:
    path = shutil.which(name)
    if not path:
        fail(f"Technischer Umgebungsfehler: Der benötigte Befehl '{name}' fehlt.")
    return path


def remove_path(path: Path) -> None:
    if not path.exists() and not path.is_symlink():
        return
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def proc_cmdline(pid: int) -> list[str] | None:
    try:
        data = Path(f"/proc/{pid}/cmdline").read_bytes()
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        return None
    return [part.decode(errors="replace") for part in data.split(b"\0") if part]


def proc_cwd(pid: int) -> str | None:
    try:
        return os.readlink(f"/proc/{pid}/cwd")
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        return None


def proc_session(pid: int) -> int | None:
    try:
        return os.getsid(pid)
    except (ProcessLookupError, PermissionError):
        return None


def parse_tcp_table(path: Path, port: int) -> list[tuple[str, str]]:
    listeners: list[tuple[str, str]] = []
    if not path.exists():
        return listeners
    lines = path.read_text(encoding="ascii", errors="replace").splitlines()[1:]
    wanted_port = f"{port:04X}"
    for line in lines:
        fields = line.split()
        if len(fields) < 10:
            continue
        local_hex = fields[1]
        state = fields[3]
        inode = fields[9]
        try:
            address_hex, port_hex = local_hex.split(":")
        except ValueError:
            continue
        if state == "0A" and port_hex.upper() == wanted_port:
            listeners.append((address_hex.upper(), inode))
    return listeners


def listener_records(port: int) -> list[dict[str, str]]:
    records: list[dict[str, str]] = []
    for address_hex, inode in parse_tcp_table(Path("/proc/net/tcp"), port):
        if address_hex == "0100007F":
            address = "127.0.0.1"
        elif address_hex == "00000000":
            address = "0.0.0.0"
        else:
            address = f"IPv4:{address_hex}"
        records.append({"family": "ipv4", "address": address, "inode": inode})
    for address_hex, inode in parse_tcp_table(Path("/proc/net/tcp6"), port):
        if address_hex == "0" * 32:
            address = "[::]"
        else:
            address = f"IPv6:{address_hex}"
        records.append({"family": "ipv6", "address": address, "inode": inode})
    return records


def inode_owners(inodes: set[str]) -> dict[str, set[int]]:
    owners = {inode: set() for inode in inodes}
    if not inodes:
        return owners
    for proc_dir in Path("/proc").iterdir():
        if not proc_dir.name.isdigit():
            continue
        pid = int(proc_dir.name)
        fd_dir = proc_dir / "fd"
        try:
            entries = list(fd_dir.iterdir())
        except (FileNotFoundError, PermissionError, ProcessLookupError):
            continue
        for fd in entries:
            try:
                target = os.readlink(fd)
            except (FileNotFoundError, PermissionError, ProcessLookupError):
                continue
            if target.startswith("socket:[") and target.endswith("]"):
                inode = target[8:-1]
                if inode in owners:
                    owners[inode].add(pid)
    return owners


def has_adjacent(tokens: list[str], first: str, second: str) -> bool:
    return any(tokens[i] == first and tokens[i + 1] == second for i in range(len(tokens) - 1))


def has_option_argument(tokens: list[str], option: str, argument: str) -> bool:
    return any(tokens[i] == option and tokens[i + 1] == argument for i in range(len(tokens) - 1))


def is_own_lab_server(pid: int, expected_dir: Path, port: int) -> bool:
    tokens = proc_cmdline(pid)
    cwd = proc_cwd(pid)
    if not tokens or cwd != str(expected_dir):
        return False
    executable = Path(tokens[0]).name.lower()
    python_process = executable.startswith("python")
    return (
        python_process
        and has_adjacent(tokens, "-m", "http.server")
        and has_option_argument(tokens, "--bind", LOOPBACK)
        and str(port) in tokens
    )


def terminate_confirmed_old_server(port: int, expected_dir: Path) -> None:
    records = listener_records(port)
    if not records:
        return

    inodes = {record["inode"] for record in records}
    owners = inode_owners(inodes)
    pids = set().union(*(owners[inode] for inode in inodes))

    if not pids:
        fail(
            f"Technischer Umgebungsfehler: Port {port} ist belegt, "
            "der zugehörige Prozess konnte aber nicht sicher ermittelt werden."
        )

    if any(record["address"] != LOOPBACK for record in records):
        fail(
            f"Technischer Umgebungsfehler: Port {port} ist durch einen nicht eindeutig "
            "lokalen Listener belegt. Es wird kein fremder Prozess beendet."
        )

    if not all(is_own_lab_server(pid, expected_dir, port) for pid in pids):
        fail(
            f"Technischer Umgebungsfehler: Port {port} ist durch einen fremden oder "
            "nicht eindeutig zuordenbaren Prozess belegt. Es wird kein Prozess beendet."
        )

    for pid in sorted(pids):
        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            continue

    deadline = time.monotonic() + 3.0
    while time.monotonic() < deadline:
        if not listener_records(port):
            return
        time.sleep(0.1)

    fail(
        f"Technischer Umgebungsfehler: Eine eindeutig eigene alte Laborinstanz auf "
        f"Port {port} konnte nicht sauber beendet werden."
    )


def assert_loopback_usable() -> None:
    probe = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        probe.bind((LOOPBACK, 0))
    except OSError as exc:
        fail(f"Technischer Umgebungsfehler: {LOOPBACK} ist lokal nicht nutzbar: {exc}")
    finally:
        probe.close()


def assert_port_free(port: int) -> None:
    if listener_records(port):
        fail(f"Technischer Umgebungsfehler: Port {port} ist weiterhin belegt.")
    probe = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    probe.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        probe.bind((LOOPBACK, port))
    except OSError as exc:
        fail(f"Technischer Umgebungsfehler: Port {port} ist nicht verfügbar: {exc}")
    finally:
        probe.close()


def exact_loopback_listener(port: int, pid: int) -> bool:
    records = listener_records(port)
    if len(records) != 1:
        return False
    record = records[0]
    if record["family"] != "ipv4" or record["address"] != LOOPBACK:
        return False
    owners = inode_owners({record["inode"]})
    return pid in owners.get(record["inode"], set())


def fetch(url: str, timeout: float = 1.0) -> bytes:
    with LOCAL_OPENER.open(url, timeout=timeout) as response:
        return response.read()


def main() -> None:
    python_exe = require_command("python3")
    require_command("ss")
    require_command("curl")

    try:
        subprocess.run(
            [python_exe, "-c", "import http.server"],
            check=True,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=20,
        )
    except (subprocess.SubprocessError, OSError) as exc:
        fail(f"Technischer Umgebungsfehler: Das Python-Modul http.server ist nicht verfügbar: {exc}")

    assert_loopback_usable()

    try:
        DEMO_DIR.mkdir(parents=True, exist_ok=True)
        FINAL_DIR.mkdir(parents=True, exist_ok=True)
        STATE_DIR.mkdir(parents=True, exist_ok=True)
    except OSError as exc:
        fail(
            "Technischer Umgebungsfehler: Die Laborverzeichnisse konnten nicht "
            f"vorbereitet werden: {exc}"
        )

    if not os.access(LAB_ROOT, os.W_OK):
        fail(f"Technischer Umgebungsfehler: {LAB_ROOT} ist nicht beschreibbar.")

    terminate_confirmed_old_server(DEMO_PORT, DEMO_DIR)
    terminate_confirmed_old_server(FINAL_PORT, FINAL_DIR)

    assert_port_free(DEMO_PORT)
    assert_port_free(FINAL_PORT)

    try:
        (DEMO_DIR / "index.html").write_bytes(DEMO_BYTES)
        remove_path(FINAL_FILE)
        for marker in (DEMO_PID, DEMO_SID):
            if marker.exists():
                marker.unlink()
        log_handle = DEMO_LOG.open("ab", buffering=0)
    except OSError as exc:
        fail(f"Technischer Umgebungsfehler bei der Laborvorbereitung: {exc}")

    try:
        process = subprocess.Popen(
        [
            python_exe,
            "-m",
            "http.server",
            "--bind",
            LOOPBACK,
            str(DEMO_PORT),
        ],
        cwd=str(DEMO_DIR),
        stdin=subprocess.DEVNULL,
        stdout=log_handle,
        stderr=subprocess.STDOUT,
        start_new_session=True,
            close_fds=True,
        )
    except OSError as exc:
        log_handle.close()
        fail(f"Technischer Umgebungsfehler: Der Demo-Server konnte nicht gestartet werden: {exc}")
    finally:
        if not log_handle.closed:
            log_handle.close()

    try:
        session_id = os.getsid(process.pid)
        DEMO_PID.write_text(f"{process.pid}\n", encoding="ascii")
        DEMO_SID.write_text(f"{session_id}\n", encoding="ascii")
    except OSError as exc:
        try:
            os.kill(process.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
        fail(f"Technischer Umgebungsfehler: PID oder Sitzungskennung konnte nicht gespeichert werden: {exc}")

    deadline = time.monotonic() + 8.0
    last_error = ""
    while time.monotonic() < deadline:
        if process.poll() is not None:
            fail(
                "Technischer Umgebungsfehler: Der vorbereitete Demo-Server wurde "
                f"unerwartet beendet. Interne Logdatei: {DEMO_LOG}"
            )
        try:
            listener_ok = exact_loopback_listener(DEMO_PORT, process.pid)
            body = fetch(f"http://{LOOPBACK}:{DEMO_PORT}/", timeout=0.8)
            if listener_ok and body == DEMO_BYTES:
                print("Labor vorbereitet: Der lokale Demo-Server auf 127.0.0.1:8000 ist bereit.")
                return
            last_error = "Listener oder Antwortinhalt entspricht noch nicht dem Sollzustand."
        except Exception as exc:
            last_error = str(exc)
        time.sleep(0.2)

    try:
        os.kill(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    fail(
        "Technischer Umgebungsfehler: Der Demo-Server wurde nicht rechtzeitig bereit. "
        f"Letzte Beobachtung: {last_error}. Interne Logdatei: {DEMO_LOG}"
    )


try:
    main()
except SetupError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)
PY
