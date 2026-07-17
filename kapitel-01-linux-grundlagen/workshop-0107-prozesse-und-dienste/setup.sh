#!/usr/bin/env bash
set -Eeuo pipefail

readonly asset_dir="/opt/labforge-workshop-07-assets"
readonly state_dir="/var/lib/labforge/prozesse-und-dienste"
readonly install_dir="/usr/local/lib/labforge"
readonly unit_path="/etc/systemd/system/lab-demo.service"
readonly worker_path="/usr/local/bin/lab-worker"
readonly wrapper_path="/usr/local/bin/systemctl"
readonly real_systemctl="/usr/bin/systemctl"

fail() {
  echo "Vorbereitung fehlgeschlagen: $*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Benötigte Asset-Datei fehlt: $1"
}

is_our_unit_file() {
  [[ -f "$1" ]] && grep -qx '# LabForge Workshop 7 isolated service' "$1"
}

is_our_script_file() {
  local file="$1"
  local marker="$2"
  [[ -f "$file" ]] && grep -qF "$marker" "$file"
}

is_our_process() {
  local pid="$1"
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  [[ -r "/proc/$pid/comm" && -r "/proc/$pid/cmdline" ]] || return 1

  local comm cmdline
  comm="$(<"/proc/$pid/comm")"
  [[ "$comm" == "lab-worker" ]] || return 1
  cmdline="$(tr '\0' ' ' <"/proc/$pid/cmdline")"
  [[ "$cmdline" == *"/usr/local/lib/labforge/lab-worker.py"* ]]
}

stop_old_own_workers() {
  local proc pid
  for proc in /proc/[0-9]*; do
    pid="${proc##*/}"
    if is_our_process "$pid"; then
      kill "$pid" 2>/dev/null || true
    fi
  done

  for _ in {1..30}; do
    local found=0
    for proc in /proc/[0-9]*; do
      pid="${proc##*/}"
      if is_our_process "$pid"; then
        found=1
        break
      fi
    done
    (( found == 0 )) && return 0
    sleep 0.1
  done

  fail "Eine alte eigene lab-worker-Instanz ließ sich nicht normal beenden."
}

atomic_write() {
  local target="$1"
  local content="$2"
  local tmp
  tmp="$(mktemp "${target}.tmp.XXXXXX")"
  printf '%s\n' "$content" >"$tmp"
  chmod 0644 "$tmp"
  mv -f "$tmp" "$target"
}

[[ -x "$real_systemctl" ]] || fail "/usr/bin/systemctl ist nicht verfügbar."
[[ -x /usr/bin/python3 ]] || fail "/usr/bin/python3 ist nicht verfügbar."
command -v ps >/dev/null 2>&1 || fail "ps ist nicht verfügbar."
command -v pgrep >/dev/null 2>&1 || fail "pgrep ist nicht verfügbar."
command -v kill >/dev/null 2>&1 || fail "kill ist nicht verfügbar."

for asset in \
  lab-worker \
  lab-worker.py \
  lab-demo-runner.py \
  lab-demo-event.py \
  lab-demo.service \
  systemctl-no-pager-wrapper; do
  require_file "$asset_dir/$asset"
done

mkdir -p "$state_dir" "$install_dir"
chmod 0755 "$state_dir" "$install_dir"

# Ein zweiter erfolgreicher Aufruf innerhalb derselben Sitzung ist ein No-op.
# So kann ein versehentlicher erneuter Aufruf keinen Lernzustand zurücksetzen.
if [[ -s "$state_dir/setup-complete.marker" && -s "$state_dir/session-id" ]]; then
  completed_session="$(sed -n 's/^session_id=//p' "$state_dir/setup-complete.marker" | head -n 1)"
  current_session="$(<"$state_dir/session-id")"
  if [[ -n "$completed_session" && "$completed_session" == "$current_session" ]]; then
    echo "Die isolierte Workshopumgebung ist bereits vorbereitet."
    exit 0
  fi
fi

# Ein vorhandener gleichnamiger, aber fremder Dienst wird niemals verändert.
if [[ -e "$unit_path" ]] && ! is_our_unit_file "$unit_path"; then
  fail "$unit_path existiert, gehört aber nicht zu diesem Workshop."
fi

