#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C

readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lab_hostname="leuchtturm"
readonly lab_root="${lab_home}/leuchtturm"
readonly room="${lab_root}/obergeschoss/kartenraum"
readonly state_root="/var/lib/labforge/workshop-0104"
readonly asset_source="/tmp/workshop-0104-assets/flag-einreichen"
readonly action_target="/usr/local/bin/flag-einreichen"

fail() { printf 'Setup-Fehler: %s\n' "$1" >&2; exit 1; }

[[ "${room}" == "/home/waerter/leuchtturm/obergeschoss/kartenraum" ]] || fail "Unsicherer Workshop-Pfad."
[[ "${state_root}" == "/var/lib/labforge/workshop-0104" ]] || fail "Unsicherer Statuspfad."

if ! getent group "${lab_user}" >/dev/null 2>&1; then groupadd "${lab_user}"; fi
if ! id "${lab_user}" >/dev/null 2>&1; then
  useradd --create-home --home-dir "${lab_home}" --shell /bin/bash --gid "${lab_user}" "${lab_user}"
fi
usermod --home "${lab_home}" --shell /bin/bash --gid "${lab_user}" "${lab_user}"
install -d -m 0750 -o "${lab_user}" -g "${lab_user}" "${lab_home}"

printf '%s\n' "${lab_hostname}" >/etc/hostname
if [[ "$(hostname)" != "${lab_hostname}" ]]; then
  if command -v hostnamectl >/dev/null 2>&1 && hostnamectl set-hostname "${lab_hostname}" >/dev/null 2>&1; then :
  elif command -v hostname >/dev/null 2>&1; then hostname "${lab_hostname}"
  else fail "Der Hostname konnte nicht gesetzt werden."
  fi
fi
if grep -qE '^[[:space:]]*127\.0\.1\.1[[:space:]]+' /etc/hosts; then
  hosts_tmp="$(mktemp /tmp/workshop-0104-hosts.XXXXXX)"
  awk -v host="${lab_hostname}" '$1 == "127.0.1.1" { print "127.0.1.1 " host; next } { print }' /etc/hosts >"${hosts_tmp}"
  cat "${hosts_tmp}" >/etc/hosts
  rm -f -- "${hosts_tmp}"
else
  printf '127.0.1.1 %s\n' "${lab_hostname}" >>/etc/hosts
fi

cat >"${lab_home}/.bash_profile" <<PROFILE
if [[ -f "\${HOME}/.bashrc" ]]; then source "\${HOME}/.bashrc"; fi
cd "${room}"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE
cat >"${lab_home}/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
bind 'set echo-control-characters off'
BASHRC

if [[ -L "${lab_root}" ]]; then fail "Der Leuchtturmpfad ist ein symbolischer Link."; fi
if [[ -e "${lab_root}" ]]; then [[ -d "${lab_root}" ]] || fail "Der Leuchtturmpfad ist kein Verzeichnis."; rm -r -- "${lab_root}"; fi
if [[ -L "${state_root}" ]]; then fail "Der Statuspfad ist ein symbolischer Link."; fi
if [[ -e "${state_root}" ]]; then [[ -d "${state_root}" ]] || fail "Der Statuspfad ist kein Verzeichnis."; rm -r -- "${state_root}"; fi

install -d -m 0755 -o "${lab_user}" -g "${lab_user}" \
  "${room}/sicherung" \
  "${room}/arbeitstisch/leere-mappe" \
  "${room}/arbeitstisch/volle-kiste" \
  "${room}/eingestuerzte-ecke/splitter"
install -d -m 0755 -o root -g root "${room}/original"
install -d -m 0750 -o root -g "${lab_user}" "${state_root}"

[[ -f "${asset_source}" && ! -L "${asset_source}" ]] || fail "Das Werkzeug zur Flag-Abgabe fehlt."
install -m 0755 -o root -g root "${asset_source}" "${action_target}"

printf '%s\n' 'Die erste Spur weist auf ein Pochen hinter der Nordwand.' >"${room}/original/erste-spur.txt"
printf '%s\n' 'Vorlage fuer eine sichere Kopie' >"${room}/arbeitstisch/vorlage.txt"
printf '%s\n' 'Diese alte Abschrift ist unbrauchbar.' >"${room}/arbeitstisch/alte-abschrift.txt"
printf '%s\n' 'Diese Kiste bleibt geschlossen und erhalten.' >"${room}/arbeitstisch/volle-kiste/inhalt.txt"
printf '%s\n' 'Vom Regen unleserlich geworden.' >"${room}/eingestuerzte-ecke/nasse-notiz.txt"
printf '%s\n' 'Morsches Holz und feuchte Pappe.' >"${room}/eingestuerzte-ecke/splitter/rest.txt"

cp -- "${room}/original/erste-spur.txt" "${state_root}/erste-spur.ref"
printf '%s\n' 'Diese Kiste bleibt geschlossen und erhalten.' >"${state_root}/volle-kiste.ref"
printf '%s\n' '2.0.0' >"${state_root}/setup-version"

chown -R "${lab_user}:${lab_user}" "${lab_root}"
chown -R root:root "${room}/original" "${state_root}"
chmod 0750 "${lab_home}"
find "${lab_root}" -type d -exec chmod 0755 {} +
find "${lab_root}" -type f -exec chmod 0644 {} +
chmod 0555 "${room}/original"
chmod 0444 "${room}/original/erste-spur.txt"
chmod 0750 "${state_root}"
chmod 0400 "${state_root}"/*.ref "${state_root}/setup-version"
chown "${lab_user}:${lab_user}" "${lab_home}/.bash_profile" "${lab_home}/.bashrc"
chmod 0644 "${lab_home}/.bash_profile" "${lab_home}/.bashrc"

[[ "$(id -u "${lab_user}")" != 0 ]] || fail "Der Workshop-Benutzer darf nicht Root sein."
[[ "$(hostname)" == "${lab_hostname}" ]] || fail "Der aktive Hostname ist nicht korrekt."
su -s /bin/bash -c "test -r '${room}/original/erste-spur.txt' && test ! -w '${room}/original/erste-spur.txt' && test ! -w '${room}/original'" "${lab_user}" || fail "Das Original ist nicht korrekt geschützt."

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "${lab_user}"
