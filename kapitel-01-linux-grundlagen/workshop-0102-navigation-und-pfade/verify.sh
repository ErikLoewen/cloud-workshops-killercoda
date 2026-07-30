#!/usr/bin/env bash
set -Eeuo pipefail

readonly marker="/tmp/navigation-im-nebel/erfolgreich"
readonly expected="navigation-im-nebel:v1"

if [[ ! -f "$marker" ]]; then
  printf '%s\n' "Der technische Erfolgsmarker fehlt."
  printf '%s\n' "Prüfe mit pwd deinen Standort und untersuche mit ls den Verzeichnisbaum."
  printf '%s\n' "Finde im Lagerraum das Archiv und dort mit ls den letzten Eintrag."
  printf '%s\n' "Führe anschließend am Fundort die bereitgestellte technische Prüfaktion aus."
  exit 1
fi

if ! cmp -s -- "$marker" <(printf '%s' "$expected"); then
  printf '%s\n' "Der technische Erfolgsmarker besitzt nicht den erwarteten Inhalt."
  printf '%s\n' "Prüfe mit pwd und ls erneut den Fundort und führe dort eintrag-bestaetigen aus."
  exit 1
fi

printf '%s\n' "CHECK erfolgreich: Der letzte Eintrag wurde am vorgesehenen Fundort bestätigt."
