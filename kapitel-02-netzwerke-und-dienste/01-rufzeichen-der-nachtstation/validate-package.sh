#!/usr/bin/env bash
set -Eeuo pipefail

readonly root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
errors=0

fail() {
  printf 'FEHLER: %s\n' "$*" >&2
  errors=$((errors + 1))
}

required_files=(
  index.json
  intro.md
  step1-orientierung.md
  step2-hostname.md
  step3-ip-address.md
  step4-loopback.md
  step5-weitere-schnittstelle.md
  challenge.md
  finish.md
  setup.sh
  verify.sh
  solution.md
  trainer-guide.md
  test-plan.md
  test-results-template.md
  CHANGELOG.md
  README-INTEGRATION.md
  validate-package.sh
)

for relative in "${required_files[@]}"; do
  path="${root}/${relative}"
  [[ -f "${path}" ]] || fail "Pflichtdatei fehlt: ${relative}"
  if [[ -f "${path}" && ! -s "${path}" ]]; then
    fail "Datei ist leer: ${relative}"
  fi
done

if ! /usr/bin/python3 - "${root}/index.json" "${root}" <<'PY_INDEX'
from __future__ import annotations

import json
import pathlib
import sys

index_path = pathlib.Path(sys.argv[1])
root = pathlib.Path(sys.argv[2])

data = json.loads(index_path.read_text(encoding="utf-8"))

allowed_top = {"title", "description", "details", "backend"}
unknown_top = set(data) - allowed_top
if unknown_top:
    raise SystemExit(
        "Unbestätigte Top-Level-Felder: " + ", ".join(sorted(unknown_top))
    )

if data.get("backend") != {"imageid": "ubuntu"}:
    raise SystemExit("Backend muss exakt imageid=ubuntu verwenden.")

details = data.get("details")
if not isinstance(details, dict):
    raise SystemExit("details fehlt oder ist kein Objekt.")

unknown_details = set(details) - {"intro", "steps", "finish"}
if unknown_details:
    raise SystemExit(
        "Unbestätigte details-Felder: " + ", ".join(sorted(unknown_details))
    )

intro = details.get("intro")
if not isinstance(intro, dict):
    raise SystemExit("intro fehlt.")

unknown_intro = set(intro) - {"title", "text", "foreground", "background"}
if unknown_intro:
    raise SystemExit(
        "Unbestätigte Intro-Felder: " + ", ".join(sorted(unknown_intro))
    )

if intro.get("foreground") != "setup.sh":
    raise SystemExit("Das Intro muss setup.sh direkt als Foreground verwenden.")

steps = details.get("steps")
if not isinstance(steps, list) or len(steps) != 6:
    raise SystemExit("Es werden genau sechs Lernschritte erwartet.")

for number, step in enumerate(steps, start=1):
    if not isinstance(step, dict):
        raise SystemExit(f"Schritt {number} ist kein Objekt.")
    unknown = set(step) - {
        "title", "text", "foreground", "background", "verify"
    }
    if unknown:
        raise SystemExit(
            f"Unbestätigte Felder in Schritt {number}: "
            + ", ".join(sorted(unknown))
        )
    for key in ("text", "foreground", "background", "verify"):
        if key not in step:
            continue
        reference = step[key]
        if pathlib.PurePosixPath(reference).is_absolute():
            raise SystemExit(
                f"Absolute Indexreferenz in Schritt {number}.{key}: {reference}"
            )
        if ".." in pathlib.PurePosixPath(reference).parts:
            raise SystemExit(
                f"Pfad verlässt den Szenarioordner: {reference}"
            )
        if not (root / reference).is_file():
            raise SystemExit(
                f"Referenz fehlt: Schritt {number}.{key} -> {reference}"
            )

for section_name, section in (
    ("intro", intro),
    ("finish", details.get("finish")),
):
    if not isinstance(section, dict):
        raise SystemExit(f"{section_name} fehlt.")
    for key in ("text", "foreground", "background"):
        if key not in section:
            continue
        reference = section[key]
        if pathlib.PurePosixPath(reference).is_absolute():
            raise SystemExit(
                f"Absolute Indexreferenz in {section_name}.{key}: {reference}"
            )
        if ".." in pathlib.PurePosixPath(reference).parts:
            raise SystemExit(
                f"Pfad verlässt den Szenarioordner: {reference}"
            )
        if not (root / reference).is_file():
            raise SystemExit(
                f"Referenz fehlt: {section_name}.{key} -> {reference}"
            )

challenge = steps[-1]
if challenge.get("text") != "challenge.md":
    raise SystemExit("Der letzte Schritt muss challenge.md verwenden.")
if challenge.get("verify") != "verify.sh":
    raise SystemExit("Die Challenge muss verify.sh referenzieren.")

referenced = {
    intro.get("text"),
    intro.get("foreground"),
    *(step.get("text") for step in steps),
    *(step.get("verify") for step in steps if step.get("verify")),
    details["finish"].get("text"),
}
for internal in {
    "solution.md",
    "trainer-guide.md",
    "test-plan.md",
    "test-results-template.md",
    "README-INTEGRATION.md",
}:
    if internal in referenced:
        raise SystemExit(
            f"Interne Wartungsdatei darf nicht im Szenario erscheinen: {internal}"
        )
PY_INDEX
then
  fail "index.json oder seine Referenzen sind ungültig."
fi

script_files=(
  setup.sh
  verify.sh
  validate-package.sh
)

for relative in "${script_files[@]}"; do
  path="${root}/${relative}"
  bash -n "${path}" || fail "Bash-Syntax ungültig: ${relative}"
  [[ "$(head -n 1 "${path}")" == '#!/usr/bin/env bash' ]] ||
    fail "Falscher Shebang: ${relative}"
  grep -q '^set -Eeuo pipefail$' "${path}" ||
    fail "set -Eeuo pipefail fehlt: ${relative}"
  [[ -x "${path}" ]] || fail "Ausführungsrecht fehlt: ${relative}"
