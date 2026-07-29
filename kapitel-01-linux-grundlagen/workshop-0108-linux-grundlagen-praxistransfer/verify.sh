#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C
export LANG=C

readonly LAB_ROOT='/root/abschlusslabor'
readonly STATE_ROOT='/var/lib/labforge/linux-grundlagen-praxistransfer'
readonly REF_ROOT="$STATE_ROOT/referenz"
readonly TEMPLATE="$LAB_ROOT/vorlage/startseite.txt"
readonly INDEX_FILE="$LAB_ROOT/web/index.html"
readonly CHECK_FILE="$LAB_ROOT/pruefung/systemcheck"
readonly MARKER="$STATE_ROOT/systemcheck-ausgefuehrt.marker"
readonly STATUS_FILE="$LAB_ROOT/dokumentation/status.txt"
readonly PROTECT_ROOT="$LAB_ROOT/schutzbereich"
readonly IMPORTANT_FILE="$PROTECT_ROOT/wichtig.txt"

user_error() {
  printf '%s\n' "Beobachtet: $1"
  printf '%s\n' "Erwartet: $2"
  printf '%s\n' "Nächster Prüfschritt: $3"
  exit 1
}

technical_error() {
  printf '%s\n' "TECHNISCHER SZENARIOFEHLER"
  printf '%s\n' "Beobachtet: $1"
  printf '%s\n' "Erwartet: $2"
  printf '%s\n' "Nächster Schritt: $3"
  exit 2
}

read_reference() {
  local path="$1"
  [[ -f "$path" && ! -L "$path" ]] || technical_error "Die Referenz '$path' fehlt oder besitzt einen unzulässigen Typ." 'Vollständige, reguläre technische Referenzdatei.' 'Szenario neu starten und bei erneutem Auftreten den Workshop melden.'
  local value
  IFS= read -r value < "$path" || true
  [[ -n "$value" ]] || technical_error "Die Referenz '$path' ist leer." 'Ein gespeicherter technischer Referenzwert.' 'Szenario neu starten und bei erneutem Auftreten den Workshop melden.'
  printf '%s\n' "$value"
}

