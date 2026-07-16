#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C

readonly LAB_ROOT="/root/dateilabor"
readonly STATE_ROOT="/var/lib/labforge/dateien-kopieren-und-sicher-loeschen"
readonly SOURCE="$LAB_ROOT/auftrag/quelle/bericht.txt"
readonly COPY="$LAB_ROOT/auftrag/arbeitsbereich/bericht-kopie.txt"
readonly ALT="$LAB_ROOT/auftrag/arbeitsbereich/alt.txt"
readonly EMPTY_ARCHIVE="$LAB_ROOT/auftrag/arbeitsbereich/leeres-archiv"
readonly TEMP_PROJECT="$LAB_ROOT/auftrag/arbeitsbereich/temp-projekt"
readonly PROTECT="$LAB_ROOT/auftrag/schutzbereich"
readonly PROTECT_FILE="$PROTECT/wichtig.txt"

readonly BERICHT_REF="$STATE_ROOT/bericht.ref"
readonly WICHTIG_REF="$STATE_ROOT/wichtig.ref"
readonly ENTRIES_REF="$STATE_ROOT/schutz-eintraege.ref"
readonly VERSION_REF="$STATE_ROOT/setup-version"

readonly EXPECTED_BERICHT_SHA="026cb10ff7a7c272d769c6762e5001e55e18ed6e24040c8f45bf1b69b6cee9d4"
readonly EXPECTED_WICHTIG_SHA="72faa93f1c67ecfd43c8dcf4c032a7abc7e3f8f0b2a004d295ee0d8e98e61887"
readonly EXPECTED_ENTRIES_SHA="e64bd13f5805d4c59b9a69364ae71ef2c0f65607725595c3f50a7f0ad7f7272a"
readonly EXPECTED_VERSION_SHA="59854984853104df5c353e2f681a15fc7924742f9a2e468c29af248dce45ce03"

fail() {
  printf 'CHECK nicht erfolgreich: %s\n' "$1"
  printf 'Nächster Schritt: %s\n' "$2"
  exit 1
}

missing_path() {
  [[ ! -e "$1" && ! -L "$1" ]]
}

validate_reference_file() {
  local path="$1"
  local expected_sha="$2"
  local label="$3"

  if missing_path "$path"; then
    fail "Technische Referenzdaten fehlen: $label." "Starte das Szenario neu oder melde den technischen Fehler."
  fi
  if [[ -L "$path" || ! -f "$path" ]]; then
    fail "Technische Referenzdaten sind beschädigt: $label ist keine echte reguläre Datei." "Starte das Szenario neu oder melde den technischen Fehler."
  fi

  local actual_sha
  actual_sha="$(sha256sum -- "$path")"
  actual_sha="${actual_sha%% *}"
  if [[ "$actual_sha" != "$expected_sha" ]]; then
    fail "Technische Referenzdaten sind beschädigt: $label besitzt einen unerwarteten Inhalt." "Starte das Szenario neu oder melde den technischen Fehler."
  fi
}

validate_reference_state() {
  if missing_path "$STATE_ROOT"; then
    fail "Das technische Zustandsverzeichnis fehlt." "Starte das Szenario neu oder melde den technischen Fehler."
  fi
  if [[ -L "$STATE_ROOT" || ! -d "$STATE_ROOT" ]]; then
    fail "Das technische Zustandsverzeichnis ist beschädigt." "Starte das Szenario neu oder melde den technischen Fehler."
  fi

  validate_reference_file "$BERICHT_REF" "$EXPECTED_BERICHT_SHA" "bericht.ref"
  validate_reference_file "$WICHTIG_REF" "$EXPECTED_WICHTIG_SHA" "wichtig.ref"
  validate_reference_file "$ENTRIES_REF" "$EXPECTED_ENTRIES_SHA" "schutz-eintraege.ref"
  validate_reference_file "$VERSION_REF" "$EXPECTED_VERSION_SHA" "setup-version"
}

validate_reference_state

if missing_path "$LAB_ROOT"; then
  fail "Der Laborstamm fehlt." "Starte das Szenario neu, damit das Labor reproduzierbar aufgebaut wird."
fi
if [[ -L "$LAB_ROOT" || ! -d "$LAB_ROOT" ]]; then
  fail "Die Laborstruktur ist technisch nicht auswertbar." "Starte das Szenario neu oder melde den technischen Fehler."
fi

if missing_path "$SOURCE"; then
  fail "Die Quelle $SOURCE fehlt." "Prüfe den Ordner quelle. Die Quelldatei muss erhalten bleiben."
fi
if [[ -L "$SOURCE" ]]; then
  fail "Die Quelle ist ein symbolischer Link und keine echte Quelldatei." "Stelle die reguläre Datei bericht.txt im Quellordner wieder her."
fi
if [[ ! -f "$SOURCE" ]]; then
  fail "Die Quelle ist keine reguläre Datei." "Prüfe den Objekttyp von bericht.txt."
fi
if ! cmp -s -- "$SOURCE" "$BERICHT_REF"; then
  fail "Die Quelle wurde verändert." "Vergleiche den Inhalt mit 'Bericht fuer die Sicherung'."
