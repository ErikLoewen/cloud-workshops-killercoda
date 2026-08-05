#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
sandbox="$(mktemp -d)"
runtime_root="$sandbox/source"
tests=0
failures=0
skipped=0
foreign_pid=""

port_is_busy() {
  local port="$1"
  ss -ltn "sport = :$port" 2>/dev/null | tail -n +2 | grep -q .
}

if port_is_busy 8080; then
  if port_is_busy 8081; then
    echo "Weder Port 8080 noch Port 8081 ist für den sicheren Sandbox-Test frei." >&2
    exit 1
  fi
  runtime_port="8081"
  exact_8080_available=0
else
  runtime_port="8080"
  exact_8080_available=1
fi

export PILOT_SANDBOX_INITIAL_PORT="$runtime_port"

export PILOT_TEST_MODE=1
system_root="$sandbox/system"
export PILOT_INSTALL_DIR="$system_root/opt/labforge/kapitel-02-killercoda-pilot"
export PILOT_WORKDIR="$system_root/home/telegrafist/nachtstation"
export PILOT_STATE_DIR="$system_root/var/lib/labforge/nachtleitung-killercoda-pilot"
export PILOT_HOSTS_FILE="$system_root/etc/hosts"
export PILOT_EXPECTED_UID="$(id -u)"

cleanup() {
  if [[ -n "$foreign_pid" ]] && kill -0 "$foreign_pid" 2>/dev/null; then
    kill -TERM "$foreign_pid" 2>/dev/null || true
    wait "$foreign_pid" 2>/dev/null || true
  fi
  if [[ -x "$PILOT_INSTALL_DIR/interne-skripte/dienststeuerung" ]]; then
    "$PILOT_INSTALL_DIR/interne-skripte/dienststeuerung" stop >/dev/null 2>&1 || true
  fi
  rm -rf "$sandbox"
}
trap cleanup EXIT

pass() {
  tests=$((tests + 1))
  echo "OK: $*"
}

fail() {
  tests=$((tests + 1))
  failures=$((failures + 1))
  echo "FEHLER: $*" >&2
}

skip() {
  skipped=$((skipped + 1))
  echo "ÜBERSPRUNGEN: $*"
}

expect_success() {
  local description="$1"
  shift
  if "$@" >/tmp/labforge-test.out 2>/tmp/labforge-test.err; then
    pass "$description"
  else
    fail "$description"
    cat /tmp/labforge-test.out >&2 || true
    cat /tmp/labforge-test.err >&2 || true
  fi
}

expect_failure() {
  local description="$1"
  shift
  if "$@" >/tmp/labforge-test.out 2>/tmp/labforge-test.err; then
    fail "$description (unerwarteter Erfolg)"
  else
    pass "$description"
  fi
}

write_config() {
  cat >"$PILOT_WORKDIR/leitung-zwei/xebico.conf"
}

curl_headers() {
  curl --noproxy '*' --connect-timeout 1 --max-time 3 -sS -i "$1"
}

"$root/validate-package.sh"
pass "Killercoda-Assetindex und statische Paketvalidierung"

export PILOT_RUNTIME_ARCHIVE="$root/assets/kapitel-02-killercoda-runtime.tar.gz"
"$root/assets/killercoda-entry.sh" --sandbox "$sandbox" >/tmp/labforge-setup.out
pass "Asset-Entry entpackt und installiert die Runtime"

expect_success "wiederholtes isoliertes Setup ohne Doppelinstanz" \
  "$runtime_root/setup.sh" --sandbox "$system_root"

expect_success "interaktive Textdemo Name" \
  "$PILOT_WORKDIR/pilot-werkzeuge/textdemo-name"
expect_success "interaktive Textdemo Dienst" \
  "$PILOT_WORKDIR/pilot-werkzeuge/textdemo-dienst"
expect_success "interaktive Textdemo Bindung" \
  "$PILOT_WORKDIR/pilot-werkzeuge/textdemo-bindung"
