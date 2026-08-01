#!/usr/bin/env bash
set -Eeuo pipefail
readonly submitted="/home/mrs_ah/.flag-submitted"
if [[ ! -f "${submitted}" || -L "${submitted}" ]] ||
  [[ "$(<"${submitted}")" != "workshop-0105-flag-submitted" ]]; then
  printf '%s\n' 'CHECK nicht erfolgreich: Die Abschlussflagge wurde noch nicht erfolgreich eingereicht.'
  printf '%s\n' "Nächster Schritt: Führe letzte-nachricht aus und nutze flag-einreichen 'GEFUNDENE_FLAG'."
  exit 1
fi
printf '%s\n' 'CHECK erfolgreich: Die Abschlussflagge wurde korrekt eingereicht.'
