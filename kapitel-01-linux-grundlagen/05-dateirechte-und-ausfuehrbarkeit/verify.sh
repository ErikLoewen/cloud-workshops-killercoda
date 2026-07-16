#!/usr/bin/env bash
set -Eeuo pipefail

readonly LAB_ROOT='/root/rechtelabor'
readonly STATE_ROOT='/var/lib/labforge/dateirechte-und-ausfuehrbarkeit'
readonly REF_ROOT="${STATE_ROOT}/referenz"
readonly TASK_DIR="${LAB_ROOT}/auftrag/arbeitsbereich"
readonly TASK_FILE="${TASK_DIR}/pruefdatei"
readonly PROTECT_DIR="${LAB_ROOT}/auftrag/schutzbereich"
readonly PROTECT_FILE="${PROTECT_DIR}/wichtig.txt"
readonly MARKER="${STATE_ROOT}/auftrag-ausgefuehrt.marker"

scenario_error() {
  printf 'Technischer Szenariofehler: %s\n' "$1" >&2
  printf 'Nächster Schritt: Starte das Szenario neu. Bleibt der Fehler bestehen, muss die Szenariotechnik geprüft werden.\n' >&2
  exit 2
}

fail_check() {
  printf 'CHECK noch nicht erfolgreich: %s\n' "$1" >&2
  printf 'Erwarteter Zustand: %s\n' "$2" >&2
  printf 'Nächster Prüfschritt: %s\n' "$3" >&2
  exit 1
}

require_reference_file() {
  local path="$1"
  [[ ! -L "$path" ]] || scenario_error "Die Referenzdatei '$path' ist ein symbolischer Link."
  [[ -e "$path" ]] || scenario_error "Die Referenzdatei '$path' fehlt."
  [[ -f "$path" ]] || scenario_error "Der Referenzpfad '$path' ist keine reguläre Datei."
  [[ "$(stat -c '%a' "$path")" == '400' ]] || scenario_error "Die Referenzdatei '$path' besitzt unerwartete technische Rechte."
}

read_reference() {
  local path="$1"
  require_reference_file "$path"
  cat "$path"
}

[[ ! -L "$STATE_ROOT" ]] || scenario_error "Das technische Zustandsverzeichnis '$STATE_ROOT' ist ein symbolischer Link."
[[ -d "$STATE_ROOT" ]] || scenario_error "Das technische Zustandsverzeichnis '$STATE_ROOT' fehlt oder ist kein Verzeichnis."
[[ ! -L "$REF_ROOT" ]] || scenario_error "Das technische Referenzverzeichnis '$REF_ROOT' ist ein symbolischer Link."
[[ -d "$REF_ROOT" ]] || scenario_error "Das technische Referenzverzeichnis '$REF_ROOT' fehlt oder ist kein Verzeichnis."

for ref_name in \
  pruefdatei.sha256 \
  wichtig.txt.sha256 \
  eigentuemer.uid \
  gruppe.gid \
  pruefdatei.modus \
  wichtig.txt.modus
do
  require_reference_file "$REF_ROOT/$ref_name"
done

readonly expected_task_hash="$(read_reference "$REF_ROOT/pruefdatei.sha256")"
readonly expected_protect_hash="$(read_reference "$REF_ROOT/wichtig.txt.sha256")"
readonly expected_uid="$(read_reference "$REF_ROOT/eigentuemer.uid")"
readonly expected_gid="$(read_reference "$REF_ROOT/gruppe.gid")"
readonly initial_task_mode="$(read_reference "$REF_ROOT/pruefdatei.modus")"
readonly expected_protect_mode="$(read_reference "$REF_ROOT/wichtig.txt.modus")"