primary_interface() {
  local line
  local -a fields=()
  local -a interfaces=()
  local iface
  local found_dev
  local i

  if ! command -v ip >/dev/null 2>&1; then
    return 10
  fi

  while IFS= read -r line; do
    read -r -a fields <<< "$line"
    [[ "${fields[0]:-}" == "default" ]] || continue

    iface=""
    found_dev=0
    for ((i = 0; i < ${#fields[@]}; i++)); do
      if [[ "${fields[$i]}" == "dev" ]]; then
        if (( found_dev != 0 )) || (( i + 1 >= ${#fields[@]} )); then
          return 11
        fi
        iface="${fields[$((i + 1))]}"
        found_dev=1
      fi
    done

    [[ -n "$iface" ]] || return 12
    interfaces+=("$iface")
  done < <(ip route)

  (( ${#interfaces[@]} == 1 )) || return 13
  [[ "${interfaces[0]}" != "lo" ]] || return 14

  printf '%s\n' "${interfaces[0]}"
}

resolve_primary_interface() {
  local iface
  if iface="$(primary_interface)"; then
    :
  else
    local rc="$?"
    case "$rc" in
      10) technical_error 'Der Befehl ip ist nicht verfügbar.' 'Die lokale Netzwerkinformation muss technisch lesbar sein.' 'Szenario neu starten und den Workshop melden.' ;;
      11|12) technical_error 'Die Standardroute enthält keinen eindeutig auswertbaren Eintrag hinter dev.' 'Genau eine verwendbare Standardroute mit eindeutigem Schnittstellennamen.' 'Szenario neu starten und den Workshop melden.' ;;
      13) technical_error 'Es ist nicht genau eine verwendbare Standardroute vorhanden.' 'Genau eine verwendbare Standardroute wie in Workshop 8.' 'Szenario neu starten und den Workshop melden.' ;;
      14) technical_error 'Die Standardroute verweist auf die Loopback-Schnittstelle.' 'Eine eindeutige Nicht-Loopback-Schnittstelle.' 'Szenario neu starten und den Workshop melden.' ;;
      *) technical_error 'Die primäre Schnittstelle konnte nicht bestimmt werden.' 'Dieselbe eindeutige Auswahlregel wie in Workshop 8.' 'Szenario neu starten und den Workshop melden.' ;;
    esac
  fi
  printf '%s\n' "$iface"
}

for ref_name in \
  startseite.sha256 \
  systemcheck.sha256 \
  systemcheck.uid \
  systemcheck.gid \
  systemcheck.modus \
  wichtig.sha256 \
  wichtig.uid \
  wichtig.gid \
  wichtig.modus \
  schutzbereich.manifest
do
  [[ -f "$REF_ROOT/$ref_name" && ! -L "$REF_ROOT/$ref_name" ]] || technical_error "Die technische Referenz '$ref_name' fehlt oder ist kein regulärer Referenzwert." 'Vollständige technische Referenzen.' 'Szenario neu starten und bei erneutem Auftreten den Workshop melden.'
done

[[ -d "$STATE_ROOT" && ! -L "$STATE_ROOT" ]] || technical_error 'Der technische Zustandsstamm fehlt oder ist ein symbolischer Link.' 'Ein echtes technisches Zustandsverzeichnis.' 'Szenario neu starten und den Workshop melden.'
[[ -d "$LAB_ROOT" && ! -L "$LAB_ROOT" ]] || user_error 'Der Teilnehmerstamm fehlt oder ist kein echtes Verzeichnis.' 'Das vorbereitete Verzeichnis /root/abschlusslabor.' 'Prüfe den absoluten Laborpfad. Bei einer versehentlichen Entfernung starte das Szenario neu.'

expected_template_hash="$(read_reference "$REF_ROOT/startseite.sha256")"
[[ -f "$TEMPLATE" ]] || user_error 'Die Vorlagendatei fehlt oder ist kein regulärer Dateityp.' 'Eine unveränderte reguläre Vorlagendatei.' 'Prüfe den Quellenbereich. Bei einer Entfernung starte das Szenario neu.'
[[ ! -L "$TEMPLATE" ]] || user_error 'Die Vorlagendatei ist ein symbolischer Link.' 'Eine echte reguläre Vorlagendatei.' 'Der Quellenbereich darf nicht ersetzt werden. Starte das Szenario neu.'
actual_template_hash="$(sha256sum "$TEMPLATE" | awk '{print $1}')"
[[ "$actual_template_hash" == "$expected_template_hash" ]] || user_error 'Der Inhalt der Vorlagendatei wurde verändert.' 'Den unveränderten Ausgangsinhalt der Vorlage.' 'Vergleiche die Rolle des Quellenbereichs. Starte das Szenario neu, wenn die Quelle verändert wurde.'

[[ -e "$INDEX_FILE" ]] || user_error 'web/index.html fehlt.' 'Eine eigenständige Webkopie der Vorlage.' 'Prüfe Quelle und Ziel deiner Kopierhandlung.'
[[ -f "$INDEX_FILE" ]] || user_error 'web/index.html ist keine reguläre Datei.' 'Eine eigenständige reguläre Datei.' 'Prüfe den Objekttyp im Webverzeichnis.'
[[ ! -L "$INDEX_FILE" ]] || user_error 'web/index.html ist ein symbolischer Link.' 'Eine eigenständige Kopie und keinen Link.' 'Erstelle im Webverzeichnis eine echte Datei mit dem Inhalt der Vorlage.'
cmp -s "$TEMPLATE" "$INDEX_FILE" || user_error 'Der Inhalt von web/index.html stimmt nicht bytegenau mit der Vorlage überein.' 'Den unveränderten Inhalt der Vorlage.' 'Kontrolliere beide Dateien mit cat und vergleiche Quelle und Ziel.'
template_identity="$(stat -c '%d:%i' "$TEMPLATE")"
index_identity="$(stat -c '%d:%i' "$INDEX_FILE")"
[[ "$template_identity" != "$index_identity" ]] || user_error 'Vorlage und index.html besitzen dieselbe Geräte- und Inodekombination.' 'Zwei eigenständige Dateien, nicht denselben Hardlink.' 'Erstelle eine eigenständige Webkopie.'

for obsolete in "$LAB_ROOT/web/alt.txt" "$LAB_ROOT/web/leeres-archiv" "$LAB_ROOT/web/temp-build"; do
  [[ ! -e "$obsolete" && ! -L "$obsolete" ]] || user_error "Das freigegebene Altobjekt '$obsolete' ist noch vorhanden." 'Das vollständige Entfernen genau dieses Altobjekts.' 'Prüfe zuerst Standort und Objekttyp und wähle dann die dazu passende bekannte Löschhandlung.'
done

[[ -e "$CHECK_FILE" ]] || user_error 'Die vorbereitete Prüfdatei fehlt.' 'Die unveränderte Datei pruefung/systemcheck.' 'Prüfe den Arbeitsbereich. Bei einer Entfernung starte das Szenario neu.'
[[ -f "$CHECK_FILE" ]] || user_error 'pruefung/systemcheck ist keine reguläre Datei.' 'Die vorbereitete reguläre Prüfdatei.' 'Prüfe den Objekttyp. Bei einer Ersetzung starte das Szenario neu.'
[[ ! -L "$CHECK_FILE" ]] || user_error 'pruefung/systemcheck ist ein symbolischer Link.' 'Die echte vorbereitete Prüfdatei.' 'Bei einer Ersetzung starte das Szenario neu.'

expected_check_hash="$(read_reference "$REF_ROOT/systemcheck.sha256")"
expected_check_uid="$(read_reference "$REF_ROOT/systemcheck.uid")"
expected_check_gid="$(read_reference "$REF_ROOT/systemcheck.gid")"
actual_check_hash="$(sha256sum "$CHECK_FILE" | awk '{print $1}')"
actual_check_uid="$(stat -c '%u' "$CHECK_FILE")"
actual_check_gid="$(stat -c '%g' "$CHECK_FILE")"
actual_check_mode="$(stat -c '%a' "$CHECK_FILE")"
actual_check_symbolic="$(stat -c '%A' "$CHECK_FILE")"

[[ "$actual_check_hash" == "$expected_check_hash" ]] || user_error 'Der Inhalt der Prüfdatei wurde verändert.' 'Den unveränderten vorbereiteten Dateiinhalt.' 'Die Datei soll nur ein zusätzliches Besitzerrecht erhalten. Starte das Szenario neu, wenn ihr Inhalt verändert wurde.'
[[ "$actual_check_uid" == "$expected_check_uid" ]] || user_error 'Der numerische Besitzer der Prüfdatei wurde verändert.' 'Den unveränderten Besitzer.' 'Eigentumsänderungen gehören nicht zum Auftrag. Starte das Szenario neu.'
[[ "$actual_check_gid" == "$expected_check_gid" ]] || user_error 'Die numerische Gruppe der Prüfdatei wurde verändert.' 'Die unveränderte Gruppe.' 'Gruppenänderungen gehören nicht zum Auftrag. Starte das Szenario neu.'

if [[ "$actual_check_mode" != '744' ]]; then
  case "$actual_check_mode" in
    6??|4??|2??|0??)
      user_error "Die Rechteanzeige lautet '$actual_check_symbolic'; dem Besitzer fehlt mindestens ein benötigtes Recht." 'Besitzer mit Lesen, Schreiben und Ausführen; Gruppe und andere ausschließlich mit Lesen.' 'Prüfe die Rechteanzeige und ergänze ausschließlich das Besitzer-Ausführungsrecht.'
      ;;
    ?[0234567]?)
      user_error "Die Rechteanzeige lautet '$actual_check_symbolic'; die Gruppenrechte sind zu weitreichend oder unvollständig." 'Gruppe ausschließlich mit Leserecht.' 'Prüfe den mittleren Rechteblock und vermeide zusätzliche Rechte.'
      ;;
    ??[0234567])
      user_error "Die Rechteanzeige lautet '$actual_check_symbolic'; die Rechte für andere sind zu weitreichend oder unvollständig." 'Andere ausschließlich mit Leserecht.' 'Prüfe den letzten Rechteblock und vermeide zusätzliche Rechte.'
      ;;
    *)
      user_error "Die Rechteanzeige lautet '$actual_check_symbolic' und entspricht nicht dem Ziel." 'Besitzer mit Lesen, Schreiben und Ausführen; Gruppe und andere ausschließlich mit Lesen.' 'Prüfe die drei Rechteblöcke mit ls -l.'
      ;;
  esac
