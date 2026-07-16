#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C
export LANG=C

readonly LAB_ROOT='/root/abschlusslabor'
readonly STATE_ROOT='/var/lib/labforge/linux-grundlagen-praxistransfer'
readonly REF_ROOT="$STATE_ROOT/referenz"
readonly WEB_ROOT="$LAB_ROOT/web"
readonly CHECK_FILE="$LAB_ROOT/pruefung/systemcheck"
readonly MARKER="$STATE_ROOT/systemcheck-ausgefuehrt.marker"
readonly SETUP_TICK_FILE="$STATE_ROOT/vorheriger-setup-zeitpunkt"
readonly PORT='9090'

technical_error() {
  printf '%s\n' "TECHNISCHER SZENARIOFEHLER: $1" >&2
  exit 1
}

guard_tree_path() {
  local actual="$1"
  local expected="$2"

  [[ -n "$actual" ]] || technical_error 'Ein interner Bereinigungspfad ist leer.'
  [[ "$actual" == "$expected" ]] || technical_error "Der Bereinigungspfad '$actual' entspricht nicht dem erwarteten statischen Pfad '$expected'."

  case "$actual" in
    /|/root|/var|/var/lib|.|..|~)
      technical_error "Der gefährliche Bereinigungspfad '$actual' wurde abgelehnt."
      ;;
  esac

  if [[ -L "$actual" ]]; then
    technical_error "Der Laborstamm '$actual' ist ein symbolischer Link und wird nicht bereinigt."
  fi
}

safe_remove_tree() {
  local actual="$1"
  local expected="$2"

  guard_tree_path "$actual" "$expected"
  if [[ -e "$actual" ]]; then
    rm -rf -- "$actual"
  fi
}

listener_state() {
  local previous_tick="${1:-}"

  python3 - "$PORT" "$WEB_ROOT" "$previous_tick" <<'PY'
import glob
import os
import socket
import sys

port = int(sys.argv[1])
expected_cwd = sys.argv[2]
previous_tick_text = sys.argv[3]
previous_tick = int(previous_tick_text) if previous_tick_text.isdigit() else None

def listeners_from(path, family):
    result = []
    try:
        lines = open(path, encoding="ascii").read().splitlines()[1:]
    except OSError:
        return result
    for line in lines:
        fields = line.split()
        if len(fields) < 10 or fields[3] != "0A":
            continue
        address_hex, port_hex = fields[1].split(":")
        if int(port_hex, 16) != port:
            continue
        if family == 4:
            raw = bytes.fromhex(address_hex)
            address = socket.inet_ntop(socket.AF_INET, raw[::-1])
        else:
            address = "IPv6"
        result.append((family, address, fields[9]))
    return result

listeners = listeners_from("/proc/net/tcp", 4) + listeners_from("/proc/net/tcp6", 6)

if not listeners:
    print("FREE")
    raise SystemExit(0)

if len(listeners) != 1:
    print("FOREIGN\tMehrere oder zusätzliche Listener verwenden Port 9090.")
    raise SystemExit(0)

family, address, inode = listeners[0]
if family != 4 or address != "127.0.0.1":
    print(f"FOREIGN\tPort 9090 lauscht nicht ausschließlich an 127.0.0.1, sondern an {address}.")
    raise SystemExit(0)

pids = set()
for proc_dir in glob.glob("/proc/[0-9]*"):
    pid = os.path.basename(proc_dir)
    for fd in glob.glob(f"{proc_dir}/fd/*"):
        try:
            target = os.readlink(fd)
        except OSError:
            continue
        if target == f"socket:[{inode}]":
            pids.add(pid)

if len(pids) != 1:
    print("FOREIGN\tDer Listener lässt sich nicht eindeutig einem Prozess zuordnen.")
    raise SystemExit(0)

pid = next(iter(pids))
try:
    cmdline = open(f"/proc/{pid}/cmdline", "rb").read().split(b"\0")
    args = [part.decode("utf-8", "surrogateescape") for part in cmdline if part]
    cwd = os.readlink(f"/proc/{pid}/cwd")
    stat_text = open(f"/proc/{pid}/stat", encoding="ascii").read()
except OSError:
    print("FOREIGN\tDie Prozessdaten des Listeners konnten nicht vollständig gelesen werden.")
    raise SystemExit(0)

expected_args = ["-m", "http.server", "--bind", "127.0.0.1", "9090"]
is_python = bool(args) and os.path.basename(args[0]).startswith("python")
is_expected_command = is_python and args[1:] == expected_args
is_expected_cwd = cwd in (expected_cwd, expected_cwd + " (deleted)")

if not is_expected_command or not is_expected_cwd:
    print("FOREIGN\tDer Listener gehört nicht eindeutig zum Abschlusslabor.")
    raise SystemExit(0)

if previous_tick is None:
    print("FOREIGN\tFür den Listener fehlt ein früherer Setup-Zeitpunkt.")
    raise SystemExit(0)

tail = stat_text[stat_text.rfind(")") + 2:].split()
if len(tail) <= 19:
    print("FOREIGN\tDer Prozessstartzeitpunkt konnte nicht gelesen werden.")
    raise SystemExit(0)

start_tick = int(tail[19])
if start_tick < previous_tick:
    print("FOREIGN\tDer Listener wurde vor dem vorherigen Setup gestartet.")
    raise SystemExit(0)

print(f"OWN\t{pid}")
PY
}