[[ "$expected_task_hash" =~ ^[0-9a-f]{64}$ ]] || scenario_error 'Der gespeicherte SHA-256-Wert der Auftragsdatei besitzt ein ungültiges Format.'
[[ "$expected_protect_hash" =~ ^[0-9a-f]{64}$ ]] || scenario_error 'Der gespeicherte SHA-256-Wert der Schutzdatei besitzt ein ungültiges Format.'
[[ "$expected_uid" =~ ^[0-9]+$ ]] || scenario_error 'Die gespeicherte Besitzer-UID besitzt ein ungültiges Format.'
[[ "$expected_gid" =~ ^[0-9]+$ ]] || scenario_error 'Die gespeicherte Gruppen-GID besitzt ein ungültiges Format.'
[[ "$initial_task_mode" =~ ^0[0-7]{3}$ ]] || scenario_error 'Der gespeicherte Ausgangsmodus der Auftragsdatei besitzt ein ungültiges Format.'
[[ "$expected_protect_mode" =~ ^0[0-7]{3}$ ]] || scenario_error 'Der gespeicherte Modus der Schutzdatei besitzt ein ungültiges Format.'
[[ "$initial_task_mode" == '0644' ]] || scenario_error 'Der gespeicherte Ausgangsmodus der Auftragsdatei entspricht nicht der Szenariospezifikation.'
[[ "$expected_protect_mode" == '0644' ]] || scenario_error 'Der gespeicherte Modus der Schutzdatei entspricht nicht der Szenariospezifikation.'

[[ "$(id -u)" == "$expected_uid" ]] || scenario_error 'Die effektive Teilnehmer- beziehungsweise Prüfer-UID passt nicht zur erwarteten Besitzer-UID der Labordateien.'
[[ "$(id -g)" == "$expected_gid" ]] || scenario_error 'Die effektive Teilnehmer- beziehungsweise Prüfer-GID passt nicht zur erwarteten Gruppen-GID der Labordateien.'

[[ ! -L "$LAB_ROOT" ]] || fail_check 'Der Teilnehmerstamm ist ein symbolischer Link.' 'Ein echtes Laborverzeichnis unter /root/rechtelabor.' 'Starte das Szenario neu.'
[[ -d "$LAB_ROOT" ]] || fail_check 'Der Teilnehmerstamm fehlt oder ist kein Verzeichnis.' 'Ein echtes Laborverzeichnis unter /root/rechtelabor.' 'Starte das Szenario neu.'

[[ ! -L "$TASK_DIR" ]] || fail_check 'Der Arbeitsbereich ist ein symbolischer Link.' 'Ein echtes Arbeitsverzeichnis.' 'Starte das Szenario neu.'
[[ -d "$TASK_DIR" ]] || fail_check 'Der Arbeitsbereich fehlt oder ist kein Verzeichnis.' 'Der vorbereitete Arbeitsbereich mit der Auftragsdatei.' 'Prüfe die Laborstruktur und starte das Szenario bei Bedarf neu.'

[[ ! -L "$TASK_FILE" ]] || fail_check 'Die Auftragsdatei ist ein symbolischer Link.' 'Eine reguläre vorbereitete Datei.' 'Starte das Szenario neu und verändere nur das vorgesehene Recht.'
[[ -e "$TASK_FILE" ]] || fail_check 'Die Auftragsdatei fehlt.' 'Die reguläre Datei pruefdatei im Arbeitsbereich.' 'Prüfe den Arbeitsbereich und starte das Szenario bei Bedarf neu.'
[[ -f "$TASK_FILE" ]] || fail_check 'Der Pfad der Auftragsdatei ist keine reguläre Datei.' 'Die reguläre Datei pruefdatei im Arbeitsbereich.' 'Prüfe den Arbeitsbereich und starte das Szenario bei Bedarf neu.'

