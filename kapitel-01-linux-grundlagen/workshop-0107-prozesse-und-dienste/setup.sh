#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lighthouse_dir="${lab_home}/leuchtturm"
readonly work_dir="${lighthouse_dir}/lichtsteuerung"
readonly docs_dir="${work_dir}/dokumentation"
readonly logs_dir="${work_dir}/protokolle"
readonly status_dir="${work_dir}/status"
readonly state_dir="/var/lib/labforge/leuchtfeuer-konfiguration"
readonly internal_dir="/usr/local/lib/labforge/workshop-0107"
readonly nano_log="${state_dir}/nano-install.log"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

ensure_nano() {
  command -v nano >/dev/null 2>&1 && return 0
  command -v apt-get >/dev/null 2>&1 ||
    fail "Nano fehlt und apt-get ist nicht verfügbar."

  export DEBIAN_FRONTEND=noninteractive
  : >"$nano_log"
  if ! apt-get update -qq >>"$nano_log" 2>&1; then
    fail "Die Paketlisten für Nano konnten nicht aktualisiert werden. Details: ${nano_log}"
  fi
  if ! apt-get install -y -qq nano >>"$nano_log" 2>&1; then
    fail "Nano konnte nicht installiert werden. Details: ${nano_log}"
  fi
  command -v nano >/dev/null 2>&1 || fail "Nano ist nach der Installation nicht verfügbar."
}

getent group "$lab_user" >/dev/null 2>&1 || groupadd "$lab_user"
if ! id "$lab_user" >/dev/null 2>&1; then
  useradd --create-home --home-dir "$lab_home" --shell /bin/bash \
    --gid "$lab_user" "$lab_user"
fi
usermod --home "$lab_home" --shell /bin/bash --gid "$lab_user" \
  "$lab_user" >/dev/null

install -d -m 0755 -o root -g root /var/lib/labforge
install -d -m 0755 -o root -g root "$state_dir"
install -d -m 0755 -o root -g root "$internal_dir"
ensure_nano

rm -rf -- "$work_dir"
rm -f -- \
  "$state_dir/session-id" \
  "$state_dir/configuration-applied.marker" \
  "$state_dir/flag-submitted.marker" \
  "$state_dir/success.marker"

install -d -m 0750 -o "$lab_user" -g "$lab_user" "$lab_home"
install -d -m 0755 -o "$lab_user" -g "$lab_user" \
  "$lighthouse_dir" "$work_dir" "$docs_dir" "$logs_dir" "$status_dir"

printf '%s\n' 'leuchtturm' >/etc/hostname
hostname leuchtturm >/dev/null 2>&1 || true

cat >"$work_dir/leuchtfeuer.conf" <<'CONFIG'
# Konfiguration der Leuchtfeuersteuerung
ROTATION=impuls
GESCHWINDIGKEIT=langsam
BEREICH=meer
CONFIG

cat >"$docs_dir/wartungsanleitung.txt" <<'DOCS'
WARTUNGSANLEITUNG – LEUCHTFEUERSTEUERUNG
========================================

Die Lichtsteuerung liest ihre Einstellungen aus:

    leuchtfeuer.conf

Die Datei verwendet Einträge im Format:

    SCHLUESSEL=WERT

Zeilen, die mit # beginnen, sind Kommentare.
Sie dienen als Hinweise für Menschen und werden von der Steuerung ignoriert.


ROTATION
--------

stop
    Der Lichtstrahl bleibt in seiner aktuellen Position stehen.

impuls
    Das Leuchtfeuer sendet einzelne Lichtimpulse.

kreis
    Der Lichtstrahl bewegt sich gleichmäßig um den Turm.


GESCHWINDIGKEIT
---------------

langsam
    Langsame, gut sichtbare Bewegung.

normal
    Reguläre Betriebsgeschwindigkeit.


BEREICH
-------

meer
    Der Lichtstrahl wird hauptsächlich über das Meer geführt.