# Lifecycle-Tracking vor jeder technischen Bereinigung deaktivieren.
rm -f "$state_dir/service-tracking.enabled"

if is_our_unit_file "$unit_path"; then
  "$real_systemctl" stop lab-demo.service >/dev/null 2>&1 || true
fi

stop_old_own_workers

# Gleichnamige fremde Programme oder Wrapper werden nicht überschrieben.
if [[ -e "$worker_path" ]] && ! is_our_script_file "$worker_path" "LabForge Workshop 7 lab-worker launcher"; then
  fail "$worker_path existiert, gehört aber nicht zu diesem Workshop."
fi

if [[ -e "$wrapper_path" ]] && ! is_our_script_file "$wrapper_path" "LabForge Workshop 7 no-pager wrapper"; then
  fail "$wrapper_path existiert, gehört aber nicht zu diesem Workshop."
fi

install -m 0755 "$asset_dir/lab-worker" "$worker_path"
install -m 0755 "$asset_dir/lab-worker.py" "$install_dir/lab-worker.py"
install -m 0755 "$asset_dir/lab-demo-runner.py" "$install_dir/lab-demo-runner.py"
install -m 0755 "$asset_dir/lab-demo-event.py" "$install_dir/lab-demo-event.py"
install -m 0644 "$asset_dir/lab-demo.service" "$unit_path"
install -m 0755 "$asset_dir/systemctl-no-pager-wrapper" "$wrapper_path"

session_id="$(cat /proc/sys/kernel/random/uuid)"
atomic_write "$state_dir/session-id" "$session_id"

rm -f \
  "$state_dir/worker-start.marker" \
  "$state_dir/worker.lock" \
  "$state_dir/service-initial-active.marker" \
  "$state_dir/service-stop.marker" \
  "$state_dir/service-start-after-stop.marker" \
  "$state_dir/service-stop.pending" \
  "$state_dir/runner-term.marker" \
  "$state_dir/service-events.lock" \
  "$state_dir/setup-complete.marker"

atomic_write "$state_dir/service-event-counter" "0"

"$real_systemctl" daemon-reload
"$real_systemctl" start lab-demo.service

active_state=""
main_pid=""
for _ in {1..50}; do
  active_state="$("$real_systemctl" show -p ActiveState --value lab-demo.service 2>/dev/null || true)"
  main_pid="$("$real_systemctl" show -p MainPID --value lab-demo.service 2>/dev/null || true)"
  if [[ "$active_state" == "active" && "$main_pid" =~ ^[1-9][0-9]*$ && -r "/proc/$main_pid/cmdline" ]]; then
    break
  fi
  sleep 0.1
done

[[ "$active_state" == "active" ]] || fail "lab-demo.service wurde nicht aktiv."
[[ "$main_pid" =~ ^[1-9][0-9]*$ ]] || fail "lab-demo.service besitzt keine gültige Main PID."

runner_comm="$(<"/proc/$main_pid/comm")"
runner_cmdline="$(tr '\0' ' ' <"/proc/$main_pid/cmdline")"
[[ "$runner_comm" == "lab-demo-svc" ]] || fail "Der Demo-Prozess besitzt nicht den erwarteten Namen."
[[ "$runner_cmdline" == *"/usr/local/lib/labforge/lab-demo-runner.py"* ]] || fail "Die Main PID gehört nicht zum eigenen Demo-Runner."

atomic_write "$state_dir/service-initial-active.marker" "session_id=$session_id
main_pid=$main_pid"

# Erst nach dem bestätigten aktiven Ausgangszustand wird Tracking aktiviert.
atomic_write "$state_dir/service-tracking.enabled" "session_id=$session_id"

# Das Setup startet den Teilnehmerprozess nicht und erzeugt keinen Worker-Startmarker.
[[ ! -e "$state_dir/worker-start.marker" ]] || fail "Das Setup darf keinen Worker-Startmarker erzeugen."
[[ ! -e "$state_dir/service-stop.marker" ]] || fail "Das Setup darf keinen Stopmarker erzeugen."
[[ ! -e "$state_dir/service-start-after-stop.marker" ]] || fail "Das Setup darf keinen Start-nach-Stop-Marker erzeugen."

atomic_write "$state_dir/setup-complete.marker" "session_id=$session_id"
echo "Die isolierte Workshopumgebung ist vorbereitet."
