#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly work_dir="${lab_home}/leuchtturm/aussenstation"
readonly state_dir="/var/lib/labforge/serverressourcen-untersuchen"

getent group "$lab_user" >/dev/null 2>&1 || groupadd "$lab_user"
if ! id "$lab_user" >/dev/null 2>&1; then
  useradd --create-home --home-dir "$lab_home" --shell /bin/bash \
    --gid "$lab_user" "$lab_user"
fi
usermod --home "$lab_home" --shell /bin/bash --gid "$lab_user" \
  "$lab_user" >/dev/null

stop_saved_process() {
  local pid="$1" expected_comm="$2" expected_exe="$3" actual_exe
  [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 0
  [[ -r "/proc/${pid}/comm" && -r "/proc/${pid}/cmdline" ]] || return 0
  [[ "$(<"/proc/${pid}/comm")" == "$expected_comm" ]] || return 0
  [[ "$(stat -c '%U' "/proc/${pid}")" == "$lab_user" ]] || return 0
  IFS= read -r -d '' actual_exe <"/proc/${pid}/cmdline" || return 0
  [[ "$actual_exe" == "$expected_exe" ]] || return 0
  kill "$pid" 2>/dev/null || true
}

if [[ -f "$state_dir/beschwoerung-started.marker" ]]; then
  worker_pid="$(awk -F= '$1 == "pid" { print $2 }' \
    "$state_dir/beschwoerung-started.marker")"
  regulator_pid="$(awk -F= '$1 == "regulator_pid" { print $2 }' \
    "$state_dir/beschwoerung-started.marker")"
  stop_saved_process "$regulator_pid" lastregler \
    /usr/local/lib/leuchtturm/lastregler
  stop_saved_process "$worker_pid" beschwoerung \
    /usr/local/lib/leuchtturm/beschwoerung
fi
if [[ -f "$state_dir/leuchtfeuer-started.marker" ]]; then
  leuchtfeuer_pid="$(awk -F= '$1 == "pid" { print $2 }' \
    "$state_dir/leuchtfeuer-started.marker")"
  stop_saved_process "$leuchtfeuer_pid" leuchtfeuer \
    /usr/local/lib/leuchtturm/leuchtfeuer
fi

rm -rf -- "$state_dir" "$lab_home/leuchtturm"
install -d -m 0750 -o "$lab_user" -g "$lab_user" "$lab_home"
install -d -m 0755 -o "$lab_user" -g "$lab_user" \
  "$lab_home/leuchtturm" "$work_dir" "$work_dir/status"

printf '%s\n' 'leuchtturm' >/etc/hostname
hostname leuchtturm >/dev/null 2>&1 || true

cat >"$lab_home/.bash_profile" <<PROFILE
if [[ -f "\${HOME}/.bashrc" ]]; then source "\${HOME}/.bashrc"; fi
cd "$work_dir"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE
cat >"$lab_home/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
BASHRC
chown "$lab_user:$lab_user" "$lab_home/.bash_profile" "$lab_home/.bashrc"
chmod 0644 "$lab_home/.bash_profile" "$lab_home/.bashrc"

/tmp/workshop-0106-assets/prepare-workshop \
  >/tmp/workshop-0106-prepare.log 2>&1 || true

install -d -m 0755 -o root -g root /usr/local/lib/leuchtturm
if [[ ! -x /usr/local/lib/leuchtturm/beschwoerung ]]; then
  install -m 0755 -o root -g root /bin/bash \
    /usr/local/lib/leuchtturm/beschwoerung
fi
install -m 0755 -o root -g root /bin/bash \
  /usr/local/lib/leuchtturm/leuchtfeuer
install -d -m 0750 -o "$lab_user" -g "$lab_user" "$state_dir"
if [[ ! -s "$state_dir/session-id" ]]; then
  cat /proc/sys/kernel/random/uuid >"$state_dir/session-id"
  chown "$lab_user:$lab_user" "$state_dir/session-id"
  chmod 0640 "$state_dir/session-id"
fi
install -m 0755 -o root -g root \
  /tmp/workshop-0106-assets/flag-einreichen /usr/local/bin/flag-einreichen
install -m 0755 -o "$lab_user" -g "$lab_user" \
  /tmp/workshop-0106-assets/leuchtfeuer-start "$work_dir/leuchtfeuer-start"
install -m 0644 -o "$lab_user" -g "$lab_user" \
  /tmp/workshop-0106-assets/wartungsnotiz.txt "$work_dir/wartungsnotiz.txt"

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "$lab_user"
