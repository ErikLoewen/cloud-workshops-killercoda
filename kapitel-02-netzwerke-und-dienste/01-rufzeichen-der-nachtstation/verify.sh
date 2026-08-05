#!/usr/bin/env bash
set -Eeuo pipefail

readonly protocol="/home/telegrafist/nachtstation/stationsprotokoll.txt"
readonly network_helper="/usr/local/lib/labforge/workshop-0201/network-state.py"

fail() {
  printf '%s\n' "$1" >&2
  if (($# > 1)); then
    printf '%s\n' "$2" >&2
  fi
  exit 1
}

[[ -x "${network_helper}" ]] ||
  fail \
    "Die technische Auswahlhilfe des Workshops fehlt." \
    "Starte das Szenario in einer frischen Killercoda-Sitzung erneut."

[[ -f "${protocol}" && ! -L "${protocol}" ]] ||
  fail \
    "Die Datei stationsprotokoll.txt wurde nicht gefunden oder ist kein reguläres Protokoll." \
    "Prüfe mit pwd deinen Standort und arbeite in /home/telegrafist/nachtstation."

protocol_size="$(stat -c '%s' "${protocol}")"
[[ "${protocol_size}" =~ ^[0-9]+$ && "${protocol_size}" -le 8192 ]] ||
  fail \
    "stationsprotokoll.txt ist ungewöhnlich groß." \
    "Prüfe, ob du wirklich nur das kurze Stationsprotokoll bearbeitet hast."

expected_json="$(/usr/bin/python3 -I "${network_helper}")" ||
  fail \
    "Der aktuelle Netzwerkzustand konnte nicht ausgewertet werden." \
    "Untersuche die Sitzung erneut mit hostname und ip address."

EXPECTED_JSON="${expected_json}" /usr/bin/python3 - "${protocol}" <<'PY_VERIFY'
from __future__ import annotations

import json
import os
import pathlib
import re
import sys

protocol_path = pathlib.Path(sys.argv[1])
expected = json.loads(os.environ["EXPECTED_JSON"])

labels = {
    "Hostname": (
        str(expected["hostname"]),
        "Führe hostname erneut aus und übernimm die einzelne Ausgabezeile.",
    ),
    "Loopback-Schnittstelle": (
        str(expected["loopback_interface"]),
        "Führe ip address erneut aus und suche den Abschnitt mit 127.0.0.1.",
    ),
    "Loopback-Adresse": (
        str(expected["loopback_address"]),
        "Suche in ip address nach der inet-Zeile mit 127.0.0.1 und lasse den Teil hinter / weg.",
    ),
    "Weitere Netzwerkschnittstelle": (
        str(expected["selected_interface"]),
        "Lies stationsauftrag.txt und untersuche den verlangten Abschnitt erneut mit ip address.",
    ),
    "IPv4-Adresse dieser Schnittstelle": (
        str(expected["selected_address"]),
        "Untersuche im ausgewählten Abschnitt die inet-Zeile und übernimm nur den Teil vor /.",
    ),
}

try:
    text = protocol_path.read_text(encoding="utf-8")
except UnicodeDecodeError:
    print("stationsprotokoll.txt ist nicht als UTF-8-Text lesbar.", file=sys.stderr)
    print("Öffne die Datei erneut in Nano und speichere sie als normalen Text.", file=sys.stderr)
    raise SystemExit(1)

lines = text.splitlines()


def values_for(label: str) -> list[str]:
    pattern = re.compile(rf"^\s*{re.escape(label)}\s*:\s*(.*?)\s*$")
    return [match.group(1) for line in lines if (match := pattern.match(line))]


for label, (expected_value, guidance) in labels.items():
    values = values_for(label)

    if not values:
        print(f"Das Pflichtfeld '{label}' fehlt.", file=sys.stderr)
        print(guidance, file=sys.stderr)
        raise SystemExit(1)

    if len(values) > 1:
        print(f"Das Pflichtfeld '{label}' ist mehrfach vorhanden.", file=sys.stderr)
        print("Lasse im Stationsprotokoll genau eine Zeile für dieses Feld stehen.", file=sys.stderr)
        raise SystemExit(1)

    actual_value = values[0].strip()
    if not actual_value:
        print(f"Das Pflichtfeld '{label}' ist noch leer.", file=sys.stderr)
        print(guidance, file=sys.stderr)
        raise SystemExit(1)

    if label in {
        "Loopback-Schnittstelle",
        "Weitere Netzwerkschnittstelle",
    }:
        comparable_value = actual_value.split("@", 1)[0]
    else:
        comparable_value = actual_value

    if "/" in actual_value and "Adresse" in label:
        print(
            f"Im Feld '{label}' steht noch ein Teil hinter einem Schrägstrich.",
            file=sys.stderr,
        )
        print(
            "Übernimm für das Protokoll nur die IPv4-Adresse vor dem Schrägstrich.",
            file=sys.stderr,
        )
        raise SystemExit(1)

    if comparable_value != expected_value:
        print(
            f"Das Feld '{label}' passt nicht zum aktuellen Laufzeitzustand.",
            file=sys.stderr,
        )
        print(
            f"Eingetragen: {actual_value!r}; aktuell erwartet: {expected_value!r}.",
            file=sys.stderr,
        )
        print(guidance, file=sys.stderr)
        raise SystemExit(1)

print("CHECK erfolgreich: Das Stationsprotokoll entspricht dem aktuellen Netzwerkzustand.")
print("Hostname, Loopback sowie die dynamisch ausgewählte weitere Schnittstelle sind korrekt dokumentiert.")
PY_VERIFY