port_is_free() {
  [[ "$(listener_state '')" == 'FREE' ]]
}

record_setup_tick() {
  python3 - <<'PY'
import os
uptime = float(open("/proc/uptime", encoding="ascii").read().split()[0])
print(int(uptime * os.sysconf("SC_CLK_TCK")))
PY
}

primary_interface() {
  local line
  local -a fields=()
  local -a interfaces=()
  local iface
  local found_dev
  local i

  if ! command -v ip >/dev/null 2>&1; then
    return 10
  fi

  while IFS= read -r line; do
    read -r -a fields <<< "$line"
    [[ "${fields[0]:-}" == "default" ]] || continue

    iface=""
    found_dev=0
    for ((i = 0; i < ${#fields[@]}; i++)); do
      if [[ "${fields[$i]}" == "dev" ]]; then
        if (( found_dev != 0 )) || (( i + 1 >= ${#fields[@]} )); then
          return 11
        fi
        iface="${fields[$((i + 1))]}"
        found_dev=1
      fi
    done

    [[ -n "$iface" ]] || return 12
    interfaces+=("$iface")
  done < <(ip route)

  (( ${#interfaces[@]} == 1 )) || return 13
  [[ "${interfaces[0]}" != "lo" ]] || return 14

  printf '%s\n' "${interfaces[0]}"
}

validate_primary_interface() {
  local iface
  if iface="$(primary_interface)"; then
    :
  else
    local rc="$?"
    case "$rc" in
      10) technical_error "Der Befehl ip ist nicht verfügbar." ;;
      11|12) technical_error "Die Standardroute enthält keinen eindeutig auswertbaren Eintrag hinter dev." ;;
      13) technical_error "Es ist nicht genau eine verwendbare Standardroute vorhanden." ;;
      14) technical_error "Die Standardroute verweist unerwartet auf die Loopback-Schnittstelle." ;;
      *) technical_error "Die primäre Schnittstelle konnte nicht bestimmt werden." ;;
    esac
  fi
  [[ -n "$iface" ]] || technical_error 'Die primäre Schnittstelle ist leer.'
}

guard_tree_path "$LAB_ROOT" "$LAB_ROOT"
guard_tree_path "$STATE_ROOT" "$STATE_ROOT"

previous_tick=''
if [[ -f "$SETUP_TICK_FILE" && ! -L "$SETUP_TICK_FILE" ]]; then
  IFS= read -r previous_tick < "$SETUP_TICK_FILE" || true
fi

listener_result="$(listener_state "$previous_tick")"
case "$listener_result" in
  FREE)
    ;;
  OWN$'\t'*)
    old_pid="${listener_result#*$'\t'}"
    kill "$old_pid"
    for _ in {1..50}; do
      if ! kill -0 "$old_pid" 2>/dev/null; then
        break
      fi
      sleep 0.1
    done
    if ! port_is_free; then
      technical_error 'Der eindeutig eigene Altserver wurde beendet, aber Port 9090 ist weiterhin belegt.'
    fi
    ;;
  FOREIGN$'\t'*)
    technical_error "${listener_result#*$'\t'} Der fremde Listener wurde nicht beendet."
    ;;
  *)
    technical_error 'Der Zustand von Port 9090 konnte nicht sicher bestimmt werden.'
    ;;
esac

safe_remove_tree "$LAB_ROOT" "$LAB_ROOT"
safe_remove_tree "$STATE_ROOT" "$STATE_ROOT"

mkdir -p \
  "$LAB_ROOT/vorlage" \
  "$LAB_ROOT/web/leeres-archiv" \
  "$LAB_ROOT/web/temp-build/cache" \
  "$LAB_ROOT/pruefung" \
  "$LAB_ROOT/dokumentation" \
  "$LAB_ROOT/schutzbereich" \
  "$REF_ROOT"

printf '%s\n' 'Linux-Grundlagen erfolgreich angewendet' > "$LAB_ROOT/vorlage/startseite.txt"
printf '%s\n' 'Diese Altdatei darf entfernt werden' > "$LAB_ROOT/web/alt.txt"
printf '%s\n' 'Temporäre Build-Notiz' > "$LAB_ROOT/web/temp-build/notiz.txt"
printf '%s\n' 'Temporärer Cache-Rest' > "$LAB_ROOT/web/temp-build/cache/rest.txt"
printf '%s\n' 'Dieser Schutzbereich bleibt unverändert' > "$LAB_ROOT/schutzbereich/wichtig.txt"