expect_success "interaktive Textdemo HTTP" \
  "$PILOT_WORKDIR/pilot-werkzeuge/textdemo-http"

response="$(curl_headers "http://127.0.0.1:${runtime_port}/architektur")"
if grep -q '^HTTP/1.1 200' <<<"$response" &&
   grep -qi '^Content-Type: text/html' <<<"$response" &&
   grep -q 'Interaktive Netzwerkarchitektur' <<<"$response" &&
   grep -q 'JavaScript aktiv' <<<"$response" &&
   grep -q 'Nächste Diagnoseebene' <<<"$response"; then
  pass "HTML/CSS/JS-Web-App unter /architektur"
else
  fail "HTML/CSS/JS-Web-App unvollständig"
fi

expect_success "Verify-Logik für Textdemos und Web-App" \
  /usr/bin/python3 -I "$PILOT_INSTALL_DIR/interne-skripte/verify_step.py" 1

config_tool="$PILOT_WORKDIR/werkzeuge/konfiguration-pruefen"
apply_tool="$PILOT_WORKDIR/werkzeuge/konfiguration-anwenden"
register_check="$PILOT_WORKDIR/werkzeuge/register-pruefen"
register_apply="$PILOT_WORKDIR/werkzeuge/register-anwenden"
service_ctl="$PILOT_INSTALL_DIR/interne-skripte/dienststeuerung"
config="$PILOT_WORKDIR/leitung-zwei/xebico.conf"
staging="$PILOT_WORKDIR/register/xebico.hosts"

expect_success "gültige Konfiguration" "$config_tool"

mv "$config" "$config.missing"
expect_failure "fehlende Konfigurationsdatei" "$config_tool"
mv "$config.missing" "$config"

cp "$config" "$config.valid"
sed '/HTTP_STATUS=/d' "$config.valid" >"$config"
expect_failure "fehlender Schlüssel" "$config_tool"

cat "$config.valid" >"$config"
printf '%s\n' 'PORT=8080' >>"$config"
expect_failure "doppelter Schlüssel" "$config_tool"

cat "$config.valid" >"$config"
printf '%s\n' 'UNBEKANNT=wert' >>"$config"
expect_failure "unbekannter Schlüssel" "$config_tool"

sed -E 's/^PORT=.*/PORT=9999/' "$config.valid" >"$config"
expect_failure "ungültiger Port" "$config_tool"

sed 's/BIND_ADRESSE=/BIND_ADRESSE =/' "$config.valid" >"$config"
expect_failure "Leerzeichenfehler" "$config_tool"

sed 's/HTTP_STATUS=200/HTTP_STATUS=200;id/' "$config.valid" >"$config"
expect_failure "Injection mit Semikolon" "$config_tool"

sed 's#MELDUNG_DATEI=.*#MELDUNG_DATEI=$(id)#' "$config.valid" >"$config"
expect_failure "Befehlsersetzung in Konfiguration" "$config_tool"

mv "$config.valid" "$config"
expect_success "Konfiguration nach Parserfällen wieder gültig" "$config_tool"

pid="$(cat "$PILOT_WORKDIR/status/xebico-dienst.pid")"
if [[ "$(<"/proc/$pid/comm")" == "xebico-dienst" ]]; then
  pass "/proc/PID/comm zeigt xebico-dienst"
else
  fail "/proc/PID/comm zeigt nicht xebico-dienst"
fi

if ps -o comm= -p "$pid" | grep -qx 'xebico-dienst'; then
  pass "ps zeigt xebico-dienst"
else
  fail "ps zeigt nicht xebico-dienst"
fi

if pgrep -x xebico-dienst | grep -qx "$pid"; then
  pass "pgrep findet die genaue Instanz"
else
  fail "pgrep findet die genaue Instanz nicht"
fi

if ss -ltnp 2>/dev/null | grep -q 'xebico-dienst'; then
  pass "ss -ltnp zeigt den Prozessnamen"
else
  fail "ss -ltnp zeigt den Prozessnamen nicht"
fi

