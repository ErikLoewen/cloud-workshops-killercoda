#!/usr/bin/env bash
set -Eeuo pipefail

readonly submitted="/home/waerter/leuchtturm/obergeschoss/kartenraum/.flag-submitted"

if [[ ! -f "${submitted}" || -L "${submitted}" ]] ||
  [[ "$(<"${submitted}")" != "wall-flag-submitted" ]]; then
  printf '%s\n' "CHECK nicht erfolgreich: Die gefundene Flag wurde noch nicht erfolgreich eingereicht."
  printf '%s\n' "Nächster Schritt: Lies notiz-aus-der-wand.txt mit cat und nutze danach flag-einreichen."
  exit 1
fi

printf '%s\n' "CHECK erfolgreich: Die enthüllte Flag wurde korrekt eingereicht."
