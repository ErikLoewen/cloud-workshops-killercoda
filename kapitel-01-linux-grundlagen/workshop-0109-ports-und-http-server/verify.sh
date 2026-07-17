#!/usr/bin/env bash
set -Eeuo pipefail

python3 - <<'PY'
from __future__ import annotations

import hashlib
import os
from pathlib import Path
import sys
import urllib.error
import urllib.request

LOCAL_OPENER = urllib.request.build_opener(urllib.request.ProxyHandler({}))

FINAL_DIR = Path("/root/httplabor/abschluss")
FINAL_FILE = FINAL_DIR / "index.html"
EXPECTED = b"HTTP-Server auf Port 8080 bereit\n"
LOOPBACK = "127.0.0.1"
PORT = 8080


class VerifyError(RuntimeError):
    pass


def fail(message: str) -> None:
    raise VerifyError(message)


def parse_tcp_table(path: Path) -> list[dict[str, str]]:
    listeners: list[dict[str, str]] = []
    if not path.exists():
        return listeners
    lines = path.read_text(encoding="ascii", errors="replace").splitlines()[1:]
    wanted_port = f"{PORT:04X}"
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
        if state != "0A" or port_hex.upper() != wanted_port:
            continue
        listeners.append({
            "address_hex": address_hex.upper(),
            "inode": inode,
        })
    return listeners


def listeners() -> list[dict[str, str]]:
    records: list[dict[str, str]] = []
    for record in parse_tcp_table(Path("/proc/net/tcp")):
        address_hex = record["address_hex"]
        if address_hex == "0100007F":
            address = "127.0.0.1"
        elif address_hex == "00000000":
            address = "0.0.0.0"
        else:
            address = f"IPv4:{address_hex}"
        records.append({
            "family": "ipv4",
            "address": address,
            "inode": record["inode"],
        })
    for record in parse_tcp_table(Path("/proc/net/tcp6")):
        address_hex = record["address_hex"]
        address = "[::]" if address_hex == "0" * 32 else f"IPv6:{address_hex}"
        records.append({
            "family": "ipv6",
            "address": address,
            "inode": record["inode"],
        })
    return records


def inode_owners(inodes: set[str]) -> tuple[dict[str, set[int]], bool]:
    owners = {inode: set() for inode in inodes}
    permission_limited = False
    for proc_dir in Path("/proc").iterdir():
        if not proc_dir.name.isdigit():
            continue
        pid = int(proc_dir.name)
        fd_dir = proc_dir / "fd"
        try:
            entries = list(fd_dir.iterdir())
        except PermissionError:
            permission_limited = True
            continue
        except (FileNotFoundError, ProcessLookupError):
            continue
        for fd in entries:
            try:
                target = os.readlink(fd)
            except PermissionError:
                permission_limited = True
                continue
            except (FileNotFoundError, ProcessLookupError):
                continue
            if target.startswith("socket:[") and target.endswith("]"):
                inode = target[8:-1]
                if inode in owners:
                    owners[inode].add(pid)
    return owners, permission_limited


def cmdline(pid: int) -> list[str] | None:
    try:
        raw = Path(f"/proc/{pid}/cmdline").read_bytes()
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        return None
    return [part.decode(errors="replace") for part in raw.split(b"\0") if part]


def cwd(pid: int) -> str | None:
    try:
        return os.readlink(f"/proc/{pid}/cwd")
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        return None


def adjacent(tokens: list[str], first: str, second: str) -> bool:
    return any(tokens[i] == first and tokens[i + 1] == second for i in range(len(tokens) - 1))


def option_argument(tokens: list[str], option: str, argument: str) -> bool:
    return any(tokens[i] == option and tokens[i + 1] == argument for i in range(len(tokens) - 1))


def validate_process(pid: int) -> None:
    tokens = cmdline(pid)
    process_cwd = cwd(pid)

    if not tokens:
        fail(
            "Der Listener wurde gefunden, seine Prozesskommandozeile konnte jedoch "
            "nicht robust gelesen werden. Der technische CHECK kann die Prozessidentität "
            "in dieser Umgebung nicht belegen."
        )

    executable = Path(tokens[0]).name.lower()
    if not executable.startswith("python"):
        fail("Auf 127.0.0.1:8080 lauscht kein zuordenbarer Python-Prozess.")

    if not adjacent(tokens, "-m", "http.server"):
        fail("Der zugeordnete Python-Prozess wurde nicht mit '-m http.server' gestartet.")

    if not option_argument(tokens, "--bind", LOOPBACK):
        fail("Der zugeordnete Serverprozess enthält nicht '--bind 127.0.0.1'.")

    if str(PORT) not in tokens:
        fail("Der zugeordnete Serverprozess enthält nicht das Portargument 8080.")

    if process_cwd is None:
        fail(
            "Der Listener wurde einem Prozess zugeordnet, aber dessen aktuelles "
            "Arbeitsverzeichnis konnte in dieser Umgebung nicht robust gelesen werden. "
            "Der CHECK behauptet diesen Nachweis deshalb nicht."
        )

    if process_cwd != str(FINAL_DIR):
        fail(
            "Der Serverprozess läuft aus dem falschen Arbeitsverzeichnis. "
            f"Erwartet wird exakt {FINAL_DIR}."
        )


