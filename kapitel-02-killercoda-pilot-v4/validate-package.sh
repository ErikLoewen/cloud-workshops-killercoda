#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
errors=0

fail() {
  printf 'FEHLER: %s\n' "$*" >&2
  errors=$((errors + 1))
}

required=(
  index.json
  intro.md
  setup.sh
  reset.sh
  step1-interaktive-demonstrationen.md
  step2-prozess-port.md
  step3-bindung-traffic.md
  step4-http.md
  step5-register.md
  step6-gesamtcheck.md
  finish.md
  verify-01-interaktive-demonstrationen.sh
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
  [[ -f "$root/$item" ]] || fail "Pfad fehlt: $item"
done

if ! /usr/bin/python3 - "$root/index.json" "$root" <<'PY'
import json
import pathlib
import sys

index_path = pathlib.Path(sys.argv[1])
root = pathlib.Path(sys.argv[2])
data = json.loads(index_path.read_text(encoding="utf-8"))

allowed_top = {"title", "description", "details", "backend"}
unknown = set(data) - allowed_top
if unknown:
    raise SystemExit("Unbestätigte Top-Level-Felder: " + ", ".join(sorted(unknown)))

if data.get("backend") != {"imageid": "ubuntu"}:
    raise SystemExit("Backend muss exakt imageid=ubuntu verwenden.")

details = data.get("details")
if not isinstance(details, dict):
    raise SystemExit("details fehlt.")
if set(details) - {"intro", "steps", "finish"}:
    raise SystemExit("V4 darf keine zusätzlichen details-Felder verwenden.")

intro = details.get("intro")
if intro != {
    "title": "Technikpilot vorbereiten",
    "text": "intro.md",
    "foreground": "setup.sh",
}:
    raise SystemExit("Intro muss exakt das Kapitel-1-Foreground-Muster verwenden.")

finish = details.get("finish")
if not isinstance(finish, dict):
    raise SystemExit("finish fehlt.")
if set(finish) - {"title", "text"}:
    raise SystemExit("Unbestätigte Finish-Felder.")
if not (root / finish["text"]).is_file():
    raise SystemExit("Finish-Text fehlt.")

steps = details.get("steps")
if not isinstance(steps, list) or len(steps) != 6:
    raise SystemExit("Genau sechs Schritte werden erwartet.")

for number, step in enumerate(steps, 1):
    if set(step) - {"title", "text", "verify"}:
        raise SystemExit(f"Unbestätigte Felder in Schritt {number}.")
    for key in ("text", "verify"):
        if not (root / step[key]).is_file():
            raise SystemExit(
                f"Referenz fehlt: Schritt {number}.{key} -> {step[key]}"
            )
PY
then
  fail "index.json oder Referenzen sind ungültig."
fi

bash_files=(
  setup.sh
  reset.sh
  validate-package.sh
  test-local.sh
  verify-01-interaktive-demonstrationen.sh
  verify-02-prozess-port.sh
  verify-03-bindung.sh
  verify-04-http.sh
  verify-05-register.sh
  verify-06-gesamt.sh
)

for item in "${bash_files[@]}"; do
  file="$root/$item"
  bash -n "$file" || fail "Bash-Syntax ungültig: $item"
  [[ "$(head -n 1 "$file")" == '#!/usr/bin/env bash' ]] ||
    fail "Falscher Bash-Shebang: $item"
  grep -q '^set -Eeuo pipefail$' "$file" ||
    fail "set -Eeuo pipefail fehlt: $item"
  [[ -x "$file" ]] || fail "Ausführungsrecht fehlt: $item"
done

# Entscheidend: Foreground-Setup muss vollständig selbstständig sein.
grep -q 'exec su - telegrafist' "$root/setup.sh" ||
  fail "setup.sh endet nicht im Arbeitskonto telegrafist."

if grep -Eq 'BASH_SOURCE|script_dir|/tmp/kapitel-02-killercoda-(entry|wait)' \
  "$root/setup.sh"; then
  fail "setup.sh enthält erneut eine relative oder /tmp-basierte Startabhängigkeit."
fi

if grep -Eq 'details.*assets|\"assets\"' "$root/index.json"; then
  fail "V4 darf kein Assetmodell verwenden."
fi

# Die benötigten technischen Dateien müssen im Setup selbst erzeugt werden.
for marker in \
  xebico_dienst.py \
  config_parser.py \
  process_guard.py \
  hosts_tool.py \
  pilot_state.py \
  verify_step.py \
  dienststeuerung \
  register-apply-root; do
  grep -q "$marker" "$root/setup.sh" ||
    fail "setup.sh erzeugt nicht: $marker"
done

step="$root/step1-interaktive-demonstrationen.md"
grep -q '<details>' "$step" ||
  fail "Interaktive details-Bereiche fehlen."
grep -q '{{exec}}' "$step" ||
  fail "Anklickbare Codeaktionen fehlen."
grep -q '{{TRAFFIC_HOST1_8080}}/architektur' "$step" ||
  fail "Traffic-Link zur Web-App fehlt."

if grep -Eq '^[[:space:]]*<(style|script|iframe)([[:space:]>])' "$step"; then
  fail "Schritt 1 enthält erneut vom Frontend entfernte Inline-Elemente."
fi

if find "$root" -type f \( \
  -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
  -o -iname '*.gif' -o -iname '*.webp' \
\) | grep -q .; then
  fail "Das Paket enthält Bilddateien."
fi

while IFS= read -r -d '' file; do
  mode="$(stat -c '%a' "$file")"
  other_digit=$((10#$mode % 10))
  if (((other_digit & 2) != 0)); then
    fail "Datei ist für andere beschreibbar: ${file#"$root/"} ($mode)"
  fi
done < <(find "$root" -type f -print0)

if ((errors > 0)); then
  printf '%s\n' "$errors Paketfehler gefunden." >&2
  exit 1
fi

printf '%s\n' 'Killercoda-V4-Paketvalidierung erfolgreich.'