fi

[[ -e "$MARKER" ]] || user_error 'Die Rechte der Prüfdatei sind korrekt, aber der Ausführungsmarker fehlt.' 'Eine erfolgreich ausgeführte vorbereitete Prüfdatei.' 'Prüfe ihren Standort und starte sie aus ihrem aktuellen Verzeichnis.'
[[ -f "$MARKER" ]] || user_error 'Der Ausführungsmarker ist keine reguläre Datei.' 'Einen regulären technischen Marker.' 'Starte das Szenario neu und führe die vorbereitete Prüfdatei erneut aus.'
[[ ! -L "$MARKER" ]] || user_error 'Der Ausführungsmarker ist ein symbolischer Link.' 'Einen echten regulären technischen Marker.' 'Starte das Szenario neu und führe die vorbereitete Prüfdatei erneut aus.'
cmp -s "$MARKER" <(printf '%s\n' 'ausgefuehrt') || user_error 'Der Ausführungsmarker besitzt nicht den erwarteten Inhalt oder Zeilenabschluss.' 'Genau den von der vorbereiteten Prüfdatei erzeugten Marker.' 'Führe die unveränderte Prüfdatei erneut aus. Bei erneutem Fehler starte das Szenario neu.'

[[ -e "$STATUS_FILE" ]] || user_error 'dokumentation/status.txt fehlt.' 'Eine Statusdatei mit genau einer dynamischen Zeile.' 'Bestimme CPU-Anzahl und primäre Schnittstelle und erzeuge danach die Statusdatei.'
[[ -f "$STATUS_FILE" ]] || user_error 'dokumentation/status.txt ist keine reguläre Datei.' 'Eine reguläre einzeilige Statusdatei.' 'Prüfe den Objekttyp im Dokumentationsbereich.'
[[ ! -L "$STATUS_FILE" ]] || user_error 'dokumentation/status.txt ist ein symbolischer Link.' 'Eine echte reguläre Statusdatei.' 'Erzeuge die Statusdatei direkt im Dokumentationsbereich.'