kueste
    Der Lichtstrahl sucht Deich und Küstenlinie ab.


SICHERES VORGEHEN
-----------------

1. Aktuelle Konfiguration lesen.
2. Vor einer Änderung eine Sicherungskopie anlegen.
3. Nur die benötigte Einstellung bearbeiten.
4. Datei speichern und den Editor schließen.
5. Konfiguration prüfen.
6. Konfiguration neu laden.
7. Betriebszustand kontrollieren.

Eine gespeicherte Datei ist nicht automatisch eine gültige Konfiguration.
DOCS

cat >"$logs_dir/leuchtfeuer.log" <<'LOG'
LEUCHTTURM – BETRIEBSPROTOKOLL
==============================

[23:41:08] Leuchtfeuerprozess gestartet
[23:41:09] Konfiguration geladen: leuchtfeuer.conf
[23:41:09] ROTATION=impuls
[23:41:09] GESCHWINDIGKEIT=langsam
[23:41:09] BEREICH=meer
[23:41:12] WARNUNG: Lichtsignal entspricht nicht dem regulären Rundlauf
[23:41:12] HINWEIS: Zulässige Einstellungen stehen in der Wartungsdokumentation
LOG

cat >"$internal_dir/konfiguration-parser" <<'PARSER'
#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  printf '%s\n' 'Interner Aufruf: konfiguration-parser [--values] DATEI' >&2
  exit 2
}

invalid() {
  printf '%s\n' 'Konfiguration ungültig:' >&2
  printf '%s\n' "$1" >&2
  if (( $# == 2 )); then
    printf '\n%s\n' "$2" >&2
  fi
  exit 1
}

emit_values=false
if [[ "${1:-}" == "--values" ]]; then
  emit_values=true
  shift
fi
(( $# == 1 )) || usage
readonly config_file="$1"

[[ -e "$config_file" ]] || invalid "Die Konfigurationsdatei ${config_file} fehlt."
[[ -f "$config_file" && ! -L "$config_file" ]] ||
  invalid "${config_file} ist keine reguläre Konfigurationsdatei."
[[ -r "$config_file" ]] || invalid "Die Konfigurationsdatei ${config_file} ist nicht lesbar."

declare -A values=()
line_number=0
while IFS= read -r line || [[ -n "$line" ]]; do
  ((line_number += 1))
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  if [[ "$line" =~ ^([A-Z_]+)=$ ]]; then
    invalid "Die Einstellung ${BASH_REMATCH[1]} besitzt keinen Wert."
  fi
  [[ "$line" =~ ^([A-Z_]+)=([^[:space:]#=]+)$ ]] ||
    invalid \
      "Zeile ${line_number} besitzt nicht das erwartete Format SCHLUESSEL=WERT." \
      "Verwende keine Leerzeichen um das Gleichheitszeichen."

  key="${BASH_REMATCH[1]}"
  value="${BASH_REMATCH[2]}"
  case "$key" in
    ROTATION|GESCHWINDIGKEIT|BEREICH) ;;
    *) invalid "Die Einstellung ${key} ist unbekannt." ;;
  esac
  [[ ! -v "values[$key]" ]] || invalid "Die Einstellung ${key} kommt mehrfach vor."
  values["$key"]="$value"
done <"$config_file"

for key in ROTATION GESCHWINDIGKEIT BEREICH; do
  [[ -v "values[$key]" ]] || invalid "Die Einstellung ${key} fehlt."
done

case "${values[ROTATION]}" in
  stop|impuls|kreis) ;;
  *) invalid \
    "ROTATION kennt den Wert \"${values[ROTATION]}\" nicht." \
    "Zulässig: stop, impuls, kreis" ;;
esac
case "${values[GESCHWINDIGKEIT]}" in
  langsam|normal) ;;
  *) invalid \
    "GESCHWINDIGKEIT kennt den Wert \"${values[GESCHWINDIGKEIT]}\" nicht." \
    "Zulässig: langsam, normal" ;;
esac
case "${values[BEREICH]}" in
  meer|kueste) ;;
  *) invalid \
    "BEREICH kennt den Wert \"${values[BEREICH]}\" nicht." \
    "Zulässig: meer, kueste" ;;
