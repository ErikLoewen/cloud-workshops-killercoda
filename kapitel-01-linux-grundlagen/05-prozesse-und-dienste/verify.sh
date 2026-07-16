#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/var/lib/labforge/prozesse-und-dienste"
readonly session_file="$state_dir/session-id"
readonly worker_marker="$state_dir/worker-start.marker"
readonly initial_marker="$state_dir/service-initial-active.marker"
readonly stop_marker="$state_dir/service-stop.marker"
readonly start_marker="$state_dir/service-start-after-stop.marker"
readonly real_systemctl="/usr/bin/systemctl"

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
  [[ "$(<"/proc/$pid/comm")" == "lab-worker" ]] || return 1
  local cmdline
  cmdline="$(tr '\0' ' ' <"/proc/$pid/cmdline")"
  [[ "$cmdline" == *"/usr/local/lib/labforge/lab-worker.py"* ]]
}

[[ -s "$session_file" ]] || fail "Die Szenariositzung wurde nicht korrekt vorbereitet."
session_id="$(<"$session_file")"

# Prozesszustand: nur Startnachweis und aktuelles Nichtlaufen.
[[ -s "$worker_marker" ]] || fail "Der Startnachweis für lab-worker fehlt."
[[ "$(read_value "$worker_marker" session_id)" == "$session_id" ]] || fail "Der Worker-Startnachweis gehört nicht zur aktuellen Szenariositzung."
[[ "$(read_value "$worker_marker" pid)" =~ ^[1-9][0-9]*$ ]] || fail "Der Worker-Startnachweis enthält keine gültige Start-PID."

for proc in /proc/[0-9]*; do
  pid="${proc##*/}"
  if is_own_worker "$pid"; then
    fail "lab-worker läuft noch. Beende die aktuell laufende eigene Instanz und prüfe erneut."
  fi
done

# Dienstereignisse und Reihenfolge.
for marker in "$initial_marker" "$stop_marker" "$start_marker"; do
  [[ -s "$marker" ]] || fail "Ein erforderlicher Dienstnachweis fehlt: $(basename "$marker")."
  [[ "$(read_value "$marker" session_id)" == "$session_id" ]] || fail "Ein Dienstnachweis gehört nicht zur aktuellen Szenariositzung: $(basename "$marker")."
done

stop_sequence="$(read_value "$stop_marker" sequence)"
start_sequence="$(read_value "$start_marker" sequence)"
[[ "$stop_sequence" =~ ^[1-9][0-9]*$ ]] || fail "Der Stopmarker besitzt keine gültige Ereignisnummer."
[[ "$start_sequence" =~ ^[1-9][0-9]*$ ]] || fail "Der Startmarker besitzt keine gültige Ereignisnummer."
(( start_sequence > stop_sequence )) || fail "Der registrierte Dienststart liegt nicht nach dem registrierten Stop."

active_state="$("$real_systemctl" show -p ActiveState --value lab-demo.service 2>/dev/null || true)"
[[ "$active_state" == "active" ]] || fail "lab-demo.service ist aktuell nicht aktiv. Starte die Unit und prüfe ihren Status."

main_pid="$("$real_systemctl" show -p MainPID --value lab-demo.service 2>/dev/null || true)"
[[ "$main_pid" =~ ^[1-9][0-9]*$ ]] || fail "lab-demo.service besitzt aktuell keine gültige Main PID."
[[ -r "/proc/$main_pid/comm" && -r "/proc/$main_pid/cmdline" ]] || fail "Der zur Main PID gehörende Prozess ist nicht vorhanden."

runner_comm="$(<"/proc/$main_pid/comm")"
runner_cmdline="$(tr '\0' ' ' <"/proc/$main_pid/cmdline")"
[[ "$runner_comm" == "lab-demo-svc" ]] || fail "Die Main PID besitzt nicht den erwarteten Prozessnamen."
[[ "$runner_cmdline" == *"/usr/local/lib/labforge/lab-demo-runner.py"* ]] || fail "Die Main PID gehört nicht zum eigenen Demo-Runner."

echo "Abschluss-CHECK erfolgreich: Der isolierte Prozessendzustand und der Dienstendzustand sind erreicht."
echo "Technische Grenze: Die Prozessprüfung weist weder die Verwendung von & noch bestimmte Diagnose- oder Steuerbefehle nach."
