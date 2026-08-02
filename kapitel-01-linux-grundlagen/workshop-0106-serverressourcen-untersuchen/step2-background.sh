#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="waerter"
readonly state_dir="/var/lib/labforge/serverressourcen-untersuchen"
readonly activated="${state_dir}/stoerung-aktiviert"
readonly started="${state_dir}/beschwoerung-started.marker"
readonly lock_file="${state_dir}/stoerung-start.lock"
readonly worker="/usr/local/lib/leuchtturm/beschwoerung"
readonly log_file="/tmp/workshop-0106-step2-background.log"

exec >>"$log_file" 2>&1
trap 'exit 0' ERR

[[ -x "$worker" && -d "$state_dir" ]] || exit 0
exec 9>"$lock_file"
flock 9
[[ ! -e "$activated" ]] || exit 0

worker_pids=()
for proc in /proc/[0-9]*; do
  pid="${proc#/proc/}"
  [[ -r "$proc/comm" && -r "$proc/cmdline" ]] || continue
  [[ "$(<"$proc/comm")" == "beschwoerung" ]] || continue
  IFS= read -r -d '' actual_exe <"$proc/cmdline" || continue
  [[ "$actual_exe" == "$worker" ]] || continue
  [[ "$(stat -c '%U' "$proc")" == "$lab_user" ]] || continue
  worker_pids+=("$pid")
done

if ((${#worker_pids[@]} == 0)); then
  duty_cycle='trap "exit 0" TERM INT
while :; do
  start=${EPOCHREALTIME/./}
  while (( 10#${EPOCHREALTIME/./} - 10#$start < 15000 )); do :; done
  sleep 0.085
done'
  command=(/usr/bin/setsid --fork /usr/bin/nice -n 15 "$worker" -c "$duty_cycle")
  if [[ "$(id -un)" == "$lab_user" ]]; then
    "${command[@]}" 9>&- </dev/null >/dev/null 2>&1
  else
    runuser -u "$lab_user" -- "${command[@]}" \
      9>&- </dev/null >/dev/null 2>&1
  fi
fi

worker_pid=""
for _ in {1..30}; do
  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    [[ -r "$proc/comm" && -r "$proc/cmdline" ]] || continue
    [[ "$(<"$proc/comm")" == "beschwoerung" ]] || continue
    IFS= read -r -d '' actual_exe <"$proc/cmdline" || continue
    [[ "$actual_exe" == "$worker" ]] || continue
    [[ "$(stat -c '%U' "$proc")" == "$lab_user" ]] || continue
    worker_pid="$pid"
    break 2
  done
  sleep 0.1
done
[[ "$worker_pid" =~ ^[1-9][0-9]*$ ]] || exit 0
[[ "$(ps -o ni= -p "$worker_pid" | tr -d ' ')" == "15" ]] || exit 0

session_id="$(<"$state_dir/session-id")"
tmp="$(mktemp "$state_dir/beschwoerung-started.marker.tmp.XXXXXX")"
printf 'session_id=%s\npid=%s\nnice=15\n' "$session_id" "$worker_pid" >"$tmp"
chmod 0640 "$tmp"
chown "$lab_user:$lab_user" "$tmp"
mv -f -- "$tmp" "$started"

tmp="$(mktemp "$state_dir/stoerung-aktiviert.tmp.XXXXXX")"
printf 'session_id=%s\nresult=activated\n' "$session_id" >"$tmp"
chmod 0644 "$tmp"
chown "$lab_user:$lab_user" "$tmp"
mv -f -- "$tmp" "$activated"
flock -u 9
exit 0
