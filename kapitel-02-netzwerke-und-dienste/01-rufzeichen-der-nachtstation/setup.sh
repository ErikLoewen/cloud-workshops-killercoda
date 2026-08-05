#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="telegrafist"
readonly lab_group="telegrafist"
readonly lab_home="/home/${lab_user}"
readonly workdir="${lab_home}/nachtstation"
readonly lab_hostname="nachtstation"
readonly internal_dir="/usr/local/lib/labforge/workshop-0201"
readonly network_helper="${internal_dir}/network-state.py"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

[[ "$(id -u)" == "0" ]] ||
  fail "Das Killercoda-Setup muss als root ausgeführt werden."

for command_name in \
  bash python3 ip hostname getent groupadd useradd usermod install \
  chown chmod sed grep su id rm stat; do
  command -v "${command_name}" >/dev/null 2>&1 ||
    fail "Benötigtes Werkzeug fehlt: ${command_name}"
done

if ! getent group "${lab_group}" >/dev/null 2>&1; then
  groupadd "${lab_group}"
fi

if ! id "${lab_user}" >/dev/null 2>&1; then
  useradd \
    --create-home \
    --home-dir "${lab_home}" \
    --shell /bin/bash \
    --gid "${lab_group}" \
    "${lab_user}"
fi

usermod \
  --home "${lab_home}" \
  --shell /bin/bash \
  --gid "${lab_group}" \
  "${lab_user}" >/dev/null

install -d -m 0755 -o "${lab_user}" -g "${lab_group}" "${lab_home}"

printf '%s\n' "${lab_hostname}" >/etc/hostname
if command -v hostnamectl >/dev/null 2>&1 &&
  hostnamectl set-hostname "${lab_hostname}" >/dev/null 2>&1; then
  :
else
  hostname "${lab_hostname}"
fi

if grep -qE '^[[:space:]]*127\.0\.1\.1[[:space:]]+' /etc/hosts; then
  sed -i -E \
    "s/^[[:space:]]*127\\.0\\.1\\.1[[:space:]]+.*/127.0.1.1 ${lab_hostname}/" \
    /etc/hosts
else
  printf '127.0.1.1 %s\n' "${lab_hostname}" >>/etc/hosts
fi

install -d -m 0700 -o root -g root "${internal_dir}"

cat >"${network_helper}" <<'PY_NETWORK_STATE'
#!/usr/bin/env python3
"""Ermittelt den dynamischen Netzwerkzustand für Workshop 02.01."""

from __future__ import annotations

import argparse
import ipaddress
import json
import shutil
import socket
import subprocess
import sys
from collections import defaultdict


def fail(message: str) -> "NoReturn":
    print(f"Netzwerkzustand nicht bestimmbar: {message}", file=sys.stderr)
    raise SystemExit(1)


def run_ip(arguments: list[str]) -> list[str]:
    ip_command = shutil.which("ip")
    if not ip_command:
        fail("Der Befehl ip wurde nicht gefunden.")

    completed = subprocess.run(
        [ip_command, *arguments],
        check=False,
        capture_output=True,
        text=True,
        timeout=5,
    )
    if completed.returncode != 0:
        fail(completed.stderr.strip() or "ip lieferte einen Fehler.")
    return [line for line in completed.stdout.splitlines() if line.strip()]


def parse_addresses() -> list[dict[str, object]]:
    records: list[dict[str, object]] = []

    for line in run_ip(["-o", "-4", "address", "show"]):
        parts = line.split()
        if "inet" not in parts or len(parts) < 4:
            continue

        interface_token = parts[1].rstrip(":")
        interface = interface_token.split("@", 1)[0]
        address_token = parts[parts.index("inet") + 1]
        address_text = address_token.split("/", 1)[0]

        try:
            address = ipaddress.IPv4Address(address_text)
        except ipaddress.AddressValueError:
            continue

        scope = "unknown"
        if "scope" in parts:
            scope_index = parts.index("scope")
            if scope_index + 1 < len(parts):
                scope = parts[scope_index + 1]

        records.append(
            {
                "interface": interface,
                "display_interface": interface_token,
                "address": str(address),
                "address_number": int(address),
                "scope": scope,
                "is_loopback": address.is_loopback,
            }
        )

    return records


def default_route_candidates(
    suitable_interfaces: set[str],
) -> list[tuple[int, str]]:
    candidates: list[tuple[int, str]] = []

    for line in run_ip(["-o", "-4", "route", "show", "default"]):
        parts = line.split()
        if "dev" not in parts:
            continue

        dev_index = parts.index("dev")
        if dev_index + 1 >= len(parts):
            continue

        interface = parts[dev_index + 1].split("@", 1)[0]
        if interface not in suitable_interfaces:
            continue

        metric = 0
        if "metric" in parts:
            metric_index = parts.index("metric")
            if metric_index + 1 < len(parts):
                try:
                    metric = int(parts[metric_index + 1])
                except ValueError:
                    metric = 0

        candidates.append((metric, interface))

    return sorted(set(candidates), key=lambda item: (item[0], item[1]))


