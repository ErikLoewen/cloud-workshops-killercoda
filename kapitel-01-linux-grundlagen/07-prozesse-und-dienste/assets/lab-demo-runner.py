#!/usr/bin/env python3
# LabForge Workshop 7 demo service runner
from __future__ import annotations

import ctypes
import os
from pathlib import Path
import signal
import tempfile
import time

PR_SET_NAME = 15
PROCESS_NAME = b"lab-demo-svc"
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
        raise RuntimeError("Der sichtbare Prozessname stimmt nicht.")


def main() -> int:
    directory = state_dir()
    session_file = directory / "session-id"
    if not session_file.is_file():
        return 1

    session_id = session_file.read_text(encoding="utf-8").strip()
    if not session_id:
        return 1

    set_process_name(PROCESS_NAME)
    pid = os.getpid()
    stop_requested = False

    def handle_term(_signum: int, _frame: object) -> None:
        nonlocal stop_requested
        atomic_write(
            directory / "runner-term.marker",
            f"session_id={session_id}\npid={pid}\nresult=clean-term\n",
        )
        stop_requested = True

    signal.signal(signal.SIGTERM, handle_term)
    signal.signal(signal.SIGINT, handle_term)

    while not stop_requested:
        time.sleep(0.2)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
