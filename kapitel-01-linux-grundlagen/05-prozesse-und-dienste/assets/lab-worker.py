#!/usr/bin/env python3
# LabForge Workshop 5 lab-worker implementation
from __future__ import annotations

import ctypes
import fcntl
import os
from pathlib import Path
import signal
import sys
import tempfile
import time

PR_SET_NAME = 15
PROCESS_NAME = b"lab-worker"
DEFAULT_STATE_DIR = Path("/var/lib/labforge/prozesse-und-dienste")


def state_dir() -> Path:
    return Path(os.environ.get("LABFORGE_STATE_DIR", str(DEFAULT_STATE_DIR)))


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


def set_process_name(name: bytes) -> None:
    libc = ctypes.CDLL(None, use_errno=True)
    result = libc.prctl(PR_SET_NAME, ctypes.c_char_p(name), 0, 0, 0)
    if result != 0:
        errno = ctypes.get_errno()
        raise OSError(errno, os.strerror(errno))

    visible_name = Path("/proc/self/comm").read_text(encoding="utf-8").strip()
    if visible_name != name.decode("ascii"):
        raise RuntimeError(
            f"Erwarteter Prozessname {name.decode('ascii')!r}, sichtbar ist {visible_name!r}."
        )


def main() -> int:
    directory = state_dir()
    directory.mkdir(parents=True, exist_ok=True)
    session_file = directory / "session-id"
    if not session_file.is_file():
        print("lab-worker: Die Szenariositzung wurde nicht vorbereitet.", file=sys.stderr)
        return 1

    session_id = session_file.read_text(encoding="utf-8").strip()
    if not session_id:
        print("lab-worker: Die Sitzungskennung ist leer.", file=sys.stderr)
        return 1

    lock_path = directory / "worker.lock"
    lock_handle = lock_path.open("a+", encoding="utf-8")
    try:
        fcntl.flock(lock_handle.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        print(
            "lab-worker läuft bereits. Beende zuerst den vorhandenen Übungsprozess.",
            file=sys.stderr,
        )
        return 1

    try:
        set_process_name(PROCESS_NAME)
    except (OSError, RuntimeError) as exc:
        print(f"lab-worker: Der eindeutige Prozessname konnte nicht gesetzt werden: {exc}", file=sys.stderr)
        return 1

    pid = os.getpid()
    atomic_write(
        directory / "worker-start.marker",
        f"session_id={session_id}\npid={pid}\nimplementation=lab-worker.py\n",
    )

    stop_requested = False

    def handle_term(_signum: int, _frame: object) -> None:
        nonlocal stop_requested
        stop_requested = True

    signal.signal(signal.SIGTERM, handle_term)
    signal.signal(signal.SIGINT, handle_term)

    while not stop_requested:
        time.sleep(0.2)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
