#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/tmp/labforge-terminal-sicher-bedienen"
readonly watcher_script="${state_dir}/watch-sleep-30.sh"
readonly watcher_pid_file="${state_dir}/watcher.pid"
readonly started_file="${state_dir}/sleep-started"
readonly process_file="${state_dir}/sleep-process"
readonly target_file="${state_dir}/target-shell"
readonly watcher_log="${state_dir}/watcher.log"
readonly ready_file="${state_dir}/setup-ready"
readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lab_hostname="leuchtturm"
readonly sudoers_file="/etc/sudoers.d/${lab_user}"

install -d -m 0700 "${state_dir}"
rm -f "${ready_file}" "${ready_file}.tmp"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

configure_user() {
  if ! getent group "${lab_user}" >/dev/null 2>&1; then
    groupadd "${lab_user}"
  fi

  if ! id "${lab_user}" >/dev/null 2>&1; then
    useradd \
      --create-home \
      --home-dir "${lab_home}" \
      --shell /bin/bash \
      --gid "${lab_user}" \
      "${lab_user}"
  fi

  usermod \
    --home "${lab_home}" \
    --shell /bin/bash \
    --gid "${lab_user}" \
    "${lab_user}"
  install -d -m 0750 -o "${lab_user}" -g "${lab_user}" "${lab_home}"
  chown -R "${lab_user}:${lab_user}" "${lab_home}"

  cat >"${lab_home}/.bash_profile" <<'PROFILE'
if [[ -f "${HOME}/.bashrc" ]]; then
  source "${HOME}/.bashrc"
fi

clear 2>/dev/null || printf '\033[2J\033[H'
PROFILE

  cat >"${lab_home}/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
BASHRC

  chown "${lab_user}:${lab_user}" \
    "${lab_home}/.bash_profile" \
    "${lab_home}/.bashrc"
  chmod 0644 \
    "${lab_home}/.bash_profile" \
    "${lab_home}/.bashrc"
}

configure_hostname() {
  printf '%s\n' "${lab_hostname}" >"/etc/hostname"

  if command -v hostnamectl >/dev/null 2>&1 &&
    hostnamectl set-hostname "${lab_hostname}" >/dev/null 2>&1; then
    :
  elif command -v hostname >/dev/null 2>&1; then
    hostname "${lab_hostname}"
  else
    fail "Der Hostname konnte nicht gesetzt werden."
  fi

  if grep -qE '^[[:space:]]*127\.0\.1\.1[[:space:]]+' /etc/hosts; then
    sed -i -E \
      "s/^[[:space:]]*127\\.0\\.1\\.1[[:space:]]+.*/127.0.1.1 ${lab_hostname}/" \
      /etc/hosts
  else
    printf '127.0.1.1 %s\n' "${lab_hostname}" >>/etc/hosts
  fi
}

configure_sudo() {
  command -v sudo >/dev/null 2>&1 ||
    fail "sudo ist im Basis-Image nicht verfügbar."

  printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "${lab_user}" \
    >"${state_dir}/sudoers.tmp"
  chmod 0440 "${state_dir}/sudoers.tmp"

  if command -v visudo >/dev/null 2>&1; then
    visudo -cf "${state_dir}/sudoers.tmp" >/dev/null
  fi

  install -o root -g root -m 0440 \
    "${state_dir}/sudoers.tmp" \
    "${sudoers_file}"
  rm -f "${state_dir}/sudoers.tmp"

  if [[ "$(su -s /bin/bash -c 'sudo -n whoami' "${lab_user}")" != "root" ]]; then
    fail "Die sudo-Berechtigung für den Workshop-Benutzer ist nicht wirksam."
  fi
}

validate_environment() {
  [[ "$(id -un "${lab_user}")" == "${lab_user}" ]] ||
    fail "Der Workshop-Benutzer fehlt."
  [[ "$(id -u "${lab_user}")" != "0" ]] ||
    fail "Der Workshop-Benutzer darf nicht Root sein."
  [[ "$(getent passwd "${lab_user}" | cut -d: -f6)" == "${lab_home}" ]] ||
    fail "Das Home-Verzeichnis ist nicht korrekt konfiguriert."
  [[ "$(getent passwd "${lab_user}" | cut -d: -f7)" == "/bin/bash" ]] ||
    fail "Bash ist nicht als Login-Shell konfiguriert."
  [[ "$(hostname)" == "${lab_hostname}" ]] ||
    fail "Der aktive Hostname ist nicht korrekt."
}

