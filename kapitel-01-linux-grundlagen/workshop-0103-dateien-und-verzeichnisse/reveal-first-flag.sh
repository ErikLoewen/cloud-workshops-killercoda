#!/usr/bin/env bash
set -Eeuo pipefail

readonly state_dir="/tmp/workshop-0103"
readonly ready="${state_dir}/ready"
readonly source="/home/waerter/leuchtturm/untergeschoss/lagerraum/archiv/letzter_eintrag.txt"
readonly target="/home/waerter/leuchtturm/obergeschoss/kartenraum/erste-spur.txt"
readonly revealed="${state_dir}/flag-revealed"
readonly notification="${state_dir}/reveal-notification"
readonly shown="${state_dir}/notification-shown"

for _ in {1..600}; do
  [[ -f "${ready}" ]] && break
  sleep 1
done

[[ -f "${ready}" ]] || {
  printf '%s\n' "Workshop 01.03 wurde nicht rechtzeitig vorbereitet." >&2
  exit 1
}

expected_identity="$(<"${state_dir}/source-identity")"
expected_hash="$(<"${state_dir}/source-hash")"

while [[ ! -e "${revealed}" ]]; do
  if [[ -f "${target}" && ! -e "${source}" ]] &&
    [[ "$(stat -c '%d:%i' "${target}" 2>/dev/null || true)" == "${expected_identity}" ]] &&
    [[ "$(sha256sum "${target}" 2>/dev/null | awk '{ print $1 }')" == "${expected_hash}" ]]; then
    reveal_tmp="$(mktemp "${target}.reveal.XXXXXX")"
    cat >"${reveal_tmp}" <<'REVEALED'
30. Oktober, 23:40 Uhr

Der Nebel steht ungewöhnlich dicht vor den Fenstern.
Im Kartenraum lassen sich die letzten Zeilen besser lesen.

Die Tinte verläuft. Zwischen den alten Zeilen erscheint eine neue Nachricht:

FLAG{erste_spur_im_kartenraum}
REVEALED
    chown waerter:waerter "${reveal_tmp}"
    chmod 0644 "${reveal_tmp}"
    mv -f -- "${reveal_tmp}" "${target}"

    marker_tmp="$(mktemp "${state_dir}/flag-revealed.XXXXXX")"
    printf '%s\n' "revealed-once" >"${marker_tmp}"
    chown waerter:waerter "${marker_tmp}"
    chmod 0644 "${marker_tmp}"
    mv -f -- "${marker_tmp}" "${revealed}"

    notification_tmp="$(mktemp "${state_dir}/reveal-notification.XXXXXX")"
    cat >"${notification_tmp}" <<'NOTICE'
[ Das Licht flackert. Schwarze Magie geht vonstatten ... ]
[ In erste-spur.txt sind neue Zeilen erschienen. ]
[ Sieh dir die Datei noch einmal genau mit cat an. ]
NOTICE
    chown waerter:waerter "${notification_tmp}"
    chmod 0644 "${notification_tmp}"
    mv -f -- "${notification_tmp}" "${notification}"

    participant_tty="$(
      ps -u waerter -o tty=,comm= 2>/dev/null |
        awk '$1 != "?" && $2 == "bash" { print $1; exit }'
    )"
    if [[ -n "${participant_tty}" && -w "/dev/${participant_tty}" ]]; then
      cat "${notification}" >"/dev/${participant_tty}"
      : >"${shown}"
      chown waerter:waerter "${shown}"
      chmod 0644 "${shown}"
      rm -f -- "${notification}"
    fi
    exit 0
  fi
  sleep 1
done
