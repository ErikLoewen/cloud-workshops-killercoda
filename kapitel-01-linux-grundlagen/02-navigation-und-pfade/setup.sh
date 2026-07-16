#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_root="/root/navigation-labor"
readonly marker_dir="/tmp/labforge-navigation-und-pfade"
readonly marker="${marker_dir}/erfolgreich"
readonly asset_source="/tmp/labforge-navigation-assets/ziel-bestaetigen"
readonly action_target="/usr/local/bin/ziel-bestaetigen"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

[[ "$lab_root" == "/root/navigation-labor" ]] || fail "Unsicherer Laborpfad."
[[ "$marker_dir" == "/tmp/labforge-navigation-und-pfade" ]] || fail "Unsicherer Markerpfad."
[[ -f "$asset_source" ]] || fail "Die bereitgestellte Lab-Aktion wurde nicht als Asset gefunden."

rm -rf -- "$lab_root"
mkdir -p --   "$lab_root/startpunkt/blauer-raum"   "$lab_root/startpunkt/gruener-raum"   "$lab_root/lernstrecke/aussichtspunkt"   "$lab_root/lernstrecke/zielraum"   "$lab_root/uebungszone/nordfluegel/kartenraum"   "$lab_root/uebungszone/suedfluegel/ruheraum"   "$lab_root/abschlussgebiet/archivbereich"   "$lab_root/abschlussgebiet/kontrollzentrum/besprechungsraum"   "$lab_root/abschlussgebiet/kontrollzentrum/freigaberaum"   "$lab_root/abschlussgebiet/versorgungsraum"

mkdir -p -- "$marker_dir"
rm -f -- "$marker"

install -m 0755 -- "$asset_source" "$action_target"

[[ -x "$action_target" ]] || fail "Die Lab-Aktion konnte nicht ausführbar installiert werden."
[[ ! -e "$marker" ]] || fail "Der alte Erfolgsmarker konnte nicht entfernt werden."
