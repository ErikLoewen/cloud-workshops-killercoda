#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
mode="system"
sandbox_root=""

if (($# > 0)); then
  if [[ "$1" == "--sandbox" && $# == 2 ]]; then
    mode="sandbox"
    sandbox_root="$(mkdir -p "$2" && cd "$2" && pwd -P)"
  else
    echo "Verwendung: setup.sh [--sandbox VERZEICHNIS]" >&2
    exit 2
  fi
fi

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Benötigtes Werkzeug fehlt: $1" >&2
    exit 1
  }
}

for command_name in bash python3 curl ss pgrep ps getent ip awk sed grep install nohup; do
  require_command "$command_name"
done

if [[ "$mode" == "system" ]]; then
  if [[ "$(id -u)" != "0" ]]; then
    echo "Der Systemmodus muss als root ausgeführt werden." >&2
    exit 1
  fi
  for command_name in useradd runuser sudo visudo hostname; do
    require_command "$command_name"
  done

  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="/home/telegrafist/nachtstation"
  state_dir="/var/lib/labforge/nachtleitung-killercoda-pilot"
  hosts_file="/etc/hosts"
  pilot_user="telegrafist"
else
  install_dir="$sandbox_root/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="$sandbox_root/home/telegrafist/nachtstation"
  state_dir="$sandbox_root/var/lib/labforge/nachtleitung-killercoda-pilot"
  hosts_file="$sandbox_root/etc/hosts"
  pilot_user="$(id -un)"
fi

install -d -m 0755 "$install_dir"
for directory in dienst interne-skripte; do
  install -d -m 0755 "$install_dir/$directory"
  if [[ "$(cd "$script_dir/$directory" && pwd -P)" != "$(cd "$install_dir/$directory" && pwd -P)" ]]; then
    cp -a "$script_dir/$directory/." "$install_dir/$directory/"
  fi
done

find "$install_dir" -type d -exec chmod 0755 {} +
find "$install_dir" -type f -exec chmod 0644 {} +
chmod 0755 \
  "$install_dir/dienst/xebico_dienst.py" \
  "$install_dir/interne-skripte/config_parser.py" \
  "$install_dir/interne-skripte/hosts_tool.py" \
  "$install_dir/interne-skripte/process_guard.py" \
  "$install_dir/interne-skripte/dienststeuerung" \
  "$install_dir/interne-skripte/register-apply-root" \
  "$install_dir/interne-skripte/station_host.py" \
  "$install_dir/interne-skripte/pilot_state.py" \
  "$install_dir/interne-skripte/verify_step.py"

if [[ "$mode" == "system" ]]; then
  if ! id telegrafist >/dev/null 2>&1; then
    useradd --create-home --shell /bin/bash telegrafist
  fi
  pilot_uid="$(id -u telegrafist)"
  pilot_gid="$(id -g telegrafist)"

  install -d -m 0700 -o root -g root "$state_dir"
  if [[ ! -f "$state_dir/original-hostname" ]]; then
    hostname >"$state_dir/original-hostname"
    chmod 0600 "$state_dir/original-hostname"
  fi
  /usr/bin/python3 -I "$install_dir/interne-skripte/station_host.py"
  hostname nachtstation

  install -m 0755 -o root -g root \
    "$install_dir/interne-skripte/register-apply-root" \
    /usr/local/sbin/labforge-xebico-hosts-apply

  sudoers_tmp="$(mktemp)"
  trap 'rm -f "$sudoers_tmp"' EXIT
  printf '%s\n' \
    'telegrafist ALL=(root) NOPASSWD: /usr/local/sbin/labforge-xebico-hosts-apply' \
    >"$sudoers_tmp"
  chmod 0440 "$sudoers_tmp"
  visudo -cf "$sudoers_tmp" >/dev/null
  install -m 0440 -o root -g root \
    "$sudoers_tmp" /etc/sudoers.d/labforge-xebico-hosts
  rm -f "$sudoers_tmp"
  trap - EXIT
else
  pilot_uid="$(id -u)"
  pilot_gid="$(id -g)"
  install -d -m 0700 "$state_dir"
  install -d -m 0755 "$(dirname "$hosts_file")"
  cat >"$hosts_file" <<'EOF'
127.0.0.1 localhost
127.0.1.1 nachtstation
198.51.100.7 fremder-eintrag
EOF
  chmod 0644 "$hosts_file"
fi

install -d -m 0755 -o "$pilot_uid" -g "$pilot_gid" "$workdir"
for directory in leitung-zwei register meldungen protokolle status; do
  install -d -m 0755 -o "$pilot_uid" -g "$pilot_gid" "$workdir/$directory"
done
install -d -m 0755 -o root -g root "$workdir/werkzeuge" 2>/dev/null || \
  install -d -m 0755 "$workdir/werkzeuge"
install -d -m 0755 -o root -g root "$workdir/pilot-werkzeuge" 2>/dev/null || \
  install -d -m 0755 "$workdir/pilot-werkzeuge"

install -m 0644 -o "$pilot_uid" -g "$pilot_gid" \
  "$script_dir/leitung-zwei/xebico.conf" "$workdir/leitung-zwei/xebico.conf"

if [[ "$mode" == "sandbox" ]]; then
  sandbox_initial_port="${PILOT_SANDBOX_INITIAL_PORT:-8080}"
  if [[ "$sandbox_initial_port" != "8080" && "$sandbox_initial_port" != "8081" ]]; then
    echo "PILOT_SANDBOX_INITIAL_PORT muss 8080 oder 8081 sein." >&2
    exit 1
  fi
  sed -i "s/^PORT=.*/PORT=$sandbox_initial_port/"     "$workdir/leitung-zwei/xebico.conf"
fi
install -m 0644 -o "$pilot_uid" -g "$pilot_gid" \
  "$script_dir/register/xebico.hosts" "$workdir/register/xebico.hosts"
install -m 0644 -o "$pilot_uid" -g "$pilot_gid" \
  "$script_dir/meldungen/xebico.txt" "$workdir/meldungen/xebico.txt"
: >"$workdir/protokolle/xebico-dienst.log"
chown "$pilot_uid:$pilot_gid" "$workdir/protokolle/xebico-dienst.log"

for tool in konfiguration-pruefen konfiguration-anwenden register-pruefen register-anwenden; do
  install -m 0755 "$script_dir/werkzeuge/$tool" "$workdir/werkzeuge/$tool"
  if [[ "$mode" == "system" ]]; then
    chown root:root "$workdir/werkzeuge/$tool"
  fi
done

for tool_path in "$script_dir"/pilot-werkzeuge/*; do
  tool="$(basename "$tool_path")"
  install -m 0755 "$tool_path" "$workdir/pilot-werkzeuge/$tool"
  if [[ "$mode" == "system" ]]; then
    chown root:root "$workdir/pilot-werkzeuge/$tool"
  fi
done

default_dev="$(ip -o -4 route show default | awk 'NR==1 {for (i=1; i<=NF; i++) if ($i=="dev") {print $(i+1); exit}}')"
if [[ -z "$default_dev" ]]; then
  echo "Keine eindeutige IPv4-Standardschnittstelle gefunden." >&2
  exit 1
fi
station_ip="$(ip -o -4 addr show dev "$default_dev" scope global | awk 'NR==1 {split($4,a,"/"); print a[1]}')"
if [[ -z "$station_ip" || "$station_ip" == 127.* ]]; then
  echo "Keine geeignete lokale Stationsadresse gefunden." >&2
  exit 1
fi
route_context="$(ip -o -4 route show | awk -v dev="$default_dev" '$0 !~ /^default / && $0 ~ ("dev " dev "([[:space:]]|$)") {print; exit}')"
if [[ -z "$route_context" ]]; then
  route_context="$(ip -o -4 route show default | head -n 1)"
fi
printf '%s\n' "$station_ip" >"$workdir/status/stationsadresse"
printf '%s\n' "$route_context" >"$workdir/status/routenkontext"
chown "$pilot_uid:$pilot_gid" \
  "$workdir/status/stationsadresse" \
  "$workdir/status/routenkontext"
chmod 0644 \
  "$workdir/status/stationsadresse" \
  "$workdir/status/routenkontext"

if [[ "$mode" == "system" ]]; then
  /usr/local/sbin/labforge-xebico-hosts-apply
  /usr/sbin/runuser -u telegrafist -- /usr/bin/env -i \
    HOME=/home/telegrafist \
    USER=telegrafist \
    LOGNAME=telegrafist \
    PATH=/usr/local/bin:/usr/bin:/bin \
    "$workdir/werkzeuge/konfiguration-anwenden"
else
  export PILOT_TEST_MODE=1
  export PILOT_INSTALL_DIR="$install_dir"
  export PILOT_WORKDIR="$workdir"
  export PILOT_STATE_DIR="$state_dir"
  export PILOT_HOSTS_FILE="$hosts_file"
  export PILOT_EXPECTED_UID="$pilot_uid"
  "$workdir/werkzeuge/register-anwenden"
  "$workdir/werkzeuge/konfiguration-anwenden"
fi

echo
echo "Technischer Pilot eingerichtet."
echo "Arbeitsverzeichnis: $workdir"
echo "Installationspfad:  $install_dir"
echo "Hosts-Datei:        $hosts_file"
if [[ "$mode" == "sandbox" ]]; then
  echo "Modus:              isolierte Sandbox"
else
  echo "Benutzer:           telegrafist"
  echo "Hostname:           nachtstation"
fi
