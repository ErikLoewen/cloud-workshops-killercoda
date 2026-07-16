#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/var/lib/labforge/prozesse-und-dienste"
readonly session_file="$state_dir/session-id"
readonly stop_marker="$state_dir/service-stop.marker"
readonly real_systemctl="/usr/bin/systemctl"

fail() {
  echo "$*" >&2
  exit 1
}

read_value() {
  local file="$1"
  local key="$2"
  sed -n "s/^${key}=//p" "$file" | head -n 1
}

[[ -s "$session_file" ]] || fail "Die Szenariositzung wurde nicht korrekt vorbereitet."
session_id="$(<"$session_file")"

[[ -s "$stop_marker" ]] || fail "Ein gültiger Stop des Demo-Dienstes wurde noch nicht registriert."
[[ "$(read_value "$stop_marker" session_id)" == "$session_id" ]] || fail "Der Stopmarker gehört nicht zur aktuellen Szenariositzung."
[[ "$(read_value "$stop_marker" sequence)" =~ ^[1-9][0-9]*$ ]] || fail "Der Stopmarker enthält keine gültige Ereignisnummer."

active_state="$("$real_systemctl" show -p ActiveState --value lab-demo.service 2>/dev/null || true)"
[[ "$active_state" == "inactive" ]] || fail "lab-demo.service ist aktuell nicht inaktiv. Zeige den Status an und prüfe die beabsichtigte Zustandsänderung."

echo "Dienst-Teilcheck erfolgreich: Ein gültiger Stop wurde registriert und lab-demo.service ist aktuell inaktiv."
