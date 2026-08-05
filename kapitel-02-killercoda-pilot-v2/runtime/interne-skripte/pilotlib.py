#!/usr/bin/env python3
"""Gemeinsame, seiteneffektfreie Parserfunktionen des technischen Piloten."""

from __future__ import annotations

import ipaddress
import os
import re
import stat
from pathlib import Path
from typing import Dict

CONFIG_KEYS = (
    "BIND_ADRESSE",
    "PORT",
    "HTTP_STATUS",
    "MELDUNG_DATEI",
)

ALLOWED_VALUES = {
    "BIND_ADRESSE": {"127.0.0.1", "0.0.0.0"},
    "PORT": {"8080", "8081"},
    "HTTP_STATUS": {"200", "404", "500"},
    "MELDUNG_DATEI": {"meldungen/xebico.txt"},
}

KEY_RE = re.compile(r"^[A-Z_]+$")
VALUE_RE = re.compile(r"^[A-Za-z0-9._/-]+$")


class PilotValidationError(ValueError):
    """Validierungsfehler mit verständlicher Diagnose."""


def _read_regular_file_nofollow(path: Path, max_bytes: int) -> bytes:
    flags = os.O_RDONLY
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        fd = os.open(path, flags)
    except FileNotFoundError as exc:
        raise PilotValidationError(f"Datei fehlt: {path}") from exc
    except OSError as exc:
        raise PilotValidationError(f"Datei kann nicht sicher geöffnet werden: {path}: {exc}") from exc

    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode):
            raise PilotValidationError(f"Keine reguläre Datei: {path}")
        if info.st_size > max_bytes:
            raise PilotValidationError(
                f"Datei ist zu groß: {path} ({info.st_size} Byte; maximal {max_bytes})"
            )
        data = b""
        while len(data) <= max_bytes:
            chunk = os.read(fd, min(4096, max_bytes + 1 - len(data)))
            if not chunk:
                break
            data += chunk
        if len(data) > max_bytes:
            raise PilotValidationError(f"Datei überschreitet {max_bytes} Byte: {path}")
        return data
    finally:
        os.close(fd)


def parse_config(config_path: Path, base_dir: Path) -> Dict[str, str]:
    """Liest die Pilotkonfiguration ohne Shell-Auswertung."""
    raw = _read_regular_file_nofollow(config_path, 4096)
    if b"\x00" in raw:
        raise PilotValidationError("Konfiguration enthält ein NUL-Zeichen.")

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PilotValidationError("Konfiguration ist nicht gültiges UTF-8.") from exc

    lines = text.splitlines()
    if not lines:
        raise PilotValidationError("Konfiguration ist leer.")

    values: Dict[str, str] = {}
    for number, line in enumerate(lines, start=1):
        if line == "":
            raise PilotValidationError(f"Leerzeile in Zeile {number} ist nicht erlaubt.")
        if line != line.strip():
            raise PilotValidationError(
                f"Leerzeichenfehler in Zeile {number}: keine führenden oder nachgestellten Leerzeichen."
            )
        if any(ch.isspace() for ch in line):
            raise PilotValidationError(
                f"Leerzeichenfehler in Zeile {number}: KEY=WERT muss ohne Leerzeichen geschrieben werden."
            )
        if line.count("=") != 1:
            raise PilotValidationError(
                f"Ungültige Syntax in Zeile {number}: erwartet wird KEY=WERT."
            )

        key, value = line.split("=", 1)
        if not KEY_RE.fullmatch(key):
            raise PilotValidationError(f"Ungültiger Schlüssel in Zeile {number}: {key!r}")
        if key not in CONFIG_KEYS:
            raise PilotValidationError(f"Unbekannter Schlüssel in Zeile {number}: {key}")
        if key in values:
            raise PilotValidationError(f"Schlüssel doppelt vorhanden: {key}")
        if not value:
            raise PilotValidationError(f"Wert fehlt für Schlüssel {key}.")
        if not VALUE_RE.fullmatch(value):
            raise PilotValidationError(
                f"Ungültige Zeichen im Wert von {key}; Shell-Sonderzeichen sind nicht erlaubt."
            )
        if value not in ALLOWED_VALUES[key]:
            allowed = ", ".join(sorted(ALLOWED_VALUES[key]))
            raise PilotValidationError(
                f"Ungültiger Wert für {key}: {value!r}. Erlaubt: {allowed}"
            )
        values[key] = value

    missing = [key for key in CONFIG_KEYS if key not in values]
    if missing:
        raise PilotValidationError("Schlüssel fehlt: " + ", ".join(missing))

    if len(lines) != len(CONFIG_KEYS):
        raise PilotValidationError(
            f"Konfiguration muss genau {len(CONFIG_KEYS)} Zeilen enthalten."
        )

    base_resolved = base_dir.resolve()
    message_path = (base_resolved / values["MELDUNG_DATEI"]).resolve()
    try:
        message_path.relative_to(base_resolved)
    except ValueError as exc:
        raise PilotValidationError("MELDUNG_DATEI verlässt das Pilotverzeichnis.") from exc

    expected = (base_resolved / "meldungen" / "xebico.txt").resolve()
    if message_path != expected:
        raise PilotValidationError(
            "MELDUNG_DATEI muss exakt meldungen/xebico.txt verwenden."
        )

    return values


def validate_hosts_line(text: str) -> tuple[str, str]:
    """Validiert exakt eine Zeile: IPV4 xebico."""
    if "\x00" in text:
        raise PilotValidationError("Registerdatei enthält ein NUL-Zeichen.")

    lines = text.splitlines()
    if len(lines) != 1:
        raise PilotValidationError("Registerdatei muss genau eine Zeile enthalten.")

    line = lines[0]
    if line != line.strip():
        raise PilotValidationError(
            "Registerzeile darf keine führenden oder nachgestellten Leerzeichen enthalten."
        )

    parts = line.split()
    if len(parts) != 2:
        raise PilotValidationError(
            "Erwartetes Format: IP-ADRESSE xebico; zusätzliche Namen oder Felder sind nicht erlaubt."
        )

    address, name = parts
    if name != "xebico":
        raise PilotValidationError("Als Name ist ausschließlich xebico erlaubt.")

    try:
        parsed = ipaddress.IPv4Address(address)
    except ipaddress.AddressValueError as exc:
        raise PilotValidationError(f"Ungültige IPv4-Adresse: {address!r}") from exc

    if parsed.is_multicast or parsed.is_unspecified or address == "255.255.255.255":
        raise PilotValidationError(
            f"Diese IPv4-Adresse ist für den Pilot-Eintrag nicht zulässig: {address}"
        )

    return str(parsed), name