def fetch(url: str) -> bytes:
    with LOCAL_OPENER.open(url, timeout=2.0) as response:
        return response.read()


def main() -> None:
    try:
        file_exists = FINAL_FILE.exists()
    except OSError as exc:
        fail(f"Die Abschlussdatei konnte nicht geprüft werden: {exc}")

    if not file_exists:
        fail(
            f"Die Datei {FINAL_FILE} wurde nicht gefunden. "
            "Wechsle in das Abschlussverzeichnis und erzeuge dort index.html."
        )

    try:
        if not FINAL_FILE.is_file():
            fail(f"{FINAL_FILE} existiert, ist aber keine reguläre Datei.")
        before_bytes = FINAL_FILE.read_bytes()
    except OSError as exc:
        fail(f"Die Abschlussdatei konnte nicht gelesen werden: {exc}")
    before_hash = hashlib.sha256(before_bytes).hexdigest()
    if before_bytes != EXPECTED:
        fail(
            "Die Datei index.html enthält nicht bytegenau den geforderten Text mit "
            "genau einem abschließenden Zeilenumbruch."
        )

    records = listeners()
    if not records:
        fail(
            "Auf TCP-Port 8080 wurde kein lauschender Endpunkt gefunden. "
            "Prüfe Port, Bind-Adresse und ob der Serverprozess weiterläuft."
        )

    rejected = [record["address"] for record in records if record["address"] != LOOPBACK]
    if rejected:
        fail(
            "Port 8080 lauscht an einer nicht erlaubten Adresse "
            f"({', '.join(sorted(set(rejected)))}). "
            "Erlaubt ist ausschließlich 127.0.0.1."
        )

    exact = [record for record in records if record["family"] == "ipv4" and record["address"] == LOOPBACK]
    if len(exact) != 1:
        fail(
            "Der Listener auf Port 8080 ist nicht eindeutig als einzelner "
            "IPv4-Loopback-Listener 127.0.0.1 nachweisbar."
        )

    owners, permission_limited = inode_owners({exact[0]["inode"]})
    pids = owners.get(exact[0]["inode"], set())
    if len(pids) != 1:
        detail = " Die /proc-Sicht war teilweise durch Berechtigungen eingeschränkt." if permission_limited else ""
        fail(
            "Der Listener konnte nicht eindeutig genau einem Prozess zugeordnet werden."
            + detail
        )

    pid = next(iter(pids))
    validate_process(pid)

    try:
        numeric_body = fetch("http://127.0.0.1:8080/")
    except Exception as exc:
        fail(
            "Der TCP-Port lauscht, aber die lokale HTTP-Anfrage an 127.0.0.1:8080 "
            f"war nicht erfolgreich: {exc}"
        )
    if numeric_body != EXPECTED:
        fail(
            "Der Server antwortet über 127.0.0.1:8080, liefert aber nicht bytegenau "
            "den geforderten Dateiinhalt."
        )

    try:
        localhost_body = fetch("http://localhost:8080/")
    except Exception as exc:
        fail(
            "Die numerische Loopback-Anfrage funktioniert, aber localhost:8080 nicht. "
            "Das kann ein technisches Umgebungsproblem der lokalen Namensauflösung sein "
            f"und bleibt ein Freigabeblocker: {exc}"
        )
    if localhost_body != EXPECTED:
        fail(
            "Die Antwort über localhost:8080 entspricht nicht bytegenau der Abschlussdatei."
        )

    after_bytes = FINAL_FILE.read_bytes()
    after_hash = hashlib.sha256(after_bytes).hexdigest()
    if before_hash != after_hash or before_bytes != after_bytes:
        fail("Der technische CHECK hat unerwartet den Dateiinhalt verändert.")

    print("Prüfung erfolgreich: Datei, lokaler Listener, Serverprozess, Arbeitsverzeichnis und HTTP-Antwort stimmen.")
    print("Nicht maschinell geprüft wurden der selbstständige Lösungsweg und das fachliche Verständnis.")


try:
    main()
except VerifyError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)
PY
