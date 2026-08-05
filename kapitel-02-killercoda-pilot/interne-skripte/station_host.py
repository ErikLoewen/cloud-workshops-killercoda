#!/usr/bin/env python3
"""Verwaltet ausschließlich den lokalen Hostnamen-Block des Piloten."""

from __future__ import annotations

import sys
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(INTERNAL_DIR))

from hosts_tool import (  # noqa: E402
    MAX_HOSTS_BYTES,
    PilotValidationError,
    read_nofollow,
    write_hosts_safely,
)

BEGIN = "# BEGIN LABFORGE NACHTSTATION"
END = "# END LABFORGE NACHTSTATION"
BLOCK = f"{BEGIN}\n127.0.1.1 nachtstation\n{END}\n"


def build(original: str) -> str:
    begins = original.count(BEGIN)
    ends = original.count(END)
    if begins != ends or begins > 1:
        raise PilotValidationError(
            "Der verwaltete Nachtstation-Block ist beschädigt oder mehrfach vorhanden."
        )
    if begins == 0:
        if original and not original.endswith("\n"):
            original += "\n"
        return original + BLOCK
    start = original.index(BEGIN)
    end = original.index(END, start) + len(END)
    if end < len(original) and original[end] == "\n":
        end += 1
    return original[:start] + BLOCK + original[end:]


def main() -> int:
    hosts = Path("/etc/hosts")
    try:
        raw, info = read_nofollow(hosts, max_bytes=MAX_HOSTS_BYTES)
        text = raw.decode("utf-8")
        updated = build(text).encode("utf-8")
        write_hosts_safely(
            hosts,
            raw,
            info,
            updated,
            allow_inplace_fallback=True,
        )
        check, _ = read_nofollow(hosts, max_bytes=MAX_HOSTS_BYTES)
        rendered = check.decode("utf-8")
        if rendered.count(BEGIN) != 1 or "127.0.1.1 nachtstation" not in rendered:
            raise PilotValidationError("Nachtstation-Block konnte nicht bestätigt werden.")
        return 0
    except (OSError, UnicodeError, PilotValidationError) as exc:
        print(f"Hostname-Block konnte nicht gesetzt werden: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
