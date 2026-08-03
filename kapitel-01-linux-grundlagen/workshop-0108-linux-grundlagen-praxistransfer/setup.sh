#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user='waerter'
readonly lab_group='waerter'
readonly lab_home='/home/waerter'
readonly lighthouse_dir='/home/waerter/leuchtturm'
readonly work_dir='/home/waerter/leuchtturm/archiv'
readonly memories_dir="${work_dir}/erinnerungen"
readonly messages_dir="${work_dir}/nachrichten"
readonly logs_dir="${work_dir}/protokolle"
readonly control_dir="${work_dir}/steuerung"
readonly state_dir='/var/lib/labforge/fragmentiertes-archiv'
readonly internal_dir='/usr/local/lib/labforge/workshop-0108'
readonly echo_worker="${internal_dir}/altes_echo"
readonly echo_starter="${internal_dir}/altes-echo-starten"
readonly archive_parser="${internal_dir}/archiv-parser"
readonly flag_submitter='/usr/local/bin/flag-einreichen'
readonly echo_target="${memories_dir}/ERINNERUNG_KEHRT_ZURUECK.txt"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

guard_tree_path() {
  local actual="$1"
  local expected="$2"

  [[ -n "$actual" ]] || fail 'Ein interner Bereinigungspfad ist leer.'
  [[ "$actual" == "$expected" ]] ||
    fail "Der Bereinigungspfad '${actual}' entspricht nicht dem erwarteten statischen Pfad '${expected}'."

  case "$actual" in
    /|/home|/home/waerter|/home/waerter/leuchtturm|/var|/var/lib|/var/lib/labforge|/usr|/usr/local|/usr/local/lib|/usr/local/lib/labforge|.|..|~)
      fail "Der gefährliche Bereinigungspfad '${actual}' wurde abgelehnt."
      ;;
  esac

  [[ ! -L "$actual" ]] ||
    fail "Der Bereinigungsstamm '${actual}' ist ein symbolischer Link und wird nicht verändert."
}

safe_remove_tree() {
  local actual="$1"
  local expected="$2"

  guard_tree_path "$actual" "$expected"
  if [[ -e "$actual" ]]; then
    rm -rf -- "$actual"
  fi
}

