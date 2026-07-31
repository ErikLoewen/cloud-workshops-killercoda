#!/usr/bin/env bash
set -Eeuo pipefail

readonly submitted="/tmp/workshop-0103/flag-submitted"

if [[ ! -f "${submitted}" || -L "${submitted}" ]] ||
  [[ "$(<"${submitted}")" != "first-flag-submitted" ]]; then
  printf '%s\n' "Die gefundene Flag wurde noch nicht erfolgreich eingereicht."
  printf '%s\n' "Lies erste-spur.txt mit cat und nutze danach flag-einreichen."
  exit 1
fi

printf '%s\n' "CHECK erfolgreich: Die enthüllte Flag wurde korrekt eingereicht."
