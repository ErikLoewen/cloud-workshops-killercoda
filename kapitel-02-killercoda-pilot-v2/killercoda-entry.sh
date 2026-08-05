#!/usr/bin/env bash
set -Eeuo pipefail

archive="${PILOT_RUNTIME_ARCHIVE:-/tmp/kapitel-02-killercoda-runtime.tar.gz}"
source_dir="/opt/labforge/kapitel-02-killercoda-pilot-source"
state_dir="/var/lib/labforge/nachtleitung-killercoda-pilot"
log_file="/var/log/killercoda/kapitel-02-killercoda-pilot-setup.log"

sandbox_dir=""
if (($# > 0)); then
  if [[ "$1" == "--sandbox" && $# == 2 ]]; then
    sandbox_dir="$2"
  else
    echo "Verwendung: killercoda-entry.sh [--sandbox VERZEICHNIS]" >&2
    exit 2
  fi
fi

[[ -f "$archive" ]] || {
  echo "Runtime-Archiv fehlt: $archive" >&2
  exit 1
}

if [[ -n "$sandbox_dir" ]]; then
  source_dir="$sandbox_dir/source"
  state_dir="$sandbox_dir/state"
  log_file="$sandbox_dir/setup.log"
elif [[ "$(id -u)" != "0" ]]; then
  echo "Der Killercoda-Systemstart muss als root laufen." >&2
  exit 1
fi

install -d -m 0755 "$source_dir"
install -d -m 0700 "$state_dir"
rm -f "$state_dir/setup.ready" "$state_dir/setup.failed"
rm -rf "${source_dir:?}/"*
tar -xzf "$archive" -C "$source_dir"

if [[ -n "$sandbox_dir" ]]; then
  if "$source_dir/setup.sh" --sandbox "$sandbox_dir/system" >"$log_file" 2>&1; then
    printf 'ready\n' >"$state_dir/setup.ready"
    exit 0
  fi
else
  if "$source_dir/setup.sh" >"$log_file" 2>&1; then
    printf 'ready\n' >"$state_dir/setup.ready"
    exit 0
  fi
fi

status=$?
printf '%s\n' "$status" >"$state_dir/setup.failed"
echo "Setup fehlgeschlagen. Protokoll: $log_file" >&2
tail -n 80 "$log_file" >&2 || true
exit "$status"