esac

if [[ "$emit_values" == true ]]; then
  printf 'ROTATION=%s\n' "${values[ROTATION]}"
  printf 'GESCHWINDIGKEIT=%s\n' "${values[GESCHWINDIGKEIT]}"
  printf 'BEREICH=%s\n' "${values[BEREICH]}"
else
  printf '%s\n\n' 'Konfiguration ist gültig.'
  printf 'ROTATION=%s\n' "${values[ROTATION]}"
  printf 'GESCHWINDIGKEIT=%s\n' "${values[GESCHWINDIGKEIT]}"
  printf 'BEREICH=%s\n' "${values[BEREICH]}"
fi
PARSER
chmod 0755 "$internal_dir/konfiguration-parser"
chown root:root "$internal_dir/konfiguration-parser"

cat >"$work_dir/konfiguration-pruefen" <<'VALIDATOR'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly config_file="${1:-./leuchtfeuer.conf}"
exec /usr/local/lib/labforge/workshop-0107/konfiguration-parser "$config_file"
VALIDATOR

cat >"$work_dir/leuchtfeuer-neu-laden" <<'RELOAD'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly work_dir="/home/waerter/leuchtturm/lichtsteuerung"
readonly config_file="${work_dir}/leuchtfeuer.conf"
readonly backup_file="${work_dir}/leuchtfeuer.conf.bak"
readonly applied_file="${work_dir}/status/angewendete-konfiguration"
readonly flag_file="${work_dir}/status/abschlussflagge"
readonly log_file="${work_dir}/protokolle/leuchtfeuer.log"
readonly parser="/usr/local/lib/labforge/workshop-0107/konfiguration-parser"
readonly flag='FLAG{die_spur_fuehrt_vom_turm_fort}'

parsed="$(mktemp)"
backup_parsed="$(mktemp)"
applied_tmp=""
log_tmp=""
flag_tmp=""
cleanup() {
  rm -f -- "$parsed" "$backup_parsed"
  [[ -z "$applied_tmp" ]] || rm -f -- "$applied_tmp"
  [[ -z "$log_tmp" ]] || rm -f -- "$log_tmp"
  [[ -z "$flag_tmp" ]] || rm -f -- "$flag_tmp"
}
trap cleanup EXIT
"$parser" --values "$config_file" >"$parsed"

declare -A values=()
while IFS='=' read -r key value; do
  values["$key"]="$value"
done <"$parsed"

applied_tmp="$(mktemp "${applied_file}.tmp.XXXXXX")"
printf 'LEUCHTFEUER=aktiv\nROTATION=%s\nGESCHWINDIGKEIT=%s\nBEREICH=%s\n' \
  "${values[ROTATION]}" "${values[GESCHWINDIGKEIT]}" "${values[BEREICH]}" >"$applied_tmp"
chmod 0644 "$applied_tmp"

timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
log_tmp="$(mktemp "${log_file}.tmp.XXXXXX")"
cat "$log_file" >"$log_tmp"
printf '[%s] Konfiguration erfolgreich geprüft\n' "$timestamp" >>"$log_tmp"
printf '[%s] ROTATION=%s\n' "$timestamp" "${values[ROTATION]}" >>"$log_tmp"
printf '[%s] GESCHWINDIGKEIT=%s\n' "$timestamp" "${values[GESCHWINDIGKEIT]}" >>"$log_tmp"
printf '[%s] BEREICH=%s\n' "$timestamp" "${values[BEREICH]}" >>"$log_tmp"
printf '[%s] Konfiguration angewendet\n' "$timestamp" >>"$log_tmp"
if [[ "${values[BEREICH]}" == "kueste" ]]; then
  printf '[%s] Suchbereich auf Küste eingestellt\n' "$timestamp" >>"$log_tmp"
  printf '[%s] Unbekanntes Objekt am Deich erkannt\n' "$timestamp" >>"$log_tmp"