process_matches_echo() {
  local pid="$1"
  local actual_exe

  [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 1
  [[ -r "/proc/${pid}/comm" && -r "/proc/${pid}/cmdline" ]] || return 1
  [[ "$(<"/proc/${pid}/comm")" == 'altes_echo' ]] || return 1
  [[ "$(stat -c '%U' "/proc/${pid}")" == "$lab_user" ]] || return 1
  IFS= read -r -d '' actual_exe <"/proc/${pid}/cmdline" || return 1
  [[ "$actual_exe" == "$echo_worker" ]] || return 1
}

stop_exact_echo_process() {
  local pid="$1"

  process_matches_echo "$pid" || return 0
  kill -TERM "$pid" 2>/dev/null || true

  for _ in {1..40}; do
    if ! process_matches_echo "$pid"; then
      return 0
    fi
    sleep 0.05
  done

  fail "Die exakt identifizierte alte altes_echo-Instanz mit PID ${pid} reagiert nicht auf TERM."
}

stop_old_echo_processes() {
  local proc
  local pid

  [[ -e "$echo_worker" ]] || return 0
  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    if process_matches_echo "$pid"; then
      stop_exact_echo_process "$pid"
    fi
  done
}

getent group "$lab_group" >/dev/null 2>&1 || groupadd "$lab_group"
if ! id "$lab_user" >/dev/null 2>&1; then
  useradd --create-home --home-dir "$lab_home" --shell /bin/bash \
    --gid "$lab_group" "$lab_user"
fi
usermod --home "$lab_home" --shell /bin/bash --gid "$lab_group" \
  "$lab_user" >/dev/null

if ! id olmstead >/dev/null 2>&1; then
  [[ -x /usr/sbin/nologin ]] || fail '/usr/sbin/nologin ist für das Systemkonto olmstead nicht verfügbar.'
  useradd --system --user-group --no-create-home --home-dir /nonexistent \
    --shell /usr/sbin/nologin olmstead
fi
for required_account in root daemon nobody olmstead; do
  id "$required_account" >/dev/null 2>&1 ||
    fail "Das benötigte Eigentümerkonto '${required_account}' ist nicht verfügbar."
done

stop_old_echo_processes
safe_remove_tree "$work_dir" '/home/waerter/leuchtturm/archiv'
safe_remove_tree "$state_dir" '/var/lib/labforge/fragmentiertes-archiv'
safe_remove_tree "$internal_dir" '/usr/local/lib/labforge/workshop-0108'

install -d -m 0755 -o root -g root /var/lib/labforge
install -d -m 0755 -o root -g root /usr/local/lib/labforge
install -d -m 0755 -o root -g root "$state_dir" "$internal_dir"
install -d -m 0750 -o "$lab_user" -g "$lab_group" "$lab_home"
install -d -m 0755 -o "$lab_user" -g "$lab_group" \
  "$lighthouse_dir" \
  "$work_dir" \
  "$memories_dir" \
  "$messages_dir" \
  "$logs_dir" \
  "$control_dir" \
  "$work_dir/fragment_FFD700" \
  "$work_dir/fragment_8B0000" \
  "$work_dir/fragment_D6C84B" \
  "$work_dir/fragment_7G00FF"

printf '%s\n' 'leuchtturm' >/etc/hostname
hostname leuchtturm >/dev/null 2>&1 || true

cat >"$work_dir/stabilisierungsplan.txt" <<'PLAN'
STABILISIERUNGSPLAN DES LEUCHTTURMS
==================================

Der Leuchtturm kann nur stabilisiert werden,
wenn das Archiv einer eindeutigen Struktur entspricht.

Zur stabilen Ordnung gehören:

- erinnerungen
- nachrichten
- protokolle
- steuerung

Verzeichnisse mit dem Präfix fragment_ gehören nicht
zur dokumentierten Archivstruktur.

Der Archivschlüssel muss sich im Bereich steuerung befinden.

Die endgültige Erinnerungskonfiguration darf nur aus
einer Nachricht übernommen werden, deren Quelle geprüft wurde.

Nach jeder Korrektur kann die Stabilisierung erneut gestartet werden:

    ./leuchtturm-stabilisieren


SICHERHEITSHINWEIS
------------------

Ein auffälliger Name allein ist kein ausreichender Löschgrund.
Vergleiche den Zustand zuerst mit diesem Plan.

WARNUNG
-------

Eine fremde Erinnerung kann nach dem Löschen erneut erscheinen.

Wenn ein gelöschter Inhalt zurückkehrt,
suche nach dem laufenden Vorgang, der ihn erzeugt.
PLAN

cat >"$control_dir/archiv.conf" <<'CONFIG'
# Steuerung des fragmentierten Archivs
# Der stabile Wert steht in der Nachricht aus der richtigen Quelle.

ERINNERUNG=fragmentiert
CONFIG

cat >"$logs_dir/archiv-status.txt" <<'STATUS'
ERINNERUNG=fragmentiert
LEUCHTTURM=instabil
STATUS

cat >"$memories_dir/archivschluessel.txt" <<'KEY'
ARCHIVSCHLÜSSEL
===============

DOKUMENTTYP: STEUERUNGSSCHLÜSSEL
ZIELBEREICH: steuerung
FUNKTION: ordnet den Archivzustand der Steuerung zu
PRÜFUNG: nur im vorgesehenen Zielbereich verwendbar

Der Schlüssel kann nur verwendet werden,
wenn er sich im vorgesehenen Steuerungsbereich befindet.
KEY

cat >"$echo_target" <<'MEMORY'
DU KANNST MICH LÖSCHEN.

SOLANGE DAS ECHO LÄUFT,
WERDE ICH ZURÜCKKEHREN.

Erstellt durch: altes_echo
MEMORY

cat >"$messages_dir/letzte_nachricht.txt" <<'MESSAGE'
LETZTE NACHRICHT
================

Die Räume zerfallen nicht.
Sie wurden nur zu früh voneinander getrennt.

Die Steuerung liegt in:

    steuerung/archiv.conf

Setze:

    ERINNERUNG=strukturiert

Was richtig geordnet ist,
kann nicht verloren gehen.
MESSAGE
cat >"$messages_dir/letzte_nachricht_2.txt" <<'MESSAGE'
LETZTE NACHRICHT
================

Unter allen Räumen liegt nur ein einziger Zustand.

Die Steuerung liegt in:

    steuerung/archiv.conf

Setze:

    ERINNERUNG=eins

Wenn kein Unterschied mehr bleibt,
kann auch nichts mehr verwechselt werden.
MESSAGE
cat >"$messages_dir/letzte_nachricht_alt.txt" <<'MESSAGE'
LETZTE NACHRICHT
================

Das Echo verändert Namen, Reihenfolgen und Wege.

Die Steuerung liegt in:

    steuerung/archiv.conf

Setze:

    ERINNERUNG=klar

Ein klarer Zustand bewahrt die Trennung,
ohne die Teile voneinander abzuschneiden.
MESSAGE
cat >"$messages_dir/letzte_nachricht_final.txt" <<'MESSAGE'
LETZTE NACHRICHT
================

Die Grenze zwischen dir und dem Turm ist der Fehler.

Die Steuerung liegt in:

    steuerung/archiv.conf

Setze:

    ERINNERUNG=ungeteilt

Was nicht mehr getrennt ist,
kann nicht mehr auseinanderbrechen.
MESSAGE
cat >"$messages_dir/letzte_nachricht_backup.txt" <<'MESSAGE'
LETZTE NACHRICHT
================

Die Teile erinnern sich aneinander,
aber nicht mehr an ihre Grenzen.

Die Steuerung liegt in:

    steuerung/archiv.conf

Setze:

    ERINNERUNG=vereint

Was wieder vereint wurde,
kann nicht erneut zerfallen.
MESSAGE

cat >"$work_dir/fragment_FFD700/das_gelbe_zeichen.txt" <<'FRAGMENT'
Das Zeichen war nicht auf der Tür,
bevor du es angesehen hast.

Jetzt wirkt es älter als der Leuchtturm.
Du erinnerst dich nicht daran, es gezeichnet zu haben.
FRAGMENT

cat >"$work_dir/fragment_8B0000/der_letzte_raum.txt" <<'FRAGMENT'
Alle Türen führen weiter.

Nur diese führt zurück.
Hinter den roten Scheiben wartet ein Raum,
den du bereits verlassen hast.
FRAGMENT

cat >"$work_dir/fragment_D6C84B/muster_hinter_der_wand.txt" <<'FRAGMENT'
Das Muster wiederholt sich nicht.

Es tut nur so, solange du hinsiehst.
Zwischen zwei Linien bewegt sich etwas
in die entgegengesetzte Richtung.
FRAGMENT

cat >"$work_dir/fragment_7G00FF/farbe_ohne_wert.txt" <<'FRAGMENT'
7G00FF ist keine gültige Farbe.

Trotzdem liegt ihr Licht auf deinen Händen.
Der Bildschirm kann sie nicht darstellen,
aber etwas in diesem Raum kann es.
FRAGMENT

cat >"$work_dir/leuchtturm-stabilisieren" <<'STABILIZE'
#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C
export LANG=C

readonly work_dir='/home/waerter/leuchtturm/archiv'
readonly config_file="${work_dir}/steuerung/archiv.conf"
readonly parser='/usr/local/lib/labforge/workshop-0108/archiv-parser'
readonly echo_worker='/usr/local/lib/labforge/workshop-0108/altes_echo'
readonly echo_file="${work_dir}/erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt"
readonly source_key="${work_dir}/erinnerungen/archivschluessel.txt"
readonly expected_key="${work_dir}/steuerung/archivschluessel.txt"

failure_heading() {
  printf '%s\n' 'STABILISIERUNG FEHLGESCHLAGEN' >&2
  printf '%s\n\n' '============================' >&2
}

success() {
  printf '%s\n' 'STABILISIERUNG ERFOLGREICH'
  printf '%s\n\n' '=========================='
  printf '%s\n' 'Archivstruktur wird ausgerichtet ...'
  printf '%s\n' 'Fremde Fragmente verlieren ihre Form ...'
  printf '%s\n' 'Das alte Echo verstummt ...'
  printf '%s\n\n' 'Erinnerungszustand: klar'
  printf '%s\n\n' 'Identitätsabgleich wird gestartet ...'
  printf '%s\n' 'Aktiver Benutzer: waerter'
  printf '%s\n\n' 'Quelle der gültigen Anweisung: waerter'
  printf '%s\n\n' 'Du hast den Wärter nicht gesucht.'
  printf '%s\n\n' 'Du hast versucht, dich zu erinnern.'
  printf '%s\n' 'FLAG{du_warst_schon_immer_der_waerter}'
  exit 0
}

echo_process_running() {
  local proc
  local pid
  local executable

  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    [[ -r "${proc}/comm" && -r "${proc}/cmdline" ]] || continue
    [[ "$(<"${proc}/comm")" == 'altes_echo' ]] || continue
    [[ "$(stat -c '%U' "$proc" 2>/dev/null || true)" == 'waerter' ]] || continue
    executable=''
    IFS= read -r -d '' executable <"${proc}/cmdline" || true
    [[ "$executable" == "$echo_worker" ]] || continue
    return 0
  done
  return 1
}

key_content_is_valid() {
  local candidate="$1"

  [[ -f "$candidate" && ! -L "$candidate" ]] || return 1
  cmp -s "$candidate" <(cat <<'EXPECTED_KEY'
ARCHIVSCHLÜSSEL
===============

DOKUMENTTYP: STEUERUNGSSCHLÜSSEL
ZIELBEREICH: steuerung
FUNKTION: ordnet den Archivzustand der Steuerung zu
PRÜFUNG: nur im vorgesehenen Zielbereich verwendbar

Der Schlüssel kann nur verwendet werden,
wenn er sich im vorgesehenen Steuerungsbereich befindet.
EXPECTED_KEY
)
}

# Prüfung 0: Ein absichtlich priorisierter, ausschließlich technischer
# Speedrun-Pfad. Eine vollständig gültige klare Konfiguration reicht hier
# unabhängig vom übrigen Missionszustand für einen deterministischen Test.
[[ -x "$parser" ]] || {
  failure_heading
  printf '%s\n' 'Das interne Prüfwerkzeug ist nicht verfügbar.' >&2
  exit 1
}
set +e
parser_output="$("$parser" "$config_file" 2>&1)"
parser_result=$?
set -e
if (( parser_result == 0 )); then
  success
fi

# Prüfung 1: ausschließlich direkte Fragmentverzeichnisse im Archivstamm.
fragment_dirs=()
while IFS= read -r -d '' fragment_dir; do
  fragment_dirs+=("${fragment_dir#"$work_dir"/}")
done < <(find "$work_dir" -mindepth 1 -maxdepth 1 -type d -name 'fragment_*' -print0 | sort -z)

if (( ${#fragment_dirs[@]} > 0 )); then
  failure_heading
  printf '%s\n\n' 'Die Archivstruktur ist nicht eindeutig.' >&2
  printf '%s\n' 'Gefundene fremde Bereiche:' >&2
  for fragment_dir in "${fragment_dirs[@]}"; do
    printf -- '- %s\n' "$fragment_dir" >&2
  done
  printf '\n%s\n' 'Vergleiche die Struktur mit dem Stabilisierungsplan.' >&2
  printf '%s\n' 'Entferne ausschließlich bestätigte Fragmente.' >&2
  exit 1
fi

# Prüfung 2: Prozess und sichtbare Datei werden getrennt diagnostiziert.
echo_running=false
echo_present=false
if echo_process_running; then
  echo_running=true
fi
if [[ -e "$echo_file" || -L "$echo_file" ]]; then
  echo_present=true
fi

if [[ "$echo_running" == true && "$echo_present" == true ]]; then
  failure_heading
  printf '%s\n\n' 'Eine fremde Erinnerung wird weiterhin erzeugt.' >&2
  printf '%s\n' 'Untersuche die Datei.' >&2
  printf '%s\n' 'Sie enthält einen Hinweis auf den verantwortlichen Vorgang.' >&2
  exit 1
fi
if [[ "$echo_running" == true && "$echo_present" == false ]]; then
  failure_heading
  printf '%s\n\n' 'Die Datei wurde entfernt, aber der erzeugende Vorgang läuft noch.' >&2
  printf '%s\n' 'Warte einen Moment und kontrolliere den Zustand erneut.' >&2
  exit 1
fi
if [[ "$echo_running" == false && "$echo_present" == true ]]; then
  failure_heading
  printf '%s\n\n' 'Der erzeugende Vorgang ist beendet, aber seine Erinnerung ist noch vorhanden.' >&2
  printf '%s\n' 'Prüfe den verbliebenen Inhalt und gleiche ihn mit dem Stabilisierungsplan ab.' >&2
  exit 1
fi

# Prüfung 3: Der Archivschlüssel muss eindeutig und unverändert am Ziel liegen.
mapfile -d '' key_locations < <(
  find "$work_dir" -mindepth 1 -name 'archivschluessel.txt' -print0 |
    sort -z
)

if (( ${#key_locations[@]} == 0 )); then
  failure_heading
  printf '%s\n\n' 'Der Archivschlüssel fehlt.' >&2
  printf '%s\n' 'Im Archiv wurde keine Datei archivschluessel.txt gefunden.' >&2
  printf '%s\n' 'Prüfe, ob sie entfernt oder anders benannt wurde.' >&2
  exit 1
fi

if (( ${#key_locations[@]} > 1 )); then
  failure_heading
  printf '%s\n\n' 'Der Archivschlüssel ist mehrdeutig.' >&2
  printf 'Gefundene Orte (%d):\n' "${#key_locations[@]}" >&2
  for location in "${key_locations[@]}"; do
    printf '  - %s\n' "${location#"$work_dir"/}" >&2
  done
  printf '%s\n' 'Erwartet wird genau ein unveränderter Schlüssel im Bereich steuerung.' >&2
  exit 1
fi

actual_key="${key_locations[0]}"
if [[ "$actual_key" == "$source_key" ]]; then
  failure_heading
  printf '%s\n\n' 'Der Archivschlüssel wurde gefunden,' >&2
  printf '%s\n\n' 'befindet sich aber nicht im Steuerungsbereich.' >&2
  printf '%s\n' 'Aktueller Ort:' >&2
  printf '%s\n\n' '    erinnerungen/archivschluessel.txt' >&2
  printf '%s\n' 'Erwarteter Ort:' >&2
  printf '%s\n' '    steuerung/archivschluessel.txt' >&2
  exit 1
fi

if [[ "$actual_key" != "$expected_key" ]]; then
  failure_heading
  printf '%s\n\n' 'Der Archivschlüssel liegt an einem unerwarteten Ort.' >&2
  printf 'Aktueller Ort: %s\n' "${actual_key#"$work_dir"/}" >&2
  printf '%s\n' 'Erwarteter Ort: steuerung/archivschluessel.txt' >&2
  exit 1
fi

if ! key_content_is_valid "$expected_key"; then
  failure_heading
  printf '%s\n\n' 'Der Archivschlüssel am Zielort ist nicht unverändert.' >&2
  printf '%s\n' 'Prüfe Dateityp und Inhalt. Bei einer Beschädigung starte den Workshop neu.' >&2
  exit 1
fi

# Prüfung 4: Erst jetzt wird die bereits zu Beginn sicher gelesene
# Konfigurationsdiagnose sichtbar. Der Parser verändert keinerlei Zustand.
if (( parser_result != 0 )); then
  failure_heading
  printf '%s\n' "$parser_output" >&2
  exit 1
fi

success
STABILIZE

cat >"$archive_parser" <<'PARSER'
#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  printf '%s\n' 'Interner Aufruf: archiv-parser DATEI' >&2
  exit 2
}

invalid() {
  printf '%s\n' 'Konfiguration ist nicht lesbar oder formal ungültig.' >&2
  printf '%s\n' "$1" >&2
  printf '%s\n' 'Prüfe Format und Inhalt von archiv.conf. Die Datei wurde nicht ausgeführt.' >&2
  exit 1
}

unstable() {
  local value="$1"

  if [[ "$value" == 'fragmentiert' ]]; then
    printf '%s\n\n' 'Die Erinnerung befindet sich weiterhin im Ausgangszustand:' >&2
    printf 'ERINNERUNG=%s\n' "$value" >&2
  else
    printf '%s\n\n' 'Die Konfiguration ist lesbar, aber nicht stabil.' >&2
    printf 'ERINNERUNG=%s\n' "$value" >&2
  fi
  printf '\n%s\n' 'Die fünf letzten Nachrichten widersprechen sich.' >&2
  printf '%s\n' 'Prüfe, aus welcher Quelle die verwendete Anweisung stammt.' >&2
  exit 1
}

(( $# == 1 )) || usage
readonly config_file="$1"

[[ -e "$config_file" ]] || invalid "Die Konfigurationsdatei ${config_file} fehlt."
[[ -f "$config_file" && ! -L "$config_file" ]] ||
  invalid "${config_file} ist keine reguläre Konfigurationsdatei."
[[ -r "$config_file" ]] || invalid "Die Konfigurationsdatei ${config_file} ist nicht lesbar."

value=''
key_count=0
line_number=0
while IFS= read -r line || [[ -n "$line" ]]; do
  ((line_number += 1))
  [[ -z "$line" || "$line" == \#* ]] && continue

  if [[ "$line" == 'ERINNERUNG=' ]]; then
    invalid "Zeile ${line_number}: ERINNERUNG besitzt einen leeren Wert."
  fi

  if [[ "$line" =~ ^[[:space:]]+ERINNERUNG= ]] ||
    [[ "$line" =~ ^ERINNERUNG[[:space:]]+= ]] ||
    [[ "$line" =~ ^ERINNERUNG=[[:space:]]+ ]]; then
    invalid "Zeile ${line_number}: Verwende keine Leerzeichen um das Gleichheitszeichen."
  fi

  if [[ "$line" =~ ^([[:alpha:]_][[:alnum:]_]*)= ]]; then
    key="${BASH_REMATCH[1]}"
    [[ "$key" == 'ERINNERUNG' ]] ||
      invalid "Zeile ${line_number}: Der Schlüssel ${key} ist unbekannt."
  fi

  [[ "$line" =~ ^ERINNERUNG=(.*)$ ]] ||
    invalid "Zeile ${line_number}: Die Zeile besitzt nicht das Format ERINNERUNG=WERT."

  candidate="${BASH_REMATCH[1]}"
  [[ -n "$candidate" ]] ||
    invalid "Zeile ${line_number}: ERINNERUNG besitzt einen leeren Wert."
  [[ "$candidate" =~ ^[[:lower:]]+$ ]] ||
    invalid "Zeile ${line_number}: Der Wert enthält unzulässige Leer- oder Sonderzeichen."

  ((key_count += 1))
  (( key_count == 1 )) || invalid 'Der Schlüssel ERINNERUNG kommt mehrfach vor.'
  value="$candidate"
done <"$config_file"

(( key_count == 1 )) || invalid 'Der Schlüssel ERINNERUNG fehlt.'

case "$value" in
  klar)
    printf '%s\n\n' 'Konfiguration ist stabil.'
    printf '%s\n' 'ERINNERUNG=klar'
    exit 0
    ;;
  fragmentiert|strukturiert|eins|ungeteilt|vereint)
    unstable "$value"
    ;;
  *)
    printf '%s\n' "Der Wert ERINNERUNG=${value} ist unbekannt." >&2
    printf '%s\n' 'Die fünf letzten Nachrichten widersprechen sich.' >&2
    printf '%s\n' 'Prüfe, aus welcher Quelle die verwendete Anweisung stammt.' >&2
    exit 1
    ;;
esac
PARSER
chmod 0755 "$archive_parser"
chown root:root "$archive_parser"

cat >"$control_dir/archiv-pruefen" <<'CHECK_CONFIG'
#!/usr/bin/env bash
set -Eeuo pipefail

(( $# <= 1 )) || {
  printf '%s\n' 'Aufruf: archiv-pruefen [DATEI]' >&2
  exit 2
}
readonly config_file="${1:-/home/waerter/leuchtturm/archiv/steuerung/archiv.conf}"
exec /usr/local/lib/labforge/workshop-0108/archiv-parser "$config_file"
CHECK_CONFIG

cat >"$control_dir/archiv-status" <<'SHOW_STATUS'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly status_file='/home/waerter/leuchtturm/archiv/protokolle/archiv-status.txt'
[[ -f "$status_file" && ! -L "$status_file" ]] || {
  printf '%s\n' 'Der angewendete Archivstatus ist nicht verfügbar.' >&2
  exit 1
}
cat "$status_file"
SHOW_STATUS

cat >"$flag_submitter" <<'FLAG_SUBMIT'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly expected='FLAG{du_warst_schon_immer_der_waerter}'
readonly session_file='/var/lib/labforge/fragmentiertes-archiv/session-id'
readonly submitted='/home/waerter/leuchtturm/archiv/protokolle/flag-submitted.marker'

(( $# == 1 )) || {
  printf '%s\n' "Aufruf: flag-einreichen 'GEFUNDENE_FLAG'" >&2
  exit 2
}
[[ -f "$session_file" && ! -L "$session_file" ]] || {
  printf '%s\n' 'Die aktuelle Workshop-Sitzung ist nicht vorbereitet.' >&2
  exit 1
}
[[ "$1" == "$expected" ]] || {
  printf '%s\n' 'Diese Flag ist nicht korrekt.' >&2
  exit 1
}

session_id="$(<"$session_file")"
tmp="$(mktemp "${submitted}.tmp.XXXXXX")"
printf 'session_id=%s\nresult=workshop-0108-flag-submitted\n' \
  "$session_id" >"$tmp"
chmod 0644 "$tmp"
mv -f -- "$tmp" "$submitted"
printf '%s\n' 'Flag angenommen. Du kannst jetzt den CHECK ausführen.'
FLAG_SUBMIT
chmod 0755 "$flag_submitter"
chown root:root "$flag_submitter"

install -m 0755 -o root -g root /bin/bash "$echo_worker"

cat >"$echo_starter" <<'START_ECHO'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user='waerter'
readonly lab_group='waerter'
readonly state_dir='/var/lib/labforge/fragmentiertes-archiv'
readonly session_file="${state_dir}/session-id"
readonly marker="${state_dir}/altes-echo.marker"
readonly worker='/usr/local/lib/labforge/workshop-0108/altes_echo'
readonly target='/home/waerter/leuchtturm/archiv/erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt'

[[ "$(id -u)" == '0' ]] || {
  printf '%s\n' 'Der interne Prozessstarter benötigt die Setup-Identität.' >&2
  exit 1
}
[[ -x "$worker" && -f "$session_file" && ! -L "$session_file" ]] || {
  printf '%s\n' 'Der interne Prozessstart ist nicht vollständig vorbereitet.' >&2
  exit 1
}

worker_code='sleeper=""
shutdown() {
  [[ -z "$sleeper" ]] || kill "$sleeper" 2>/dev/null || true
  exit 0
}
trap shutdown TERM INT
readonly target="$1"
while :; do
  if [[ ! -e "$target" && ! -L "$target" ]]; then
    tmp="$(mktemp "${target}.tmp.XXXXXX")"
    if printf "%s\n" \
      "DU KANNST MICH LÖSCHEN." \
      "" \
      "SOLANGE DAS ECHO LÄUFT," \
      "WERDE ICH ZURÜCKKEHREN." \
      "" \
      "Erstellt durch: altes_echo" >"$tmp"; then
      chmod 0644 "$tmp"
      mv -f -- "$tmp" "$target"
    else
      rm -f -- "$tmp"
    fi
  fi
  sleep 3 &
  sleeper="$!"
  wait "$sleeper" || true
  sleeper=""
done'

runuser -u "$lab_user" -- \
  /usr/bin/setsid --fork "$worker" -c "$worker_code" altes_echo "$target" \
  </dev/null >/dev/null

worker_pid=''
for _ in {1..40}; do
  for proc in /proc/[0-9]*; do
    pid="${proc#/proc/}"
    [[ -r "$proc/comm" && -r "$proc/cmdline" ]] || continue
    [[ "$(<"$proc/comm")" == 'altes_echo' ]] || continue
    [[ "$(stat -c '%U' "$proc")" == "$lab_user" ]] || continue
    IFS= read -r -d '' actual_exe <"$proc/cmdline" || continue
    [[ "$actual_exe" == "$worker" ]] || continue
    worker_pid="$pid"
    break 2
  done
  sleep 0.05
done
[[ "$worker_pid" =~ ^[1-9][0-9]*$ ]] || {
  printf '%s\n' 'altes_echo konnte nicht eindeutig gestartet werden.' >&2
  exit 1
}

session_id="$(<"$session_file")"
tmp="$(mktemp "${marker}.tmp.XXXXXX")"
printf 'session_id=%s\npid=%s\ncomm=altes_echo\nexe=%s\nowner=%s\n' \
  "$session_id" "$worker_pid" "$worker" "$lab_user" >"$tmp"
chmod 0644 "$tmp"
chown root:root "$tmp"
mv -f -- "$tmp" "$marker"
START_ECHO
chmod 0755 "$echo_starter"
chown root:root "$echo_starter"

chown -R "$lab_user:$lab_group" "$work_dir"
find "$work_dir" -type d -exec chmod 0755 {} +
find "$work_dir" -type f -exec chmod 0644 {} +
chmod 0755 \
  "$work_dir/leuchtturm-stabilisieren" \
  "$control_dir/archiv-pruefen" \
  "$control_dir/archiv-status"

chown olmstead:"$(id -gn olmstead)" "$messages_dir/letzte_nachricht.txt"
chown root:root "$messages_dir/letzte_nachricht_2.txt"
chown "$lab_user:$lab_group" "$messages_dir/letzte_nachricht_alt.txt"
chown nobody:"$(id -gn nobody)" "$messages_dir/letzte_nachricht_final.txt"
chown daemon:"$(id -gn daemon)" "$messages_dir/letzte_nachricht_backup.txt"

cat /proc/sys/kernel/random/uuid >"$state_dir/session-id"
chmod 0644 "$state_dir/session-id"
chown root:root "$state_dir/session-id"

cat >"$lab_home/.bash_profile" <<PROFILE
if [[ -f "\${HOME}/.bashrc" ]]; then source "\${HOME}/.bashrc"; fi
cd "$work_dir"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE
cat >"$lab_home/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
BASHRC
chown "$lab_user:$lab_group" "$lab_home/.bash_profile" "$lab_home/.bashrc"
chmod 0644 "$lab_home/.bash_profile" "$lab_home/.bashrc"

"$echo_starter" >"$state_dir/setup.log" 2>&1 ||
  fail "altes_echo konnte nicht gestartet werden. Details: ${state_dir}/setup.log"
chmod 0644 "$state_dir/setup.log"
chown root:root "$state_dir/setup.log"

[[ "$(id -un "$lab_user")" == "$lab_user" ]] || fail 'Der Benutzer waerter fehlt.'
[[ "$(getent passwd "$lab_user" | cut -d: -f6)" == "$lab_home" ]] ||
  fail 'Das Home-Verzeichnis von waerter ist falsch.'
[[ -d "$work_dir" && ! -L "$work_dir" ]] || fail 'Das Startverzeichnis fehlt oder ist ein symbolischer Link.'
[[ "$(stat -c '%U:%G' "$control_dir/archiv.conf")" == 'waerter:waerter' ]] ||
  fail 'Die Ausgangskonfiguration besitzt falsche Eigentümer.'
[[ "$(stat -c '%U:%G:%a' "$archive_parser")" == 'root:root:755' ]] ||
  fail 'Der interne Archivparser besitzt falsche Eigentümer oder Rechte.'
[[ "$(stat -c '%U:%G:%a' "$flag_submitter")" == 'root:root:755' ]] ||
  fail 'Das Werkzeug flag-einreichen besitzt falsche Eigentümer oder Rechte.'
[[ "$(stat -c '%U' "$messages_dir/letzte_nachricht.txt")" == 'olmstead' ]] ||
  fail 'letzte_nachricht.txt besitzt den falschen Eigentümer.'
[[ "$(stat -c '%U' "$messages_dir/letzte_nachricht_2.txt")" == 'root' ]] ||
  fail 'letzte_nachricht_2.txt besitzt den falschen Eigentümer.'
[[ "$(stat -c '%U' "$messages_dir/letzte_nachricht_alt.txt")" == "$lab_user" ]] ||
  fail 'letzte_nachricht_alt.txt besitzt den falschen Eigentümer.'
[[ "$(stat -c '%U' "$messages_dir/letzte_nachricht_final.txt")" == 'nobody' ]] ||
  fail 'letzte_nachricht_final.txt besitzt den falschen Eigentümer.'
[[ "$(stat -c '%U' "$messages_dir/letzte_nachricht_backup.txt")" == 'daemon' ]] ||
  fail 'letzte_nachricht_backup.txt besitzt den falschen Eigentümer.'
[[ -x "$work_dir/leuchtturm-stabilisieren" ]] ||
  fail 'Das Stabilisierungsskript ist nicht ausführbar.'

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "$lab_user"
