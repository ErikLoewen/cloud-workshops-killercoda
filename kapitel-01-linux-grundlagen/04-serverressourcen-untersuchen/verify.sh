#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C

target="/root/ressourcenlabor/serverstatus.txt"
required_keys=(
  "CPU_LOGISCH"
  "RAM_GESAMT"
  "RAM_VERFUEGBAR"
  "DATEISYSTEM_BELEGT"
  "DATEISYSTEM_VERFUEGBAR"
)

fail() {
  printf 'CHECK nicht erfolgreich: %s\n' "$1" >&2
  exit 1
}

is_required_key() {
  local candidate="$1"
  local key
  for key in "${required_keys[@]}"; do
    [[ "$candidate" == "$key" ]] && return 0
  done
  return 1
}

size_is_valid() {
  local value="$1"
  [[ "$value" =~ ^[0-9]+([.][0-9]+)?(B|Ki|Mi|Gi|Ti|Pi|Ei|K|M|G|T|P|E)$ ]]
}

# Gibt das durch die angezeigte Rundung mögliche Intervall in Bytes aus.
size_interval() {
  local value="$1"
  size_is_valid "$value" || return 1

  [[ "$value" =~ ^([0-9]+([.][0-9]+)?)(B|Ki|Mi|Gi|Ti|Pi|Ei|K|M|G|T|P|E)$ ]]
  local number="${BASH_REMATCH[1]}"
  local unit="${BASH_REMATCH[3]}"
  local decimals=0
  local multiplier

  if [[ "$number" == *.* ]]; then
    fraction="${number#*.}"
    decimals="${#fraction}"
  fi

  case "$unit" in
    B)  multiplier=1 ;;
    K|Ki) multiplier=1024 ;;
    M|Mi) multiplier=1048576 ;;
    G|Gi) multiplier=1073741824 ;;
    T|Ti) multiplier=1099511627776 ;;
    P|Pi) multiplier=1125899906842624 ;;
    E|Ei) multiplier=1152921504606846976 ;;
    *) return 1 ;;
  esac

  awk -v number="$number" -v multiplier="$multiplier" -v decimals="$decimals" '
    BEGIN {
      step = multiplier
      for (i = 0; i < decimals; i++) {
        step = step / 10
      }
      low = number * multiplier - step / 2
      high = number * multiplier + step / 2
      if (low < 0) {
        low = 0
      }
      printf "%.0f %.0f\n", low, high
    }
  '
}

intervals_overlap() {
  local a_low="$1"
  local a_high="$2"
  local b_low="$3"
  local b_high="$4"

  awk -v a_low="$a_low" -v a_high="$a_high" \
      -v b_low="$b_low" -v b_high="$b_high" '
    BEGIN {
      exit !((a_low <= b_high) && (b_low <= a_high))
    }
  '
}

[[ -e "$target" ]] || fail "Die Datei $target wurde nicht gefunden."
[[ -f "$target" ]] || fail "$target ist keine reguläre Datei."
[[ -s "$target" ]] || fail "Die Statusdatei ist leer."

nonempty_lines="$(awk 'NF { count++ } END { print count + 0 }' "$target")"
[[ "$nonempty_lines" -eq 1 ]] || fail "Die Datei muss genau eine nicht leere Datenzeile enthalten."

status_line="$(awk 'NF { print; exit }' "$target")"
read -r -a fields <<< "$status_line"

declare -A values=()
declare -A counts=()

for field in "${fields[@]}"; do
  if [[ ! "$field" =~ ^([A-Z_]+)=([^=[:space:]]+)$ ]]; then
    fail "Der Eintrag '$field' hat nicht das Format SCHLUESSEL=WERT."
  fi

  key="${BASH_REMATCH[1]}"
  value="${BASH_REMATCH[2]}"

  is_required_key "$key" || fail "Der Schlüssel '$key' ist für diese Statusdatei nicht vorgesehen."

  counts["$key"]=$(( ${counts["$key"]:-0} + 1 ))
  [[ "${counts["$key"]}" -eq 1 ]] || fail "Der Schlüssel '$key' kommt mehrfach vor."
  [[ -n "$value" ]] || fail "Der Schlüssel '$key' besitzt keinen Wert."
  values["$key"]="$value"
done

for key in "${required_keys[@]}"; do
  [[ "${counts["$key"]:-0}" -eq 1 ]] || fail "Der vorgeschriebene Schlüssel '$key' fehlt."
done

[[ "${#fields[@]}" -eq 5 ]] || fail "Die Statuszeile muss genau fünf Schlüssel-Wert-Paare enthalten."

cpu_value="${values[CPU_LOGISCH]}"
[[ "$cpu_value" =~ ^[1-9][0-9]*$ ]] || fail "CPU_LOGISCH muss eine positive ganze Zahl sein."

expected_cpu="$(nproc)"
[[ "$cpu_value" == "$expected_cpu" ]] || fail "CPU_LOGISCH stimmt nicht mit dem aktuellen nproc-Wert überein."

memory_keys=(
  "RAM_GESAMT"
  "RAM_VERFUEGBAR"
  "DATEISYSTEM_BELEGT"
  "DATEISYSTEM_VERFUEGBAR"
)

for key in "${memory_keys[@]}"; do
  size_is_valid "${values[$key]}" || fail "$key besitzt kein zulässiges Zahlen- und Einheitenformat."
done

current_ram_total="$(free -h | awk '/^Mem:/ { print $2; exit }')"
[[ -n "$current_ram_total" ]] || fail "Der aktuelle Gesamt-RAM konnte intern nicht ermittelt werden."
size_is_valid "$current_ram_total" || fail "Das interne Format des aktuellen Gesamt-RAM ist unerwartet."

read -r report_total_low report_total_high <<< "$(size_interval "${values[RAM_GESAMT]}")"
read -r current_total_low current_total_high <<< "$(size_interval "$current_ram_total")"

intervals_overlap \
  "$report_total_low" "$report_total_high" \
  "$current_total_low" "$current_total_high" \
  || fail "RAM_GESAMT stimmt unter Berücksichtigung der Anzeigerundung nicht mit dem aktuellen Gesamt-RAM überein."

read -r available_low available_high <<< "$(size_interval "${values[RAM_VERFUEGBAR]}")"
if ! awk -v available_low="$available_low" -v total_high="$report_total_high" \
  'BEGIN { exit !(available_low <= total_high) }'; then
  fail "RAM_VERFUEGBAR ist größer als RAM_GESAMT."
fi

filesystem_size_bytes="$(df -B1 --output=size / | awk 'NR == 2 { print $1; exit }')"
[[ "$filesystem_size_bytes" =~ ^[1-9][0-9]*$ ]] || fail "Die Größe des Root-Dateisystems konnte intern nicht ermittelt werden."

for key in "DATEISYSTEM_BELEGT" "DATEISYSTEM_VERFUEGBAR"; do
  read -r value_low value_high <<< "$(size_interval "${values[$key]}")"

  if ! awk -v value_low="$value_low" -v fs_size="$filesystem_size_bytes" \
    'BEGIN { exit !(value_low <= fs_size) }'; then
    fail "$key ist offensichtlich größer als das gesamte Root-Dateisystem."
  fi
done

printf '%s\n' "CHECK erfolgreich: Statusdatei, Format, CPU-Wert, Gesamt-RAM und robuste Plausibilitätsbeziehungen sind korrekt."
printf '%s\n' "Hinweis: Der CHECK bestätigt nicht das Verständnis und prüft dynamische Momentwerte nicht mit ungepilotierten Toleranzen."
