#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C
export LANG=C

target="/root/netzwerklabor/netzwerkstatus.txt"

fail() {
  printf '%s\n' "$1" >&2
  if [[ $# -ge 2 ]]; then
    printf '%s\n' "$2" >&2
  fi
  exit 1
}

environment_fail() {
  printf 'Technischer Umgebungsfehler: %s\n' "$1" >&2
  if [[ $# -ge 2 ]]; then
    printf '%s\n' "$2" >&2
  fi
  exit 2
}

validate_ipv4_prefix() {
  local value="$1"
  local address prefix
  local -a octets

  if [[ ! "$value" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]; then
    return 1
  fi

  address="${value%/*}"
  prefix="${value#*/}"
  IFS='.' read -r -a octets <<< "$address"

  if (( ${#octets[@]} != 4 )); then
    return 1
  fi

  local octet
  for octet in "${octets[@]}"; do
    if (( 10#$octet < 0 || 10#$octet > 255 )); then
      return 2
    fi
  done

  if (( 10#$prefix < 0 || 10#$prefix > 32 )); then
    return 3
  fi

  return 0
}

if [[ ! -e "$target" ]]; then
  fail \
    "Die Bestandsdatei $target wurde nicht gefunden." \
    "Prüfe den absoluten Zielpfad und erzeuge dort die Statusdatei."
fi

if [[ ! -f "$target" ]]; then
  fail \
    "Der Pfad $target ist keine reguläre Datei." \
    "Entferne das falsche Objekt und erzeuge am Zielpfad eine Textdatei."
fi

if [[ ! -s "$target" ]]; then
  fail \
    "Die Bestandsdatei ist leer." \
    "Schreibe die vier Schlüssel und ihre aktuellen Werte in eine gemeinsame Datenzeile."
fi

mapfile -t data_lines < <(awk 'NF { print }' "$target")

if (( ${#data_lines[@]} == 0 )); then
  fail \
    "Die Bestandsdatei enthält keine nicht leere Datenzeile." \
    "Schreibe die vier Schlüssel und ihre aktuellen Werte in eine gemeinsame Datenzeile."
fi

if (( ${#data_lines[@]} > 1 )); then
  fail \
    "Die Bestandsdatei enthält mehr als eine nicht leere Datenzeile." \
    "Fasse alle vier Schlüssel-Wert-Paare in genau einer Datenzeile zusammen."
fi

line="${data_lines[0]}"
read -r -a fields <<< "$line"

declare -A values=()
allowed_keys=(
  "LOOPBACK_INTERFACE"
  "LOOPBACK_IPV4"
  "PRIMAERE_INTERFACE"
  "PRIMAERE_IPV4"
)

is_allowed_key() {
  local candidate="$1"
  local allowed
  for allowed in "${allowed_keys[@]}"; do
    [[ "$candidate" == "$allowed" ]] && return 0
  done
  return 1
}

for field in "${fields[@]}"; do
  if [[ "$field" != *=* ]]; then
    fail \
      "Das Feld '$field' besitzt nicht die Form SCHLUESSEL=WERT." \
      "Prüfe die Leerzeichen und die Gleichheitszeichen in der gemeinsamen Datenzeile."
  fi

  key="${field%%=*}"
  value="${field#*=}"

  if ! is_allowed_key "$key"; then
    fail \
      "Der unbekannte zusätzliche Schlüssel '$key' ist nicht erlaubt." \
      "Verwende ausschließlich die vier vorgeschriebenen Schlüssel."
  fi

  if [[ -v "values[$key]" ]]; then
    fail \
      "Der Schlüssel '$key' kommt mehrfach vor." \
      "Jeder vorgeschriebene Schlüssel darf genau einmal vorkommen."
  fi

  if [[ -z "$value" ]]; then
    fail \
      "Für den Schlüssel '$key' fehlt ein Wert." \
      "Ermittle den aktuellen Wert erneut und trage ihn direkt hinter dem Gleichheitszeichen ein."
  fi

  values["$key"]="$value"
done

for key in "${allowed_keys[@]}"; do
  if [[ ! -v "values[$key]" ]]; then
    fail \
      "Der vorgeschriebene Schlüssel '$key' fehlt." \
      "Ergänze den fehlenden Schlüssel mit seinem aktuellen Wert in derselben Datenzeile."
  fi
done

for key in LOOPBACK_IPV4 PRIMAERE_IPV4; do
  set +e
  validate_ipv4_prefix "${values[$key]}"
  validation_status=$?
  set -e

  case "$validation_status" in
    0)
      ;;
    1)
      fail \
        "Der Wert von '$key' besitzt kein gültiges IPv4-Format mit Präfixlänge." \
        "Erwartet wird eine Punktnotation mit angehängtem / und einer Präfixlänge."
      ;;
    2)
      fail \
        "Der Wert von '$key' enthält ein IPv4-Oktett außerhalb des Bereichs 0 bis 255." \
        "Lies die Adresse erneut aus der passenden Schnittstellenzeile ab."
      ;;
    3)
      fail \
        "Der Wert von '$key' enthält eine Präfixlänge außerhalb des Bereichs 0 bis 32." \
        "Übernimm die sichtbare Präfixlänge direkt aus der Adressausgabe."
      ;;
    *)
      fail \
        "Der Wert von '$key' konnte nicht geprüft werden." \
        "Kontrolliere die IPv4-Adresse einschließlich Präfixlänge."
      ;;
  esac
done

mapfile -t loopback_candidates < <(
  ip -o link show | awk -F': ' '
    index($0, "<LOOPBACK") {
      name=$2
      sub(/:.*/, "", name)
      sub(/@.*/, "", name)
      print name
    }
  ' | sort -u
)

if (( ${#loopback_candidates[@]} == 0 )); then
  environment_fail \
    "Die Lernumgebung liefert keine als Loopback gekennzeichnete Schnittstelle." \
    "Dieser Zustand blockiert die Veröffentlichung des Szenarios."
fi

mapfile -t expected_loopback_interfaces < <(
  ip -o -4 addr show | awk '
    $3 == "inet" && $4 == "127.0.0.1/8" {
      name=$2
      sub(/@.*/, "", name)
      print name
    }
  ' | sort -u
)

if (( ${#expected_loopback_interfaces[@]} == 0 )); then
  environment_fail \
    "Die erwartete lokale Loopback-Adresse 127.0.0.1/8 ist nicht vorhanden." \
    "Dieser Zustand blockiert die Veröffentlichung des Szenarios."
fi

valid_loopback_interface=""
for address_interface in "${expected_loopback_interfaces[@]}"; do
  for loopback_interface in "${loopback_candidates[@]}"; do
    if [[ "$address_interface" == "$loopback_interface" ]]; then
      if [[ -n "$valid_loopback_interface" && "$valid_loopback_interface" != "$address_interface" ]]; then
        environment_fail \
          "Die Lernumgebung liefert mehr als eine passende Loopback-Schnittstelle für 127.0.0.1/8." \
          "Der technische Ausgangszustand ist für diesen Workshop nicht eindeutig."
      fi
      valid_loopback_interface="$address_interface"
    fi
  done
done

if [[ -z "$valid_loopback_interface" ]]; then
  environment_fail \
    "Die Adresse 127.0.0.1/8 ist keiner als Loopback gekennzeichneten Schnittstelle zugeordnet." \
    "Dieser Zustand blockiert die Veröffentlichung des Szenarios."
fi

if [[ "${values[LOOPBACK_INTERFACE]}" != "$valid_loopback_interface" ]]; then
  fail \
    "LOOPBACK_INTERFACE stimmt nicht mit der aktuell ermittelten Loopback-Schnittstelle überein." \
    "Suche die Zeile mit 127.0.0.1/8 erneut und übernimm ihren Schnittstellennamen."
fi

if [[ "${values[LOOPBACK_IPV4]}" != "127.0.0.1/8" ]]; then
  fail \
    "LOOPBACK_IPV4 stimmt nicht mit der aktuell ermittelten Loopback-Adresse 127.0.0.1/8 überein." \
    "Übernimm die IPv4-Adresse einschließlich Präfixlänge aus der Loopback-Zeile."
fi

mapfile -t default_routes < <(ip -4 route show default | awk 'NF { print }')

if (( ${#default_routes[@]} == 0 )); then
  environment_fail \
    "Die Lernumgebung liefert keine verwendbare IPv4-Standardroute." \
    "Dies ist kein Fehler der Bestandsdatei. Starte die Umgebung neu oder melde den technischen Zustand."
fi

if (( ${#default_routes[@]} > 1 )); then
  environment_fail \
    "Die Lernumgebung liefert mehrere uneindeutige IPv4-Standardrouten." \
    "Der CHECK wählt keine Route willkürlich aus. Für die Veröffentlichung ist eine eindeutige Umgebung erforderlich."
fi

route_line="${default_routes[0]}"
route_interface="$(
  awk '
    {
      for (i = 1; i <= NF; i++) {
        if ($i == "dev" && i < NF) {
          print $(i + 1)
          exit
        }
      }
    }
  ' <<< "$route_line"
)"

if [[ -z "$route_interface" ]]; then
  environment_fail \
    "Die eindeutige Standardroute enthält keinen Schnittstellennamen hinter 'dev'." \
    "Der technische Ausgangszustand ist für diesen Workshop nicht verwendbar."
fi

if [[ "${values[PRIMAERE_INTERFACE]}" != "$route_interface" ]]; then
  fail \
    "PRIMAERE_INTERFACE entspricht nicht der Schnittstelle der aktuellen Standardroute." \
    "Suche in 'ip route' die Zeile mit 'default' und lies den Namen direkt hinter 'dev'."
fi

mapfile -t primary_ipv4_addresses < <(
  ip -o -4 addr show | awk -v wanted="$route_interface" '
    $3 == "inet" {
      name=$2
      if (name == wanted || index(name, wanted "@") == 1) {
        if ($4 !~ /^127\./) {
          print $4
        }
      }
    }
  ' | sort -u
)

if (( ${#primary_ipv4_addresses[@]} == 0 )); then
  environment_fail \
    "Die primäre Schnittstelle '$route_interface' besitzt keine aktuelle Nicht-Loopback-IPv4-Adresse." \
    "Dies ist ein technischer Umgebungsfehler und kein Fehler der Bestandsdatei."
fi

primary_match=false
for current_address in "${primary_ipv4_addresses[@]}"; do
  if [[ "${values[PRIMAERE_IPV4]}" == "$current_address" ]]; then
    primary_match=true
    break
  fi
done

if [[ "$primary_match" != true ]]; then
  fail \
    "Die dokumentierte PRIMAERE_IPV4 gehört aktuell nicht zur primären Schnittstelle '$route_interface'." \
    "Suche diese Schnittstelle erneut in 'ip -brief addr' und übernimm dort eine IPv4-Adresse einschließlich Präfixlänge."
fi

echo "Prüfung erfolgreich: Die Bestandsdatei entspricht dem aktuellen lokalen Netzwerkzustand."
echo "Der CHECK bewertet den Endzustand, nicht den verwendeten Lösungsweg oder das vollständige Verständnis."
