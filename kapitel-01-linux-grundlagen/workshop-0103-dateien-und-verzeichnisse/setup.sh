#!/usr/bin/env bash
set -Eeuo pipefail

readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly lab_root="${lab_home}/leuchtturm"
readonly lab_hostname="leuchtturm"
readonly archive_dir="${lab_root}/untergeschoss/lagerraum/archiv"
readonly source_file="${archive_dir}/letzter_eintrag.txt"
readonly state_dir="/tmp/workshop-0103"
readonly asset_source="/tmp/workshop-0103-assets/flag-einreichen"
readonly action_target="/usr/local/bin/flag-einreichen"

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

[[ "${lab_root}" == "/home/waerter/leuchtturm" ]] ||
  fail "Unsicherer Workshop-Pfad."
[[ "${state_dir}" == "/tmp/workshop-0103" ]] ||
  fail "Unsicherer Statuspfad."

install -d -m 0755 "${state_dir}"
rm -f -- \
  "${state_dir}/ready" \
  "${state_dir}/source-identity" \
  "${state_dir}/source-hash" \
  "${state_dir}/flag-revealed" \
  "${state_dir}/flag-submitted" \
  "${state_dir}/reveal-notification" \
  "${state_dir}/notification-shown"

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
if [[ "$(hostname)" != "${lab_hostname}" ]]; then
  if command -v hostnamectl >/dev/null 2>&1 &&
    hostnamectl set-hostname "${lab_hostname}" >/dev/null 2>&1; then
    :
  elif command -v hostname >/dev/null 2>&1; then
    hostname "${lab_hostname}"
  else
    fail "Der Hostname konnte nicht gesetzt werden."
  fi
fi

if grep -qE '^[[:space:]]*127\.0\.1\.1[[:space:]]+' /etc/hosts; then
  hosts_tmp="$(mktemp /tmp/workshop-0103-hosts.XXXXXX)"
  awk -v host="${lab_hostname}" \
    '$1 == "127.0.1.1" { print "127.0.1.1 " host; next } { print }' \
    /etc/hosts >"${hosts_tmp}"
  cat "${hosts_tmp}" >"/etc/hosts"
  rm -f "${hosts_tmp}"
else
  printf '127.0.1.1 %s\n' "${lab_hostname}" >>/etc/hosts
fi

cat >"${lab_home}/.bash_profile" <<PROFILE
if [[ -f "\${HOME}/.bashrc" ]]; then
  source "\${HOME}/.bashrc"
fi

cd "${archive_dir}"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE

cat >"${lab_home}/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
bind 'set echo-control-characters off'

workshop_0103_notification() {
  local state_dir="/tmp/workshop-0103"
  local notification="${state_dir}/reveal-notification"
  local shown="${state_dir}/notification-shown"

  if [[ -f "${notification}" && ! -e "${shown}" ]]; then
    cat "${notification}"
    : >"${shown}"
    rm -f -- "${notification}"
  fi
}

PROMPT_COMMAND=workshop_0103_notification
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

cat >"${source_file}" <<'ENTRY'
30. Oktober, 23:40 Uhr

Der Nebel steht ungewöhnlich dicht vor den Fenstern.
Im Kartenraum lassen sich die letzten Zeilen besser lesen.

Die Tinte ist an den Rändern verwischt.
ENTRY

chown -R "${lab_user}:${lab_user}" "${lab_home}"
chmod 0750 "${lab_home}"
find "${lab_root}" -type d -exec chmod 0755 {} +
chmod 0644 "${lab_home}/.bash_profile" "${lab_home}/.bashrc" "${source_file}"

install -d -m 0770 -o "${lab_user}" -g "${lab_user}" "${state_dir}"
stat -c '%d:%i' "${source_file}" >"${state_dir}/source-identity"
sha256sum "${source_file}" | awk '{ print $1 }' >"${state_dir}/source-hash"
chown "${lab_user}:${lab_user}" \
  "${state_dir}/source-identity" \
  "${state_dir}/source-hash"
chmod 0640 "${state_dir}/source-identity" "${state_dir}/source-hash"

[[ -f "${asset_source}" ]] ||
  fail "Der Befehl zur Flag-Abgabe wurde nicht als Asset gefunden."
install -o root -g root -m 0755 "${asset_source}" "${action_target}"

[[ "$(id -un "${lab_user}")" == "${lab_user}" ]] ||
  fail "Der Workshop-Benutzer fehlt."
[[ "$(id -u "${lab_user}")" != "0" ]] ||
  fail "Der Workshop-Benutzer darf nicht Root sein."
[[ "$(hostname)" == "${lab_hostname}" ]] ||
  fail "Der aktive Hostname ist nicht korrekt."
[[ -x "${action_target}" ]] ||
  fail "Der Befehl zur Flag-Abgabe konnte nicht installiert werden."
[[ -f "${source_file}" ]] ||
  fail "Der letzte Eintrag fehlt."

ready_tmp="$(mktemp "${state_dir}/ready.XXXXXX")"
printf '%s\n' "workshop-0103-ready" >"${ready_tmp}"
chown "${lab_user}:${lab_user}" "${ready_tmp}"
chmod 0644 "${ready_tmp}"
mv -f -- "${ready_tmp}" "${state_dir}/ready"

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "${lab_user}"
