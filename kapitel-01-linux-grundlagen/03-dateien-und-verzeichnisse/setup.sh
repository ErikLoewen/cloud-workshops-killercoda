#!/usr/bin/env bash
set -Eeuo pipefail

base="/root/dateilabor"

if [[ "$base" != "/root/dateilabor" ]]; then
  echo "Interner Fehler: unerwarteter Übungspfad." >&2
  exit 1
fi

rm -rf -- "$base"
mkdir -p -- "$base/eingang" "$base/uebung"
printf 'vorlage\n' > "$base/eingang/entwurf.txt"

if [[ ! -d "$base/eingang" || ! -d "$base/uebung" ]]; then
  echo "Das Setup konnte die Ausgangsverzeichnisse nicht herstellen." >&2
  exit 1
fi

if ! cmp -s "$base/eingang/entwurf.txt" <(printf 'vorlage\n'); then
  echo "Das Setup konnte den Inhalt der Quelldatei nicht korrekt herstellen." >&2
  exit 1
fi

if [[ -e "$base/projekt" ]]; then
  echo "Das Setup hat unerwartet den Abschlussbereich erzeugt." >&2
  exit 1
fi