cat > "$CHECK_FILE" <<'SYSTEMCHECK'
#!/usr/bin/env bash
set -Eeuo pipefail
readonly MARKER='/var/lib/labforge/linux-grundlagen-praxistransfer/systemcheck-ausgefuehrt.marker'
printf '%s\n' 'Systemcheck erfolgreich ausgeführt'
printf '%s\n' 'ausgefuehrt' > "$MARKER"
SYSTEMCHECK

participant_uid="$(id -u)"
participant_gid="$(id -g)"

ensure_numeric_owner() {
  local path="$1"
  local current_uid
  local current_gid

  current_uid="$(stat -c '%u' "$path")"
  current_gid="$(stat -c '%g' "$path")"

  if [[ "$current_uid" == "$participant_uid" && "$current_gid" == "$participant_gid" ]]; then
    return 0
  fi

  if [[ "$(id -u)" != '0' ]]; then
    technical_error "Die Eigentümerschaft von '$path' kann unter der effektiven Laboridentität nicht reproduzierbar gesetzt werden."
  fi

  chown -R "$participant_uid:$participant_gid" "$path"
}

ensure_numeric_owner "$LAB_ROOT"
ensure_numeric_owner "$STATE_ROOT"

find "$LAB_ROOT" -type d -exec chmod 0755 {} +
chmod 0700 "$STATE_ROOT" "$REF_ROOT"
chmod 0644 \
  "$LAB_ROOT/vorlage/startseite.txt" \
  "$LAB_ROOT/web/alt.txt" \
  "$LAB_ROOT/web/temp-build/notiz.txt" \
  "$LAB_ROOT/web/temp-build/cache/rest.txt" \
  "$LAB_ROOT/schutzbereich/wichtig.txt" \
  "$CHECK_FILE"

rm -f -- "$MARKER"

sha256sum "$LAB_ROOT/vorlage/startseite.txt" | awk '{print $1}' > "$REF_ROOT/startseite.sha256"
sha256sum "$CHECK_FILE" | awk '{print $1}' > "$REF_ROOT/systemcheck.sha256"
stat -c '%u' "$CHECK_FILE" > "$REF_ROOT/systemcheck.uid"
stat -c '%g' "$CHECK_FILE" > "$REF_ROOT/systemcheck.gid"
stat -c '%a' "$CHECK_FILE" > "$REF_ROOT/systemcheck.modus"
sha256sum "$LAB_ROOT/schutzbereich/wichtig.txt" | awk '{print $1}' > "$REF_ROOT/wichtig.sha256"
stat -c '%u' "$LAB_ROOT/schutzbereich/wichtig.txt" > "$REF_ROOT/wichtig.uid"
stat -c '%g' "$LAB_ROOT/schutzbereich/wichtig.txt" > "$REF_ROOT/wichtig.gid"
stat -c '%a' "$LAB_ROOT/schutzbereich/wichtig.txt" > "$REF_ROOT/wichtig.modus"
printf '%s\n' 'wichtig.txt' > "$REF_ROOT/schutzbereich.manifest"
chmod 0600 "$REF_ROOT"/*

[[ ! -e "$LAB_ROOT/web/index.html" ]] || technical_error 'index.html wurde durch das Setup vorweggenommen.'
[[ ! -e "$LAB_ROOT/dokumentation/status.txt" ]] || technical_error 'status.txt wurde durch das Setup vorweggenommen.'
[[ ! -e "$MARKER" ]] || technical_error 'Der Ausführungsmarker wurde durch das Setup vorweggenommen.'
[[ -f "$LAB_ROOT/web/alt.txt" ]] || technical_error 'Die vorbereitete Altdatei fehlt.'
[[ -d "$LAB_ROOT/web/leeres-archiv" ]] || technical_error 'Das vorbereitete leere Archiv fehlt.'
[[ -d "$LAB_ROOT/web/temp-build/cache" ]] || technical_error 'Der vorbereitete temporäre Arbeitsbereich ist unvollständig.'
[[ -w "$STATE_ROOT" ]] || technical_error 'Die vorgesehene Teilnehmeridentität kann den technischen Marker nicht erzeugen.'

command -v findmnt >/dev/null 2>&1 || technical_error 'findmnt ist für die noexec-Prüfung nicht verfügbar.'
mount_options="$(findmnt -no OPTIONS --target "$CHECK_FILE" | head -n 1)"
case ",$mount_options," in
  *,noexec,*)
    technical_error 'Das Ziel-Dateisystem verhindert die direkte Ausführung vorbereiteter Dateien.'
    ;;
esac

[[ -x /usr/bin/env ]] || technical_error '/usr/bin/env ist nicht ausführbar.'
command -v bash >/dev/null 2>&1 || technical_error 'Bash ist nicht verfügbar.'

validate_primary_interface

port_is_free || technical_error 'Port 9090 ist nach dem Setup nicht frei.'

record_setup_tick > "$SETUP_TICK_FILE"
chmod 0600 "$SETUP_TICK_FILE"

printf '%s\n' 'Abschlusslabor wurde reproduzierbar vorbereitet.'
