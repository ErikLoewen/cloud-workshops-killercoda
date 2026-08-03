#!/usr/bin/env bash
set -Eeuo pipefail

readonly session_file='/var/lib/labforge/fragmentiertes-archiv/session-id'
readonly submitted='/home/waerter/leuchtturm/archiv/protokolle/flag-submitted.marker'

if [[ ! -f "$session_file" || -L "$session_file" ]] ||
  [[ ! -f "$submitted" || -L "$submitted" ]]; then
  printf '%s\n' 'CHECK nicht erfolgreich: Die Abschlussflagge wurde noch nicht erfolgreich eingereicht.'
  printf '%s\n' "Nächster Schritt: Führe ./leuchtturm-stabilisieren aus und nutze flag-einreichen 'GEFUNDENE_FLAG'."
  exit 1
fi

session_id="$(<"$session_file")"
if ! grep -qxF "session_id=${session_id}" "$submitted" ||
  ! grep -qxF 'result=workshop-0108-flag-submitted' "$submitted"; then
  printf '%s\n' 'CHECK nicht erfolgreich: Die Flag-Abgabe gehört nicht zur aktuellen Workshop-Sitzung.'
  printf '%s\n' 'Nächster Schritt: Reiche die aktuelle Flag erneut ein.'
  exit 1
fi

printf '%s\n' 'CHECK erfolgreich: Die Abschlussflagge wurde korrekt eingereicht.'
