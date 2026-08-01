#!/usr/bin/env bash
set -Eeuo pipefail
readonly lab_user="waerter"
readonly lab_home="/home/${lab_user}"
readonly panel="${lab_home}/leuchtturm/flur/schalttafel"
readonly state="/var/lib/labforge/workshop-0105"
readonly asset="/tmp/workshop-0105-assets/flag-einreichen"
fail() { printf 'Setup-Fehler: %s\n' "$1" >&2; exit 1; }
for account in waerter nachtwache mrs_ah; do
  getent group "${account}" >/dev/null 2>&1 || groupadd "${account}"
  if ! id "${account}" >/dev/null 2>&1; then
    useradd --create-home --shell /bin/bash --gid "${account}" "${account}"
  fi
  usermod --shell /bin/bash --gid "${account}" "${account}"
done
printf '%s\n' 'nachtwache:sturmlicht' 'mrs_ah:tabitha' | chpasswd
printf '%s\n' 'leuchtturm' >/etc/hostname
hostname leuchtturm 2>/dev/null || true
rm -rf -- "${lab_home}/leuchtturm" "${state}"
install -d -m 0755 -o waerter -g waerter "${panel}"
install -d -m 0733 -o root -g root "${state}"
cat >"${panel}/signaltest" <<'SCRIPT'
#!/usr/bin/env bash
set -Eeuo pipefail
printf '%s\n' 'Signalprüfung erfolgreich: Die Schalttafel reagiert.'
printf '%s\n' 'signaltest-ausgefuehrt' >"/var/lib/labforge/workshop-0105/signaltest.marker"
SCRIPT
cat >"${panel}/uebergabe-chat.log" <<'LOG'
Nachtwache: Das Übergabekennwort bleibt vorerst sturmlicht.
Waerter: Zugangsdaten gehören nicht in diesen Chat. Entferne die Nachricht.
LOG
cat >"/home/nachtwache/hinweis-fuer-mrs-ah.log" <<'LOG'
Mrs. A. H., Tabitha, du kannst deinen Vornamen nicht als Passwort benutzen.
Bitte ändere das endlich.
LOG
cat >"/home/mrs_ah/letzte-nachricht" <<'SCRIPT'
#!/usr/bin/env bash
set -Eeuo pipefail
printf '%s\n' 'Die Schalttafel entriegelt die nächste Spur:'
printf '%s\n' 'FLAG{mrs_a_h_war_nie_ihr_name}'
printf '%s\n' 'letzte-nachricht-ausgefuehrt' >"/var/lib/labforge/workshop-0105/letzte-nachricht.marker"
SCRIPT
chown waerter:waerter "${panel}/signaltest"
chown nachtwache:nachtwache "${panel}/uebergabe-chat.log" "/home/nachtwache/hinweis-fuer-mrs-ah.log"
chown mrs_ah:mrs_ah "/home/mrs_ah/letzte-nachricht"
chmod 0644 "${panel}/signaltest" "${panel}/uebergabe-chat.log" \
  "/home/nachtwache/hinweis-fuer-mrs-ah.log" "/home/mrs_ah/letzte-nachricht"
chmod 0755 "${lab_home}/leuchtturm" "${lab_home}/leuchtturm/flur" "${panel}"
chmod 0755 "${lab_home}"
chmod 0750 "/home/nachtwache" "/home/mrs_ah"
rm -f -- "/home/mrs_ah/.flag-submitted"
[[ -f "${asset}" && ! -L "${asset}" ]] || fail "flag-einreichen fehlt."
install -m 0755 -o root -g root "${asset}" /usr/local/bin/flag-einreichen
cat >"${lab_home}/.bash_profile" <<PROFILE
if [[ -f "\${HOME}/.bashrc" ]]; then source "\${HOME}/.bashrc"; fi
cd "${panel}"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE
cat >"${lab_home}/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
BASHRC
for account in nachtwache mrs_ah; do
  cat >"/home/${account}/.bash_profile" <<'PROFILE'
if [[ -f "${HOME}/.bashrc" ]]; then source "${HOME}/.bashrc"; fi
cd "${HOME}"
PROFILE
  cat >"/home/${account}/.bashrc" <<'BASHRC'
PS1='\u@\h:\w\$ '
BASHRC
done
chown waerter:waerter "${lab_home}/.bash_profile" "${lab_home}/.bashrc"
chown nachtwache:nachtwache /home/nachtwache/.bash_profile /home/nachtwache/.bashrc
chown mrs_ah:mrs_ah /home/mrs_ah/.bash_profile /home/mrs_ah/.bashrc
[[ "$(stat -c '%U:%G:%a' "${panel}/signaltest")" == "waerter:waerter:644" ]] ||
  fail "signaltest besitzt einen falschen Ausgangszustand."
[[ "$(stat -c '%U:%G:%a' "/home/mrs_ah/letzte-nachricht")" == "mrs_ah:mrs_ah:644" ]] ||
  fail "letzte-nachricht besitzt einen falschen Ausgangszustand."
clear 2>/dev/null || printf '\033[2J\033[H'
exec su - "${lab_user}"
