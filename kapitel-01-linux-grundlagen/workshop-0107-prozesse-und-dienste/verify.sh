#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir='/var/lib/labforge/leuchtfeuer-konfiguration'
readonly session_file="${state_dir}/session-id"
readonly submitted='/home/waerter/leuchtturm/lichtsteuerung/status/flag-submitted.marker'

if [[ ! -f "$session_file" || -L "$session_file" ]] ||
  [[ ! -f "$submitted" || -L "$submitted" ]]; then
  printf '%s\n' 'CHECK nicht erfolgreich: Die Abschlussflagge wurde noch nicht erfolgreich eingereicht.'
  printf '%s\n' "Nächster Schritt: Lies status/abschlussflagge und nutze flag-einreichen 'GEFUNDENE_FLAG'."
  exit 1
fi

session_id="$(<"$session_file")"
if ! grep -qxF "session_id=${session_id}" "$submitted" ||
  ! grep -qxF 'result=workshop-0107-flag-submitted' "$submitted"; then
  printf '%s\n' 'CHECK nicht erfolgreich: Die Flag-Abgabe gehört nicht zur aktuellen Workshop-Sitzung.'
  printf '%s\n' "Nächster Schritt: Lies status/abschlussflagge und reiche die aktuelle Flag erneut ein."
  exit 1
fi

printf '%s\n' 'CHECK erfolgreich: Die Abschlussflagge wurde korrekt eingereicht.'
