#!/usr/bin/env bash
set -Eeuo pipefail

lab_dir="/root/ressourcenlabor"
target="${lab_dir}/serverstatus.txt"

mkdir -p -- "$lab_dir"

if [[ -d "$target" ]]; then
  echo "Setup abgebrochen: $target ist unerwartet ein Verzeichnis." >&2
  exit 1
fi

rm -f -- "$target"
