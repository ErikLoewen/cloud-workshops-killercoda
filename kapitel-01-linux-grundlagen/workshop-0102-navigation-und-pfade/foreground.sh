#!/usr/bin/env bash
set -Eeuo pipefail

readonly ready_file="/tmp/navigation-im-nebel/setup-ready"
readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lab_hostname="leuchtturm"

for _ in {1..300}; do
  if [[ -f "${ready_file}" ]]; then
    break
  fi
  sleep 0.1
done

if [[ ! -f "${ready_file}" ]]; then
  printf 'Das Workshop-Setup wurde nicht rechtzeitig fertig.\n' >&2
  exit 1
fi

if [[ "$(id -un "${lab_user}")" != "${lab_user}" ]] ||
  [[ "$(getent passwd "${lab_user}" | cut -d: -f6)" != "${lab_home}" ]] ||
  [[ "$(getent passwd "${lab_user}" | cut -d: -f7)" != "/bin/bash" ]] ||
  [[ "$(hostname)" != "${lab_hostname}" ]]; then
  printf 'Der Workshop-Benutzer wurde nicht vollständig vorbereitet.\n' >&2
  exit 1
fi

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "${lab_user}"