if [[ "$(wc -l < "$STATUS_FILE")" -ne 1 ]]; then
  user_error 'Die Statusdatei besitzt nicht genau eine abgeschlossene Inhaltszeile.' 'Genau eine Zeile mit genau einem abschließenden Zeilenumbruch.' 'Kontrolliere die vollständige Datei mit cat und schreibe die einzelne Statuszeile neu.'
fi
last_byte="$(tail -c 1 "$STATUS_FILE" | od -An -t u1 | tr -d '[:space:]')"
[[ "$last_byte" == '10' ]] || user_error 'Die Statusdatei endet nicht mit genau dem erwarteten Zeilenabschluss.' 'Eine einzelne Zeile mit abschließendem Zeilenumbruch.' 'Schreibe die Statuszeile erneut mit der bekannten echo-Form.'

IFS= read -r status_line < "$STATUS_FILE" || true
if [[ "$status_line" == *'<ANZAHL>'* || "$status_line" == *'<NAME>'* || "$status_line" == *'<'* || "$status_line" == *'>'* ]]; then
  user_error 'Die Statusdatei enthält noch Platzhalter oder spitze Klammern.' 'Die tatsächlich beobachtete CPU-Anzahl und den tatsächlichen Schnittstellennamen.' 'Führe nproc und ip route aus und ersetze die Platzhalter vollständig.'
fi

if [[ "$status_line" != CPU:\ *,\ Schnittstelle:\ * ]]; then
  user_error "Die Statuszeile '$status_line' besitzt nicht das geforderte Format." 'CPU: aktuelle_Anzahl, Schnittstelle: aktueller_Name' 'Vergleiche Reihenfolge, Doppelpunkt, Komma und Leerzeichen mit der sichtbaren Struktur.'
fi

