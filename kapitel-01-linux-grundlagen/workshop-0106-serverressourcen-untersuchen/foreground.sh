#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lab_hostname="leuchtturm"
readonly work_dir="${lab_home}/leuchtturm/aussenstation"
readonly ready_file="/var/lib/labforge/serverressourcen-untersuchen/setup-ready"

for _ in {1..450}; do
  [[ -f "$ready_file" ]] && break
  sleep 0.1
done

[[ -f "$ready_file" && ! -L "$ready_file" ]] || {
  printf '%s\n' 'Das Workshop-Setup wurde nicht rechtzeitig fertig.' >&2
  exit 1
}
[[ "$(<"$ready_file")" == workshop-0106-ready:* ]] || {
  printf '%s\n' 'Das Workshop-Setup meldet keinen gültigen Bereitschaftsstatus.' >&2
  exit 1
}
[[ "$(id -un "$lab_user")" == "$lab_user" ]] || {
  printf '%s\n' 'Der Workshop-Benutzer wurde nicht vorbereitet.' >&2
  exit 1
}
[[ "$(getent passwd "$lab_user" | cut -d: -f6)" == "$lab_home" ]] || {
  printf '%s\n' 'Das Home-Verzeichnis des Workshop-Benutzers ist nicht korrekt.' >&2
  exit 1
}
[[ "$(getent passwd "$lab_user" | cut -d: -f7)" == "/bin/bash" ]] || {
  printf '%s\n' 'Die Shell des Workshop-Benutzers ist nicht korrekt.' >&2
  exit 1
}
[[ "$(hostname)" == "$lab_hostname" && -d "$work_dir" ]] || {
  printf '%s\n' 'Hostname oder Arbeitsbereich wurden nicht vollständig vorbereitet.' >&2
  exit 1
}

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "$lab_user"
