#!/usr/bin/env bash
set -Eeuo pipefail

mode="system"
sandbox_root=""

if (($# > 0)); then
  if [[ "$1" == "--sandbox" && $# == 2 ]]; then
    mode="sandbox"
    sandbox_root="$(cd "$2" && pwd -P)"
  else
    echo "Verwendung: reset.sh [--sandbox VERZEICHNIS]" >&2
    exit 2
  fi
fi

if [[ "$mode" == "system" ]]; then
  if [[ "$(id -u)" != "0" ]]; then
    echo "Der Systemreset muss als root ausgeführt werden." >&2
    exit 1
  fi
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="/home/telegrafist/nachtstation"
  pilot_uid="$(id -u telegrafist)"
  pilot_gid="$(id -g telegrafist)"

  /usr/sbin/runuser -u telegrafist -- /usr/bin/env -i \
    HOME=/home/telegrafist \
    USER=telegrafist \
    LOGNAME=telegrafist \
    PATH=/usr/local/bin:/usr/bin:/bin \
    "$install_dir/interne-skripte/dienststeuerung" stop || true
else
  install_dir="$sandbox_root/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="$sandbox_root/home/telegrafist/nachtstation"
  pilot_uid="$(id -u)"
  pilot_gid="$(id -g)"
  export PILOT_TEST_MODE=1
  export PILOT_INSTALL_DIR="$install_dir"
  export PILOT_WORKDIR="$workdir"
  export PILOT_STATE_DIR="$sandbox_root/var/lib/labforge/nachtleitung-killercoda-pilot"
  export PILOT_HOSTS_FILE="$sandbox_root/etc/hosts"
  export PILOT_EXPECTED_UID="$pilot_uid"
  "$install_dir/interne-skripte/dienststeuerung" stop || true
fi

reset_port="8080"
if [[ "$mode" == "sandbox" ]]; then
  reset_port="${PILOT_SANDBOX_INITIAL_PORT:-8080}"
  if [[ "$reset_port" != "8080" && "$reset_port" != "8081" ]]; then
    echo "PILOT_SANDBOX_INITIAL_PORT muss 8080 oder 8081 sein." >&2
    exit 1
  fi
fi

cat >"$workdir/leitung-zwei/xebico.conf" <<EOF
BIND_ADRESSE=0.0.0.0
PORT=$reset_port
HTTP_STATUS=200
MELDUNG_DATEI=meldungen/xebico.txt
EOF

cat >"$workdir/register/xebico.hosts" <<'EOF'
192.0.2.10 xebico
EOF

cat >"$workdir/meldungen/xebico.txt" <<'EOF'
STATUS: NACHTLEITUNG-BEREIT
MELDUNG: XEBICO RUFT NACHTSTATION
DIE LICHTER UNTER DEM NEBEL SIND ERLOSCHEN.
HALTET LEITUNG ZWEI OFFEN.
ANTWORTET NICHT AUF DAS DRITTE SIGNAL.
FLAG{die_nachtleitung_bleibt_offen}
EOF

chown "$pilot_uid:$pilot_gid" \
  "$workdir/leitung-zwei/xebico.conf" \
  "$workdir/register/xebico.hosts" \
  "$workdir/meldungen/xebico.txt"
chmod 0644 \
  "$workdir/leitung-zwei/xebico.conf" \
  "$workdir/register/xebico.hosts" \
  "$workdir/meldungen/xebico.txt"
find "$workdir/status" -maxdepth 1 -type f -name '*.ok' -delete
rm -f "$workdir/status/xebico-dienst.pid"
: >"$workdir/protokolle/xebico-dienst.log"
chown "$pilot_uid:$pilot_gid" "$workdir/protokolle/xebico-dienst.log"

if [[ "$mode" == "system" ]]; then
  /usr/local/sbin/labforge-xebico-hosts-apply
  /usr/sbin/runuser -u telegrafist -- /usr/bin/env -i \
    HOME=/home/telegrafist \
    USER=telegrafist \
    LOGNAME=telegrafist \
    PATH=/usr/local/bin:/usr/bin:/bin \
    "$workdir/werkzeuge/konfiguration-anwenden"
else
  "$workdir/werkzeuge/register-anwenden"
  "$workdir/werkzeuge/konfiguration-anwenden"
fi

echo "Pilot-Ausgangszustand wiederhergestellt."
