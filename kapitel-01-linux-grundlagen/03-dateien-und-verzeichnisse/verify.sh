#!/usr/bin/env bash
set -Eeuo pipefail

base="/root/dateilabor"
project="$base/projekt"
texts="$project/texte"
status_file="$texts/status.txt"
target_file="$project/hinweis.txt"
source_file="$base/eingang/entwurf.txt"

if [[ ! -d "$project" ]]; then
  echo "Das Hauptverzeichnis /root/dateilabor/projekt fehlt."
  echo "Prüfe deinen Standort und die vorhandenen Einträge mit pwd und ls."
  exit 1
fi

if [[ ! -d "$texts" ]]; then
  echo "Das Unterverzeichnis /root/dateilabor/projekt/texte fehlt."
  echo "Prüfe mit ls den Inhalt des Verzeichnisses projekt."
  exit 1
fi

if [[ -e "$status_file" && ! -f "$status_file" ]]; then
  echo "Der Pfad /root/dateilabor/projekt/texte/status.txt existiert, ist aber keine reguläre Datei."
  exit 1
fi

if [[ ! -f "$status_file" ]]; then
  mapfile -t misplaced_status_files < <(
    find "$base" -type f -name 'status.txt' ! -path "$status_file" -print 2>/dev/null | sort
  )

  if (( ${#misplaced_status_files[@]} > 0 )); then
    echo "Die Statusdatei liegt am falschen Ort: ${misplaced_status_files[0]}"
    echo "Gefordert ist /root/dateilabor/projekt/texte/status.txt."
  else
    echo "Die Statusdatei /root/dateilabor/projekt/texte/status.txt fehlt."
    echo "Prüfe den Zielpfad und den Inhalt des Verzeichnisses texte."
  fi
  exit 1
fi

if ! cmp -s "$status_file" <(printf 'bereit\n'); then
  echo "Der Inhalt von /root/dateilabor/projekt/texte/status.txt stimmt nicht."
  echo "Gefordert ist exakt die Zeile bereit mit abschließendem Zeilenumbruch."
  exit 1
fi

if [[ -e "$target_file" && ! -f "$target_file" ]]; then
  echo "Der Pfad /root/dateilabor/projekt/hinweis.txt existiert, ist aber keine reguläre Datei."
  exit 1
fi

if [[ ! -f "$target_file" ]]; then
  echo "Das Verschiebe- und Umbenennungsziel /root/dateilabor/projekt/hinweis.txt fehlt."
  echo "Prüfe Quelle und Ziel deiner Dateioperation."
  exit 1
fi

if ! cmp -s "$target_file" <(printf 'vorlage\n'); then
  echo "Der Inhalt von /root/dateilabor/projekt/hinweis.txt stimmt nicht mehr."
  echo "Die verschobene Datei muss weiterhin exakt die Zeile vorlage enthalten."
  exit 1
fi

if [[ -e "$source_file" ]]; then
  echo "Der alte Quellpfad /root/dateilabor/eingang/entwurf.txt existiert noch."
  echo "Das Objekt muss sich nach dem Verschieben nur am Zielort befinden."
  exit 1
fi

echo "Technischer Endzustand korrekt: Verzeichnisse, Zielpfade und Dateiinhalte stimmen."
echo "Diese Prüfung bewertet weder die verwendete Befehlsfolge noch das Verständnis."
