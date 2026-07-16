#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C

readonly LAB_ROOT="/root/dateilabor"
readonly STATE_ROOT="/var/lib/labforge/dateien-kopieren-und-sicher-loeschen"
readonly EXPECTED_LAB_ROOT="/root/dateilabor"
readonly EXPECTED_STATE_ROOT="/var/lib/labforge/dateien-kopieren-und-sicher-loeschen"
readonly MIN_LAB_PATH_LENGTH=10
readonly MIN_STATE_PATH_LENGTH=20

fail() {
  printf 'Setup abgebrochen: %s\n' "$1" >&2
  exit 1
}

validate_lab_cleanup_path() {
  local candidate="${1-}"

  [[ -n "$candidate" ]] || fail "Der Laborpfad ist leer."
  [[ "$candidate" == "$EXPECTED_LAB_ROOT" ]] || fail "Der Laborpfad entspricht nicht exakt $EXPECTED_LAB_ROOT."
  [[ "$candidate" != "/" ]] || fail "Der Wurzelpfad darf nicht bereinigt werden."
  [[ "$candidate" != "/root" ]] || fail "Der Pfad /root darf nicht bereinigt werden."
  [[ "$candidate" != "." ]] || fail "Der Pfad . darf nicht bereinigt werden."
  [[ "$candidate" != ".." ]] || fail "Der Pfad .. darf nicht bereinigt werden."
  (( ${#candidate} >= MIN_LAB_PATH_LENGTH )) || fail "Der Laborpfad ist unerwartet kurz."
  [[ "$candidate" != *'$'* ]] || fail "Der Laborpfad enthält eine unaufgelöste Variable."
  [[ "$candidate" != *'{'* ]] || fail "Der Laborpfad enthält einen unaufgelösten Platzhalter."
  [[ "$candidate" != *'}'* ]] || fail "Der Laborpfad enthält einen unaufgelösten Platzhalter."
}

validate_state_cleanup_path() {
  local candidate="${1-}"

  [[ -n "$candidate" ]] || fail "Der technische Zustandspfad ist leer."
  [[ "$candidate" == "$EXPECTED_STATE_ROOT" ]] || fail "Der technische Zustandspfad entspricht nicht dem erwarteten statischen Pfad."
  [[ "$candidate" != "/" ]] || fail "Der Wurzelpfad darf nicht bereinigt werden."
  [[ "$candidate" != "/var" ]] || fail "Der Pfad /var darf nicht bereinigt werden."
  [[ "$candidate" != "/var/lib" ]] || fail "Der Pfad /var/lib darf nicht bereinigt werden."
  (( ${#candidate} >= MIN_STATE_PATH_LENGTH )) || fail "Der technische Zustandspfad ist unerwartet kurz."
  [[ "$candidate" != *'$'* ]] || fail "Der technische Zustandspfad enthält eine unaufgelöste Variable."
  [[ "$candidate" != *'{'* ]] || fail "Der technische Zustandspfad enthält einen unaufgelösten Platzhalter."
  [[ "$candidate" != *'}'* ]] || fail "Der technische Zustandspfad enthält einen unaufgelösten Platzhalter."
}

remove_existing_static_directory() {
  local candidate="$1"
  local label="$2"

  if [[ -L "$candidate" ]]; then
    fail "$label ist ein symbolischer Link. Das Linkziel wird nicht verändert."
  fi

  if [[ -e "$candidate" ]]; then
    [[ -d "$candidate" ]] || fail "$label existiert, ist aber kein Verzeichnis."
    rm -r -- "$candidate"
  fi
}

main() {
  validate_lab_cleanup_path "$LAB_ROOT"
  validate_state_cleanup_path "$STATE_ROOT"

  [[ "/root" == "$(dirname -- "$LAB_ROOT")" ]] || fail "Der Elternpfad des Labors ist nicht /root."

  remove_existing_static_directory "$LAB_ROOT" "Der Laborstamm"
  remove_existing_static_directory "$STATE_ROOT" "Das technische Zustandsverzeichnis"

  mkdir -p -- \
    "$LAB_ROOT/demo/leerer-ordner" \
    "$LAB_ROOT/demo/nicht-leer" \
    "$LAB_ROOT/auftrag/quelle" \
    "$LAB_ROOT/auftrag/arbeitsbereich/leeres-archiv" \
    "$LAB_ROOT/auftrag/arbeitsbereich/temp-projekt/unterordner" \
    "$LAB_ROOT/auftrag/schutzbereich" \
    "$STATE_ROOT"

  printf '%s\n' 'Kopieren erhaelt die Quelle' > "$LAB_ROOT/demo/quelle.txt"
  printf '%s\n' 'Dieses Objekt erinnert an mv' > "$LAB_ROOT/demo/verschoben.txt"
  printf '%s\n' 'Diese Datei darf entfernt werden' > "$LAB_ROOT/demo/einzeldatei.txt"
  printf '%s\n' 'Das Verzeichnis ist nicht leer' > "$LAB_ROOT/demo/nicht-leer/inhalt.txt"

  printf '%s\n' 'Bericht fuer die Sicherung' > "$LAB_ROOT/auftrag/quelle/bericht.txt"
  printf '%s\n' 'Veraltete Arbeitsdatei' > "$LAB_ROOT/auftrag/arbeitsbereich/alt.txt"
  printf '%s\n' 'Temporäre Notiz' > "$LAB_ROOT/auftrag/arbeitsbereich/temp-projekt/notiz.txt"
  printf '%s\n' 'Temporärer Rest' > "$LAB_ROOT/auftrag/arbeitsbereich/temp-projekt/unterordner/rest.txt"
  printf '%s\n' 'Dieser Inhalt muss erhalten bleiben' > "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt"

  printf '%s\n' 'Bericht fuer die Sicherung' > "$STATE_ROOT/bericht.ref"
  printf '%s\n' 'Dieser Inhalt muss erhalten bleiben' > "$STATE_ROOT/wichtig.ref"
  printf '%s\n' 'wichtig.txt' > "$STATE_ROOT/schutz-eintraege.ref"
  printf '%s\n' '1.0.0' > "$STATE_ROOT/setup-version"

  chmod 0755 "$LAB_ROOT" "$LAB_ROOT/demo" "$LAB_ROOT/auftrag" \
    "$LAB_ROOT/auftrag/quelle" "$LAB_ROOT/auftrag/arbeitsbereich" \
    "$LAB_ROOT/auftrag/schutzbereich" "$STATE_ROOT"
  chmod 0644 "$STATE_ROOT/bericht.ref" "$STATE_ROOT/wichtig.ref" \
    "$STATE_ROOT/schutz-eintraege.ref" "$STATE_ROOT/setup-version"

  [[ ! -e "$LAB_ROOT/demo/kopie.txt" && ! -L "$LAB_ROOT/demo/kopie.txt" ]] \
    || fail "Die Demo-Kopie darf im Ausgangszustand nicht existieren."
  [[ ! -e "$LAB_ROOT/auftrag/arbeitsbereich/bericht-kopie.txt" && ! -L "$LAB_ROOT/auftrag/arbeitsbereich/bericht-kopie.txt" ]] \
    || fail "Die Auftragskopie darf im Ausgangszustand nicht existieren."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