fi
chmod 0644 "$log_tmp"

mv -f -- "$applied_tmp" "$applied_file"
applied_tmp=""
mv -f -- "$log_tmp" "$log_file"
log_tmp=""
rm -f -- "$flag_file"

backup_is_original=false
if [[ -f "$backup_file" && ! -L "$backup_file" && -r "$backup_file" ]] &&
  "$parser" --values "$backup_file" >"$backup_parsed" 2>/dev/null &&
  grep -qx 'ROTATION=impuls' "$backup_parsed" &&
  grep -qx 'GESCHWINDIGKEIT=langsam' "$backup_parsed" &&
  grep -qx 'BEREICH=meer' "$backup_parsed"; then
  backup_is_original=true
fi

printf '%s\n' 'Die Leuchtfeuersteuerung übernimmt die geprüfte Konfiguration.'
if [[ "${values[ROTATION]}" == "kreis" &&
  "${values[GESCHWINDIGKEIT]}" == "langsam" &&
  "${values[BEREICH]}" == "meer" ]]; then
  printf '%s\n' 'Der Lichtstrahl zieht wieder gleichmäßig über das Meer.'
elif [[ "${values[ROTATION]}" == "kreis" &&
  "${values[GESCHWINDIGKEIT]}" == "langsam" &&
  "${values[BEREICH]}" == "kueste" ]]; then
  printf '%s\n' 'Der Lichtstrahl folgt ruhig der Küstenlinie.'
fi

if [[ "${values[ROTATION]}" == "kreis" &&
  "${values[GESCHWINDIGKEIT]}" == "langsam" &&
  "${values[BEREICH]}" == "kueste" &&
  "$backup_is_original" == true ]]; then
  flag_tmp="$(mktemp "${flag_file}.tmp.XXXXXX")"
  printf '%s\n' "$flag" >"$flag_tmp"
  chmod 0644 "$flag_tmp"
  mv -f -- "$flag_tmp" "$flag_file"
  flag_tmp=""
  printf '%s\n' 'Am Deich wird eine eingeritzte Kennung sichtbar:'
  printf '%s\n' "$flag"
elif [[ "${values[ROTATION]}" == "kreis" &&
  "${values[GESCHWINDIGKEIT]}" == "langsam" &&
  "${values[BEREICH]}" == "kueste" ]]; then
  printf '%s\n' 'Die Küstenkonfiguration ist aktiv, aber die vorgeschriebene Ausgangssicherung fehlt.'
fi
RELOAD

cat >"$work_dir/leuchtfeuer-status" <<'STATUS'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly applied_file="/home/waerter/leuchtturm/lichtsteuerung/status/angewendete-konfiguration"
[[ -f "$applied_file" && ! -L "$applied_file" ]] || {
  printf '%s\n' 'Der angewendete Zustand ist nicht verfügbar.' >&2
  exit 1
}
cat "$applied_file"
STATUS

cat >/usr/local/bin/flag-einreichen <<'FLAG_SUBMIT'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly expected='FLAG{die_spur_fuehrt_vom_turm_fort}'
readonly work_dir='/home/waerter/leuchtturm/lichtsteuerung'
readonly state_dir='/var/lib/labforge/leuchtfeuer-konfiguration'
readonly session_file="${state_dir}/session-id"
readonly flag_file="${work_dir}/status/abschlussflagge"
readonly submitted="${work_dir}/status/flag-submitted.marker"

