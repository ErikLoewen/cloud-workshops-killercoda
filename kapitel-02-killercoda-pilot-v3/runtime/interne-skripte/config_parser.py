#!/usr/bin/env python3
"""CLI für die sichere Validierung der Dienstkonfiguration."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(INTERNAL_DIR))

from pilotlib import CONFIG_KEYS, PilotValidationError, parse_config


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", required=True, type=Path)
    parser.add_argument("--base-dir", required=True, type=Path)
    parser.add_argument("--get", choices=CONFIG_KEYS)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    try:
        values = parse_config(args.config, args.base_dir)
    except PilotValidationError as exc:
        print(f"Konfiguration nicht gültig: {exc}", file=sys.stderr)
        return 1

    if args.get:
        print(values[args.get])
        return 0

    if args.json:
        print(json.dumps(values, sort_keys=True))
        return 0

    print("Konfiguration gültig.")
    print(f"Bind-Adresse: {values['BIND_ADRESSE']}")
    print(f"TCP-Port:      {values['PORT']}")
    print(f"HTTP-Status:   {values['HTTP_STATUS']}")
    print(f"Meldungsdatei: {values['MELDUNG_DATEI']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