status_rest="${status_line#CPU: }"
status_cpu="${status_rest%%, Schnittstelle: *}"
status_iface="${status_rest#*, Schnittstelle: }"
[[ "$status_line" == "CPU: $status_cpu, Schnittstelle: $status_iface" ]] || user_error "Die Statuszeile '$status_line' enthält zusätzliche oder fehlende Zeichen." 'Das exakte einzeilige Format ohne zusätzliche Leerzeichen.' 'Vergleiche die fertige Datei mit der sichtbaren Struktur.'
[[ "$status_cpu" =~ ^[0-9]+$ ]] || user_error "Der CPU-Wert '$status_cpu' ist keine reine Anzahl." 'Die aktuelle Zahl aus nproc.' 'Führe nproc erneut aus und übernimm nur die angezeigte Zahl.'
expected_cpu="$(nproc)"
[[ "$status_cpu" == "$expected_cpu" ]] || user_error "Die Statusdatei enthält CPU '$status_cpu', aktuell beobachtet wird '$expected_cpu'." 'Die aktuelle Ausgabe von nproc.' 'Führe nproc erneut aus und korrigiere nur den CPU-Wert.'
expected_iface="$(resolve_primary_interface)"
[[ "$status_iface" == "$expected_iface" ]] || user_error "Die Statusdatei enthält Schnittstelle '$status_iface', die eindeutige Standardroute verwendet '$expected_iface'." 'Den Namen direkt hinter dev in der verwendbaren Standardroute.' 'Führe ip route erneut aus und lies den Namen direkt hinter dev.'

expected_protect_hash="$(read_reference "$REF_ROOT/wichtig.sha256")"
expected_protect_uid="$(read_reference "$REF_ROOT/wichtig.uid")"
expected_protect_gid="$(read_reference "$REF_ROOT/wichtig.gid")"
expected_protect_mode="$(read_reference "$REF_ROOT/wichtig.modus")"
expected_manifest="$(read_reference "$REF_ROOT/schutzbereich.manifest")"

[[ -e "$PROTECT_ROOT" ]] || user_error 'Der Schutzbereich fehlt.' 'Das unveränderte echte Verzeichnis schutzbereich.' 'Bei einer Entfernung starte das Szenario neu.'
[[ -d "$PROTECT_ROOT" ]] || user_error 'Der Schutzbereich ist kein echtes Verzeichnis.' 'Ein echtes Verzeichnis und keinen anderen Objekttyp.' 'Bei einer Ersetzung starte das Szenario neu.'
[[ ! -L "$PROTECT_ROOT" ]] || user_error 'Der Schutzbereich ist ein symbolischer Link.' 'Das echte vorbereitete Schutzverzeichnis.' 'Bei einer Ersetzung starte das Szenario neu.'

