#!/usr/bin/env bash
set -Eeuo pipefail

readonly LAB_ROOT='/root/rechtelabor'
readonly STATE_ROOT='/var/lib/labforge/dateirechte-und-ausfuehrbarkeit'
readonly REF_ROOT="${STATE_ROOT}/referenz"
readonly MARKER="${STATE_ROOT}/auftrag-ausgefuehrt.marker"

die() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

safe_remove_tree() {
  local path="$1"
  local expected="$2"

  [[ -n "$path" ]] || die 'Ein Bereinigungspfad ist leer.'
  [[ "$path" == "$expected" ]] || die "Der Bereinigungspfad '$path' entspricht nicht dem erwarteten statischen Pfad '$expected'."

  case "$path" in
    /|/root|/var|/var/lib|.|..|\~)
      die "Der Bereinigungspfad '$path' ist ausdrücklich gesperrt."
      ;;
  esac

  [[ ! -L "$path" ]] || die "Der Laborstamm '$path' ist ein symbolischer Link und wird nicht bereinigt."

  if [[ -e "$path" ]]; then
    rm -rf -- "$path"
  fi
}

require_regular_not_symlink() {
  local path="$1"
  [[ ! -L "$path" ]] || die "Der erwartete reguläre Pfad '$path' ist ein symbolischer Link."
  [[ -f "$path" ]] || die "Die erwartete reguläre Datei '$path' fehlt."
}

mode_with_leading_zero() {
  local path="$1"
  local raw
  raw="$(stat -c '%a' "$path")"
  printf '0%s\n' "$raw"
}

safe_remove_tree "$LAB_ROOT" '/root/rechtelabor'
safe_remove_tree "$STATE_ROOT" '/var/lib/labforge/dateirechte-und-ausfuehrbarkeit'

readonly setup_uid="$(id -u)"
readonly setup_gid="$(id -g)"

mkdir -p \
  "$LAB_ROOT/demo" \
  "$LAB_ROOT/auftrag/arbeitsbereich" \
  "$LAB_ROOT/auftrag/schutzbereich" \
  "$REF_ROOT"

cat > "$LAB_ROOT/demo/ohne-ausfuehrungsrecht" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'Demo-Datei erfolgreich ausgeführt'
EOF

cat > "$LAB_ROOT/demo/bereits-ausfuehrbar" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'Diese Demo-Datei ist bereits ausführbar'
EOF

cat > "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei" <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
readonly MARKER='/var/lib/labforge/dateirechte-und-ausfuehrbarkeit/auftrag-ausgefuehrt.marker'
printf '%s\n' 'Prüfdatei erfolgreich ausgeführt'
printf '%s\n' 'ausgefuehrt' > "$MARKER"
EOF

cat > "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt" <<'EOF'
Dieser Inhalt und diese Rechte bleiben unverändert
EOF

chown -R "${setup_uid}:${setup_gid}" "$LAB_ROOT" "$STATE_ROOT"

chmod 0755 \
  "$LAB_ROOT" \
  "$LAB_ROOT/demo" \
  "$LAB_ROOT/auftrag" \
  "$LAB_ROOT/auftrag/arbeitsbereich" \
  "$LAB_ROOT/auftrag/schutzbereich"

chmod 0750 "$STATE_ROOT"
chmod 0700 "$REF_ROOT"

chmod 0644 "$LAB_ROOT/demo/ohne-ausfuehrungsrecht"
chmod 0744 "$LAB_ROOT/demo/bereits-ausfuehrbar"
chmod 0644 "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei"
chmod 0644 "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt"

rm -f -- "$MARKER"

sha256sum "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei" | cut -d ' ' -f 1 > "$REF_ROOT/pruefdatei.sha256"
sha256sum "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt" | cut -d ' ' -f 1 > "$REF_ROOT/wichtig.txt.sha256"
printf '%s\n' "$setup_uid" > "$REF_ROOT/eigentuemer.uid"
printf '%s\n' "$setup_gid" > "$REF_ROOT/gruppe.gid"
mode_with_leading_zero "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei" > "$REF_ROOT/pruefdatei.modus"
mode_with_leading_zero "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt" > "$REF_ROOT/wichtig.txt.modus"

chown -R "${setup_uid}:${setup_gid}" "$STATE_ROOT"
chmod 0400 "$REF_ROOT"/*

require_regular_not_symlink "$LAB_ROOT/demo/ohne-ausfuehrungsrecht"
require_regular_not_symlink "$LAB_ROOT/demo/bereits-ausfuehrbar"
require_regular_not_symlink "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei"
require_regular_not_symlink "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt"

[[ "$(stat -c '%a' "$LAB_ROOT/demo/ohne-ausfuehrungsrecht")" == '644' ]] || die 'Der Ausgangsmodus der nicht ausführbaren Demo-Datei ist falsch.'
[[ "$(stat -c '%a' "$LAB_ROOT/demo/bereits-ausfuehrbar")" == '744' ]] || die 'Der Ausgangsmodus der ausführbaren Demo-Datei ist falsch.'
[[ "$(stat -c '%a' "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei")" == '644' ]] || die 'Der Ausgangsmodus der Auftragsdatei ist falsch.'
[[ "$(stat -c '%a' "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt")" == '644' ]] || die 'Der Ausgangsmodus der Schutzdatei ist falsch.'
[[ ! -e "$MARKER" && ! -L "$MARKER" ]] || die 'Der Ausführungsmarker darf nach dem Setup nicht existieren.'

[[ "$(stat -c '%u' "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei")" == "$setup_uid" ]] || die 'Die Besitzer-UID der Auftragsdatei ist nicht reproduzierbar.'
[[ "$(stat -c '%g' "$LAB_ROOT/auftrag/arbeitsbereich/pruefdatei")" == "$setup_gid" ]] || die 'Die Gruppen-GID der Auftragsdatei ist nicht reproduzierbar.'
[[ "$(stat -c '%u' "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt")" == "$setup_uid" ]] || die 'Die Besitzer-UID der Schutzdatei ist nicht reproduzierbar.'
[[ "$(stat -c '%g' "$LAB_ROOT/auftrag/schutzbereich/wichtig.txt")" == "$setup_gid" ]] || die 'Die Gruppen-GID der Schutzdatei ist nicht reproduzierbar.'
