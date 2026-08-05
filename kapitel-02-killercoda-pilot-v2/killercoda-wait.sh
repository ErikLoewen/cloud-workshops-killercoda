#!/usr/bin/env bash
set -Eeuo pipefail

state_dir="/var/lib/labforge/nachtleitung-killercoda-pilot"
log_file="/var/log/killercoda/kapitel-02-killercoda-pilot-setup.log"

for _ in {1..180}; do
  if [[ -f "$state_dir/setup.ready" ]]; then
    echo "Technikpilot bereit."
    echo "Arbeitskonto: telegrafist"
    echo "Arbeitsordner: /home/telegrafist/nachtstation"
    exit 0
  fi

  if [[ -f "$state_dir/setup.failed" ]]; then
    echo "Technikpilot konnte nicht vorbereitet werden." >&2
    tail -n 80 "$log_file" >&2 || true
    exit 1
  fi

  sleep 0.5
done

echo "Timeout: Das Setup wurde nicht innerhalb von 90 Sekunden bereit." >&2
tail -n 80 "$log_file" >&2 || true
exit 1