def determine_state() -> dict[str, object]:
    records = parse_addresses()
    if not records:
        fail("ip address zeigt keine auswertbare IPv4-Adresse.")

    loopback_records = [
        record for record in records
        if record["address"] == "127.0.0.1"
    ]
    if not loopback_records:
        fail("Die Adresse 127.0.0.1 wurde auf keiner Schnittstelle gefunden.")

    loopback_records.sort(
        key=lambda record: (
            str(record["interface"]),
            str(record["display_interface"]),
        )
    )
    loopback = loopback_records[0]

    addresses_by_interface: dict[str, list[dict[str, object]]] = defaultdict(list)
    for record in records:
        if bool(record["is_loopback"]):
            continue
        addresses_by_interface[str(record["interface"])].append(record)

    suitable_interfaces = set(addresses_by_interface)
    if not suitable_interfaces:
        fail("Keine Nicht-Loopback-Schnittstelle mit IPv4-Adresse gefunden.")

    route_candidates = default_route_candidates(suitable_interfaces)
    if route_candidates:
        selected_interface = route_candidates[0][1]
        selection_reason = "default-route"
    else:
        selected_interface = sorted(suitable_interfaces)[0]
        selection_reason = "alphabetical-fallback"

    scope_order = {
        "global": 0,
        "site": 1,
        "link": 2,
        "host": 3,
        "unknown": 4,
    }
    selected_records = sorted(
        addresses_by_interface[selected_interface],
        key=lambda record: (
            scope_order.get(str(record["scope"]), 5),
            int(record["address_number"]),
            str(record["display_interface"]),
        ),
    )
    selected = selected_records[0]

    return {
        "hostname": socket.gethostname(),
        "loopback_interface": str(loopback["interface"]),
        "loopback_display_interface": str(loopback["display_interface"]),
        "loopback_address": str(loopback["address"]),
        "selected_interface": selected_interface,
        "selected_display_interface": str(selected["display_interface"]),
        "selected_address": str(selected["address"]),
        "candidate_interfaces": sorted(suitable_interfaces),
        "candidate_count": len(suitable_interfaces),
        "selection_reason": selection_reason,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--field")
    args = parser.parse_args()

    state = determine_state()

    if args.field:
        if args.field not in state:
            print(f"Unbekanntes Feld: {args.field}", file=sys.stderr)
            return 2
        value = state[args.field]
        if isinstance(value, list):
            print("\n".join(str(item) for item in value))
        else:
            print(value)
        return 0

    print(json.dumps(state, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
PY_NETWORK_STATE

chmod 0700 "${network_helper}"
chown root:root "${network_helper}"

selected_interface="$(/usr/bin/python3 -I "${network_helper}" --field selected_interface)" ||
  fail "Die weitere Netzwerkschnittstelle konnte nicht ausgewählt werden."
candidate_count="$(/usr/bin/python3 -I "${network_helper}" --field candidate_count)" ||
  fail "Die Anzahl geeigneter Schnittstellen konnte nicht bestimmt werden."
[[ -n "${selected_interface}" ]] ||
  fail "Die ausgewählte weitere Netzwerkschnittstelle ist leer."

rm -rf -- "${workdir}"
install -d -m 0755 -o "${lab_user}" -g "${lab_group}" "${workdir}"

cat >"${workdir}/stationsprotokoll.txt" <<'PROTOCOL'
STATIONSPROTOKOLL – NACHTSTATION

Vorhersage: eine Adresse / mehrere Adressen

Hostname:
Loopback-Schnittstelle:
Loopback-Adresse:
Weitere Netzwerkschnittstelle:
IPv4-Adresse dieser Schnittstelle:

Selbst-Erklärung:
Ein Host kann mehrere Schnittstellen und Adressen besitzen, weil ...
PROTOCOL

if [[ "${candidate_count}" == "1" ]]; then
  cat >"${workdir}/stationsauftrag.txt" <<'ASSIGNMENT'
STATIONSAUFTRAG – AUSWAHL DER WEITEREN SCHNITTSTELLE

In dieser Sitzung gibt es genau eine Nicht-Loopback-Schnittstelle mit einer
IPv4-Adresse. Verwende diese Schnittstelle und ihre IPv4-Adresse für das
Stationsprotokoll.
ASSIGNMENT
else
  cat >"${workdir}/stationsauftrag.txt" <<ASSIGNMENT
STATIONSAUFTRAG – AUSWAHL DER WEITEREN SCHNITTSTELLE

In dieser Sitzung gibt es mehrere Nicht-Loopback-Schnittstellen mit einer
IPv4-Adresse. Damit der CHECK eindeutig bleibt, verwendet dieser Workshop:

${selected_interface}

Die Auswahl wurde intern nach einer reproduzierbaren Regel getroffen.
Untersuche die genannte Schnittstelle mit ip address. Die Auswahlregel ist
für Autorinnen und Autoren dokumentiert, aber in diesem Workshop kein
zusätzliches Lernziel.
ASSIGNMENT
fi

chown "${lab_user}:${lab_group}" \
  "${workdir}/stationsprotokoll.txt" \
  "${workdir}/stationsauftrag.txt"
chmod 0644 \
  "${workdir}/stationsprotokoll.txt" \
  "${workdir}/stationsauftrag.txt"

cat >"${lab_home}/.bash_profile" <<PROFILE
PS1='\u@\h:\w\$ '
alias ls='ls --color=auto'
cd "${workdir}"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE

chown "${lab_user}:${lab_group}" "${lab_home}/.bash_profile"
chmod 0644 "${lab_home}/.bash_profile"

[[ "$(hostname)" == "${lab_hostname}" ]] ||
  fail "Der aktive Hostname entspricht nicht dem Sollzustand."

[[ "$(stat -c '%U:%G:%a' "${workdir}/stationsprotokoll.txt")" == \
  "${lab_user}:${lab_group}:644" ]] ||
  fail "Die Teilnehmerdatei besitzt nicht die vorgesehenen Rechte."

/usr/bin/python3 -I "${network_helper}" >/dev/null ||
  fail "Der dynamische Netzwerkzustand ist nach dem Setup nicht auswertbar."

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "${lab_user}"
