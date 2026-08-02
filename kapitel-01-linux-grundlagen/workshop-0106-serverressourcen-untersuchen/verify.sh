#!/usr/bin/env bash
set -Eeuo pipefail

readonly submitted="/var/lib/labforge/serverressourcen-untersuchen/flag-submitted.marker"

if [[ ! -f "$submitted" || -L "$submitted" ]] ||
  [[ "$(<"$submitted")" != "workshop-0106-flag-submitted" ]]; then
  printf '%s\n' 'CHECK nicht erfolgreich: Die Abschlussflagge wurde noch nicht erfolgreich eingereicht.'
  printf '%s\n' "Nächster Schritt: Starte das Leuchtfeuer und nutze flag-einreichen 'GEFUNDENE_FLAG'."
  exit 1
fi

printf '%s\n' 'CHECK erfolgreich: Die Abschlussflagge wurde korrekt eingereicht.'
