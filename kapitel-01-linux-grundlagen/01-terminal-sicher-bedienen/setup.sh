#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/tmp/labforge-terminal-sicher-bedienen"
readonly watcher_script="${state_dir}/watch-sleep-30.sh"
readonly watcher_pid_file="${state_dir}/watcher.pid"
readonly started_file="${state_dir}/sleep-started"
readonly process_file="${state_dir}/sleep-process"
readonly target_file="${state_dir}/target-shell"
readonly watcher_log="${state_dir}/watcher.log"

install -d -m 0700 "${state_dir}"

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

cat >"${watcher_script}" <<'WATCHER'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="$1"
readonly started_file="${state_dir}/sleep-started"
readonly process_file="${state_dir}/sleep-process"
readonly target_file="${state_dir}/target-shell"

find_target_shell() {
  local tty_candidate
  local fallback_pid

  tty_candidate="$(
    ps -eo pid=,tty=,pgid=,tpgid=,comm= |
      awk '$2 != "?" && $5 == "bash" && $3 == $4 { print $1, $2; exit }'
  )"

  if [[ -n "${tty_candidate}" ]]; then
    printf 'tty %s\n' "${tty_candidate}"
    return 0
  fi

  fallback_pid="$(
    ps -eo pid=,comm=,args= |
      awk '$2 == "bash" && $0 ~ /(^|[[:space:]])-i([[:space:]]|$)/ { pid=$1 } END { if (pid) print pid }'
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
  printf 'Keine interaktive Bash-Shell gefunden.\n' >&2
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

nohup "${watcher_script}" "${state_dir}" >"${watcher_log}" 2>&1 &
watcher_pid=$!
printf '%s\n' "${watcher_pid}" >"${watcher_pid_file}"

exit 0