response="$(curl_headers "http://127.0.0.1:${runtime_port}/meldung")"
if grep -q '^HTTP/1.1 200' <<<"$response" &&
   grep -qi '^X-Xebico-Status: EMPFANGEN' <<<"$response" &&
   grep -q 'STATUS: NACHTLEITUNG-BEREIT' <<<"$response"; then
  pass "HTTP 200, Erfolgsheader und Body"
else
  fail "HTTP-200-Antwort unvollständig"
fi

log_file="$PILOT_WORKDIR/protokolle/xebico-dienst.log"
log_size_before="$(stat -c '%s' "$log_file")"
for _ in {1..25}; do
  curl --noproxy '*' --connect-timeout 1 --max-time 3 -fsS     "http://127.0.0.1:${runtime_port}/meldung" >/dev/null
done
log_size_after="$(stat -c '%s' "$log_file")"
if [[ "$log_size_before" == "$log_size_after" ]]; then
  pass "HTTP-Anfragen erzeugen kein unkontrolliertes Logwachstum"
else
  fail "Dienstlog ist durch reine Anfragen gewachsen"
fi

sleep 30 &
foreign_pid=$!
printf '%s\n' "$foreign_pid" >"$PILOT_WORKDIR/status/xebico-dienst.pid"
expect_success "veraltete PID-Datei wird nicht als Prozessidentität vertraut" "$apply_tool"
if kill -0 "$foreign_pid" 2>/dev/null; then
  pass "fremder Prozess aus PID-Datei wurde nicht beendet"
else
  fail "fremder Prozess aus PID-Datei wurde beendet"
fi
kill -TERM "$foreign_pid"
wait "$foreign_pid" 2>/dev/null || true
foreign_pid=""

expect_success "Doppelstartschutz durch wiederholtes Anwenden" "$apply_tool"
managed_count="$("$service_ctl" status 2>/dev/null | sed -n '/Verwaltete PID:/{n;p;}' | wc -l | tr -d ' ')"
if [[ "$managed_count" == "1" ]]; then
  pass "genau eine Dienstinstanz nach wiederholtem Anwenden"
else
  fail "Instanzzahl nach wiederholtem Anwenden: $managed_count"
fi

if ((exact_8080_available == 1)); then
  cat >"$config" <<'EOF'
BIND_ADRESSE=127.0.0.1
PORT=8080
HTTP_STATUS=200
MELDUNG_DATEI=meldungen/xebico.txt
EOF
  expect_success "Dienst auf Sollport 8080 anwenden" "$apply_tool"
  if curl_headers http://127.0.0.1:8080/meldung | grep -q '^HTTP/1.1 200'; then
    pass "HTTP 200 auf Port 8080"
  else
    fail "Port 8080 antwortet nicht wie erwartet"
  fi
else
  skip "Laufzeittest auf Port 8080: Port ist durch einen fremden Plattformprozess belegt"
fi

cat >"$config" <<'EOF'
BIND_ADRESSE=127.0.0.1
PORT=8081
HTTP_STATUS=200
MELDUNG_DATEI=meldungen/xebico.txt
EOF
expect_success "Dienst auf Kontrollport 8081 anwenden" "$apply_tool"
if curl_headers http://127.0.0.1:8081/meldung | grep -q '^HTTP/1.1 200'; then
  pass "HTTP 200 auf Port 8081"
else
  fail "Port 8081 antwortet nicht wie erwartet"
fi

cat >"$config" <<EOF
BIND_ADRESSE=0.0.0.0
PORT=$runtime_port
HTTP_STATUS=200
MELDUNG_DATEI=meldungen/xebico.txt
EOF
expect_success "Wildcard-Bindung anwenden" "$apply_tool"
if ss -ltnp 2>/dev/null | grep 'xebico-dienst' | grep -Eq "0\\.0\\.0\\.0:${runtime_port}|\\*:${runtime_port}"; then
  pass "ss zeigt Wildcard-Bindung auf $runtime_port"
else
  fail "ss zeigt keine Wildcard-Bindung auf $runtime_port"
