#!/usr/bin/env bash
set -Eeuo pipefail

readonly source="/home/waerter/leuchtturm/untergeschoss/lagerraum/archiv/letzter_eintrag.txt"
readonly target="/home/waerter/leuchtturm/obergeschoss/kartenraum/erste-spur.txt"
readonly state_dir="/tmp/workshop-0103"
readonly revealed="${state_dir}/flag-revealed"
readonly submitted="${state_dir}/flag-submitted"
readonly expected_flag="FLAG{erste_spur_im_kartenraum}"

if [[ -e "${source}" ]]; then
  printf '%s\n' "Das Logbuch liegt noch im Archiv."
  printf '%s\n' "Prüfe bei mv die Reihenfolge von Quelle und Ziel."
  exit 1
fi

if [[ ! -f "${target}" ]]; then
  printf '%s\n' "erste-spur.txt wurde nicht direkt im Kartenraum gefunden."
  printf '%s\n' "Prüfe den Zielpfad und die genaue Schreibweise mit ls."
  exit 1
fi

if [[ "$(stat -c '%U:%G' "${target}" 2>/dev/null)" != "waerter:waerter" ]]; then
  printf '%s\n' "Die Spur gehört nicht dem Workshop-Benutzer waerter."
  printf '%s\n' "Starte das Szenario neu und verschiebe die vorbereitete Datei erneut."
  exit 1
fi

if [[ ! -f "${revealed}" ]]; then
  printf '%s\n' "Die vorbereitete Logbuchdatei wurde am Ziel noch nicht erkannt."
  printf '%s\n' "Eine neu angelegte oder kopierte Datei gleichen Namens genügt nicht."
  exit 1
fi

flag_count="$(grep -Fxc -- "${expected_flag}" "${target}" || true)"
if [[ "${flag_count}" != "1" ]]; then
  printf '%s\n' "Die erste Spur ist nicht genau einmal im Logbuch enthalten."
  printf '%s\n' "Lies die Datei mit cat und prüfe, ob der vorgesehene Ablauf vollständig war."
  exit 1
fi

if [[ ! -f "${submitted}" ]]; then
  printf '%s\n' "Die gefundene Flag wurde noch nicht erfolgreich eingereicht."
  printf '%s\n' "Lies erste-spur.txt mit cat und nutze danach flag-einreichen."
  exit 1
fi

printf '%s\n' "CHECK erfolgreich: Die echte Logbuchdatei liegt als erste-spur.txt im Kartenraum."
printf '%s\n' "Die enthüllte Flag wurde korrekt eingereicht."