mapfile -d '' protect_entries < <(find "$PROTECT_ROOT" -mindepth 1 -maxdepth 1 -print0)
if (( ${#protect_entries[@]} != 1 )); then
  user_error "Der Schutzbereich enthält ${#protect_entries[@]} Einträge." 'Genau einen Eintrag mit dem Namen wichtig.txt.' 'Zeige den Schutzbereich mit ls an. Bei einer Schutzverletzung starte das Szenario neu.'
fi
[[ "${protect_entries[0]}" == "$PROTECT_ROOT/$expected_manifest" ]] || user_error "Der einzige Eintrag im Schutzbereich heißt nicht '$expected_manifest'." 'Ausschließlich die unveränderte Datei wichtig.txt.' 'Bei einer Umbenennung oder Ersetzung starte das Szenario neu.'

[[ -f "$IMPORTANT_FILE" ]] || user_error 'wichtig.txt fehlt oder ist keine reguläre Datei.' 'Die unveränderte reguläre Schutzdatei.' 'Bei einer Schutzverletzung starte das Szenario neu.'
[[ ! -L "$IMPORTANT_FILE" ]] || user_error 'wichtig.txt ist ein symbolischer Link.' 'Die echte unveränderte Schutzdatei.' 'Bei einer Schutzverletzung starte das Szenario neu.'
actual_protect_hash="$(sha256sum "$IMPORTANT_FILE" | awk '{print $1}')"
actual_protect_uid="$(stat -c '%u' "$IMPORTANT_FILE")"
actual_protect_gid="$(stat -c '%g' "$IMPORTANT_FILE")"
actual_protect_mode="$(stat -c '%a' "$IMPORTANT_FILE")"
[[ "$actual_protect_hash" == "$expected_protect_hash" ]] || user_error 'Der Inhalt der Schutzdatei wurde verändert.' 'Den bytegenau unveränderten Ausgangsinhalt.' 'Bei einer Schutzverletzung starte das Szenario neu.'
[[ "$actual_protect_uid" == "$expected_protect_uid" ]] || user_error 'Der numerische Besitzer der Schutzdatei wurde verändert.' 'Den unveränderten Besitzer.' 'Bei einer Schutzverletzung starte das Szenario neu.'
[[ "$actual_protect_gid" == "$expected_protect_gid" ]] || user_error 'Die numerische Gruppe der Schutzdatei wurde verändert.' 'Die unveränderte Gruppe.' 'Bei einer Schutzverletzung starte das Szenario neu.'
[[ "$actual_protect_mode" == "$expected_protect_mode" ]] || user_error 'Die Rechte der Schutzdatei wurden verändert.' 'Die unveränderten Ausgangsrechte.' 'Bei einer Schutzverletzung starte das Szenario neu.'

server_result="$(python3 - <<'PY'
import glob
import os
import socket

PORT = 9090
EXPECTED_CWD = "/root/abschlusslabor/web"

def parse_listeners(path, family):
    result = []
    try:
        lines = open(path, encoding="ascii").read().splitlines()[1:]
    except FileNotFoundError:
        if family == 6:
            return result
        print("TECH\tSOCKET_READ\t/proc/net/tcp fehlt.")
        raise SystemExit
    except OSError as exc:
        print(f"TECH\tSOCKET_READ\t{exc}")
        raise SystemExit
    for line in lines:
        fields = line.split()
        if len(fields) < 10 or fields[3] != "0A":
            continue
        address_hex, port_hex = fields[1].split(":")
        if int(port_hex, 16) != PORT:
            continue
        if family == 4:
            raw = bytes.fromhex(address_hex)
            address = socket.inet_ntop(socket.AF_INET, raw[::-1])
        else:
            address = "IPv6"
        result.append((family, address, fields[9]))
    return result

listeners = parse_listeners("/proc/net/tcp", 4) + parse_listeners("/proc/net/tcp6", 6)

if not listeners:
    print("USER\tNO_LISTENER\tKein Listener auf Port 9090.")
    raise SystemExit

if any(family == 4 and address == "0.0.0.0" for family, address, _ in listeners):
    print("USER\tIPV4_WILDCARD\tEin Listener verwendet 0.0.0.0:9090.")
    raise SystemExit

if any(family == 6 for family, _, _ in listeners):
    print("USER\tIPV6_LISTENER\tMindestens ein IPv6-Listener verwendet Port 9090.")
    raise SystemExit

if len(listeners) != 1:
    print(f"USER\tADDITIONAL_LISTENER\tEs wurden {len(listeners)} Listener auf Port 9090 gefunden.")
    raise SystemExit

family, address, inode = listeners[0]
if family != 4 or address != "127.0.0.1":
    print(f"USER\tWRONG_BIND\tDer Listener verwendet {address}:9090.")
    raise SystemExit

pids = set()
for proc_dir in glob.glob("/proc/[0-9]*"):
    pid = os.path.basename(proc_dir)
    for fd in glob.glob(f"{proc_dir}/fd/*"):
        try:
            target = os.readlink(fd)
        except OSError:
            continue
        if target == f"socket:[{inode}]":
            pids.add(pid)

if len(pids) != 1:
    print(f"TECH\tSOCKET_MAPPING\tDer Socket-Inode gehört zu {len(pids)} eindeutig lesbaren Prozessen.")
    raise SystemExit

pid = next(iter(pids))
try:
    raw_cmdline = open(f"/proc/{pid}/cmdline", "rb").read()
    args = [
        part.decode("utf-8", "surrogateescape")
        for part in raw_cmdline.split(b"\0")
        if part
    ]
    cwd = os.readlink(f"/proc/{pid}/cwd")
except OSError as exc:
    print(f"TECH\tPROCESS_READ\t{exc}")
    raise SystemExit

expected_args = ["-m", "http.server", "--bind", "127.0.0.1", "9090"]
is_python = bool(args) and os.path.basename(args[0]).startswith("python")
if not (is_python and args[1:] == expected_args):
    print("USER\tWRONG_PROCESS\tDer Listener gehört nicht zum erwarteten Python-HTTP-Serverkommando.")
    raise SystemExit

if cwd != EXPECTED_CWD:
    print(f"USER\tWRONG_CWD\tDer Server arbeitet aus '{cwd}'.")
    raise SystemExit

print(f"OK\t{pid}")
PY
)"

case "$server_result" in
  OK$'\t'*)
    server_pid="${server_result#*$'\t'}"
    ;;
  USER$'\t'NO_LISTENER$'\t'*)
    user_error "${server_result#*$'\t'NO_LISTENER$'\t'}" 'Einen IPv4-Listener ausschließlich an 127.0.0.1:9090.' 'Wechsle in das Webverzeichnis und prüfe den verbindlichen Serverstart.'
    ;;
  USER$'\t'IPV4_WILDCARD$'\t'*|USER$'\t'IPV6_LISTENER$'\t'*|USER$'\t'ADDITIONAL_LISTENER$'\t'*|USER$'\t'WRONG_BIND$'\t'*)
    user_error "${server_result##*$'\t'}" 'Genau einen IPv4-Listener ausschließlich an 127.0.0.1:9090.' 'Prüfe Bind-Adresse und Port mit ss -ltn. Beende nur einen eindeutig eigenen Fehlstart.'
    ;;
  USER$'\t'WRONG_PROCESS$'\t'*)
    user_error "${server_result##*$'\t'}" 'Den vorbereiteten Python-HTTP-Server mit der verbindlichen Befehlsform.' 'Prüfe, welcher eindeutig eigene Prozess den Port verwendet. Beende keinen fremden Prozess auf Verdacht.'
    ;;
  USER$'\t'WRONG_CWD$'\t'*)
    user_error "${server_result##*$'\t'}" 'Arbeitsverzeichnis /root/abschlusslabor/web.' 'Beende nur einen eindeutig eigenen Fehlstart und starte den Server aus dem Webverzeichnis neu.'
    ;;
  TECH$'\t'*)
    technical_error "${server_result##*$'\t'}" 'Eine eindeutige Socket-Prozess-Zuordnung im lokalen Prozessnamensraum.' 'Szenario neu starten und bei erneutem Auftreten den Workshop melden.'
    ;;
  *)
    technical_error "Unerwartetes Ergebnis der Serverprüfung: $server_result" 'Eine eindeutig auswertbare Listener- und Prozesszuordnung.' 'Szenario neu starten und den Workshop melden.'
    ;;