fi

primary_ip="$(ip -o -4 addr show scope global | awk 'NR==1 {split($4,a,"/"); print a[1]}')"
if [[ -n "$primary_ip" ]]; then
  if curl --noproxy '*' --connect-timeout 1 --max-time 3 -fsS \
    "http://$primary_ip:${runtime_port}/healthz" | grep -qx 'bereit'; then
    pass "Wildcard-Bindung ist über die lokale Stationsadresse erreichbar"
  else
    fail "Wildcard-Bindung ist nicht über $primary_ip erreichbar"
  fi
else
  pass "kein globaler IPv4-Testpfad vorhanden; ss-Bindungsnachweis wurde ausgeführt"
fi

for status in 404 500; do
  cat >"$config" <<EOF
BIND_ADRESSE=127.0.0.1
PORT=$runtime_port
HTTP_STATUS=$status
MELDUNG_DATEI=meldungen/xebico.txt
EOF
  expect_success "HTTP-Status $status anwenden" "$apply_tool"
  response="$(curl_headers "http://127.0.0.1:${runtime_port}/meldung")"
  if grep -q "^HTTP/1.1 $status" <<<"$response"; then
    pass "kontrollierte HTTP-Antwort $status"
  else
    fail "HTTP-Antwort $status fehlt"
  fi
done

cp "$staging" "$staging.valid"
printf '%s\n' '999.1.1.1 xebico' >"$staging"
expect_failure "ungültige Register-IP" "$register_check"

printf '%s\n' '127.0.0.1 xebico alias' >"$staging"
expect_failure "zusätzlicher Registername" "$register_check"

printf '%s\n%s\n' '127.0.0.1 xebico' '127.0.0.2 xebico' >"$staging"
expect_failure "zusätzliche Registerzeile" "$register_check"

printf '%s\n' '127.0.0.1 xebico;id' >"$staging"
expect_failure "Injectionversuch im Register" "$register_check"

printf '%s\n' '127.0.0.1 xebico' >"$staging"
expect_success "gültige Registerdatei" "$register_check"
expect_success "Hosts-Block anwenden" "$register_apply"
hosts_before="$(cat "$PILOT_HOSTS_FILE")"
expect_success "Hosts-Block idempotent erneut anwenden" "$register_apply"
hosts_after="$(cat "$PILOT_HOSTS_FILE")"
if [[ "$hosts_before" == "$hosts_after" ]] &&
   [[ "$(grep -c '^# BEGIN LABFORGE XEBICO$' "$PILOT_HOSTS_FILE")" == "1" ]] &&
   grep -q '^198.51.100.7 fremder-eintrag$' "$PILOT_HOSTS_FILE"; then
  pass "Hosts-Block idempotent; fremder Eintrag unverändert"
else
  fail "Hosts-Block-Idempotenz oder Erhalt fremder Einträge fehlgeschlagen"
fi

mv "$staging.valid" "$staging"
expect_success "Reset in Sandbox" "$runtime_root/reset.sh" --sandbox "$system_root"
expect_success "wiederholter Reset bleibt idempotent" "$runtime_root/reset.sh" --sandbox "$system_root"

if grep -q '^192.0.2.10 xebico$' "$PILOT_HOSTS_FILE" &&
   ss -ltnp 2>/dev/null | grep 'xebico-dienst' | grep -q "127.0.0.1:${runtime_port}"; then
  pass "Reset stellt Hosts-Ausgangsblock und Loopback-Listener auf $runtime_port her"
else
  fail "Reset-Ausgangszustand stimmt nicht"
fi

if ((failures > 0)); then
  echo
  echo "$failures von $tests lokalen Prüfungen fehlgeschlagen." >&2
  exit 1
fi

echo
echo "Alle $tests ausgeführten lokalen Prüfungen erfolgreich."
if ((skipped > 0)); then
  echo "$skipped Laufzeitprüfung(en) wurden wegen belegter fremder Ports transparent übersprungen."
fi