done

if ! /usr/bin/python3 - "${root}/setup.sh" <<'PY_EMBEDDED'
from __future__ import annotations

import pathlib
import re
import sys

setup = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
match = re.search(
    r"<<'PY_NETWORK_STATE'\n(.*?)\nPY_NETWORK_STATE\n",
    setup,
    flags=re.DOTALL,
)
if not match:
    raise SystemExit("Der eingebettete Netzwerkselektor fehlt.")

compile(match.group(1), "network-state.py", "exec")
PY_EMBEDDED
then
  fail "Der eingebettete Python-Netzwerkselektor ist syntaktisch ungültig."
fi

participant_files=(
  intro.md
  step1-orientierung.md
  step2-hostname.md
  step3-ip-address.md
  step4-loopback.md
  step5-weitere-schnittstelle.md
  challenge.md
  finish.md
)

for relative in "${participant_files[@]}"; do
  path="${root}/${relative}"

  if grep -Eq '(^|[^[:alnum:]_])ip[[:space:]]+a([^[:alnum:]_]|$)' "${path}"; then
    fail "Nicht zugelassene Kurzform ip a im Teilnehmertext: ${relative}"
  fi

  if grep -Eq '(^|[[:space:]`])ip[[:space:]]+route([[:space:]`]|$)' "${path}"; then
    fail "Routingbefehl im Teilnehmertext: ${relative}"
  fi

  if grep -Eqi '\b(ifconfig|netstat|nslookup|nmap|lsof)\b' "${path}"; then
    fail "Nicht vorgesehener Netzwerkbefehl im Teilnehmertext: ${relative}"
  fi

  if grep -Eqi '\b(TCP|Socket|DNS|Subnetting|CIDR|Firewall|NAT)\b' "${path}"; then
    fail "Ausgeschlossener Fachinhalt im Teilnehmertext: ${relative}"
  fi
done

if grep -REn --exclude='validate-package.sh' \
  '\b(eth[0-9]+|ens[0-9]+|enp[0-9]+s[0-9]+)\b' "${root}" >/dev/null; then
  fail "Verdächtig fest codierter realer Schnittstellenname gefunden."
fi

if ! /usr/bin/python3 - "${root}" <<'PY_IPS'
from __future__ import annotations

import ipaddress
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
allowed = {
    ipaddress.IPv4Address("127.0.0.1"),
    ipaddress.IPv4Address("127.0.1.1"),
}

pattern = re.compile(
    r"(?<![0-9])(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?![0-9])"
)

violations = []
for path in root.rglob("*"):
    if not path.is_file() or path.name == "validate-package.sh":
        continue
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue
    for match in pattern.finditer(text):
        try:
            address = ipaddress.IPv4Address(match.group(0))
        except ipaddress.AddressValueError:
            continue
        if address not in allowed:
            violations.append(
                f"{path.relative_to(root)}:{match.group(0)}"
            )

if violations:
    raise SystemExit(
        "Verdächtig fest codierte IPv4-Adresse(n): "
        + ", ".join(violations)
    )
PY_IPS
then
  fail "Feste dynamische IPv4-Adresse gefunden."
fi

for forbidden in \
  'curl http' \
  'https://' \
  'http://' \
  'pkill' \
  'killall' \
  'eval ' \
  'apt install' \
  'apt-get' \
  'sleep '; do
  if grep -RFn --exclude='validate-package.sh' "${forbidden}" "${root}" >/dev/null; then
    fail "Verbotenes oder unnötiges Muster gefunden: ${forbidden}"
  fi
done

for documentation in \
  solution.md \
  trainer-guide.md \
  test-plan.md \
  README-INTEGRATION.md; do
  path="${root}/${documentation}"
  grep -q 'Standardroute' "${path}" ||
    fail "Dynamische Auswahlregel unvollständig dokumentiert: ${documentation}"
  grep -qi 'alphabet' "${path}" ||
    fail "Alphabetischer Fallback fehlt: ${documentation}"
done

for marker in \
  'Hostname:' \
  'Loopback-Schnittstelle:' \
  'Loopback-Adresse:' \
  'Weitere Netzwerkschnittstelle:' \
  'IPv4-Adresse dieser Schnittstelle:'; do
  grep -Fq "${marker}" "${root}/setup.sh" ||
    fail "Pflichtfeld fehlt im Setup-Template: ${marker}"
  grep -Fq "${marker%:}" "${root}/verify.sh" ||
    fail "Pflichtfeld fehlt in Verify: ${marker}"
done

if find "${root}" -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
     -o -iname '*.gif' -o -iname '*.webp' \) |
  grep -q .; then
  fail "Unerwartete Bilddatei im Workshoppaket."
fi

while IFS= read -r -d '' path; do
  mode="$(stat -c '%a' "${path}")"
  other_digit=$((10#${mode} % 10))
  if (((other_digit & 2) != 0)); then
    fail "Datei ist für andere beschreibbar: ${path#${root}/} (${mode})"
  fi
done < <(find "${root}" -type f -print0)

if grep -RFn --exclude='validate-package.sh' \
  -e 'TODO' -e 'FIXME' -e 'TBD' "${root}" >/dev/null; then
  fail "Unfertiger Platzhalter TODO/FIXME/TBD gefunden."
fi

if ((errors > 0)); then
  printf '%s Paketfehler gefunden.\n' "${errors}" >&2
  exit 1
fi

printf '%s\n' "Paketvalidierung erfolgreich."
