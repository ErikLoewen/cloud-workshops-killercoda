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
  test-local.sh
  test-checklist.md
  pilot-results-template.md
  assets/kapitel-02-killercoda-runtime.tar.gz
  assets/killercoda-entry.sh
  assets/killercoda-wait.sh
  runtime/setup.sh
  runtime/reset.sh
  runtime/dienst/xebico_dienst.py
  runtime/interne-skripte/verify_step.py
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
unknown_top = set(data) - allowed_top
if unknown_top:
    raise SystemExit("Unbestätigte Top-Level-Felder: " + ", ".join(sorted(unknown_top)))

if data.get("backend") != {"imageid": "ubuntu"}:
    raise SystemExit("Backend muss exakt imageid=ubuntu verwenden.")

details = data.get("details")
if not isinstance(details, dict):
    raise SystemExit("details fehlt oder ist kein Objekt.")

allowed_details = {"intro", "steps", "finish", "assets"}
unknown_details = set(details) - allowed_details
if unknown_details:
    raise SystemExit(
        "Unbestätigte details-Felder: "
        + ", ".join(sorted(unknown_details))
    )

for section_name in ("intro", "finish"):
    section = details.get(section_name)
    if not isinstance(section, dict):
        raise SystemExit(f"{section_name} fehlt.")
    allowed = {"title", "text", "foreground", "background"}
    unknown = set(section) - allowed
    if unknown:
        raise SystemExit(
            f"Unbestätigte Felder in {section_name}: "
            + ", ".join(sorted(unknown))
        )
    for key in ("text", "foreground", "background"):
        if key in section and not (root / section[key]).is_file():
            raise SystemExit(
                f"Referenz fehlt: {section_name}.{key} -> {section[key]}"
            )

steps = details.get("steps")
if not isinstance(steps, list) or len(steps) != 6:
    raise SystemExit("Genau sechs Schritte werden erwartet.")

allowed_step = {"title", "text", "foreground", "background", "verify"}
for number, step in enumerate(steps, 1):
    unknown = set(step) - allowed_step
    if unknown:
        raise SystemExit(
            f"Unbestätigte Felder in Schritt {number}: "
            + ", ".join(sorted(unknown))
        )
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
    allowed_asset = {"file", "target", "chmod"}
    unknown = set(item) - allowed_asset
    if unknown:
        raise SystemExit(
            "Unbestätigte Asset-Felder: "
            + ", ".join(sorted(unknown))
        )

    file_name = item.get("file")
    target = item.get("target")
    chmod = item.get("chmod")

    # Killercoda sucht Upload-Dateien im Szenario-Unterordner assets/.
    asset_path = root / "assets" / file_name
    if not asset_path.is_file():
        raise SystemExit(
            f"Asset fehlt unter assets/: {file_name}"
        )

    actual.add((file_name, target, chmod))

if actual != expected:
    raise SystemExit("Assetliste entspricht nicht dem freigegebenen Sollzustand.")
PY
then
  fail "index.json oder Assetreferenzen sind ungültig."
fi

for file in intro-background.sh intro-foreground.sh; do
  grep -q 'BASH_SOURCE' "$root/$file" &&
    fail "$file darf BASH_SOURCE nicht verwenden."
  grep -q 'script_dir' "$root/$file" &&
    fail "$file darf kein relatives script_dir verwenden."
done

background_command="$(
  grep -vE '^(#!|set |$)' "$root/intro-background.sh"
)"
foreground_command="$(
  grep -vE '^(#!|set |$)' "$root/intro-foreground.sh"
)"

[[ "$background_command" == "/tmp/kapitel-02-killercoda-entry.sh" ]] ||
  fail "Intro-Background muss den absoluten Asset-Entry aufrufen."

[[ "$foreground_command" == "/tmp/kapitel-02-killercoda-wait.sh" ]] ||
  fail "Intro-Foreground muss den absoluten Asset-Warter aufrufen."

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
  find "$root" -type f \( \
    -name '*.sh' \
    -o -path "$root/runtime/werkzeuge/*" \
    -o -path "$root/runtime/pilot-werkzeuge/*" \
    -o -path "$root/runtime/interne-skripte/dienststeuerung" \
    -o -path "$root/runtime/interne-skripte/register-apply-root" \
  \) -print0
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

archive="$root/assets/kapitel-02-killercoda-runtime.tar.gz"
archive_listing="$(tar -tzf "$archive")" ||
  fail "Runtime-Archiv ist nicht lesbar."

for item in \
  setup.sh \
  reset.sh \
  dienst/xebico_dienst.py \
  interne-skripte/verify_step.py \
  werkzeuge/konfiguration-anwenden \
  pilot-werkzeuge/textdemo-name \
  pilot-werkzeuge/textdemo-dienst \
  pilot-werkzeuge/textdemo-bindung \
  pilot-werkzeuge/textdemo-http; do
  grep -qx "$item" <<<"$archive_listing" ||
    fail "Runtime-Archiv enthält nicht: $item"
done

step="$root/step1-interaktive-demonstrationen.md"
grep -q '<details>' "$step" ||
  fail "Native details-Demonstrationen fehlen."
grep -q '{{exec}}' "$step" ||
  fail "Ausführbare Markdownaktionen fehlen."
grep -q '{{TRAFFIC_HOST1_8080}}/architektur' "$step" ||
  fail "Architektur-Traffic-Link fehlt."

if grep -Eq '^[[:space:]]*<(style|script|iframe)([[:space:]>])' "$step"; then
  fail "Schritt 1 darf keine vom Frontend blockierten Inline-Elemente enthalten."
fi

grep -q 'self.path == "/architektur"' \
  "$root/runtime/dienst/xebico_dienst.py" ||
  fail "HTTP-Endpunkt /architektur fehlt."

grep -q 'architecture_page' \
  "$root/runtime/dienst/xebico_dienst.py" ||
  fail "HTML/CSS/JS-Architektur-Web-App fehlt."

executables=(
  intro-background.sh
  intro-foreground.sh
  validate-package.sh
  test-local.sh
  verify-01-interaktive-demonstrationen.sh
  verify-02-prozess-port.sh
  verify-03-bindung.sh
  verify-04-http.sh
  verify-05-register.sh
  verify-06-gesamt.sh
  assets/killercoda-entry.sh
  assets/killercoda-wait.sh
  runtime/setup.sh
  runtime/reset.sh
)

for item in "${executables[@]}"; do
  [[ -x "$root/$item" ]] || fail "Ausführungsrecht fehlt: $item"
done

while IFS= read -r -d '' file; do
  mode="$(stat -c '%a' "$file")"
  other_digit=$((10#$mode % 10))
  if (((other_digit & 2) != 0)); then
    fail "Datei ist für andere beschreibbar: ${file#"$root/"} ($mode)"
  fi
done < <(find "$root" -type f -print0)

if find "$root" -type f \( \
  -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
  -o -iname '*.gif' -o -iname '*.webp' \
\) | grep -q .; then
  fail "Das Paket enthält Bilddateien."
fi

if ((errors > 0)); then
  echo "$errors Paketfehler gefunden." >&2
  exit 1
fi

echo "Killercoda-V3-Paketvalidierung erfolgreich."
