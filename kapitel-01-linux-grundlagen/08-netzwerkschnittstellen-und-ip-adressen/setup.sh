#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C
export LANG=C

target_dir="/root/netzwerklabor"
target_file="${target_dir}/netzwerkstatus.txt"

if ! command -v ip >/dev/null 2>&1; then
  echo "Technischer Umgebungsfehler: Der Befehl 'ip' ist in dieser Lernumgebung nicht verfügbar." >&2
  echo "Das Szenario kann ohne dieses lokale Diagnosewerkzeug nicht gestartet werden." >&2
  exit 1
fi

mkdir -p "$target_dir"
rm -f "$target_file"

if [[ ! -d "$target_dir" || ! -w "$target_dir" ]]; then
  echo "Technischer Umgebungsfehler: Das Verzeichnis $target_dir ist nicht beschreibbar." >&2
  exit 1
fi
