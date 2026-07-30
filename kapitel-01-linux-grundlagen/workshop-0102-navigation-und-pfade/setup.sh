#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lab_root="${lab_home}/leuchtturm"
readonly lab_hostname="leuchtturm"
readonly marker_dir="/tmp/navigation-im-nebel"
readonly marker="${marker_dir}/erfolgreich"
readonly asset_source="/tmp/navigation-im-nebel-assets/eintrag-bestaetigen"
readonly action_target="/usr/local/bin/eintrag-bestaetigen"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

[[ "${lab_root}" == "/home/waerter/leuchtturm" ]] ||
  fail "Unsicherer Workshop-Pfad."
[[ "${marker_dir}" == "/tmp/navigation-im-nebel" ]] ||
  fail "Unsicherer Markerpfad."

if ! getent group "${lab_user}" >/dev/null 2>&1; then
  groupadd "${lab_user}"
fi

if ! id "${lab_user}" >/dev/null 2>&1; then
  useradd \
    --create-home \
    --home-dir "${lab_home}" \
    --shell /bin/bash \
    --gid "${lab_user}" \
    "${lab_user}"
fi

usermod \
  --home "${lab_home}" \
  --shell /bin/bash \
  --gid "${lab_user}" \
  "${lab_user}"
install -d -m 0750 -o "${lab_user}" -g "${lab_user}" "${lab_home}"

printf '%s\n' "${lab_hostname}" >"/etc/hostname"
if command -v hostnamectl >/dev/null 2>&1 &&
  hostnamectl set-hostname "${lab_hostname}" >/dev/null 2>&1; then
  :
elif command -v hostname >/dev/null 2>&1; then
  hostname "${lab_hostname}"
else
  fail "Der Hostname konnte nicht gesetzt werden."
fi

if grep -qE '^[[:space:]]*127\.0\.1\.1[[:space:]]+' /etc/hosts; then
  hosts_tmp="$(mktemp /tmp/navigation-im-nebel-hosts.XXXXXX)"
  awk -v host="${lab_hostname}" \
    '$1 == "127.0.1.1" { print "127.0.1.1 " host; next } { print }' \
    /etc/hosts >"${hosts_tmp}"
  cat "${hosts_tmp}" >"/etc/hosts"
  rm -f "${hosts_tmp}"
else
  printf '127.0.1.1 %s\n' "${lab_hostname}" >>/etc/hosts
fi

cat >"${lab_home}/.bash_profile" <<'PROFILE'
if [[ -f "${HOME}/.bashrc" ]]; then
  source "${HOME}/.bashrc"
fi

clear 2>/dev/null || printf '\033[2J\033[H'
PROFILE

cat >"${lab_home}/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
BASHRC

rm -rf -- "${lab_root}"
mkdir -p -- \
  "${lab_root}/eingang" \
  "${lab_root}/obergeschoss/kartenraum" \
  "${lab_root}/obergeschoss/funkraum" \
  "${lab_root}/untergeschoss/lagerraum/archiv" \
  "${lab_root}/untergeschoss/vorratsraum" \
  "${lab_root}/technik/kontrollraum" \
  "${lab_root}/technik/maschinenraum"

cat >"${lab_root}/untergeschoss/lagerraum/archiv/letzter_eintrag.txt" <<'ENTRY'
Der Sturm kam schneller als erwartet.
Im Funkraum stimmt etwas nicht.
ENTRY

chown -R "${lab_user}:${lab_user}" "${lab_home}"
chmod 0750 "${lab_home}"
find "${lab_root}" -type d -exec chmod 0755 {} +
chmod 0644 \
  "${lab_home}/.bash_profile" \
  "${lab_home}/.bashrc" \
  "${lab_root}/untergeschoss/lagerraum/archiv/letzter_eintrag.txt"

install -d -m 0770 -o "${lab_user}" -g "${lab_user}" "${marker_dir}"
rm -f -- "${marker}"
[[ -f "${asset_source}" ]] ||
  fail "Die bereitgestellte Prüfaktion wurde nicht als Asset gefunden."
install -o root -g root -m 0755 "${asset_source}" "${action_target}"

[[ "$(id -un "${lab_user}")" == "${lab_user}" ]] ||
  fail "Der Workshop-Benutzer fehlt."
[[ "$(id -u "${lab_user}")" != "0" ]] ||
  fail "Der Workshop-Benutzer darf nicht Root sein."
[[ "$(getent passwd "${lab_user}" | cut -d: -f6)" == "${lab_home}" ]] ||
  fail "Das Home-Verzeichnis ist nicht korrekt."
[[ "$(getent passwd "${lab_user}" | cut -d: -f7)" == "/bin/bash" ]] ||
  fail "Bash ist nicht als Login-Shell gesetzt."
[[ "$(hostname)" == "${lab_hostname}" ]] ||
  fail "Der aktive Hostname ist nicht korrekt."
[[ -x "${action_target}" ]] ||
  fail "Die Prüfaktion konnte nicht installiert werden."
[[ -r "${lab_root}/untergeschoss/lagerraum/archiv/letzter_eintrag.txt" ]] ||
  fail "Der letzte Eintrag fehlt."

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "${lab_user}"
