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
  intro-background.sh
  intro-foreground.sh
  killercoda-entry.sh
  killercoda-wait.sh
  kapitel-02-killercoda-runtime.tar.gz
  step1-html-css-js.md
  step2-prozess-port.md
  step3-bindung-traffic.md
  step4-http.md
  step5-register.md
  step6-gesamtcheck.md
  finish.md
  verify-01-html-css-js.sh
  verify-02-prozess-port.sh
  verify-03-bindung.sh
  verify-04-http.sh
  verify-05-register.sh
  verify-06-gesamt.sh
  README.md
  test-local.sh
  test-checklist.md
  pilot-results-template.md
  runtime/setup.sh
  runtime/reset.sh
  runtime/dienst/xebico_dienst.py
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

if set(data) - {"title", "description", "details", "backend"}:
    raise SystemExit("Unbestätigte Top-Level-Felder.")

if data.get("backend") != {"imageid": "ubuntu"}:
    raise SystemExit("Backend muss exakt ubuntu verwenden.")

details = data.get("details")
if not isinstance(details, dict):
    raise SystemExit("details fehlt.")

allowed_details = {"intro", "steps", "finish", "assets"}
if set(details) - allowed_details:
    raise SystemExit(
        "Unbestätigte details-Felder: "
        + ", ".join(sorted(set(details) - allowed_details))
    )

intro = details.get("intro")
if not isinstance(intro, dict):
    raise SystemExit("intro fehlt.")
if set(intro) - {"title", "text", "foreground", "background"}:
    raise SystemExit("Unbestätigte intro-Felder.")

finish = details.get("finish")
if not isinstance(finish, dict):
    raise SystemExit("finish fehlt.")
if set(finish) - {"title", "text", "foreground", "background"}:
    raise SystemExit("Unbestätigte finish-Felder.")

for section_name, section in (("intro", intro), ("finish", finish)):
    for key in ("text", "foreground", "background"):
        if key in section and not (root / section[key]).is_file():
            raise SystemExit(f"Referenz fehlt: {section_name}.{key}")

steps = details.get("steps")
if not isinstance(steps, list) or len(steps) != 6:
    raise SystemExit("Genau sechs Schritte werden erwartet.")

for number, step in enumerate(steps, 1):
    if set(step) - {"title", "text", "foreground", "background", "verify"}:
        raise SystemExit(f"Unbestätigte Felder in Schritt {number}.")
    for key in ("text", "foreground", "background", "verify"):
        if key in step and not (root / step[key]).is_file():
            raise SystemExit(
                f"Referenz fehlt: Schritt {number}.{key} -> {step[key]}"
            )

assets = details.get("assets")
if not isinstance(assets, dict) or set(assets) != {"host01"}:
    raise SystemExit("assets.host01 fehlt oder enthält unbekannte Hosts.")

expected = {
    ("kapitel-02-killercoda-runtime.tar.gz", "/tmp", None),
    ("killercoda-entry.sh", "/tmp", "+x"),
    ("killercoda-wait.sh", "/tmp", "+x"),
}
actual = set()
for item in assets["host01"]:
    if set(item) - {"file", "target", "chmod"}:
        raise SystemExit("Unbestätigte Asset-Felder.")
    file_name = item.get("file")
    target = item.get("target")
    chmod = item.get("chmod")
    if not (root / file_name).is_file():
        raise SystemExit(f"Asset fehlt: {file_name}")
    actual.add((file_name, target, chmod))

if actual != expected:
    raise SystemExit("Assetliste entspricht nicht dem freigegebenen Sollzustand.")
PY
then
  fail "index.json oder Assetreferenzen sind ungültig."
fi

# Das Foreground/Background darf nicht erneut den fehlerhaften relativen Aufbau enthalten.
for file in intro-background.sh intro-foreground.sh; do
  grep -q 'BASH_SOURCE' "$root/$file" &&
    fail "$file darf BASH_SOURCE nicht verwenden."
  grep -q 'script_dir' "$root/$file" &&
    fail "$file darf kein relatives script_dir verwenden."