actual_task_hash=''
if ! actual_task_hash="$(sha256sum "$TASK_FILE" 2>/dev/null | cut -d ' ' -f 1)"; then
  readonly unreadable_task_mode_text="$(stat -c '%a' "$TASK_FILE")"
  readonly unreadable_task_mode=$((8#$unreadable_task_mode_text))
  if (( (unreadable_task_mode & 0400) == 0 )); then
    fail_check 'Im Besitzerbereich fehlt das Leserecht; deshalb kann der vorbereitete Inhalt nicht geprüft werden.' 'Besitzer rwx, Gruppe r--, andere r--.' 'Prüfe den ersten Rechtebereich mit ls -l.'
  fi
  fail_check 'Der Inhalt der Auftragsdatei konnte nicht gelesen werden.' 'Eine lesbare reguläre Auftragsdatei mit unverändertem Inhalt.' 'Prüfe Dateityp und Rechteanzeige.'
fi
readonly actual_task_hash
[[ "$actual_task_hash" == "$expected_task_hash" ]] || fail_check 'Der Inhalt der Auftragsdatei wurde verändert.' 'Der vorbereitete Dateiinhalt bleibt bytegenau unverändert.' 'Ändere nur Dateirechte. Für einen sauberen Ausgangszustand starte das Szenario neu.'

readonly actual_task_uid="$(stat -c '%u' "$TASK_FILE")"
readonly actual_task_gid="$(stat -c '%g' "$TASK_FILE")"
[[ "$actual_task_uid" == "$expected_uid" ]] || fail_check "Die Besitzer-UID der Auftragsdatei wurde verändert: beobachtet $actual_task_uid." 'Die ursprüngliche Besitzer-UID bleibt erhalten.' 'Für einen sauberen Ausgangszustand starte das Szenario neu.'
[[ "$actual_task_gid" == "$expected_gid" ]] || fail_check "Die Gruppen-GID der Auftragsdatei wurde verändert: beobachtet $actual_task_gid." 'Die ursprüngliche Gruppen-GID bleibt erhalten.' 'Für einen sauberen Ausgangszustand starte das Szenario neu.'

readonly actual_task_mode_text="$(stat -c '%a' "$TASK_FILE")"
readonly actual_task_mode=$((8#$actual_task_mode_text))
readonly expected_task_mode=$((8#$initial_task_mode | 0100))

if (( actual_task_mode != expected_task_mode )); then
  if (( (actual_task_mode & 0400) == 0 )); then
    fail_check 'Im Besitzerbereich fehlt das Leserecht.' 'Besitzer rwx, Gruppe r--, andere r--.' 'Prüfe den ersten Rechtebereich mit ls -l.'
  elif (( (actual_task_mode & 0200) == 0 )); then
    fail_check 'Im Besitzerbereich fehlt das Schreibrecht.' 'Besitzer rwx, Gruppe r--, andere r--.' 'Prüfe den ersten Rechtebereich mit ls -l.'
  elif (( (actual_task_mode & 0100) == 0 )); then
    fail_check 'Im Besitzerbereich fehlt das Ausführungsrecht.' 'Besitzer rwx, Gruppe r--, andere r--.' 'Prüfe die Rechteanzeige und ergänze nur das Besitzer-Ausführungsrecht.'
  elif (( (actual_task_mode & 0020) != 0 )); then
    fail_check 'Die Gruppe besitzt ein unerwartetes Schreibrecht.' 'Die Gruppe besitzt nur das Leserecht.' 'Prüfe die zweite Dreiergruppe.'
  elif (( (actual_task_mode & 0010) != 0 )); then
    fail_check 'Die Gruppe besitzt ein unerwartetes Ausführungsrecht.' 'Die Gruppe besitzt nur das Leserecht.' 'Prüfe die zweite Dreiergruppe.'
  elif (( (actual_task_mode & 0002) != 0 )); then
    fail_check 'Andere Benutzer besitzen ein unerwartetes Schreibrecht.' 'Andere Benutzer besitzen nur das Leserecht.' 'Prüfe die dritte Dreiergruppe.'
  elif (( (actual_task_mode & 0001) != 0 )); then
    fail_check 'Andere Benutzer besitzen ein unerwartetes Ausführungsrecht.' 'Andere Benutzer besitzen nur das Leserecht.' 'Prüfe die dritte Dreiergruppe.'
  elif (( (actual_task_mode & 0040) == 0 )); then
    fail_check 'Der Gruppe fehlt das vorgesehene Leserecht.' 'Die Gruppe besitzt nur das Leserecht.' 'Prüfe die zweite Dreiergruppe.'
  elif (( (actual_task_mode & 0004) == 0 )); then
    fail_check 'Anderen Benutzern fehlt das vorgesehene Leserecht.' 'Andere Benutzer besitzen nur das Leserecht.' 'Prüfe die dritte Dreiergruppe.'
  else
    fail_check "Der Rechteblock der Auftragsdatei ist zu weitreichend oder entspricht aus einem anderen Grund nicht dem Ziel: beobachtet $(stat -c '%A' "$TASK_FILE")." 'Besitzer rwx, Gruppe r--, andere r--.' 'Prüfe alle drei Dreiergruppen und entferne nicht benötigte Rechte.'
  fi
fi

[[ ! -L "$MARKER" ]] || fail_check 'Der technische Ausführungsnachweis ist ein symbolischer Link.' 'Ein regulärer interner Nachweis mit dem erwarteten Inhalt.' 'Starte das Szenario neu und führe die vorbereitete Datei erneut aus.'
if [[ ! -e "$MARKER" ]]; then
  fail_check 'Die Rechte der Auftragsdatei sind korrekt, aber die vorbereitete Datei wurde noch nicht erfolgreich ausgeführt.' 'Die Datei ist ausführbar und der interne Ausführungsnachweis ist vorhanden.' 'Prüfe die Rechteanzeige und führe die Datei anschließend aus ihrem aktuellen Verzeichnis aus.'
fi
[[ -f "$MARKER" ]] || fail_check 'Der technische Ausführungsnachweis ist keine reguläre Datei.' 'Ein regulärer interner Nachweis mit dem erwarteten Inhalt.' 'Starte das Szenario neu und führe die vorbereitete Datei erneut aus.'
cmp -s "$MARKER" <(printf '%s\n' 'ausgefuehrt') || fail_check 'Der technische Ausführungsnachweis besitzt einen falschen Inhalt.' 'Der interne Nachweis enthält exakt den vorgesehenen Wert.' 'Starte das Szenario neu und führe die unveränderte Auftragsdatei erneut aus.'

[[ ! -L "$PROTECT_DIR" ]] || fail_check 'Der Schutzbereich ist ein symbolischer Link.' 'Ein echtes unverändertes Schutzverzeichnis.' 'Starte das Szenario neu.'
[[ -d "$PROTECT_DIR" ]] || fail_check 'Der Schutzbereich fehlt oder ist kein Verzeichnis.' 'Das vorbereitete Schutzverzeichnis mit genau einer Datei.' 'Prüfe die Laborstruktur und starte das Szenario bei Bedarf neu.'

readonly protect_dir_uid="$(stat -c '%u' "$PROTECT_DIR")"
readonly protect_dir_gid="$(stat -c '%g' "$PROTECT_DIR")"
readonly protect_dir_mode="$(stat -c '%a' "$PROTECT_DIR")"
[[ "$protect_dir_uid" == "$expected_uid" ]] || fail_check 'Der Besitzer des Schutzverzeichnisses wurde verändert.' 'Der ursprüngliche Besitzer bleibt erhalten.' 'Für einen sauberen Ausgangszustand starte das Szenario neu.'
[[ "$protect_dir_gid" == "$expected_gid" ]] || fail_check 'Die Gruppe des Schutzverzeichnisses wurde verändert.' 'Die ursprüngliche Gruppe bleibt erhalten.' 'Für einen sauberen Ausgangszustand starte das Szenario neu.'
[[ "$protect_dir_mode" == '755' ]] || fail_check 'Die Rechte des Schutzverzeichnisses wurden verändert.' 'Der Schutzbereich bleibt in seinem vorbereiteten Zustand.' 'Für einen sauberen Ausgangszustand starte das Szenario neu.'

[[ ! -L "$PROTECT_FILE" ]] || fail_check 'Die Schutzdatei ist ein symbolischer Link.' 'Eine reguläre unveränderte Datei wichtig.txt.' 'Starte das Szenario neu.'
[[ -e "$PROTECT_FILE" ]] || fail_check 'Die Schutzdatei fehlt.' 'Die reguläre Datei wichtig.txt.' 'Starte das Szenario neu.'
[[ -f "$PROTECT_FILE" ]] || fail_check 'Der Pfad der Schutzdatei ist keine reguläre Datei.' 'Die reguläre Datei wichtig.txt.' 'Starte das Szenario neu.'

mapfile -d '' -t protect_entries < <(find "$PROTECT_DIR" -mindepth 1 -maxdepth 1 -print0)
if (( ${#protect_entries[@]} != 1 )); then
  fail_check "Der Schutzbereich enthält ${#protect_entries[@]} Einträge statt genau eines Eintrags." 'Der Schutzbereich enthält ausschließlich wichtig.txt.' 'Entferne keine Schutzdatei und erzeuge dort keine zusätzlichen Einträge. Starte bei Veränderungen das Szenario neu.'
fi
[[ "${protect_entries[0]}" == "$PROTECT_FILE" ]] || fail_check 'Der einzige Eintrag im Schutzbereich heißt nicht wichtig.txt.' 'Der Schutzbereich enthält ausschließlich wichtig.txt.' 'Starte das Szenario neu.'

actual_protect_hash=''
if ! actual_protect_hash="$(sha256sum "$PROTECT_FILE" 2>/dev/null | cut -d ' ' -f 1)"; then
  fail_check 'Der Inhalt der Schutzdatei konnte nicht gelesen werden.' 'Eine lesbare reguläre Schutzdatei mit unverändertem Inhalt.' 'Starte das Szenario neu.'
fi
readonly actual_protect_hash
readonly actual_protect_uid="$(stat -c '%u' "$PROTECT_FILE")"
readonly actual_protect_gid="$(stat -c '%g' "$PROTECT_FILE")"
readonly actual_protect_mode_text="$(stat -c '%a' "$PROTECT_FILE")"

[[ "$actual_protect_hash" == "$expected_protect_hash" ]] || fail_check 'Der Inhalt der Schutzdatei wurde verändert.' 'Der vorbereitete Inhalt bleibt bytegenau unverändert.' 'Starte das Szenario neu und verändere den Schutzbereich nicht.'
[[ "$actual_protect_uid" == "$expected_uid" ]] || fail_check 'Die Besitzer-UID der Schutzdatei wurde verändert.' 'Die ursprüngliche Besitzer-UID bleibt erhalten.' 'Starte das Szenario neu.'
[[ "$actual_protect_gid" == "$expected_gid" ]] || fail_check 'Die Gruppen-GID der Schutzdatei wurde verändert.' 'Die ursprüngliche Gruppen-GID bleibt erhalten.' 'Starte das Szenario neu.'
[[ "0$actual_protect_mode_text" == "$expected_protect_mode" ]] || fail_check "Die Rechte der Schutzdatei wurden verändert: beobachtet $(stat -c '%A' "$PROTECT_FILE")." 'Die Schutzdatei bleibt im vorbereiteten Rechtezustand.' 'Starte das Szenario neu und verändere nur die freigegebene Auftragsdatei.'

printf '%s\n' 'Technischer CHECK erfolgreich: Auftragsdatei, Ausführungsnachweis und Schutzbereich besitzen den vorgesehenen Endzustand.'
printf '%s\n' 'Der CHECK bewertet den technischen Endzustand, nicht den verwendeten Lösungsweg oder dein begriffliches Verständnis.'
