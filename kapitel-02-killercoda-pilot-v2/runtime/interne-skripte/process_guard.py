#!/usr/bin/env python3
"""Validiert ausschließlich exakt zum Pilot gehörende Prozessinstanzen."""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

EXPECTED_COMM = "xebico-dienst"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="strict").strip()


def process_uid(pid: int) -> int:
    for line in (Path("/proc") / str(pid) / "status").read_text().splitlines():
        if line.startswith("Uid:"):
            return int(line.split()[1])
    raise RuntimeError("Uid fehlt im Prozessstatus.")


def process_cmdline(pid: int) -> list[str]:
    raw = (Path("/proc") / str(pid) / "cmdline").read_bytes()
    return [part.decode("utf-8", errors="strict") for part in raw.split(b"\0") if part]


def validate(
    pid: int,
    expected_uid: int,
    script: Path,
    config: Path,
    base_dir: Path,
) -> tuple[bool, str]:
    proc = Path("/proc") / str(pid)
    if not proc.is_dir():
        return False, "Prozess existiert nicht."

    try:
        if process_uid(pid) != expected_uid:
            return False, "Prozessbesitzer stimmt nicht."
        if read_text(proc / "comm") != EXPECTED_COMM:
            return False, "Prozessname stimmt nicht."

        args = process_cmdline(pid)
        script_real = str(script.resolve())
        config_real = str(config.resolve())
        base_real = str(base_dir.resolve())

        resolved_args = []
        for value in args:
            if value.startswith("/"):
                try:
                    resolved_args.append(str(Path(value).resolve()))
                except OSError:
                    resolved_args.append(value)
            else:
                resolved_args.append(value)

        if script_real not in resolved_args:
            return False, "Erwarteter Startpfad fehlt."

        def option_matches(option: str, expected: str) -> bool:
            for index, value in enumerate(args[:-1]):
                if value == option:
                    candidate = args[index + 1]
                    try:
                        candidate = str(Path(candidate).resolve())
                    except OSError:
                        pass
                    return candidate == expected
            return False

        if not option_matches("--config", config_real):
            return False, "Erwarteter Konfigurationspfad fehlt."
        if not option_matches("--base-dir", base_real):
            return False, "Erwartetes Arbeitsverzeichnis fehlt."
    except (OSError, UnicodeError, RuntimeError, ValueError) as exc:
        return False, f"Prozessdaten nicht sicher lesbar: {exc}"

    return True, "verwaltete Pilotinstanz"


def iter_pids() -> list[int]:
    result = []
    for entry in Path("/proc").iterdir():
        if entry.name.isdigit():
            result.append(int(entry.name))
    return sorted(result)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--expected-uid", required=True, type=int)
    parser.add_argument("--script", required=True, type=Path)
    parser.add_argument("--config", required=True, type=Path)
    parser.add_argument("--base-dir", required=True, type=Path)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--validate", type=int)
    group.add_argument("--list", action="store_true")
    args = parser.parse_args()

    if args.validate is not None:
        ok, reason = validate(
            args.validate,
            args.expected_uid,
            args.script,
            args.config,
            args.base_dir,
        )
        if ok:
            print(reason)
            return 0
        print(reason, file=sys.stderr)
        return 1

    found = []
    for pid in iter_pids():
        ok, _reason = validate(
            pid,
            args.expected_uid,
            args.script,
            args.config,
            args.base_dir,
        )
        if ok:
            found.append(pid)

    for pid in found:
        print(pid)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
