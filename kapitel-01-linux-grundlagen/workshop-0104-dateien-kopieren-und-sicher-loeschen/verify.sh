#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C
readonly room="/home/waerter/leuchtturm/obergeschoss/kartenraum"
readonly state="/var/lib/labforge/workshop-0104"
readonly original="${room}/original/erste-spur.txt"
readonly copy="${room}/sicherung/erste-spur-kopie.txt"
readonly full_box="${room}/arbeitstisch/volle-kiste"
readonly expected_original_sha="558d6ad13b8b410df5ada20a57282478f49aca1ad64c3e7cf077a9d0123c2a92"
readonly expected_box_sha="47fde1c9a7ccd093dc031a10ae4f835f2535080d64001ca34a814dfe4b2052f2"
readonly expected_version_sha="c28fcca53637bc88e124af1725df13cb98c69dedefd62fb3cdbe1cdb6b760624"

fail() { printf 'CHECK nicht erfolgreich: %s\nNächster Schritt: %s\n' "$1" "$2"; exit 1; }
missing() { [[ ! -e "$1" && ! -L "$1" ]]; }
regular_not_link() { [[ -f "$1" && ! -L "$1" ]]; }

[[ -d "${state}" && ! -L "${state}" ]] || fail "Technische Referenzdaten fehlen oder sind beschädigt." "Starte das Szenario neu."
regular_not_link "${state}/erste-spur.ref" || fail "Die Referenz der ersten Spur ist beschädigt." "Starte das Szenario neu."
regular_not_link "${state}/volle-kiste.ref" || fail "Die Referenz der vollen Kiste ist beschädigt." "Starte das Szenario neu."
regular_not_link "${state}/setup-version" || fail "Die Referenz der Setup-Version ist beschädigt." "Starte das Szenario neu."
[[ "$(sha256sum -- "${state}/erste-spur.ref" | cut -d' ' -f1)" == "${expected_original_sha}" ]] || fail "Die Referenz der ersten Spur besitzt einen unerwarteten Inhalt." "Starte das Szenario neu."
[[ "$(sha256sum -- "${state}/volle-kiste.ref" | cut -d' ' -f1)" == "${expected_box_sha}" ]] || fail "Die Referenz der vollen Kiste besitzt einen unerwarteten Inhalt." "Starte das Szenario neu."
[[ "$(sha256sum -- "${state}/setup-version" | cut -d' ' -f1)" == "${expected_version_sha}" ]] || fail "Die Setup-Version passt nicht zum CHECK." "Starte das Szenario neu."

regular_not_link "${original}" || fail "Das geschützte Original fehlt oder ist kein reguläres Original." "Starte das Szenario neu; der CHECK stellt das Original nicht wieder her."
cmp -s -- "${original}" "${state}/erste-spur.ref" || fail "Das geschützte Original wurde verändert." "Starte das Szenario neu; kopiere beim nächsten Versuch nur aus original/."
[[ "$(stat -c '%U:%G:%a' -- "${room}/original")" == "root:root:555" ]] || fail "Der Schutz des Originalordners wurde verändert." "Starte das Szenario neu."
[[ "$(stat -c '%U:%G:%a' -- "${original}")" == "root:root:444" ]] || fail "Eigentümer oder Rechte des Originals wurden verändert." "Starte das Szenario neu."
[[ "$(find "${room}/original" -mindepth 1 -maxdepth 1 -printf '%f\n')" == "erste-spur.txt" ]] || fail "Der Originalordner enthält unerwartete oder fehlende Einträge." "Starte das Szenario neu."

regular_not_link "${copy}" || fail "Die Sicherung fehlt oder ist keine eigenständige reguläre Datei." "Kopiere original/erste-spur.txt nach sicherung/erste-spur-kopie.txt."
cmp -s -- "${original}" "${copy}" || fail "Original und Sicherung sind nicht inhaltlich identisch." "Vergleiche beide Dateien und kopiere das unveränderte Original erneut."
[[ "$(stat -c '%d:%i' -- "${original}")" != "$(stat -c '%d:%i' -- "${copy}")" ]] || fail "Die Sicherung ist ein Hardlink statt einer eigenständigen Kopie." "Erzeuge die Sicherung mit cp."

missing "${room}/arbeitstisch/alte-abschrift.txt" || fail "alte-abschrift.txt ist noch vorhanden." "Prüfe den Pfad und entferne nur diese Datei."
missing "${room}/arbeitstisch/leere-mappe" || fail "leere-mappe ist noch vorhanden." "Das leere Verzeichnis kann mit rmdir entfernt werden."
[[ -d "${full_box}" && ! -L "${full_box}" ]] || fail "volle-kiste muss als echtes Verzeichnis erhalten bleiben." "Starte bei veränderter voller Kiste das Szenario neu."
regular_not_link "${full_box}/inhalt.txt" || fail "Der Inhalt der vollen Kiste fehlt oder wurde ersetzt." "volle-kiste gehört nicht zu den Löschzielen."
cmp -s -- "${full_box}/inhalt.txt" "${state}/volle-kiste.ref" || fail "Der Inhalt der vollen Kiste wurde verändert." "Starte das Szenario neu."
[[ "$(find "${full_box}" -mindepth 1 -maxdepth 1 -printf '%f\n')" == "inhalt.txt" ]] || fail "volle-kiste enthält unerwartete oder fehlende Einträge." "Sie muss unverändert bleiben."
missing "${room}/eingestuerzte-ecke" || fail "eingestuerzte-ecke ist noch vorhanden." "Untersuche den vollständigen Baum und entferne ausschließlich diesen Bereich rekursiv."

printf '%s\n' 'CHECK erfolgreich: Die erste Spur ist eigenständig gesichert und das Original blieb unverändert geschützt.'
printf '%s\n' 'Die freigegebenen Ziele wurden entfernt; volle-kiste blieb samt Inhalt erhalten.'
printf '%s\n' 'Der CHECK bewertet den Endzustand, nicht die tatsächlich eingegebene Befehlsfolge.'