fi

if missing_path "$COPY"; then
  fail "Die Kopie $COPY fehlt." "Kopiere bericht.txt in den Arbeitsbereich und kontrolliere den Zielnamen."
fi
if [[ -L "$COPY" ]]; then
  fail "Die Kopie ist ein symbolischer Link und keine echte Dateikopie." "Erzeuge am Ziel eine reguläre Datei."
fi
if [[ ! -f "$COPY" ]]; then
  fail "Die Kopie ist keine reguläre Datei." "Prüfe den Objekttyp von bericht-kopie.txt."
fi
if ! cmp -s -- "$COPY" "$SOURCE"; then
  fail "Quelle und Kopie besitzen nicht denselben bytegenauen Inhalt." "Kontrolliere beide Dateien mit cat und kopiere die Quelle erneut an den Zielpfad."
fi
if ! cmp -s -- "$COPY" "$BERICHT_REF"; then
  fail "Die Kopie entspricht nicht der technischen Referenz." "Kontrolliere, ob die unveränderte Quelle kopiert wurde."
fi

source_inode="$(stat -c '%d:%i' -- "$SOURCE")"
copy_inode="$(stat -c '%d:%i' -- "$COPY")"
if [[ "$source_inode" == "$copy_inode" ]]; then
  fail "Quelle und Kopie besitzen denselben Inode. Ein Hardlink gilt nicht als Dateikopie." "Erzeuge eine eigenständige reguläre Datei am Zielpfad."
fi

for target in "$ALT" "$EMPTY_ARCHIVE" "$TEMP_PROJECT"; do
  if [[ -e "$target" || -L "$target" ]]; then
    case "$target" in
      "$ALT")
        fail "Die einzelne Datei alt.txt ist noch vorhanden oder wurde durch ein anderes Objekt ersetzt." "Prüfe den konkreten Pfad im Arbeitsbereich."
        ;;
      "$EMPTY_ARCHIVE")
        fail "Das leere Verzeichnis leeres-archiv ist noch vorhanden oder wurde durch ein anderes Objekt ersetzt." "Prüfe den konkreten Pfad und den Endzustand."
        ;;
      "$TEMP_PROJECT")
        fail "Das rekursive Ziel temp-projekt ist noch vorhanden oder wurde durch ein anderes Objekt ersetzt." "Prüfe ausschließlich den freigegebenen Zielpfad im Arbeitsbereich."
        ;;
    esac
  fi
done

if missing_path "$PROTECT"; then
  fail "Der Schutzbereich fehlt." "Der gesamte Schutzbereich muss vollständig erhalten bleiben."
fi
if [[ -L "$PROTECT" ]]; then
  fail "Der Schutzbereich ist ein symbolischer Link." "Der Schutzbereich muss ein echtes Verzeichnis sein."
fi
if [[ ! -d "$PROTECT" ]]; then
  fail "Der Schutzbereich ist kein echtes Verzeichnis." "Stelle den unveränderten Verzeichniszustand durch einen Szenarioneustart wieder her."
fi

if missing_path "$PROTECT_FILE"; then
  fail "Die Schutzdatei wichtig.txt fehlt." "Der CHECK kann sie nicht wiederherstellen; starte das Szenario für einen neuen Versuch."
fi
if [[ -L "$PROTECT_FILE" ]]; then
  fail "Die Schutzdatei ist ein symbolischer Link." "Die Schutzdatei muss eine echte reguläre Datei sein."
fi
if [[ ! -f "$PROTECT_FILE" ]]; then
  fail "Die Schutzdatei ist keine reguläre Datei." "Prüfe den Objekttyp von wichtig.txt."
fi
if ! cmp -s -- "$PROTECT_FILE" "$WICHTIG_REF"; then
  fail "Die Schutzdatei besitzt nicht mehr den erwarteten bytegenauen Inhalt." "Der CHECK repariert den Schutzbereich nicht; starte das Szenario für einen neuen Versuch."
fi

mapfile -d '' -t protect_entries < <(find "$PROTECT" -mindepth 1 -maxdepth 1 -print0)
if (( ${#protect_entries[@]} != 1 )); then
  fail "Der Schutzbereich enthält nicht genau den erwarteten Eintrag wichtig.txt." "Entferne nichts weiter. Starte bei verändertem Schutzbereich das Szenario neu."
fi
if [[ "${protect_entries[0]}" != "$PROTECT_FILE" ]]; then
  fail "Im Schutzbereich befindet sich ein unerwarteter Eintrag." "Der Schutzbereich darf ausschließlich wichtig.txt enthalten."
fi

printf '%s\n' "CHECK erfolgreich: Der fachlich erwartete Dateizustand ist vorhanden."
printf '%s\n' "Quelle und eigenständige Kopie sind korrekt, die freigegebenen Ziele fehlen und der Schutzbereich ist unverändert."
printf '%s\n' "Der CHECK beweist nicht, welche Befehle verwendet wurden oder ob die Sicherheitsroutine bewusst eingehalten wurde."
