#!/usr/bin/env python3
# LabForge Workshop 5 lifecycle event helper
from __future__ import annotations

import fcntl
import os
from pathlib import Path
import signal
import sys
import tempfile
import time
from typing import Dict

DEFAULT_STATE_DIR = Path("/var/lib/labforge/prozesse-und-dienste")
EXPECTED_RUNNER = "/usr/local/lib/labforge/lab-demo-runner.py"
EXPECTED_COMM = "lab-demo-svc"


def state_dir() -> Path:
    return Path(os.environ.get("LABFORGE_STATE_DIR", str(DEFAULT_STATE_DIR)))


def runner_path() -> str:
    return os.environ.get("LABFORGE_RUNNER_PATH", EXPECTED_RUNNER)


def atomic_write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            handle.write(content)
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, 0o644)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def read_key_values(path: Path) -> Dict[str, str]:
    values: Dict[str, str] = {}
    if not path.is_file():
        return values
    for line in path.read_text(encoding="utf-8").splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            values[key] = value
    return values


def read_session(directory: Path) -> str:
    session_file = directory / "session-id"
    if not session_file.is_file():
        raise RuntimeError("Sitzungskennung fehlt.")
    session_id = session_file.read_text(encoding="utf-8").strip()
    if not session_id:
        raise RuntimeError("Sitzungskennung ist leer.")
    return session_id


def tracking_enabled(directory: Path, session_id: str) -> bool:
    values = read_key_values(directory / "service-tracking.enabled")
    return values.get("session_id") == session_id


def process_is_expected(pid: int) -> bool:
    proc = Path("/proc") / str(pid)
    try:
        comm = (proc / "comm").read_text(encoding="utf-8").strip()
        cmdline = (proc / "cmdline").read_bytes().replace(b"\0", b" ").decode(
            "utf-8", errors="replace"
        )
    except OSError:
        return False
    return comm == EXPECTED_COMM and runner_path() in cmdline


def next_sequence(directory: Path) -> int:
    lock_path = directory / "service-events.lock"
    counter_path = directory / "service-event-counter"
    with lock_path.open("a+", encoding="utf-8") as lock_handle:
        fcntl.flock(lock_handle.fileno(), fcntl.LOCK_EX)
        try:
            current = int(counter_path.read_text(encoding="utf-8").strip())
        except (OSError, ValueError):
            current = 0
        next_value = current + 1
        atomic_write(counter_path, f"{next_value}\n")
        return next_value


def process_has_exited(pid: int) -> bool:
    proc = Path("/proc") / str(pid)
    if not proc.exists():
        return True
    try:
        stat_fields = (proc / "stat").read_text(encoding="utf-8").split()
    except OSError:
        return True
    return len(stat_fields) >= 3 and stat_fields[2] == "Z"


def wait_for_exit(pid: int, timeout_seconds: float = 5.0) -> bool:
    deadline = time.monotonic() + timeout_seconds
    while time.monotonic() < deadline:
        if process_has_exited(pid):
            return True
        time.sleep(0.05)
    return process_has_exited(pid)


def stop_request(directory: Path, session_id: str, pid: int) -> int:
    """Terminate the expected runner cleanly and create only a pending record."""
    if not process_is_expected(pid):
        print("Der zu stoppende Prozess gehört nicht zum eigenen Demo-Dienst.", file=sys.stderr)
        return 1

    term_marker = directory / "runner-term.marker"
    pending_marker = directory / "service-stop.pending"
    for path in (term_marker, pending_marker):
        try:
            path.unlink()
        except FileNotFoundError:
            pass

    os.kill(pid, signal.SIGTERM)
    if not wait_for_exit(pid):
        print("Der Demo-Prozess reagierte nicht rechtzeitig auf die normale Beendigung.", file=sys.stderr)
        return 1

    term_values = read_key_values(term_marker)
    clean_term = (
        term_values.get("session_id") == session_id
        and term_values.get("pid") == str(pid)
        and term_values.get("result") == "clean-term"
    )
    if not clean_term:
        print("Der Demo-Prozess bestätigte keine geordnete Beendigung.", file=sys.stderr)
        return 1

    if tracking_enabled(directory, session_id):
        atomic_write(
            pending_marker,
            f"session_id={session_id}\npid={pid}\nresult=clean-term-pending\n",
        )
    return 0