esac

tmp_dir="$(mktemp -d)"
trap 'rm -rf -- "$tmp_dir"' EXIT

if ! curl -fsS --max-time 3 'http://127.0.0.1:9090/' -o "$tmp_dir/ipv4.response"; then
  user_error 'Die lokale HTTP-Anfrage an 127.0.0.1:9090 ist fehlgeschlagen.' 'Eine erfolgreiche lokale HTTP-Antwort.' 'Prüfe Listener, Serverprozess und Arbeitsverzeichnis.'
fi

if ! curl -fsS --max-time 3 'http://localhost:9090/' -o "$tmp_dir/localhost.response"; then
  user_error 'Die unveränderte Teilnehmeranfrage über localhost:9090 ist fehlgeschlagen.' 'Eine erfolgreiche lokale HTTP-Antwort über localhost.' 'Prüfe den IPv4-Listener. Bleibt der Fehler bestehen, melde einen technischen Szenariofehler.'
fi

cmp -s "$tmp_dir/ipv4.response" "$INDEX_FILE" || user_error 'Die Antwort über 127.0.0.1 enthält nicht bytegenau web/index.html.' 'Den Inhalt der eigenständigen Webkopie.' 'Prüfe Arbeitsverzeichnis und Inhalt von index.html.'
cmp -s "$tmp_dir/localhost.response" "$INDEX_FILE" || user_error 'Die Antwort über localhost enthält nicht bytegenau web/index.html.' 'Den Inhalt der eigenständigen Webkopie.' 'Prüfe Listener, Arbeitsverzeichnis und Inhalt von index.html.'
cmp -s "$tmp_dir/ipv4.response" "$TEMPLATE" || user_error 'Die HTTP-Antwort stimmt nicht bytegenau mit der unveränderten Vorlage überein.' 'Den Text der Vorlage als Startseite.' 'Vergleiche Vorlage und index.html mit cat.'

printf '%s\n' 'CHECK erfolgreich: Der vollständige technische Endzustand ist erreicht.'
printf '%s\n' 'Der CHECK bewertet weder den Lösungsweg noch die selbstständige Planung oder das fachliche Verständnis.'
printf '%s\n' "Geprüfter Serverprozess: PID $server_pid"
