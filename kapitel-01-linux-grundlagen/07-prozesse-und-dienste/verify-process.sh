#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/var/lib/labforge/prozesse-und-dienste"
readonly session_file="$state_dir/session-id"
readonly marker_file="$state_dir/worker-start.marker"

fail() {
  echo "$*" >&2
  exit 1
}

read_value() {
  local file="$1"
  local key="$2"
  sed -n "s/^${key}=//p" "$file" | head -n 1
}

is_own_worker() {
  local pid="$1"
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  [[ -r "/proc/$pid/comm" && -r "/proc/$pid/cmdline" ]] || return 1

  local comm cmdline
  comm="$(<"/proc/$pid/comm")"
  [[ "$comm" == "lab-worker" ]] || return 1
  cmdline="$(tr '\0' ' ' <"/proc/$pid/cmdline")"
  [[ "$cmdline" == *"/usr/local/lib/labforge/lab-worker.py"* ]]
}

[[ -s "$session_file" ]] || fail "Die Szenariositzung wurde nicht korrekt vorbereitet."
session_id="$(<"$session_file")"

[[ -s "$marker_file" ]] || fail "Der Startnachweis für lab-worker fehlt. Starte das Lab-Programm wie beschrieben und prüfe danach erneut."

marker_session="$(read_value "$marker_file" session_id)"
marker_pid="$(read_value "$marker_file" pid)"

[[ "$marker_session" == "$session_id" ]] || fail "Der Startnachweis gehört nicht zur aktuellen Szenariositzung."
[[ "$marker_pid" =~ ^[1-9][0-9]*$ ]] || fail "Der Startnachweis enthält keine gültige Start-PID."

for proc in /proc/[0-9]*; do
  pid="${proc##*/}"
  if is_own_worker "$pid"; then
    fail "lab-worker läuft noch. Ermittle die aktuelle PID erneut mit pgrep lab-worker und beende genau diese PID."
  fi
done

echo "Prozess-Teilcheck erfolgreich: lab-worker wurde in dieser Sitzung gestartet und keine eigene Instanz läuft mehr."
echo "Technische Grenze: Dieser CHECK weist nicht nach, welche Befehle oder ob & verwendet wurden."