def stop_result(
    directory: Path,
    session_id: str,
    service_result: str,
    exit_code: str,
    exit_status: str,
) -> int:
    """Finalize a participant stop only after systemd reports a clean result."""
    pending_marker = directory / "service-stop.pending"
    pending_values = read_key_values(pending_marker)

    if not tracking_enabled(directory, session_id):
        try:
            pending_marker.unlink()
        except FileNotFoundError:
            pass
        return 0

    if pending_values.get("session_id") != session_id:
        return 0

    clean_systemd_result = (
        service_result == "success"
        and exit_code == "exited"
        and exit_status == "0"
        and pending_values.get("result") == "clean-term-pending"
    )

    try:
        pending_marker.unlink()
    except FileNotFoundError:
        pass

    if not clean_systemd_result:
        print(
            "Der Stop wurde von systemd nicht als sauberer erfolgreicher Ablauf bestätigt.",
            file=sys.stderr,
        )
        return 0

    sequence = next_sequence(directory)
    atomic_write(
        directory / "service-stop.marker",
        "session_id={session}\nsequence={sequence}\npid={pid}\n"
        "service_result={service_result}\nexit_code={exit_code}\n"
        "exit_status={exit_status}\nresult=clean-stop\n".format(
            session=session_id,
            sequence=sequence,
            pid=pending_values.get("pid", ""),
            service_result=service_result,
            exit_code=exit_code,
            exit_status=exit_status,
        ),
    )
    return 0


def start_event(directory: Path, session_id: str, pid: int) -> int:
    if not process_is_expected(pid):
        print("Der gestartete Prozess gehört nicht zum eigenen Demo-Dienst.", file=sys.stderr)
        return 1

    if not tracking_enabled(directory, session_id):
        return 0

    stop_values = read_key_values(directory / "service-stop.marker")
    if stop_values.get("session_id") != session_id:
        return 0
    try:
        stop_sequence = int(stop_values["sequence"])
    except (KeyError, ValueError):
        return 0

    sequence = next_sequence(directory)
    if sequence <= stop_sequence:
        print("Die Startsequenz liegt nicht nach der Stopsequenz.", file=sys.stderr)
        return 1

    atomic_write(
        directory / "service-start-after-stop.marker",
        f"session_id={session_id}\nsequence={sequence}\npid={pid}\nresult=active-start\n",
    )
    return 0


def main() -> int:
    if len(sys.argv) < 2:
        print("Interner Lifecycle-Aufruf fehlt.", file=sys.stderr)
        return 2

    directory = state_dir()
    session_id = read_session(directory)
    action = sys.argv[1]

    if action == "start" and len(sys.argv) == 3:
        try:
            pid = int(sys.argv[2])
        except ValueError:
            print("Die interne Main PID ist ungültig.", file=sys.stderr)
            return 2
        return start_event(directory, session_id, pid)

    if action == "stop-request" and len(sys.argv) == 3:
        try:
            pid = int(sys.argv[2])
        except ValueError:
            print("Die interne Main PID ist ungültig.", file=sys.stderr)
            return 2
        return stop_request(directory, session_id, pid)

    if action == "stop-result" and len(sys.argv) == 5:
        return stop_result(directory, session_id, sys.argv[2], sys.argv[3], sys.argv[4])

    print(
        "Interner Aufruf: start MAINPID | stop-request MAINPID | "
        "stop-result SERVICE_RESULT EXIT_CODE EXIT_STATUS",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
