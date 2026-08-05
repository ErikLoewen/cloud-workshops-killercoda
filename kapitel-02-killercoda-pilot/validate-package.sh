#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
errors=0

fail() {
  echo "FEHLER: $*" >&2
  errors=$((errors + 1))
}

required=(
  index.json
  intro.md
  finish.md
  step1-markdown.md
  step2-prozess-port.md
  step3-bindung-traffic.md
  step4-http.md
  step5-register.md
  step6-gesamtcheck.md
  setup.sh
  reset.sh
  validate-package.sh
  test-local.sh
  verify-01-markdown.sh
  verify-02-prozess-port.sh
  verify-03-bindung.sh
  verify-04-http.sh
  verify-05-register.sh
  verify-06-gesamt.sh
  README.md
  test-checklist.md
  pilot-results-template.md
)

for item in "${required[@]}"; do
  [[ -e "$root/$item" ]] || fail "Pfad fehlt: $item"
done

if ! /usr/bin/python3 - "$root/index.json" "$root" <<'PY'
import json
import pathlib
import sys

index_path = pathlib.Path(sys.argv[1])
root = pathlib.Path(sys.argv[2])
data = json.loads(index_path.read_text(encoding="utf-8"))

allowed_top = {"title", "description", "details", "backend"}
if set(data) - allowed_top:
    raise SystemExit("Unbestätigte Top-Level-Felder: " + ", ".join(sorted(set(data) - allowed_top)))

if data.get("backend") != {"imageid": "ubuntu"}:
    raise SystemExit("Backend muss exakt imageid=ubuntu verwenden.")

details = data.get("details")
if not isinstance(details, dict):
    raise SystemExit("details fehlt oder ist kein Objekt.")

for name in ("intro", "finish"):
    item = details.get(name)
    if not isinstance(item, dict):
        raise SystemExit(f"{name} fehlt.")
    allowed = {"title", "text", "foreground", "background"}
    if set(item) - allowed:
        raise SystemExit(f"Unbestätigte Felder in {name}: {set(item) - allowed}")
    for key in ("text", "foreground", "background"):
        if key in item and not (root / item[key]).is_file():
            raise SystemExit(f"Referenz fehlt: {name}.{key} -> {item[key]}")

steps = details.get("steps")
if not isinstance(steps, list) or not steps:
    raise SystemExit("details.steps fehlt oder ist leer.")
for number, item in enumerate(steps, 1):
    if not isinstance(item, dict):
        raise SystemExit(f"Schritt {number} ist kein Objekt.")
    allowed = {"title", "text", "foreground", "background", "verify"}
    if set(item) - allowed:
        raise SystemExit(f"Unbestätigte Felder in Schritt {number}: {set(item) - allowed}")
    for key in ("text", "foreground", "background", "verify"):
        if key in item and not (root / item[key]).is_file():
            raise SystemExit(f"Referenz fehlt: Schritt {number}.{key} -> {item[key]}")
PY
then
  fail "index.json oder Referenzen sind ungültig."
fi

while IFS= read -r -d '' file; do
  bash -n "$file" || fail "Bash-Syntax ungültig: ${file#"$root/"}"
  [[ "$(head -n 1 "$file")" == '#!/usr/bin/env bash' ]] ||
    fail "Falscher Bash-Shebang: ${file#"$root/"}"
  grep -q '^set -Eeuo pipefail$' "$file" ||
    fail "set -Eeuo pipefail fehlt: ${file#"$root/"}"

  if [[ "$file" != "$root/validate-package.sh" ]]; then
    grep -Eq '(^|[;&|[:space:]])source[[:space:]]' "$file" &&
      fail "Verbotenes source in ${file#"$root/"}"
    grep -Eq '(^|[;&|[:space:]])eval[[:space:]]' "$file" &&
      fail "Verbotenes eval in ${file#"$root/"}"
    grep -Eq '(^|[;&|[:space:]])(pkill|killall)([;&|[:space:]]|$)' "$file" &&
      fail "Globaler Kill-Befehl in ${file#"$root/"}"
  fi
done < <(
  find "$root" -type f \( -name '*.sh' -o -path "$root/werkzeuge/*" \
    -o -path "$root/pilot-werkzeuge/*" \
    -o -path "$root/interne-skripte/dienststeuerung" \
    -o -path "$root/interne-skripte/register-apply-root" \) -print0
)

while IFS= read -r -d '' file; do
  if ! /usr/bin/python3 - "$file" <<'PY'
import pathlib
import sys
path = pathlib.Path(sys.argv[1])
compile(path.read_text(encoding="utf-8"), str(path), "exec")
PY
  then
    fail "Python-Syntaxprüfung fehlgeschlagen: ${file#"$root/"}"
  fi
done < <(find "$root" -type f -name '*.py' -print0)

exec_files=(
  setup.sh reset.sh validate-package.sh test-local.sh
  dienst/xebico_dienst.py
  werkzeuge/konfiguration-pruefen
  werkzeuge/konfiguration-anwenden
  werkzeuge/register-pruefen
  werkzeuge/register-anwenden
  interne-skripte/config_parser.py
  interne-skripte/hosts_tool.py
  interne-skripte/process_guard.py
  interne-skripte/station_host.py
  interne-skripte/pilot_state.py
  interne-skripte/verify_step.py
  interne-skripte/dienststeuerung
  interne-skripte/register-apply-root
  verify-01-markdown.sh
  verify-02-prozess-port.sh
  verify-03-bindung.sh
  verify-04-http.sh
  verify-05-register.sh
  verify-06-gesamt.sh
)

while IFS= read -r file; do
  exec_files+=("$file")
done < <(find "$root/pilot-werkzeuge" -maxdepth 1 -type f -printf 'pilot-werkzeuge/%f\n' | sort)

for item in "${exec_files[@]}"; do
  [[ -x "$root/$item" ]] || fail "Ausführungsrecht fehlt: $item"
done

markdown_all="$(cat "$root"/*.md)"
grep -q '{{exec}}' <<<"$markdown_all" || fail "Markdown enthält kein {{exec}}."
grep -q '{{copy}}' <<<"$markdown_all" || fail "Markdown enthält kein {{copy}}."
grep -q '{{exec interrupt}}' <<<"$markdown_all" || fail "Markdown enthält kein {{exec interrupt}}."
grep -q '<details>' <<<"$markdown_all" || fail "Markdown enthält keinen details-Bereich."
grep -q '{{TRAFFIC_HOST1_8080}}' <<<"$markdown_all" ||
  fail "Traffic-Platzhalter fehlt."

while IFS= read -r -d '' file; do
  mode="$(stat -c '%a' "$file")"
  other_digit=$((10#$mode % 10))
  if (((other_digit & 2) != 0)); then
    fail "Datei ist für andere beschreibbar: ${file#"$root/"} ($mode)"
  fi
done < <(find "$root" -type f -print0)

if ((errors > 0)); then
  echo "$errors Paketfehler gefunden." >&2
  exit 1
fi

echo "Killercoda-Paketvalidierung erfolgreich."
