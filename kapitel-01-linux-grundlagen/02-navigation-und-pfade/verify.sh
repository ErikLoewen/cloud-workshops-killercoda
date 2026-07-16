#!/usr/bin/env bash
set -Eeuo pipefail

readonly marker="/tmp/labforge-navigation-und-pfade/erfolgreich"
readonly expected="navigation-und-pfade:v1"

if [[ ! -f "$marker" ]]; then
  printf '%s\n' "Der technische Erfolgsmarker fehlt."
  printf '%s\n' "Prüfe mit pwd deinen Standort und untersuche mit ls den Verzeichnisbaum."
  printf '%s\n' "Wechsle in das Zielverzeichnis freigaberaum und führe dort die bereitgestellte technische Lab-Aktion aus."
  exit 1
fi

if ! cmp -s -- "$marker" <(printf '%s' "$expected"); then
  printf '%s\n' "Der technische Erfolgsmarker besitzt nicht den erwarteten Inhalt."
  printf '%s\n' "Prüfe mit pwd und ls erneut den Zielort und führe die bereitgestellte technische Lab-Aktion im freigaberaum noch einmal aus."
  exit 1
fi

printf '%s\n' "CHECK erfolgreich: Der Zielort wurde durch die bereitgestellte Lab-Aktion bestätigt."
