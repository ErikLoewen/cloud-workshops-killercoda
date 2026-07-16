#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/tmp/labforge-terminal-sicher-bedienen"
readonly started_file="${state_dir}/sleep-started"
readonly process_file="${state_dir}/sleep-process"

if [[ ! -f "${started_file}" || ! -f "${process_file}" ]]; then
  echo "Die technische Teilprüfung konnte die vorgesehene sleep-30-Übung noch nicht erkennen."
  echo "Starte die bereits eingeführte Warteübung, beende sie wie geübt und starte den CHECK danach erneut."
  exit 1
fi

read -r recorded_pid recorded_start_time recorded_tty <"${process_file}"

if [[ ! "${recorded_pid}" =~ ^[0-9]+$ || ! "${recorded_start_time}" =~ ^[0-9]+$ ]]; then
  echo "Die technischen Prüfdaten sind unvollständig."
  echo "Starte die Abschlussaufgabe in einer frischen Szenariositzung erneut."
  exit 2
fi

process_is_same=false

if [[ -r "/proc/${recorded_pid}/stat" ]]; then
  current_start_time="$(awk '{ print $22 }' "/proc/${recorded_pid}/stat")"

  if [[ "${current_start_time}" == "${recorded_start_time}" ]]; then
    process_is_same=true
  fi
fi

if [[ "${process_is_same}" == "true" ]]; then
  echo "Der eindeutig zugeordnete Übungsprozess läuft noch."
  echo "Kehre zum Terminal zurück, beende den Vordergrundprozess und starte den CHECK danach erneut."
  exit 1
fi

echo "Die technische Teilprüfung ist bestanden: Der zugeordnete Übungsprozess läuft nicht mehr."
echo "Die Verwendung von Enter, Pfeiltaste nach oben und Ctrl+C sowie dein Begriffsverständnis werden durch die Abschlussfragen und die Beobachtung deiner Arbeit geprüft."
exit 0