stop_previous_watcher() {
  [[ -f "${watcher_pid_file}" ]] || return 0

  local old_pid
  old_pid="$(cat "${watcher_pid_file}" 2>/dev/null || true)"

  [[ "${old_pid}" =~ ^[0-9]+$ ]] || return 0
  [[ -r "/proc/${old_pid}/cmdline" ]] || return 0

  if tr '\0' '\n' <"/proc/${old_pid}/cmdline" | grep -Fxq "${watcher_script}"; then
    kill "${old_pid}" 2>/dev/null || true

    for _ in {1..20}; do
      if ! kill -0 "${old_pid}" 2>/dev/null; then
        break
      fi
      sleep 0.05
    done
  fi
}

stop_previous_watcher

rm -f \
  "${watcher_pid_file}" \
  "${started_file}" \
  "${process_file}" \
  "${target_file}" \
  "${watcher_log}"

configure_user
configure_hostname
configure_sudo
validate_environment

cat >"${watcher_script}" <<'WATCHER'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="$1"
readonly target_uid="$2"
readonly started_file="${state_dir}/sleep-started"
readonly process_file="${state_dir}/sleep-process"
readonly target_file="${state_dir}/target-shell"

find_target_shell() {
  local tty_candidate
  local fallback_pid

  tty_candidate="$(
    ps -eo pid=,uid=,tty=,pgid=,tpgid=,comm= |
      awk -v uid="${target_uid}" \
        '$2 == uid && $3 != "?" && $6 == "bash" && $4 == $5 {
          print $1, $3
          exit
        }'
  )"

  if [[ -n "${tty_candidate}" ]]; then
    printf 'tty %s\n' "${tty_candidate}"
    return 0
  fi

  fallback_pid="$(
    ps -eo pid=,uid=,comm= |
      awk -v uid="${target_uid}" \
        '$2 == uid && $3 == "bash" { pid=$1 }
         END { if (pid) print pid }'
  )"

  if [[ -n "${fallback_pid}" ]]; then
    printf 'shell %s -\n' "${fallback_pid}"
    return 0
  fi

  return 1
}

is_exact_sleep_30() {
  local pid="$1"
  local -a argv=()

  [[ -r "/proc/${pid}/cmdline" ]] || return 1
  mapfile -d '' -t argv <"/proc/${pid}/cmdline" || return 1

  [[ "${#argv[@]}" -eq 2 ]] || return 1
  [[ "${argv[0]##*/}" == "sleep" ]] || return 1
  [[ "${argv[1]}" == "30" ]]
}

target_mode=""
target_shell_pid=""
target_tty=""

for _ in {1..300}; do
  if read -r target_mode target_shell_pid target_tty < <(find_target_shell); then
    printf '%s %s %s\n' "${target_mode}" "${target_shell_pid}" "${target_tty}" >"${target_file}"
    break
  fi
  sleep 0.1
done

if [[ -z "${target_mode}" ]]; then
  printf 'Keine Bash-Shell des Workshop-Benutzers gefunden.\n' >&2
  exit 1
fi

while :; do
  while read -r pid ppid tty pgid tpgid comm; do
    [[ "${comm}" == "sleep" ]] || continue

    if [[ "${target_mode}" == "tty" ]]; then
      [[ "${tty}" == "${target_tty}" ]] || continue
      [[ "${pgid}" == "${tpgid}" ]] || continue
    else
      [[ "${ppid}" == "${target_shell_pid}" ]] || continue
      [[ "${pgid}" == "${pid}" ]] || continue
    fi

    is_exact_sleep_30 "${pid}" || continue
    [[ -r "/proc/${pid}/stat" ]] || continue

    start_time="$(awk '{ print $22 }' "/proc/${pid}/stat")"
    printf '%s\n' "${pid} ${start_time} ${target_mode} ${target_tty}" >"${process_file}.tmp"
    mv "${process_file}.tmp" "${process_file}"
    printf 'started\n' >"${started_file}"
    exit 0
  done < <(ps -eo pid=,ppid=,tty=,pgid=,tpgid=,comm=)

  sleep 0.1
done
WATCHER

chmod 0700 "${watcher_script}"

target_uid="$(id -u "${lab_user}")"
nohup "${watcher_script}" "${state_dir}" "${target_uid}" >"${watcher_log}" 2>&1 &
watcher_pid=$!
printf '%s\n' "${watcher_pid}" >"${watcher_pid_file}"

printf 'ready\n' >"${ready_file}.tmp"
mv "${ready_file}.tmp" "${ready_file}"

exit 0
