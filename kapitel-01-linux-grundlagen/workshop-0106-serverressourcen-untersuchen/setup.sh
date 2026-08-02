#!/usr/bin/env bash
set -Eeuo pipefail
readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly work_dir="${lab_home}/leuchtturm/aussenstation"
readonly state_dir="/var/lib/labforge/serverressourcen-untersuchen"
readonly install_dir="/usr/local/lib/leuchtturm"
readonly install_marker="${install_dir}/.workshop-0106"
readonly beschwoerung_bin="${install_dir}/beschwoerung"
readonly leuchtfeuer_bin="${install_dir}/leuchtfeuer"
readonly flag_asset="/tmp/workshop-0106-assets/flag-einreichen"
readonly expected_install_marker="LabForge Workshop 0106 process binaries"

fail() { printf 'Setup-Fehler: %s\n' "$1" >&2; exit 1; }

process_matches() {
  local pid="$1" expected_comm="$2" expected_exe="$3"
  local actual_comm actual_exe
  [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 1
  [[ -r "/proc/${pid}/comm" && -r "/proc/${pid}/cmdline" ]] || return 1
  actual_comm="$(<"/proc/${pid}/comm")"
  [[ "$actual_comm" == "$expected_comm" ]] || return 1
  IFS= read -r -d '' actual_exe <"/proc/${pid}/cmdline" || return 1
  [[ "$actual_exe" == "$expected_exe" ]]
}

matching_pids() {
  local expected_comm="$1" expected_exe="$2" proc pid
  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    process_matches "$pid" "$expected_comm" "$expected_exe" && printf '%s\n' "$pid"
  done
}

stop_workshop_processes() {
  local expected_comm="$1" expected_exe="$2"
  local -a pids=()
  mapfile -t pids < <(matching_pids "$expected_comm" "$expected_exe")
  ((${#pids[@]} == 0)) || kill "${pids[@]}" 2>/dev/null || true
  for _ in {1..30}; do
    mapfile -t pids < <(matching_pids "$expected_comm" "$expected_exe")
    ((${#pids[@]} == 0)) && return 0
    sleep 0.1
  done
  # Nur exakt erkannte Workshopprozesse werden beim Reset notfalls erzwungen beendet.
  kill -KILL "${pids[@]}" 2>/dev/null || true
  for _ in {1..20}; do
    mapfile -t pids < <(matching_pids "$expected_comm" "$expected_exe")
    ((${#pids[@]} == 0)) && return 0
    sleep 0.1
  done
  fail "Alte ${expected_comm}-Instanzen ließen sich nicht zurücksetzen."
}

atomic_write() {
  local target="$1" content="$2" mode="${3:-0644}" tmp
  tmp="$(mktemp "${target}.tmp.XXXXXX")"
  printf '%s\n' "$content" >"$tmp"
  chmod "$mode" "$tmp"
  mv -f -- "$tmp" "$target"
}

for command_name in nice setsid runuser flock ps pgrep top; do
  command -v "$command_name" >/dev/null 2>&1 ||
    fail "${command_name} ist nicht verfügbar."
done
[[ -x /bin/sleep ]] || fail "/bin/sleep ist nicht verfügbar."
[[ -f "$flag_asset" && ! -L "$flag_asset" ]] || fail "Das Asset flag-einreichen fehlt."

getent group "$lab_user" >/dev/null 2>&1 || groupadd "$lab_user"
if ! id "$lab_user" >/dev/null 2>&1; then
  useradd --create-home --shell /bin/bash --gid "$lab_user" "$lab_user"
fi
usermod --shell /bin/bash --gid "$lab_user" "$lab_user" >/dev/null
printf '%s\n' 'leuchtturm' >/etc/hostname
hostname leuchtturm 2>/dev/null || true

if [[ -e "$install_dir" ]]; then
  [[ -f "$install_marker" ]] || fail "$install_dir existiert, gehört aber nicht zu Workshop 0106."
  [[ "$(<"$install_marker")" == "$expected_install_marker" ]] ||
    fail "$install_dir besitzt einen unerwarteten Workshopmarker."
  stop_workshop_processes beschwoerung "$beschwoerung_bin"
  stop_workshop_processes leuchtfeuer "$leuchtfeuer_bin"
else
  install -d -m 0755 -o root -g root "$install_dir"
fi
atomic_write "$install_marker" "$expected_install_marker"

beschwoerung_mode="yes"
if [[ -x /usr/bin/yes && ! -L /usr/bin/yes ]]; then
  install -m 0755 -o root -g root /usr/bin/yes "$beschwoerung_bin"
elif [[ -x /bin/bash ]]; then
  install -m 0755 -o root -g root /bin/bash "$beschwoerung_bin"
  beschwoerung_mode="bash-fallback"
else
  fail "Weder /usr/bin/yes noch /bin/bash ist als kontrollierter CPU-Worker verfügbar."
fi
leuchtfeuer_mode="sleep"
if [[ -x /bin/sleep && ! -L /bin/sleep ]]; then
  install -m 0755 -o root -g root /bin/sleep "$leuchtfeuer_bin"
elif [[ -x /bin/bash ]]; then
  install -m 0755 -o root -g root /bin/bash "$leuchtfeuer_bin"
  leuchtfeuer_mode="bash-fallback"
else
  fail "Weder eine kopierbare sleep-Binärdatei noch /bin/bash ist verfügbar."
fi

rm -rf -- "$state_dir" "$work_dir"
install -d -m 0755 -o root -g root /var/lib/labforge
install -d -m 0750 -o "$lab_user" -g "$lab_user" "$state_dir"
install -d -m 0755 -o "$lab_user" -g "$lab_user" \
  "$lab_home/leuchtturm" "$work_dir" "$work_dir/status"
session_id="$(cat /proc/sys/kernel/random/uuid)"
atomic_write "$state_dir/session-id" "$session_id" 0640
atomic_write "$state_dir/beschwoerung-mode" "$beschwoerung_mode" 0640
atomic_write "$state_dir/leuchtfeuer-mode" "$leuchtfeuer_mode" 0640
chown "$lab_user:$lab_user" "$state_dir/session-id" \
  "$state_dir/beschwoerung-mode" "$state_dir/leuchtfeuer-mode"

cat >"$work_dir/leuchtfeuer-start" <<'SCRIPT'
#!/usr/bin/env bash
set -Eeuo pipefail
readonly state_dir="/var/lib/labforge/serverressourcen-untersuchen"
readonly beschwoerung_bin="/usr/local/lib/leuchtturm/beschwoerung"
readonly leuchtfeuer_bin="/usr/local/lib/leuchtturm/leuchtfeuer"
readonly flag='FLAG{das_licht_brennt_wieder}'

process_matches() {
  local pid="$1" expected_comm="$2" expected_exe="$3" actual_exe
  [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 1
  [[ -r "/proc/${pid}/comm" && -r "/proc/${pid}/cmdline" ]] || return 1
  [[ "$(<"/proc/${pid}/comm")" == "$expected_comm" ]] || return 1
  IFS= read -r -d '' actual_exe <"/proc/${pid}/cmdline" || return 1
  [[ "$actual_exe" == "$expected_exe" ]]
}

process_exists() {
  local expected_comm="$1" expected_exe="$2" proc pid
  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    process_matches "$pid" "$expected_comm" "$expected_exe" && return 0
  done
  return 1
}

atomic_marker() {
  local target="$1" content="$2" tmp
  tmp="$(mktemp "${target}.tmp.XXXXXX")"
  printf '%s\n' "$content" >"$tmp"
  chmod 0640 "$tmp"
  mv -f -- "$tmp" "$target"
}

[[ "$(id -un)" == "waerter" ]] || {
  printf '%s\n' 'Start abgebrochen: leuchtfeuer-start muss als waerter ausgeführt werden.' >&2
  exit 1
}
[[ -s "$state_dir/session-id" ]] || {
  printf '%s\n' 'Start abgebrochen: Die Workshop-Sitzung ist nicht vorbereitet.' >&2
  exit 1
}
exec 9>"$state_dir/leuchtfeuer-start.lock"
flock -n 9 || {
  printf '%s\n' 'Start abgebrochen: Ein Startvorgang läuft bereits.' >&2
  exit 1
}
if process_exists beschwoerung "$beschwoerung_bin"; then
  printf '%s\n' 'Start verweigert: Das System steht weiterhin unter hoher Last.' >&2
  exit 1
fi
if process_exists leuchtfeuer "$leuchtfeuer_bin"; then
  printf '%s\n' 'Start übersprungen: Das Leuchtfeuer läuft bereits.' >&2
  exit 1
fi

leuchtfeuer_command=("$leuchtfeuer_bin" 2147483647)
if [[ "$(<"$state_dir/leuchtfeuer-mode")" == "bash-fallback" ]]; then
  leuchtfeuer_command=(
    "$leuchtfeuer_bin" -c
    'child=""; cleanup() { [[ -z "$child" ]] || kill "$child" 2>/dev/null || true; exit 0; }; trap cleanup TERM INT; /bin/sleep 2147483647 & child=$!; wait "$child" || true'
  )
fi
/usr/bin/setsid --fork "${leuchtfeuer_command[@]}" </dev/null >/dev/null 2>&1
leuchtfeuer_pid=""
for _ in {1..30}; do
  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    if process_matches "$pid" leuchtfeuer "$leuchtfeuer_bin"; then
      leuchtfeuer_pid="$pid"
      break 2
    fi
  done
  sleep 0.1
done
[[ "$leuchtfeuer_pid" =~ ^[1-9][0-9]*$ ]] || {
  printf '%s\n' 'Start fehlgeschlagen: Der Leuchtfeuerprozess wurde nicht aktiv.' >&2
  exit 1
}
session_id="$(<"$state_dir/session-id")"
atomic_marker "$state_dir/leuchtfeuer-started.marker" \
  "session_id=${session_id}
pid=${leuchtfeuer_pid}
result=started"
flock -u 9
printf '%s\n' 'Das Leuchtfeuer fährt hoch. Ein Lichtstrahl schneidet durch den Nebel.'
printf '%s\n' "$flag"
SCRIPT
chmod 0755 "$work_dir/leuchtfeuer-start"
chown "$lab_user:$lab_user" "$work_dir/leuchtfeuer-start"

cat >"$work_dir/wartungsnotiz.txt" <<'NOTE'
Der Rechner besitzt ausreichend Arbeitsspeicher und freien Speicherplatz.
Die Ursache der Stoerung muss in den laufenden Prozessen gesucht werden.
NOTE
chmod 0644 "$work_dir/wartungsnotiz.txt"
chown "$lab_user:$lab_user" "$work_dir/wartungsnotiz.txt"
install -m 0755 -o root -g root "$flag_asset" /usr/local/bin/flag-einreichen

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

beschwoerung_command=("$beschwoerung_bin")
if [[ "$beschwoerung_mode" == "bash-fallback" ]]; then
  beschwoerung_command+=( -c "trap 'exit 0' TERM INT; while :; do :; done" )
fi
affinity_mode="single-worker-fallback"
launcher=(/usr/bin/nice -n 15)
if command -v taskset >/dev/null 2>&1 && taskset -c 0 /bin/true >/dev/null 2>&1; then
  launcher+=(/usr/bin/taskset -c 0)
  affinity_mode="taskset-cpu-0"
fi
launcher+=("${beschwoerung_command[@]}")
runuser -u "$lab_user" -- /usr/bin/setsid --fork "${launcher[@]}" \
  </dev/null >/dev/null 2>&1

mapfile -t beschwoerung_pids < <(matching_pids beschwoerung "$beschwoerung_bin")
for _ in {1..30}; do
  ((${#beschwoerung_pids[@]} == 1)) && break
  sleep 0.1
  mapfile -t beschwoerung_pids < <(matching_pids beschwoerung "$beschwoerung_bin")
done
[[ ${#beschwoerung_pids[@]} -eq 1 ]] || fail "beschwoerung wurde nicht genau einmal gestartet."
beschwoerung_pid="${beschwoerung_pids[0]}"
[[ "$(stat -c '%U' "/proc/${beschwoerung_pid}")" == "$lab_user" ]] ||
  fail "beschwoerung gehört nicht dem Benutzer waerter."
[[ "$(ps -o ni= -p "$beschwoerung_pid" | tr -d ' ')" == "15" ]] ||
  fail "beschwoerung läuft nicht mit Nice-Wert 15."
atomic_write "$state_dir/beschwoerung-started.marker" \
  "session_id=${session_id}
pid=${beschwoerung_pid}
affinity=${affinity_mode}
nice=15" 0640
chown "$lab_user:$lab_user" "$state_dir/beschwoerung-started.marker"
rm -f -- "$state_dir/leuchtfeuer-started.marker" "$state_dir/flag-submitted.marker"
pgrep -x beschwoerung >/dev/null || fail "beschwoerung ist mit pgrep nicht auffindbar."
ps -p "$beschwoerung_pid" -o comm= | grep -qx 'beschwoerung' ||
  fail "beschwoerung ist mit ps nicht eindeutig sichtbar."

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "$lab_user"
