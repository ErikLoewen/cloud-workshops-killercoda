#!/usr/bin/env bash
set -Eeuo pipefail

readonly room="/home/waerter/leuchtturm/obergeschoss/kartenraum"
readonly collapsed_corner="${room}/eingestuerzte-ecke"
readonly wall_note="${room}/notiz-aus-der-wand.txt"
readonly state="/var/lib/labforge/workshop-0104"
readonly ready="${state}/setup-version"
readonly revealed="${state}/flag-revealed"

for _ in {1..600}; do
  [[ -f "${ready}" && -d "${collapsed_corner}" ]] && break
  sleep 0.1
done

[[ -f "${ready}" && -d "${collapsed_corner}" ]] || {
  printf '%s\n' "Workshop 01.04 wurde nicht rechtzeitig vorbereitet." >&2
  exit 1
}

while [[ -e "${collapsed_corner}" || -L "${collapsed_corner}" ]]; do
  sleep 0.1
done

note_tmp="$(mktemp "${room}/notiz-aus-der-wand.txt.XXXXXX")"
cat >"${note_tmp}" <<'NOTE'
Zwischen den freigelegten Steinen steckt eine salzfleckige Notiz:

FLAG{der_waerter_war_hier}
NOTE
chown waerter:waerter "${note_tmp}"
chmod 0644 "${note_tmp}"
mv -f -- "${note_tmp}" "${wall_note}"

marker_tmp="$(mktemp "${state}/flag-revealed.XXXXXX")"
printf '%s\n' "revealed-after-corner-removed" >"${marker_tmp}"
chown root:root "${marker_tmp}"
chmod 0400 "${marker_tmp}"
mv -f -- "${marker_tmp}" "${revealed}"

participant_tty=""
if command -v ps >/dev/null 2>&1; then
  participant_tty="$(
    ps -u waerter -o tty=,comm= 2>/dev/null |
      awk '$1 != "?" && $2 == "bash" { print $1; exit }'
  )" || true
fi
if [[ -n "${participant_tty}" && -w "/dev/${participant_tty}" ]]; then
  cat >"/dev/${participant_tty}" <<'NOTICE'

[ Hinter der entfernten Ecke ist etwas Neues erschienen. ]
[ Prüfe den Kartenraum mit ls und lies die neue Datei mit cat. ]
NOTICE
fi