(( $# == 1 )) || {
  printf '%s\n' "Aufruf: flag-einreichen 'GEFUNDENE_FLAG'" >&2
  exit 2
}
[[ -f "$session_file" && ! -L "$session_file" ]] || {
  printf '%s\n' 'Die aktuelle Workshop-Sitzung ist nicht vorbereitet.' >&2
  exit 1
}
[[ -f "$flag_file" && ! -L "$flag_file" ]] &&
  [[ "$(<"$flag_file")" == "$expected" ]] || {
    printf '%s\n' 'Die Abschlussflagge wurde in dieser Sitzung noch nicht freigelegt.' >&2
    exit 1
  }
[[ "$1" == "$expected" ]] || {
  printf '%s\n' 'Diese Flag ist nicht korrekt.' >&2
  exit 1
}

session_id="$(<"$session_file")"
tmp="$(mktemp "${submitted}.tmp.XXXXXX")"
printf 'session_id=%s\nresult=workshop-0107-flag-submitted\n' "$session_id" >"$tmp"
chmod 0644 "$tmp"
mv -f -- "$tmp" "$submitted"
printf '%s\n' 'Flag angenommen. Du kannst jetzt den CHECK ausführen.'
FLAG_SUBMIT
chmod 0755 /usr/local/bin/flag-einreichen
chown root:root /usr/local/bin/flag-einreichen

cat >"$status_dir/angewendete-konfiguration" <<'APPLIED'
LEUCHTFEUER=aktiv
ROTATION=impuls
GESCHWINDIGKEIT=langsam
BEREICH=meer
APPLIED

rm -f -- \
  "$work_dir/leuchtfeuer.conf.bak" \
  "$status_dir/abschlussflagge" \
  "$status_dir/flag-submitted.marker" \
  "$status_dir/erfolg.marker"

chown -R "$lab_user:$lab_user" "$work_dir"
find "$work_dir" -type d -exec chmod 0755 {} +
find "$work_dir" -type f -exec chmod 0644 {} +
chmod 0755 \
  "$work_dir/konfiguration-pruefen" \
  "$work_dir/leuchtfeuer-neu-laden" \
  "$work_dir/leuchtfeuer-status"

cat /proc/sys/kernel/random/uuid >"$state_dir/session-id"
chmod 0644 "$state_dir/session-id"

cat >"$lab_home/.bash_profile" <<PROFILE
if [[ -f "\${HOME}/.bashrc" ]]; then source "\${HOME}/.bashrc"; fi
cd "$work_dir"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE
cat >"$lab_home/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
eval "$(dircolors -b)"
alias ls='ls --color=auto'
BASHRC
chown "$lab_user:$lab_user" "$lab_home/.bash_profile" "$lab_home/.bashrc"
chmod 0644 "$lab_home/.bash_profile" "$lab_home/.bashrc"

[[ "$(id -un "$lab_user")" == "$lab_user" ]] || fail "Der Benutzer waerter fehlt."
[[ "$(getent passwd "$lab_user" | cut -d: -f6)" == "$lab_home" ]] ||
  fail "Das Home-Verzeichnis von waerter ist falsch."
[[ -x "$(command -v nano)" ]] || fail "Nano ist nicht ausführbar."
[[ "$(stat -c '%U:%G:%a' "$work_dir/leuchtfeuer.conf")" == "waerter:waerter:644" ]] ||
  fail "Die Ausgangskonfiguration besitzt falsche Rechte."
[[ "$(stat -c '%U:%G:%a' "$work_dir/konfiguration-pruefen")" == "waerter:waerter:755" ]] ||
  fail "Das Prüfskript besitzt falsche Rechte."
[[ "$(stat -c '%U:%G:%a' "$internal_dir/konfiguration-parser")" == "root:root:755" ]] ||
  fail "Der interne Konfigurationsparser besitzt falsche Rechte."
[[ "$(stat -c '%U:%G:%a' /usr/local/bin/flag-einreichen)" == "root:root:755" ]] ||
  fail "Das Werkzeug flag-einreichen besitzt falsche Rechte."

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "$lab_user"