done

grep -qx '/tmp/kapitel-02-killercoda-entry.sh' \
  <(grep -vE '^(#!|set |$)' "$root/intro-background.sh") ||
  fail "Intro-Background muss genau den absoluten Entry aufrufen."

grep -qx '/tmp/kapitel-02-killercoda-wait.sh' \
  <(grep -vE '^(#!|set |$)' "$root/intro-foreground.sh") ||
  fail "Intro-Foreground muss genau den absoluten Warter aufrufen."

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
  find "$root" -type f \( -name '*.sh' \
    -o -path "$root/runtime/werkzeuge/*" \
    -o -path "$root/runtime/pilot-werkzeuge/*" \
    -o -path "$root/runtime/interne-skripte/dienststeuerung" \
    -o -path "$root/runtime/interne-skripte/register-apply-root" \) -print0
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
done < <(find "$root/runtime" -type f -name '*.py' -print0)

# Runtime-Archiv prüfen.
archive_listing="$(tar -tzf "$root/kapitel-02-killercoda-runtime.tar.gz")" ||
  fail "Runtime-Archiv ist nicht lesbar."

for item in \
  setup.sh \
  reset.sh \
  dienst/xebico_dienst.py \
  interne-skripte/verify_step.py \
  werkzeuge/konfiguration-anwenden \
  pilot-werkzeuge/demo-gesamtkette; do
  grep -qx "$item" <<<"$archive_listing" ||
    fail "Runtime-Archiv enthält nicht: $item"
done

# Markdown-Kompatibilitätsproben.
step="$root/step1-html-css-js.md"
grep -q '<style>' "$step" || fail "Inline-CSS-Probe fehlt."
grep -q '<script>' "$step" || fail "Inline-JavaScript-Probe fehlt."
grep -q '<iframe' "$step" || fail "iframe-Probe fehlt."
grep -q '{{TRAFFIC_HOST1_8080}}/architektur' "$step" ||
  fail "Architektur-Traffic-Link fehlt."
grep -q "status/ui-js.result" "$step" ||
  fail "JavaScript-Ergebnisdatei fehlt."

# Der Dienst muss die eigenständige Demo bereitstellen.
grep -q 'self.path == "/architektur"' \
  "$root/runtime/dienst/xebico_dienst.py" ||
  fail "HTTP-Endpunkt /architektur fehlt."
grep -q 'architecture_page' "$root/runtime/dienst/xebico_dienst.py" ||
  fail "Architektur-HTML fehlt."

# Ausführungsrechte und Schreibschutz.
while IFS= read -r -d '' file; do
  mode="$(stat -c '%a' "$file")"
  other_digit=$((10#$mode % 10))
  if (((other_digit & 2) != 0)); then
    fail "Datei ist für andere beschreibbar: ${file#"$root/"} ($mode)"
  fi
done < <(find "$root" -type f -print0)

executables=(
  intro-background.sh
  intro-foreground.sh
  killercoda-entry.sh
  killercoda-wait.sh
  validate-package.sh
  test-local.sh
  verify-01-html-css-js.sh
  verify-02-prozess-port.sh
  verify-03-bindung.sh
  verify-04-http.sh
  verify-05-register.sh
  verify-06-gesamt.sh
  runtime/setup.sh
  runtime/reset.sh
)
for item in "${executables[@]}"; do
  [[ -x "$root/$item" ]] || fail "Ausführungsrecht fehlt: $item"
done

if find "$root" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
  -o -iname '*.gif' -o -iname '*.webp' \) | grep -q .; then
  fail "Das Paket enthält Bilddateien; der Pilot soll Interaktivität testen."
fi

if ((errors > 0)); then
  echo "$errors Paketfehler gefunden." >&2
  exit 1
fi

echo "Killercoda-V2-Paketvalidierung erfolgreich."
