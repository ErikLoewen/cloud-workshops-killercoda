#!/usr/bin/env bash
set -Eeuo pipefail

mode="system"
sandbox_root=""

if (($# > 0)); then
  if [[ "$1" == "--sandbox" && $# == 2 ]]; then
    mode="sandbox"
    sandbox_root="$(mkdir -p "$2" && cd "$2" && pwd -P)"
  else
    printf '%s\n' 'Verwendung: setup.sh [--sandbox VERZEICHNIS]' >&2
    exit 2
  fi
fi

fail() {
  printf 'Setup-Fehler: %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 ||
    fail "Benötigtes Werkzeug fehlt: $1"
}

for command_name in \
  bash python3 curl ss pgrep ps getent ip awk sed grep install \
  nohup sort stat mktemp hostname; do
  require_command "$command_name"
done

if [[ "$mode" == "system" ]]; then
  [[ "$(id -u)" == "0" ]] ||
    fail "Der Killercoda-Systemmodus muss als root laufen."

  for command_name in \
    groupadd useradd usermod runuser sudo visudo chown chmod; do
    require_command "$command_name"
  done

  readonly lab_user="telegrafist"
  readonly lab_home="/home/${lab_user}"
  readonly workdir="${lab_home}/nachtstation"
  readonly install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
  readonly state_dir="/var/lib/labforge/nachtleitung-killercoda-pilot"
  readonly hosts_file="/etc/hosts"
else
  readonly lab_user="$(id -un)"
  readonly lab_home="${sandbox_root}/home/telegrafist"
  readonly workdir="${lab_home}/nachtstation"
  readonly install_dir="${sandbox_root}/opt/labforge/kapitel-02-killercoda-pilot"
  readonly state_dir="${sandbox_root}/var/lib/labforge/nachtleitung-killercoda-pilot"
  readonly hosts_file="${sandbox_root}/etc/hosts"
fi

if [[ "$mode" == "system" ]]; then
  getent group telegrafist >/dev/null 2>&1 || groupadd telegrafist
  if ! id telegrafist >/dev/null 2>&1; then
    useradd --create-home --home-dir /home/telegrafist \
      --shell /bin/bash --gid telegrafist telegrafist
  fi
  usermod --home /home/telegrafist --shell /bin/bash \
    --gid telegrafist telegrafist >/dev/null

  readonly pilot_uid="$(id -u telegrafist)"
  readonly pilot_gid="$(id -g telegrafist)"
else
  readonly pilot_uid="$(id -u)"
  readonly pilot_gid="$(id -g)"
fi

install -d -m 0755 "$install_dir"
install -d -m 0755 \
  "$install_dir/dienst" \
  "$install_dir/interne-skripte"

cat >"$install_dir/dienst/xebico_dienst.py" <<'__DIENST_XEBICO_DIENST_PY__'
#!/usr/bin/env python3
"""Kleiner deterministischer HTTP-Hostprozess für den technischen Pilot."""

from __future__ import annotations

import argparse
import ctypes
import os
import signal
import stat
import sys
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parents[1] / "interne-skripte"
sys.path.insert(0, str(INTERNAL_DIR))

from pilotlib import PilotValidationError, parse_config  # noqa: E402

PROCESS_NAME = b"xebico-dienst"
PR_SET_NAME = 15
MAX_MESSAGE_BYTES = 8192


def set_process_name() -> None:
    libc = ctypes.CDLL(None, use_errno=True)
    libc.prctl.argtypes = [
        ctypes.c_int,
        ctypes.c_char_p,
        ctypes.c_ulong,
        ctypes.c_ulong,
        ctypes.c_ulong,
    ]
    libc.prctl.restype = ctypes.c_int
    result = libc.prctl(PR_SET_NAME, PROCESS_NAME, 0, 0, 0)
    if result != 0:
        errno = ctypes.get_errno()
        raise OSError(errno, os.strerror(errno))


def read_message(path: Path) -> bytes:
    flags = os.O_RDONLY
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        fd = os.open(path, flags)
    except OSError as exc:
        raise RuntimeError(f"Meldungsdatei kann nicht sicher geöffnet werden: {exc}") from exc

    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode):
            raise RuntimeError("Meldungsdatei ist keine reguläre Datei.")
        if info.st_size > MAX_MESSAGE_BYTES:
            raise RuntimeError(
                f"Meldungsdatei ist größer als {MAX_MESSAGE_BYTES} Byte."
            )
        data = b""
        while len(data) <= MAX_MESSAGE_BYTES:
            chunk = os.read(fd, min(4096, MAX_MESSAGE_BYTES + 1 - len(data)))
            if not chunk:
                break
            data += chunk
        if len(data) > MAX_MESSAGE_BYTES:
            raise RuntimeError("Meldungsdatei überschreitet die Größenbegrenzung.")
        data.decode("utf-8")
        return data
    except UnicodeDecodeError as exc:
        raise RuntimeError("Meldungsdatei ist nicht gültiges UTF-8.") from exc
    finally:
        os.close(fd)


def architecture_page() -> bytes:
    """Eigenständige, lokale HTML/CSS/JS-Demonstration ohne externe Ressourcen."""
    html = r"""<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Nachtleitung – interaktive Netzwerkarchitektur</title>
<style>
:root {
  color-scheme: dark;
  font-family: system-ui, sans-serif;
  --panel: #111827;
  --line: #64748b;
  --active: #22d3ee;
  --ok: #86efac;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  min-height: 100vh;
  padding: 1rem;
  background: #020617;
  color: #e2e8f0;
}
main {
  max-width: 900px;
  margin: 0 auto;
}
h1 { font-size: 1.35rem; }
.architecture {
  display: grid;
  grid-template-columns: repeat(4, minmax(120px, 1fr));
  align-items: center;
  gap: .65rem;
  margin: 1.25rem 0;
}
.node {
  min-height: 7rem;
  padding: .8rem;
  border: 2px solid #334155;
  border-radius: .8rem;
  background: var(--panel);
  transition: border-color .2s, transform .2s, box-shadow .2s;
}
.node strong { display: block; color: #f8fafc; }
.node small { display: block; margin-top: .35rem; color: #94a3b8; }
.node.active {
  border-color: var(--active);
  transform: translateY(-3px);
  box-shadow: 0 0 0 3px rgb(34 211 238 / .18);
}
.arrow {
  display: none;
  color: var(--line);
  text-align: center;
}
.controls {
  display: flex;
  flex-wrap: wrap;
  gap: .6rem;
}
button {
  border: 0;
  border-radius: .55rem;
  padding: .65rem .9rem;
  font-weight: 700;
  cursor: pointer;
}
#status {
  margin-top: 1rem;
  padding: .75rem;
  border-left: .35rem solid var(--ok);
  background: #052e16;
}
@media (max-width: 720px) {
  .architecture { grid-template-columns: 1fr; }
}
</style>
</head>
<body>
<main>
  <h1>Interaktive Netzwerkarchitektur der Nachtleitung</h1>
  <p>Die Schaltfläche hebt nacheinander die bekannten Diagnoseebenen hervor.</p>

  <section class="architecture" aria-label="Netzwerkarchitektur">
    <article class="node active" data-label="Name und Adresse">
      <strong>1 · Name</strong>
      <small>xebico → Stationsadresse</small>
    </article>
    <article class="node" data-label="Prozess und Listener">
      <strong>2 · Dienst</strong>
      <small>xebico-dienst → TCP 8080</small>
    </article>
    <article class="node" data-label="Bind-Adresse">
      <strong>3 · Bindung</strong>
      <small>0.0.0.0:8080</small>
    </article>
    <article class="node" data-label="HTTP-Antwort">
      <strong>4 · HTTP</strong>
      <small>200 · Header · Body</small>
    </article>
  </section>

  <div class="controls">
    <button id="next" type="button">Nächste Diagnoseebene</button>
    <button id="reset" type="button">Zurücksetzen</button>
  </div>

  <p id="status" role="status">JavaScript aktiv · Ebene: Name und Adresse</p>
</main>
<script>
(() => {
  const nodes = [...document.querySelectorAll('.node')];
  const status = document.getElementById('status');
  let current = 0;

  function render() {
    nodes.forEach((node, index) => node.classList.toggle('active', index === current));
    status.textContent = `JavaScript aktiv · Ebene: ${nodes[current].dataset.label}`;
  }

  document.getElementById('next').addEventListener('click', () => {
    current = (current + 1) % nodes.length;
    render();
  });

  document.getElementById('reset').addEventListener('click', () => {
    current = 0;
    render();
  });
})();
</script>
</body>
</html>
"""
    return html.encode("utf-8")

class PilotServer(ThreadingHTTPServer):
    daemon_threads = True
    allow_reuse_address = True


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "XebicoPilot/1.0"
    sys_version = ""

    def log_message(self, _format: str, *args: object) -> None:
        # Keine Anfrageprotokolle: Der Pilot erzeugt kein unkontrolliertes Logwachstum.
        return

    def _respond(
        self,
        status: int,
        body: bytes,
        x_status: str,
        content_type: str = "text/plain; charset=utf-8",
    ) -> None:
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("X-Xebico-Status", x_status)
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(body)
        self.close_connection = True

    def do_GET(self) -> None:  # noqa: N802
        if self.path == "/healthz":
            self._respond(200, b"bereit\n", "BEREIT")
            return

        if self.path == "/architektur":
            self._respond(
                200,
                architecture_page(),
                "DEMO",
                "text/html; charset=utf-8",
            )
            return

        if self.path != "/meldung":
            self._respond(
                404,
                b"FEHLER: MELDUNG NICHT GEFUNDEN\nHINWEIS: PRUEFE DEN PFAD\n",
                "NICHT-GEFUNDEN",
            )
            return

        status = self.server.config["HTTP_STATUS"]  # type: ignore[attr-defined]
        if status == "200":
            try:
                body = read_message(self.server.message_path)  # type: ignore[attr-defined]
            except RuntimeError:
                self._respond(
                    500,
                    b"FEHLER: MELDUNGSDATEI NICHT LESBAR\n",
                    "STOERUNG",
                )
                return
            self._respond(200, body, "EMPFANGEN")
        elif status == "404":
            self._respond(
                404,
                b"FEHLER: MELDUNG NICHT GEFUNDEN\nHINWEIS: PRUEFE DEN PFAD\n",
                "NICHT-GEFUNDEN",
            )
        else:
            self._respond(
                500,
                b"FEHLER: GEGENSTELLE KANN MELDUNG NICHT LIEFERN\n"
                b"HINWEIS: SERVER HAT INTERN EINE STOERUNG\n",
                "STOERUNG",
            )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", required=True, type=Path)
    parser.add_argument("--base-dir", required=True, type=Path)
    args = parser.parse_args()

    try:
        config = parse_config(args.config, args.base_dir)
        set_process_name()
    except (PilotValidationError, OSError) as exc:
        print(f"Start abgebrochen: {exc}", file=sys.stderr)
        return 1

    base_dir = args.base_dir.resolve()
    message_path = (base_dir / config["MELDUNG_DATEI"]).resolve()

    try:
        server = PilotServer(
            (config["BIND_ADRESSE"], int(config["PORT"])),
            Handler,
        )
    except OSError as exc:
        print(
            f"Listener kann nicht gestartet werden auf "
            f"{config['BIND_ADRESSE']}:{config['PORT']}: {exc}",
            file=sys.stderr,
        )
        return 1

    server.config = config  # type: ignore[attr-defined]
    server.message_path = message_path  # type: ignore[attr-defined]

    shutdown_started = threading.Event()

    def request_shutdown(_signum: int, _frame: object) -> None:
        if not shutdown_started.is_set():
            shutdown_started.set()
            threading.Thread(target=server.shutdown, daemon=True).start()

    signal.signal(signal.SIGTERM, request_shutdown)
    signal.signal(signal.SIGINT, request_shutdown)

    print(
        f"xebico-dienst bereit: {config['BIND_ADRESSE']}:{config['PORT']} "
        f"HTTP_STATUS={config['HTTP_STATUS']}",
        flush=True,
    )

    try:
        server.serve_forever(poll_interval=0.2)
    finally:
        server.server_close()
        print("xebico-dienst beendet.", flush=True)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
__DIENST_XEBICO_DIENST_PY__

cat >"$install_dir/interne-skripte/pilotlib.py" <<'__INTERNE_SKRIPTE_PILOTLIB_PY__'
#!/usr/bin/env python3
"""Gemeinsame, seiteneffektfreie Parserfunktionen des technischen Piloten."""

from __future__ import annotations

import ipaddress
import os
import re
import stat
from pathlib import Path
from typing import Dict

CONFIG_KEYS = (
    "BIND_ADRESSE",
    "PORT",
    "HTTP_STATUS",
    "MELDUNG_DATEI",
)

ALLOWED_VALUES = {
    "BIND_ADRESSE": {"127.0.0.1", "0.0.0.0"},
    "PORT": {"8080", "8081"},
    "HTTP_STATUS": {"200", "404", "500"},
    "MELDUNG_DATEI": {"meldungen/xebico.txt"},
}

KEY_RE = re.compile(r"^[A-Z_]+$")
VALUE_RE = re.compile(r"^[A-Za-z0-9._/-]+$")


class PilotValidationError(ValueError):
    """Validierungsfehler mit verständlicher Diagnose."""


def _read_regular_file_nofollow(path: Path, max_bytes: int) -> bytes:
    flags = os.O_RDONLY
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        fd = os.open(path, flags)
    except FileNotFoundError as exc:
        raise PilotValidationError(f"Datei fehlt: {path}") from exc
    except OSError as exc:
        raise PilotValidationError(f"Datei kann nicht sicher geöffnet werden: {path}: {exc}") from exc

    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode):
            raise PilotValidationError(f"Keine reguläre Datei: {path}")
        if info.st_size > max_bytes:
            raise PilotValidationError(
                f"Datei ist zu groß: {path} ({info.st_size} Byte; maximal {max_bytes})"
            )
        data = b""
        while len(data) <= max_bytes:
            chunk = os.read(fd, min(4096, max_bytes + 1 - len(data)))
            if not chunk:
                break
            data += chunk
        if len(data) > max_bytes:
            raise PilotValidationError(f"Datei überschreitet {max_bytes} Byte: {path}")
        return data
    finally:
        os.close(fd)


def parse_config(config_path: Path, base_dir: Path) -> Dict[str, str]:
    """Liest die Pilotkonfiguration ohne Shell-Auswertung."""
    raw = _read_regular_file_nofollow(config_path, 4096)
    if b"\x00" in raw:
        raise PilotValidationError("Konfiguration enthält ein NUL-Zeichen.")

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PilotValidationError("Konfiguration ist nicht gültiges UTF-8.") from exc

    lines = text.splitlines()
    if not lines:
        raise PilotValidationError("Konfiguration ist leer.")

    values: Dict[str, str] = {}
    for number, line in enumerate(lines, start=1):
        if line == "":
            raise PilotValidationError(f"Leerzeile in Zeile {number} ist nicht erlaubt.")
        if line != line.strip():
            raise PilotValidationError(
                f"Leerzeichenfehler in Zeile {number}: keine führenden oder nachgestellten Leerzeichen."
            )
        if any(ch.isspace() for ch in line):
            raise PilotValidationError(
                f"Leerzeichenfehler in Zeile {number}: KEY=WERT muss ohne Leerzeichen geschrieben werden."
            )
        if line.count("=") != 1:
            raise PilotValidationError(
                f"Ungültige Syntax in Zeile {number}: erwartet wird KEY=WERT."
            )

        key, value = line.split("=", 1)
        if not KEY_RE.fullmatch(key):
            raise PilotValidationError(f"Ungültiger Schlüssel in Zeile {number}: {key!r}")
        if key not in CONFIG_KEYS:
            raise PilotValidationError(f"Unbekannter Schlüssel in Zeile {number}: {key}")
        if key in values:
            raise PilotValidationError(f"Schlüssel doppelt vorhanden: {key}")
        if not value:
            raise PilotValidationError(f"Wert fehlt für Schlüssel {key}.")
        if not VALUE_RE.fullmatch(value):
            raise PilotValidationError(
                f"Ungültige Zeichen im Wert von {key}; Shell-Sonderzeichen sind nicht erlaubt."
            )
        if value not in ALLOWED_VALUES[key]:
            allowed = ", ".join(sorted(ALLOWED_VALUES[key]))
            raise PilotValidationError(
                f"Ungültiger Wert für {key}: {value!r}. Erlaubt: {allowed}"
            )
        values[key] = value

    missing = [key for key in CONFIG_KEYS if key not in values]
    if missing:
        raise PilotValidationError("Schlüssel fehlt: " + ", ".join(missing))

    if len(lines) != len(CONFIG_KEYS):
        raise PilotValidationError(
            f"Konfiguration muss genau {len(CONFIG_KEYS)} Zeilen enthalten."
        )

    base_resolved = base_dir.resolve()
    message_path = (base_resolved / values["MELDUNG_DATEI"]).resolve()
    try:
        message_path.relative_to(base_resolved)
    except ValueError as exc:
        raise PilotValidationError("MELDUNG_DATEI verlässt das Pilotverzeichnis.") from exc

    expected = (base_resolved / "meldungen" / "xebico.txt").resolve()
    if message_path != expected:
        raise PilotValidationError(
            "MELDUNG_DATEI muss exakt meldungen/xebico.txt verwenden."
        )

    return values


def validate_hosts_line(text: str) -> tuple[str, str]:
    """Validiert exakt eine Zeile: IPV4 xebico."""
    if "\x00" in text:
        raise PilotValidationError("Registerdatei enthält ein NUL-Zeichen.")

    lines = text.splitlines()
    if len(lines) != 1:
        raise PilotValidationError("Registerdatei muss genau eine Zeile enthalten.")

    line = lines[0]
    if line != line.strip():
        raise PilotValidationError(
            "Registerzeile darf keine führenden oder nachgestellten Leerzeichen enthalten."
        )

    parts = line.split()
    if len(parts) != 2:
        raise PilotValidationError(
            "Erwartetes Format: IP-ADRESSE xebico; zusätzliche Namen oder Felder sind nicht erlaubt."
        )

    address, name = parts
    if name != "xebico":
        raise PilotValidationError("Als Name ist ausschließlich xebico erlaubt.")

    try:
        parsed = ipaddress.IPv4Address(address)
    except ipaddress.AddressValueError as exc:
        raise PilotValidationError(f"Ungültige IPv4-Adresse: {address!r}") from exc

    if parsed.is_multicast or parsed.is_unspecified or address == "255.255.255.255":
        raise PilotValidationError(
            f"Diese IPv4-Adresse ist für den Pilot-Eintrag nicht zulässig: {address}"
        )

    return str(parsed), name
__INTERNE_SKRIPTE_PILOTLIB_PY__

cat >"$install_dir/interne-skripte/config_parser.py" <<'__INTERNE_SKRIPTE_CONFIG_PARSER_PY__'
#!/usr/bin/env python3
"""CLI für die sichere Validierung der Dienstkonfiguration."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(INTERNAL_DIR))

from pilotlib import CONFIG_KEYS, PilotValidationError, parse_config


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", required=True, type=Path)
    parser.add_argument("--base-dir", required=True, type=Path)
    parser.add_argument("--get", choices=CONFIG_KEYS)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    try:
        values = parse_config(args.config, args.base_dir)
    except PilotValidationError as exc:
        print(f"Konfiguration nicht gültig: {exc}", file=sys.stderr)
        return 1

    if args.get:
        print(values[args.get])
        return 0

    if args.json:
        print(json.dumps(values, sort_keys=True))
        return 0

    print("Konfiguration gültig.")
    print(f"Bind-Adresse: {values['BIND_ADRESSE']}")
    print(f"TCP-Port:      {values['PORT']}")
    print(f"HTTP-Status:   {values['HTTP_STATUS']}")
    print(f"Meldungsdatei: {values['MELDUNG_DATEI']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
__INTERNE_SKRIPTE_CONFIG_PARSER_PY__

cat >"$install_dir/interne-skripte/process_guard.py" <<'__INTERNE_SKRIPTE_PROCESS_GUARD_PY__'
#!/usr/bin/env python3
"""Validiert ausschließlich exakt zum Pilot gehörende Prozessinstanzen."""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

EXPECTED_COMM = "xebico-dienst"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="strict").strip()


def process_uid(pid: int) -> int:
    for line in (Path("/proc") / str(pid) / "status").read_text().splitlines():
        if line.startswith("Uid:"):
            return int(line.split()[1])
    raise RuntimeError("Uid fehlt im Prozessstatus.")


def process_cmdline(pid: int) -> list[str]:
    raw = (Path("/proc") / str(pid) / "cmdline").read_bytes()
    return [part.decode("utf-8", errors="strict") for part in raw.split(b"\0") if part]


def validate(
    pid: int,
    expected_uid: int,
    script: Path,
    config: Path,
    base_dir: Path,
) -> tuple[bool, str]:
    proc = Path("/proc") / str(pid)
    if not proc.is_dir():
        return False, "Prozess existiert nicht."

    try:
        if process_uid(pid) != expected_uid:
            return False, "Prozessbesitzer stimmt nicht."
        if read_text(proc / "comm") != EXPECTED_COMM:
            return False, "Prozessname stimmt nicht."

        args = process_cmdline(pid)
        script_real = str(script.resolve())
        config_real = str(config.resolve())
        base_real = str(base_dir.resolve())

        resolved_args = []
        for value in args:
            if value.startswith("/"):
                try:
                    resolved_args.append(str(Path(value).resolve()))
                except OSError:
                    resolved_args.append(value)
            else:
                resolved_args.append(value)

        if script_real not in resolved_args:
            return False, "Erwarteter Startpfad fehlt."

        def option_matches(option: str, expected: str) -> bool:
            for index, value in enumerate(args[:-1]):
                if value == option:
                    candidate = args[index + 1]
                    try:
                        candidate = str(Path(candidate).resolve())
                    except OSError:
                        pass
                    return candidate == expected
            return False

        if not option_matches("--config", config_real):
            return False, "Erwarteter Konfigurationspfad fehlt."
        if not option_matches("--base-dir", base_real):
            return False, "Erwartetes Arbeitsverzeichnis fehlt."
    except (OSError, UnicodeError, RuntimeError, ValueError) as exc:
        return False, f"Prozessdaten nicht sicher lesbar: {exc}"

    return True, "verwaltete Pilotinstanz"


def iter_pids() -> list[int]:
    result = []
    for entry in Path("/proc").iterdir():
        if entry.name.isdigit():
            result.append(int(entry.name))
    return sorted(result)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--expected-uid", required=True, type=int)
    parser.add_argument("--script", required=True, type=Path)
    parser.add_argument("--config", required=True, type=Path)
    parser.add_argument("--base-dir", required=True, type=Path)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--validate", type=int)
    group.add_argument("--list", action="store_true")
    args = parser.parse_args()

    if args.validate is not None:
        ok, reason = validate(
            args.validate,
            args.expected_uid,
            args.script,
            args.config,
            args.base_dir,
        )
        if ok:
            print(reason)
            return 0
        print(reason, file=sys.stderr)
        return 1

    found = []
    for pid in iter_pids():
        ok, _reason = validate(
            pid,
            args.expected_uid,
            args.script,
            args.config,
            args.base_dir,
        )
        if ok:
            found.append(pid)

    for pid in found:
        print(pid)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
__INTERNE_SKRIPTE_PROCESS_GUARD_PY__

cat >"$install_dir/interne-skripte/hosts_tool.py" <<'__INTERNE_SKRIPTE_HOSTS_TOOL_PY__'
#!/usr/bin/env python3
"""Sichere Validierung und Verwaltung des markierten Xebico-Hosts-Blocks."""

from __future__ import annotations

import argparse
import errno
import os
import stat
import sys
import tempfile
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(INTERNAL_DIR))

from pilotlib import PilotValidationError, validate_hosts_line

BEGIN = "# BEGIN LABFORGE XEBICO"
END = "# END LABFORGE XEBICO"
MAX_STAGING_BYTES = 256
MAX_HOSTS_BYTES = 1024 * 1024


def read_nofollow(
    path: Path,
    *,
    max_bytes: int,
    expected_uid: int | None = None,
) -> tuple[bytes, os.stat_result]:
    flags = os.O_RDONLY
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        fd = os.open(path, flags)
    except FileNotFoundError as exc:
        raise PilotValidationError(f"Datei fehlt: {path}") from exc
    except OSError as exc:
        raise PilotValidationError(f"Datei kann nicht sicher geöffnet werden: {path}: {exc}") from exc

    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode):
            raise PilotValidationError(f"Keine reguläre Datei: {path}")
        if expected_uid is not None and info.st_uid != expected_uid:
            raise PilotValidationError(
                f"Falscher Besitzer für {path}: UID {info.st_uid}, erwartet {expected_uid}"
            )
        if info.st_size > max_bytes:
            raise PilotValidationError(
                f"Datei ist zu groß: {path} ({info.st_size} Byte)"
            )
        data = b""
        while len(data) <= max_bytes:
            chunk = os.read(fd, min(4096, max_bytes + 1 - len(data)))
            if not chunk:
                break
            data += chunk
        if len(data) > max_bytes:
            raise PilotValidationError(f"Datei überschreitet {max_bytes} Byte: {path}")
        return data, info
    finally:
        os.close(fd)


def parse_staging(path: Path, expected_uid: int) -> tuple[str, str]:
    raw, _info = read_nofollow(
        path,
        max_bytes=MAX_STAGING_BYTES,
        expected_uid=expected_uid,
    )
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PilotValidationError("Registerdatei ist nicht gültiges UTF-8.") from exc
    return validate_hosts_line(text)


def build_hosts(original: str, address: str) -> str:
    begin_count = original.count(BEGIN)
    end_count = original.count(END)
    if begin_count != end_count or begin_count > 1:
        raise PilotValidationError(
            "Der verwaltete Xebico-Block ist beschädigt oder mehrfach vorhanden."
        )

    block = f"{BEGIN}\n{address} xebico\n{END}\n"

    if begin_count == 0:
        if original and not original.endswith("\n"):
            original += "\n"
        return original + block

    start = original.index(BEGIN)
    end_start = original.index(END, start)
    end_pos = end_start + len(END)
    if end_pos < len(original) and original[end_pos] == "\n":
        end_pos += 1

    if end_start < start:
        raise PilotValidationError("Reihenfolge der Blockmarkierungen ist ungültig.")

    return original[:start] + block + original[end_pos:]


def verify_block(text: str, address: str) -> None:
    expected = f"{BEGIN}\n{address} xebico\n{END}"
    if text.count(BEGIN) != 1 or text.count(END) != 1:
        raise PilotValidationError("Nach dem Schreiben existiert nicht genau ein Xebico-Block.")
    start = text.index(BEGIN)
    end = text.index(END, start) + len(END)
    if text[start:end] != expected:
        raise PilotValidationError("Der geschriebene Xebico-Block entspricht nicht dem Sollzustand.")


def write_hosts_safely(
    path: Path,
    original: bytes,
    original_info: os.stat_result,
    updated: bytes,
    allow_inplace_fallback: bool,
) -> None:
    parent = path.parent
    fd, temp_name = tempfile.mkstemp(prefix=".labforge-hosts.", dir=parent)
    temp_path = Path(temp_name)
    try:
        os.fchmod(fd, stat.S_IMODE(original_info.st_mode))
        try:
            os.fchown(fd, original_info.st_uid, original_info.st_gid)
        except PermissionError:
            if os.geteuid() == 0:
                raise
        os.write(fd, updated)
        os.fsync(fd)
        os.close(fd)
        fd = -1
        try:
            os.replace(temp_path, path)
            return
        except OSError as exc:
            if not allow_inplace_fallback or exc.errno not in {
                errno.EBUSY,
                errno.EXDEV,
                errno.EPERM,
                errno.EACCES,
            }:
                raise

        flags = os.O_WRONLY
        if hasattr(os, "O_NOFOLLOW"):
            flags |= os.O_NOFOLLOW
        target_fd = os.open(path, flags)
        try:
            current_info = os.fstat(target_fd)
            if (
                current_info.st_dev != original_info.st_dev
                or current_info.st_ino != original_info.st_ino
            ):
                raise PilotValidationError(
                    "Hosts-Datei wurde während der Anwendung ausgetauscht."
                )
            try:
                os.ftruncate(target_fd, 0)
                os.write(target_fd, updated)
                os.fsync(target_fd)
            except Exception:
                os.ftruncate(target_fd, 0)
                os.write(target_fd, original)
                os.fsync(target_fd)
                raise
        finally:
            os.close(target_fd)
    finally:
        if fd >= 0:
            os.close(fd)
        try:
            temp_path.unlink()
        except FileNotFoundError:
            pass


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("validate", "apply"))
    parser.add_argument("--staging", required=True, type=Path)
    parser.add_argument("--expected-owner-uid", required=True, type=int)
    parser.add_argument("--hosts", type=Path)
    parser.add_argument("--allow-inplace-fallback", action="store_true")
    args = parser.parse_args()

    try:
        address, name = parse_staging(args.staging, args.expected_owner_uid)
        if args.action == "validate":
            print("Registereintrag gültig.")
            print(f"Name:     {name}")
            print(f"Adresse:  {address}")
            return 0

        if args.hosts is None:
            raise PilotValidationError("--hosts ist für apply erforderlich.")

        original_raw, original_info = read_nofollow(
            args.hosts,
            max_bytes=MAX_HOSTS_BYTES,
        )
        try:
            original_text = original_raw.decode("utf-8")
        except UnicodeDecodeError as exc:
            raise PilotValidationError("Hosts-Datei ist nicht gültiges UTF-8.") from exc

        updated_text = build_hosts(original_text, address)
        verify_block(updated_text, address)
        updated_raw = updated_text.encode("utf-8")

        write_hosts_safely(
            args.hosts,
            original_raw,
            original_info,
            updated_raw,
            args.allow_inplace_fallback,
        )

        check_raw, _ = read_nofollow(args.hosts, max_bytes=MAX_HOSTS_BYTES)
        check_text = check_raw.decode("utf-8")
        verify_block(check_text, address)

        print("Registereintrag angewendet.")
        print(f"{address}    xebico")
        return 0
    except (PilotValidationError, OSError) as exc:
        print(f"Register nicht gültig: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
__INTERNE_SKRIPTE_HOSTS_TOOL_PY__

cat >"$install_dir/interne-skripte/station_host.py" <<'__INTERNE_SKRIPTE_STATION_HOST_PY__'
#!/usr/bin/env python3
"""Verwaltet ausschließlich den lokalen Hostnamen-Block des Piloten."""

from __future__ import annotations

import sys
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(INTERNAL_DIR))

from hosts_tool import (  # noqa: E402
    MAX_HOSTS_BYTES,
    PilotValidationError,
    read_nofollow,
    write_hosts_safely,
)

BEGIN = "# BEGIN LABFORGE NACHTSTATION"
END = "# END LABFORGE NACHTSTATION"
BLOCK = f"{BEGIN}\n127.0.1.1 nachtstation\n{END}\n"


def build(original: str) -> str:
    begins = original.count(BEGIN)
    ends = original.count(END)
    if begins != ends or begins > 1:
        raise PilotValidationError(
            "Der verwaltete Nachtstation-Block ist beschädigt oder mehrfach vorhanden."
        )
    if begins == 0:
        if original and not original.endswith("\n"):
            original += "\n"
        return original + BLOCK
    start = original.index(BEGIN)
    end = original.index(END, start) + len(END)
    if end < len(original) and original[end] == "\n":
        end += 1
    return original[:start] + BLOCK + original[end:]


def main() -> int:
    hosts = Path("/etc/hosts")
    try:
        raw, info = read_nofollow(hosts, max_bytes=MAX_HOSTS_BYTES)
        text = raw.decode("utf-8")
        updated = build(text).encode("utf-8")
        write_hosts_safely(
            hosts,
            raw,
            info,
            updated,
            allow_inplace_fallback=True,
        )
        check, _ = read_nofollow(hosts, max_bytes=MAX_HOSTS_BYTES)
        rendered = check.decode("utf-8")
        if rendered.count(BEGIN) != 1 or "127.0.1.1 nachtstation" not in rendered:
            raise PilotValidationError("Nachtstation-Block konnte nicht bestätigt werden.")
        return 0
    except (OSError, UnicodeError, PilotValidationError) as exc:
        print(f"Hostname-Block konnte nicht gesetzt werden: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
__INTERNE_SKRIPTE_STATION_HOST_PY__

cat >"$install_dir/interne-skripte/pilot_state.py" <<'__INTERNE_SKRIPTE_PILOT_STATE_PY__'
#!/usr/bin/env python3
"""Feste, ungefährliche Zustandswechsel und Live-Demonstrationen des Piloten."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

SYSTEM_INSTALL = Path("/opt/labforge/kapitel-02-killercoda-pilot")
SYSTEM_WORKDIR = Path("/home/telegrafist/nachtstation")


def paths() -> tuple[Path, Path]:
    if os.environ.get("PILOT_TEST_MODE") == "1":
        return (
            Path(os.environ["PILOT_INSTALL_DIR"]),
            Path(os.environ["PILOT_WORKDIR"]),
        )
    return SYSTEM_INSTALL, SYSTEM_WORKDIR


def run(command: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        text=True,
        capture_output=True,
        check=check,
        timeout=15,
        env={**os.environ, "NO_PROXY": "*", "no_proxy": "*"},
    )


def write_config(workdir: Path, bind: str, port: int, status: int) -> None:
    content = (
        f"BIND_ADRESSE={bind}\n"
        f"PORT={port}\n"
        f"HTTP_STATUS={status}\n"
        "MELDUNG_DATEI=meldungen/xebico.txt\n"
    )
    (workdir / "leitung-zwei" / "xebico.conf").write_text(content, encoding="utf-8")


def apply_config(workdir: Path) -> None:
    for tool in ("konfiguration-pruefen", "konfiguration-anwenden"):
        result = run([str(workdir / "werkzeuge" / tool)])
        if result.stdout:
            print(result.stdout, end="")
        if result.stderr:
            print(result.stderr, file=sys.stderr, end="")


def curl_response(url: str) -> str:
    result = run(
        [
            "curl",
            "--noproxy",
            "*",
            "--connect-timeout",
            "2",
            "--max-time",
            "5",
            "-sS",
            "-i",
            url,
        ]
    )
    return result.stdout


def marker(workdir: Path, name: str, value: str = "ok") -> None:
    path = workdir / "status" / f"{name}.ok"
    path.write_text(value + "\n", encoding="utf-8")


def station_ip(workdir: Path) -> str:
    return (workdir / "status" / "stationsadresse").read_text(encoding="utf-8").strip()


def show_process_socket(workdir: Path) -> None:
    pid_result = run(["pgrep", "-x", "xebico-dienst"], check=False)
    pid = pid_result.stdout.strip() or "nicht gefunden"
    ss_result = run(["ss", "-ltnp"], check=False)
    listener = "keine passende Listenerzeile"
    for line in ss_result.stdout.splitlines():
        if "xebico-dienst" in line:
            listener = line.strip()
            break
    print("┌─ LIVE: PROZESS → SOCKET")
    print(f"│ Prozess: xebico-dienst")
    print(f"│ PID:     {pid}")
    print(f"│ Socket:  {listener}")
    print("└─ Werte stammen aus dem aktuellen Systemzustand.")


def show_architecture(workdir: Path) -> None:
    address = run(["getent", "hosts", "xebico"], check=False).stdout.strip()
    process = run(["pgrep", "-a", "xebico-dienst"], check=False).stdout.strip()
    ss_output = run(["ss", "-ltnp"], check=False).stdout
    socket = next((line.strip() for line in ss_output.splitlines() if "xebico-dienst" in line), "")
    response = run(
        [
            "curl",
            "--noproxy",
            "*",
            "--connect-timeout",
            "1",
            "--max-time",
            "3",
            "-sS",
            "-i",
            "http://127.0.0.1:8080/meldung",
        ],
        check=False,
    ).stdout
    first_status = next((line for line in response.splitlines() if line.startswith("HTTP/")), "keine HTTP-Statuszeile")
    print("┌─ LIVE-ARCHITEKTUR DER NACHTLEITUNG")
    print(f"│ Name → Adresse: {address or 'keine Auflösung'}")
    print(f"│ Prozess:        {process or 'nicht gefunden'}")
    print(f"│ Listener:       {socket or 'nicht gefunden'}")
    print(f"│ HTTP:           {first_status}")
    print("└─ Diese Darstellung wird bei jedem Klick neu erzeugt.")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "action",
        choices=(
            "markdown-inline",
            "markdown-details",
            "markdown-interrupt",
            "demo-architektur",
            "demo-prozess-socket",
            "port-8081",
            "port-8080",
            "bindung-loopback",
            "bindung-alle",
            "http-404",
            "http-500",
            "http-200",
            "register-stationsadresse",
            "demo-gesamtkette",
            "demo-name",
            "demo-dienst",
            "demo-bindung",
            "demo-http",
        ),
    )
    args = parser.parse_args()
    install_dir, workdir = paths()

    if args.action == "markdown-inline":
        user = run(["id", "-un"]).stdout.strip()
        host = run(["hostname"]).stdout.strip()
        if user != "telegrafist" and os.environ.get("PILOT_TEST_MODE") != "1":
            print("Bitte zuerst in das Konto telegrafist wechseln.", file=sys.stderr)
            return 1
        marker(workdir, "markdown-inline", user)
        print(f"Interaktive Einzelaktion: Benutzer={user}, Hostname={host}")
        return 0

    if args.action == "markdown-details":
        show_process_socket(workdir)
        marker(workdir, "markdown-details")
        return 0

    if args.action == "markdown-interrupt":
        marker(workdir, "markdown-interrupt")
        print("Der vorherige blockierende Befehl wurde unterbrochen.")
        return 0

    if args.action == "demo-architektur":
        show_architecture(workdir)
        return 0

    if args.action == "demo-prozess-socket":
        show_process_socket(workdir)
        return 0

    if args.action == "port-8081":
        write_config(workdir, "127.0.0.1", 8081, 200)
        apply_config(workdir)
        response = curl_response("http://127.0.0.1:8081/meldung")
        if not response.startswith("HTTP/1.1 200"):
            raise RuntimeError("Port 8081 lieferte nicht HTTP 200.")
        marker(workdir, "port-8081")
        print(response)
        return 0

    if args.action == "port-8080":
        write_config(workdir, "127.0.0.1", 8080, 200)
        apply_config(workdir)
        response = curl_response("http://127.0.0.1:8080/meldung")
        if not response.startswith("HTTP/1.1 200"):
            raise RuntimeError("Port 8080 lieferte nicht HTTP 200.")
        marker(workdir, "port-8080")
        print(response)
        return 0

    if args.action == "bindung-loopback":
        write_config(workdir, "127.0.0.1", 8080, 200)
        apply_config(workdir)
        response = curl_response("http://127.0.0.1:8080/meldung")
        if not response.startswith("HTTP/1.1 200"):
            raise RuntimeError("Loopback-Test war nicht erfolgreich.")
        marker(workdir, "bindung-loopback")
        print("Loopback-Bindung aktiv und lokal erreichbar.")
        return 0

    if args.action == "bindung-alle":
        write_config(workdir, "0.0.0.0", 8080, 200)
        apply_config(workdir)
        address = station_ip(workdir)
        response = curl_response(f"http://{address}:8080/meldung")
        if not response.startswith("HTTP/1.1 200"):
            raise RuntimeError("Stationsadresse lieferte nicht HTTP 200.")
        marker(workdir, "bindung-alle")
        print(response)
        return 0

    if args.action in {"http-404", "http-500", "http-200"}:
        status = {"http-404": 404, "http-500": 500, "http-200": 200}[args.action]
        write_config(workdir, "0.0.0.0", 8080, status)
        apply_config(workdir)
        response = curl_response("http://127.0.0.1:8080/meldung")
        if not response.startswith(f"HTTP/1.1 {status}"):
            raise RuntimeError(f"Erwarteter HTTP-Status {status} fehlt.")
        marker(workdir, args.action)
        print(response)
        return 0

    if args.action == "register-stationsadresse":
        address = station_ip(workdir)
        (workdir / "register" / "xebico.hosts").write_text(
            f"{address} xebico\n",
            encoding="utf-8",
        )
        marker(workdir, "register-stationsadresse")
        print(f"Staging vorbereitet: {address} xebico")
        return 0

    if args.action == "demo-name":
        address = run(["getent", "hosts", "xebico"], check=False).stdout.strip()
        print("┌─ 1 · NAME UND ADRESSE")
        print(f"│ {address or 'xebico ist noch nicht aufgelöst'}")
        print("└─ Die Systemauflösung verbindet den Namen mit einer Adresse.")
        marker(workdir, "textdemo-name")
        return 0

    if args.action == "demo-dienst":
        process = run(["pgrep", "-a", "xebico-dienst"], check=False).stdout.strip()
        print("┌─ 2 · PROZESS UND PORT")
        print(f"│ {process or 'xebico-dienst wurde nicht gefunden'}")
        print("│ Sollport: 8080/tcp")
        print("└─ Der Prozess stellt den Dienst bereit.")
        marker(workdir, "textdemo-dienst")
        return 0

    if args.action == "demo-bindung":
        output = run(["ss", "-ltnp"], check=False).stdout
        listener = next(
            (line.strip() for line in output.splitlines() if "xebico-dienst" in line),
            "keine passende Listenerzeile",
        )
        print("┌─ 3 · LISTENER UND BIND-ADRESSE")
        print(f"│ {listener}")
        print("└─ Die lokale Adresse bestimmt, an welchen Adressen der Socket lauscht.")
        marker(workdir, "textdemo-bindung")
        return 0

    if args.action == "demo-http":
        config_port = run(
            [
                "/usr/bin/python3",
                "-I",
                str(install_dir / "interne-skripte" / "config_parser.py"),
                "--config",
                str(workdir / "leitung-zwei" / "xebico.conf"),
                "--base-dir",
                str(workdir),
                "--get",
                "PORT",
            ]
        ).stdout.strip()
        response = curl_response(
            f"http://127.0.0.1:{config_port}/meldung"
        )
        status = next(
            (line for line in response.splitlines() if line.startswith("HTTP/")),
            "keine HTTP-Statuszeile",
        )
        header = next(
            (line for line in response.splitlines() if line.lower().startswith("x-xebico-status:")),
            "X-Xebico-Status fehlt",
        )
        print("┌─ 4 · HTTP-ANTWORT")
        print(f"│ {status}")
        print(f"│ {header}")
        print("└─ Status, ausgewählter Header und Body werden getrennt gelesen.")
        marker(workdir, "textdemo-http")
        return 0

    if args.action == "demo-gesamtkette":
        show_architecture(workdir)
        address = station_ip(workdir)
        resolved = run(["getent", "hosts", "xebico"], check=False).stdout
        if address not in resolved:
            print("Gesamtkette nicht bereit: Namensauflösung abweichend.", file=sys.stderr)
            return 1
        response = curl_response("http://xebico:8080/meldung")
        required = (
            "HTTP/1.1 200",
            "X-Xebico-Status: EMPFANGEN",
            "STATUS: NACHTLEITUNG-BEREIT",
            "MELDUNG: XEBICO RUFT NACHTSTATION",
        )
        missing = [value for value in required if value not in response]
        if missing:
            print("Gesamtkette unvollständig: " + ", ".join(missing), file=sys.stderr)
            return 1
        marker(workdir, "demo-gesamtkette")
        print()
        print("GESAMTKETTE: BEREIT")
        print(response)
        return 0

    return 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, subprocess.SubprocessError) as exc:
        print(f"Pilotaktion fehlgeschlagen: {exc}", file=sys.stderr)
        raise SystemExit(1)
__INTERNE_SKRIPTE_PILOT_STATE_PY__

cat >"$install_dir/interne-skripte/verify_step.py" <<'__INTERNE_SKRIPTE_VERIFY_STEP_PY__'
#!/usr/bin/env python3
"""Zustandsneutrale Verify-Prüfungen für die Killercoda-Pilotschritte."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

if os.environ.get("PILOT_TEST_MODE") == "1":
    INSTALL = Path(os.environ["PILOT_INSTALL_DIR"])
    WORKDIR = Path(os.environ["PILOT_WORKDIR"])
else:
    INSTALL = Path("/opt/labforge/kapitel-02-killercoda-pilot")
    WORKDIR = Path("/home/telegrafist/nachtstation")


def run(command: list[str], *, user: str | None = None, check: bool = True) -> subprocess.CompletedProcess[str]:
    if user:
        command = [
            "/usr/sbin/runuser",
            "-u",
            user,
            "--",
            "/usr/bin/env",
            "-i",
            "HOME=/home/telegrafist",
            "USER=telegrafist",
            "LOGNAME=telegrafist",
            "PATH=/usr/local/bin:/usr/bin:/bin",
            *command,
        ]
    return subprocess.run(
        command,
        text=True,
        capture_output=True,
        timeout=10,
        check=check,
        env={**os.environ, "NO_PROXY": "*", "no_proxy": "*"},
    )


def fail(message: str) -> int:
    print(f"CHECK nicht erfolgreich: {message}", file=sys.stderr)
    return 1


def marker(name: str) -> bool:
    return (WORKDIR / "status" / f"{name}.ok").is_file()


def config_value(key: str) -> str:
    result = run(
        [
            "/usr/bin/python3",
            "-I",
            str(INSTALL / "interne-skripte" / "config_parser.py"),
            "--config",
            str(WORKDIR / "leitung-zwei" / "xebico.conf"),
            "--base-dir",
            str(WORKDIR),
            "--get",
            key,
        ]
    )
    return result.stdout.strip()


def managed_pids() -> list[str]:
    uid = run(["id", "-u", "telegrafist"]).stdout.strip()
    result = run(
        [
            "/usr/bin/python3",
            "-I",
            str(INSTALL / "interne-skripte" / "process_guard.py"),
            "--expected-uid",
            uid,
            "--script",
            str(INSTALL / "dienst" / "xebico_dienst.py"),
            "--config",
            str(WORKDIR / "leitung-zwei" / "xebico.conf"),
            "--base-dir",
            str(WORKDIR),
            "--list",
        ]
    )
    return [line for line in result.stdout.splitlines() if line.strip()]


def require_process_port_bind(bind: str, port: str) -> str | None:
    pids = managed_pids()
    if len(pids) != 1:
        return f"Erwartet wird genau eine verwaltete Instanz; gefunden: {len(pids)}."
    output = run(["ss", "-ltnp"]).stdout
    matching = [line for line in output.splitlines() if "xebico-dienst" in line]
    if not matching:
        return "ss -ltnp zeigt keine Listenerzeile für xebico-dienst."
    line = matching[0]
    if f":{port}" not in line:
        return f"Die Listenerzeile verwendet nicht TCP-Port {port}."
    if bind == "127.0.0.1" and f"127.0.0.1:{port}" not in line:
        return "Die erwartete Loopback-Bindung fehlt."
    if bind == "0.0.0.0" and not (
        f"0.0.0.0:{port}" in line or f"*:{port}" in line
    ):
        return "Die erwartete Wildcard-Bindung fehlt."
    return None


def http_response(url: str) -> str:
    return run(
        [
            "curl",
            "--noproxy",
            "*",
            "--connect-timeout",
            "2",
            "--max-time",
            "5",
            "-sS",
            "-i",
            url,
        ]
    ).stdout


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("step", type=int, choices=range(1, 7))
    args = parser.parse_args()

    if args.step == 1:
        required_markers = (
            "textdemo-name",
            "textdemo-dienst",
            "textdemo-bindung",
            "textdemo-http",
        )
        missing = [name for name in required_markers if not marker(name)]
        if missing:
            return fail(
                "Interaktive Textdemonstrationen fehlen: " + ", ".join(missing)
            )

        port = config_value("PORT")
        response = http_response(
            f"http://127.0.0.1:{port}/architektur"
        )
        required = (
            "HTTP/1.1 200",
            "text/html",
            "Interaktive Netzwerkarchitektur",
            "JavaScript aktiv",
            "Nächste Diagnoseebene",
        )
        missing_http = [
            value for value in required if value not in response
        ]
        if missing_http:
            return fail(
                "HTML/CSS/JS-Web-App unvollständig: "
                + ", ".join(missing_http)
            )

        print("Textdemonstrationen und interaktive Web-App bestätigt.")
        return 0

    if args.step == 2:
        for name in ("port-8081", "port-8080"):
            if not marker(name):
                return fail(f"Der Testmarker {name} fehlt.")
        error = require_process_port_bind("127.0.0.1", "8080")
        if error:
            return fail(error)
        user_ss = run(["ss", "-ltnp"], user="telegrafist").stdout
        if "xebico-dienst" not in user_ss:
            return fail(
                "ss -ltnp zeigt den Prozessnamen für telegrafist nicht. "
                "Dieser Befund ist für den Killercoda-Pilot kritisch."
            )
        print("Prozessname, PID-Sichtbarkeit und beide Pilotports bestätigt.")
        return 0

    if args.step == 3:
        for name in ("bindung-loopback", "bindung-alle"):
            if not marker(name):
                return fail(f"Der Testmarker {name} fehlt.")
        error = require_process_port_bind("0.0.0.0", "8080")
        if error:
            return fail(error)
        address = (WORKDIR / "status" / "stationsadresse").read_text().strip()
        response = http_response(f"http://{address}:8080/meldung")
        if not response.startswith("HTTP/1.1 200"):
            return fail("Die lokale Stationsadresse liefert nicht HTTP 200.")
        print("Loopback- und Wildcard-Bindung technisch bestätigt.")
        return 0

    if args.step == 4:
        for name in ("http-404", "http-500", "http-200"):
            if not marker(name):
                return fail(f"Der Testmarker {name} fehlt.")
        if config_value("HTTP_STATUS") != "200":
            return fail("Der finale Konfigurationsstatus ist nicht 200.")
        response = http_response("http://127.0.0.1:8080/meldung")
        required = (
            "HTTP/1.1 200",
            "X-Xebico-Status: EMPFANGEN",
            "STATUS: NACHTLEITUNG-BEREIT",
        )
        if any(value not in response for value in required):
            return fail("Die finale HTTP-200-Antwort ist unvollständig.")
        print("HTTP 404, 500 und finaler Erfolgszustand bestätigt.")
        return 0

    if args.step == 5:
        if not marker("register-stationsadresse"):
            return fail("Die Stationsadresse wurde noch nicht in der Staging-Datei vorbereitet.")
        address = (WORKDIR / "status" / "stationsadresse").read_text().strip()
        resolved = run(["getent", "hosts", "xebico"], check=False).stdout
        if address not in resolved:
            return fail("getent hosts xebico liefert nicht die erwartete Stationsadresse.")
        hosts = Path("/etc/hosts").read_text(encoding="utf-8")
        if hosts.count("# BEGIN LABFORGE XEBICO") != 1:
            return fail("Der verwaltete Xebico-Block existiert nicht genau einmal.")
        print("Staging, Hosts-Block und Systemauflösung bestätigt.")
        return 0

    if args.step == 6:
        error = require_process_port_bind("0.0.0.0", "8080")
        if error:
            return fail(error)
        address = (WORKDIR / "status" / "stationsadresse").read_text().strip()
        resolved = run(["getent", "hosts", "xebico"], check=False).stdout
        if address not in resolved:
            return fail("Namensauflösung entspricht nicht dem Sollwert.")
        response = http_response("http://xebico:8080/meldung")
        required = (
            "HTTP/1.1 200",
            "X-Xebico-Status: EMPFANGEN",
            "STATUS: NACHTLEITUNG-BEREIT",
            "MELDUNG: XEBICO RUFT NACHTSTATION",
            "ANTWORTET NICHT AUF DAS DRITTE SIGNAL.",
        )
        missing = [value for value in required if value not in response]
        if missing:
            return fail("Endzustand unvollständig: " + ", ".join(missing))
        if not marker("demo-gesamtkette"):
            return fail("Die interaktive Gesamtkette wurde noch nicht ausgeführt.")
        print("Vollständiger technischer Endzustand bestätigt.")
        return 0

    return 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, subprocess.SubprocessError, UnicodeError) as exc:
        print(f"CHECK nicht erfolgreich: {exc}", file=sys.stderr)
        raise SystemExit(1)
__INTERNE_SKRIPTE_VERIFY_STEP_PY__

cat >"$install_dir/interne-skripte/dienststeuerung" <<'__INTERNE_SKRIPTE_DIENSTSTEUERUNG__'
#!/usr/bin/env bash
set -Eeuo pipefail

action="${1:-}"
if [[ "$action" != "start" && "$action" != "stop" && "$action" != "restart" && "$action" != "status" ]]; then
  echo "Verwendung: dienststeuerung {start|stop|restart|status}" >&2
  exit 2
fi

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
  workdir="${PILOT_WORKDIR:?PILOT_WORKDIR fehlt im Testmodus}"
  expected_uid="${PILOT_EXPECTED_UID:?PILOT_EXPECTED_UID fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="/home/telegrafist/nachtstation"
  expected_uid="$(id -u telegrafist)"
fi

config="$workdir/leitung-zwei/xebico.conf"
service_script="$install_dir/dienst/xebico_dienst.py"
parser="$install_dir/interne-skripte/config_parser.py"
guard="$install_dir/interne-skripte/process_guard.py"
pid_file="$workdir/status/xebico-dienst.pid"
log_file="$workdir/protokolle/xebico-dienst.log"

python_bin="/usr/bin/python3"
if [[ ! -x "$python_bin" ]]; then
  echo "Python 3 fehlt unter $python_bin." >&2
  exit 1
fi
curl_bin="$(command -v curl || true)"
if [[ -z "$curl_bin" ]]; then
  echo "curl wurde nicht gefunden." >&2
  exit 1
fi

mkdir -p "$workdir/status" "$workdir/protokolle"

config_value() {
  "$python_bin" -I "$parser" \
    --config "$config" \
    --base-dir "$workdir" \
    --get "$1"
}

list_managed() {
  "$python_bin" -I "$guard" \
    --expected-uid "$expected_uid" \
    --script "$service_script" \
    --config "$config" \
    --base-dir "$workdir" \
    --list
}

validate_pid() {
  local pid="$1"
  "$python_bin" -I "$guard" \
    --expected-uid "$expected_uid" \
    --script "$service_script" \
    --config "$config" \
    --base-dir "$workdir" \
    --validate "$pid" >/dev/null
}

stop_managed() {
  local -a pids=()
  local pid

  if [[ -f "$pid_file" ]]; then
    pid="$(cat "$pid_file")"
    if [[ "$pid" =~ ^[0-9]+$ ]] && validate_pid "$pid"; then
      pids+=("$pid")
    fi
  fi

  while IFS= read -r pid; do
    [[ -n "$pid" ]] || continue
    pids+=("$pid")
  done < <(list_managed)

  if ((${#pids[@]} == 0)); then
    rm -f "$pid_file"
    return 0
  fi

  mapfile -t pids < <(printf '%s\n' "${pids[@]}" | sort -n -u)

  for pid in "${pids[@]}"; do
    if validate_pid "$pid"; then
      kill -TERM "$pid"
    fi
  done

  for _ in {1..50}; do
    local alive=0
    for pid in "${pids[@]}"; do
      if validate_pid "$pid" 2>/dev/null; then
        alive=1
      fi
    done
    if ((alive == 0)); then
      rm -f "$pid_file"
      return 0
    fi
    sleep 0.1
  done

  for pid in "${pids[@]}"; do
    if validate_pid "$pid" 2>/dev/null; then
      kill -KILL "$pid"
    fi
  done

  for _ in {1..20}; do
    if [[ -z "$(list_managed)" ]]; then
      rm -f "$pid_file"
      return 0
    fi
    sleep 0.1
  done

  echo "Die validierte Pilotinstanz konnte nicht beendet werden." >&2
  return 1
}

start_managed() {
  "$python_bin" -I "$parser" --config "$config" --base-dir "$workdir" >/dev/null

  local existing
  existing="$(list_managed)"
  if [[ -n "$existing" ]]; then
    echo "Start abgebrochen: Es existiert bereits eine verwaltete Instanz: $existing" >&2
    return 1
  fi

  local bind_address port http_status
  bind_address="$(config_value BIND_ADRESSE)"
  port="$(config_value PORT)"
  http_status="$(config_value HTTP_STATUS)"

  : >"$log_file"
  nohup "$python_bin" -I "$service_script" \
    --config "$config" \
    --base-dir "$workdir" \
    >>"$log_file" 2>&1 &
  local pid=$!

  local validated=0
  for _ in {1..30}; do
    if validate_pid "$pid" 2>/dev/null; then
      validated=1
      break
    fi
    if ! kill -0 "$pid" 2>/dev/null; then
      break
    fi
    sleep 0.1
  done

  if ((validated == 0)); then
    wait "$pid" 2>/dev/null || true
    echo "Dienststart fehlgeschlagen. Protokoll:" >&2
    tail -n 20 "$log_file" >&2 || true
    return 1
  fi

  printf '%s\n' "$pid" >"$pid_file"

  local ready=0
  for _ in {1..50}; do
    if "$curl_bin" --noproxy '*' --connect-timeout 1 --max-time 2 \
      -fsS "http://127.0.0.1:${port}/healthz" 2>/dev/null |
      grep -qx 'bereit'; then
      ready=1
      break
    fi
    if ! validate_pid "$pid" 2>/dev/null; then
      break
    fi
    sleep 0.2
  done

  if ((ready == 0)); then
    echo "Dienst wurde nicht innerhalb des Timeouts bereit." >&2
    tail -n 20 "$log_file" >&2 || true
    stop_managed || true
    return 1
  fi

  local count
  count="$(list_managed | wc -l | tr -d ' ')"
  if [[ "$count" != "1" ]]; then
    echo "Doppelstartschutz fehlgeschlagen: $count Instanzen gefunden." >&2
    stop_managed || true
    return 1
  fi

  echo "Konfiguration angewendet."
  echo "Prozess:       xebico-dienst"
  echo "PID:           $pid"
  echo "Bind-Adresse:  $bind_address"
  echo "TCP-Port:      $port"
  echo "HTTP-Status:   $http_status"
  echo "Zustand:       LISTEN"
}

status_managed() {
  local pids
  pids="$(list_managed)"
  if [[ -z "$pids" ]]; then
    echo "Status: keine verwaltete Instanz"
    return 1
  fi

  echo "Verwaltete PID:"
  printf '%s\n' "$pids"
  echo
  "$python_bin" -I "$parser" --config "$config" --base-dir "$workdir"
  if command -v ss >/dev/null 2>&1; then
    echo
    echo "Passende Listenerzeilen:"
    ss -ltnp 2>/dev/null | grep 'xebico-dienst' || true
  fi
}

case "$action" in
  start)
    start_managed
    ;;
  stop)
    stop_managed
    ;;
  restart)
    stop_managed
    start_managed
    ;;
  status)
    status_managed
    ;;
esac
__INTERNE_SKRIPTE_DIENSTSTEUERUNG__

cat >"$install_dir/interne-skripte/register-apply-root" <<'__INTERNE_SKRIPTE_REGISTER_APPLY_ROOT__'
#!/usr/bin/env bash
set -Eeuo pipefail

if (($# != 0)); then
  echo "Dieses Hilfsprogramm akzeptiert keine Argumente." >&2
  exit 2
fi

if [[ "$(id -u)" != "0" ]]; then
  echo "Dieses Hilfsprogramm muss privilegiert ausgeführt werden." >&2
  exit 1
fi

install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
workdir="/home/telegrafist/nachtstation"
staging="$workdir/register/xebico.hosts"
helper="$install_dir/interne-skripte/hosts_tool.py"
expected_uid="$(id -u telegrafist)"

exec /usr/bin/env -i \
  PATH=/usr/sbin:/usr/bin:/sbin:/bin \
  /usr/bin/python3 -I "$helper" apply \
    --staging "$staging" \
    --expected-owner-uid "$expected_uid" \
    --hosts /etc/hosts \
    --allow-inplace-fallback
__INTERNE_SKRIPTE_REGISTER_APPLY_ROOT__


find "$install_dir" -type d -exec chmod 0755 {} +
find "$install_dir" -type f -exec chmod 0644 {} +
chmod 0755 \
  "$install_dir/dienst/xebico_dienst.py" \
  "$install_dir/interne-skripte/config_parser.py" \
  "$install_dir/interne-skripte/process_guard.py" \
  "$install_dir/interne-skripte/hosts_tool.py" \
  "$install_dir/interne-skripte/station_host.py" \
  "$install_dir/interne-skripte/pilot_state.py" \
  "$install_dir/interne-skripte/verify_step.py" \
  "$install_dir/interne-skripte/dienststeuerung" \
  "$install_dir/interne-skripte/register-apply-root"

if [[ "$mode" == "system" ]]; then
  chown -R root:root "$install_dir"

  /usr/sbin/runuser -u telegrafist -- /usr/bin/env -i \
    HOME=/home/telegrafist \
    USER=telegrafist \
    LOGNAME=telegrafist \
    PATH=/usr/local/bin:/usr/bin:/bin \
    "$install_dir/interne-skripte/dienststeuerung" stop \
    >/dev/null 2>&1 || true
else
  export PILOT_TEST_MODE=1
  export PILOT_INSTALL_DIR="$install_dir"
  export PILOT_WORKDIR="$workdir"
  export PILOT_STATE_DIR="$state_dir"
  export PILOT_HOSTS_FILE="$hosts_file"
  export PILOT_EXPECTED_UID="$pilot_uid"
  "$install_dir/interne-skripte/dienststeuerung" stop \
    >/dev/null 2>&1 || true
fi

rm -rf -- "$workdir"
install -d -m 0755 -o "$pilot_uid" -g "$pilot_gid" \
  "$lab_home" \
  "$workdir" \
  "$workdir/leitung-zwei" \
  "$workdir/register" \
  "$workdir/meldungen" \
  "$workdir/protokolle" \
  "$workdir/status"
install -d -m 0755 "$workdir/werkzeuge" "$workdir/pilot-werkzeuge"

initial_port="8080"
if [[ "$mode" == "sandbox" ]]; then
  initial_port="${PILOT_SANDBOX_INITIAL_PORT:-8080}"
  [[ "$initial_port" == "8080" || "$initial_port" == "8081" ]] ||
    fail "PILOT_SANDBOX_INITIAL_PORT muss 8080 oder 8081 sein."
fi

cat >"$workdir/leitung-zwei/xebico.conf" <<EOF
BIND_ADRESSE=0.0.0.0
PORT=${initial_port}
HTTP_STATUS=200
MELDUNG_DATEI=meldungen/xebico.txt
EOF

cat >"$workdir/register/xebico.hosts" <<'REGISTER'
192.0.2.10 xebico
REGISTER

cat >"$workdir/meldungen/xebico.txt" <<'MELDUNG'
STATUS: NACHTLEITUNG-BEREIT
MELDUNG: XEBICO RUFT NACHTSTATION
DIE LICHTER UNTER DEM NEBEL SIND ERLOSCHEN.
HALTET LEITUNG ZWEI OFFEN.
ANTWORTET NICHT AUF DAS DRITTE SIGNAL.
FLAG{die_nachtleitung_bleibt_offen}
MELDUNG

cat >"$workdir/werkzeuge/konfiguration-anwenden" <<'__WERKZEUGE_KONFIGURATION_ANWENDEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec "$install_dir/interne-skripte/dienststeuerung" restart
__WERKZEUGE_KONFIGURATION_ANWENDEN__

cat >"$workdir/werkzeuge/konfiguration-pruefen" <<'__WERKZEUGE_KONFIGURATION_PRUEFEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
  workdir="${PILOT_WORKDIR:?PILOT_WORKDIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="/home/telegrafist/nachtstation"
fi

exec /usr/bin/python3 -I \
  "$install_dir/interne-skripte/config_parser.py" \
  --config "$workdir/leitung-zwei/xebico.conf" \
  --base-dir "$workdir"
__WERKZEUGE_KONFIGURATION_PRUEFEN__

cat >"$workdir/werkzeuge/register-anwenden" <<'__WERKZEUGE_REGISTER_ANWENDEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
  workdir="${PILOT_WORKDIR:?PILOT_WORKDIR fehlt im Testmodus}"
  expected_uid="${PILOT_EXPECTED_UID:?PILOT_EXPECTED_UID fehlt im Testmodus}"
  hosts_file="${PILOT_HOSTS_FILE:?PILOT_HOSTS_FILE fehlt im Testmodus}"

  exec /usr/bin/python3 -I \
    "$install_dir/interne-skripte/hosts_tool.py" apply \
    --staging "$workdir/register/xebico.hosts" \
    --expected-owner-uid "$expected_uid" \
    --hosts "$hosts_file"
fi

exec /usr/bin/sudo -n /usr/local/sbin/labforge-xebico-hosts-apply
__WERKZEUGE_REGISTER_ANWENDEN__

cat >"$workdir/werkzeuge/register-pruefen" <<'__WERKZEUGE_REGISTER_PRUEFEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
  workdir="${PILOT_WORKDIR:?PILOT_WORKDIR fehlt im Testmodus}"
  expected_uid="${PILOT_EXPECTED_UID:?PILOT_EXPECTED_UID fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
  workdir="/home/telegrafist/nachtstation"
  expected_uid="$(id -u telegrafist)"
fi

exec /usr/bin/python3 -I \
  "$install_dir/interne-skripte/hosts_tool.py" validate \
  --staging "$workdir/register/xebico.hosts" \
  --expected-owner-uid "$expected_uid"
__WERKZEUGE_REGISTER_PRUEFEN__

cat >"$workdir/pilot-werkzeuge/bindung-alle-testen" <<'__PILOT_WERKZEUGE_BINDUNG_ALLE_TESTEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" bindung-alle
__PILOT_WERKZEUGE_BINDUNG_ALLE_TESTEN__

cat >"$workdir/pilot-werkzeuge/bindung-loopback-testen" <<'__PILOT_WERKZEUGE_BINDUNG_LOOPBACK_TESTEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" bindung-loopback
__PILOT_WERKZEUGE_BINDUNG_LOOPBACK_TESTEN__

cat >"$workdir/pilot-werkzeuge/demo-architektur" <<'__PILOT_WERKZEUGE_DEMO_ARCHITEKTUR__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" demo-architektur
__PILOT_WERKZEUGE_DEMO_ARCHITEKTUR__

cat >"$workdir/pilot-werkzeuge/demo-gesamtkette" <<'__PILOT_WERKZEUGE_DEMO_GESAMTKETTE__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" demo-gesamtkette
__PILOT_WERKZEUGE_DEMO_GESAMTKETTE__

cat >"$workdir/pilot-werkzeuge/demo-prozess-socket" <<'__PILOT_WERKZEUGE_DEMO_PROZESS_SOCKET__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" demo-prozess-socket
__PILOT_WERKZEUGE_DEMO_PROZESS_SOCKET__

cat >"$workdir/pilot-werkzeuge/http-200-wiederherstellen" <<'__PILOT_WERKZEUGE_HTTP_200_WIEDERHERSTELLEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" http-200
__PILOT_WERKZEUGE_HTTP_200_WIEDERHERSTELLEN__

cat >"$workdir/pilot-werkzeuge/http-404-testen" <<'__PILOT_WERKZEUGE_HTTP_404_TESTEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" http-404
__PILOT_WERKZEUGE_HTTP_404_TESTEN__

cat >"$workdir/pilot-werkzeuge/http-500-testen" <<'__PILOT_WERKZEUGE_HTTP_500_TESTEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" http-500
__PILOT_WERKZEUGE_HTTP_500_TESTEN__

cat >"$workdir/pilot-werkzeuge/markdown-details-demo" <<'__PILOT_WERKZEUGE_MARKDOWN_DETAILS_DEMO__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" markdown-details
__PILOT_WERKZEUGE_MARKDOWN_DETAILS_DEMO__

cat >"$workdir/pilot-werkzeuge/markdown-inline-demo" <<'__PILOT_WERKZEUGE_MARKDOWN_INLINE_DEMO__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" markdown-inline
__PILOT_WERKZEUGE_MARKDOWN_INLINE_DEMO__

cat >"$workdir/pilot-werkzeuge/markdown-interrupt-demo" <<'__PILOT_WERKZEUGE_MARKDOWN_INTERRUPT_DEMO__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" markdown-interrupt
__PILOT_WERKZEUGE_MARKDOWN_INTERRUPT_DEMO__

cat >"$workdir/pilot-werkzeuge/port-8080-wiederherstellen" <<'__PILOT_WERKZEUGE_PORT_8080_WIEDERHERSTELLEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" port-8080
__PILOT_WERKZEUGE_PORT_8080_WIEDERHERSTELLEN__

cat >"$workdir/pilot-werkzeuge/port-8081-testen" <<'__PILOT_WERKZEUGE_PORT_8081_TESTEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" port-8081
__PILOT_WERKZEUGE_PORT_8081_TESTEN__

cat >"$workdir/pilot-werkzeuge/register-stationsadresse-vorbereiten" <<'__PILOT_WERKZEUGE_REGISTER_STATIONSADRESSE_VORBEREITEN__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I "$install_dir/interne-skripte/pilot_state.py" register-stationsadresse
__PILOT_WERKZEUGE_REGISTER_STATIONSADRESSE_VORBEREITEN__

cat >"$workdir/pilot-werkzeuge/textdemo-bindung" <<'__PILOT_WERKZEUGE_TEXTDEMO_BINDUNG__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I               "$install_dir/interne-skripte/pilot_state.py" demo-bindung
__PILOT_WERKZEUGE_TEXTDEMO_BINDUNG__

cat >"$workdir/pilot-werkzeuge/textdemo-dienst" <<'__PILOT_WERKZEUGE_TEXTDEMO_DIENST__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I               "$install_dir/interne-skripte/pilot_state.py" demo-dienst
__PILOT_WERKZEUGE_TEXTDEMO_DIENST__

cat >"$workdir/pilot-werkzeuge/textdemo-http" <<'__PILOT_WERKZEUGE_TEXTDEMO_HTTP__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I               "$install_dir/interne-skripte/pilot_state.py" demo-http
__PILOT_WERKZEUGE_TEXTDEMO_HTTP__

cat >"$workdir/pilot-werkzeuge/textdemo-name" <<'__PILOT_WERKZEUGE_TEXTDEMO_NAME__'
#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PILOT_TEST_MODE:-0}" == "1" ]]; then
  install_dir="${PILOT_INSTALL_DIR:?PILOT_INSTALL_DIR fehlt im Testmodus}"
else
  install_dir="/opt/labforge/kapitel-02-killercoda-pilot"
fi

exec /usr/bin/python3 -I               "$install_dir/interne-skripte/pilot_state.py" demo-name
__PILOT_WERKZEUGE_TEXTDEMO_NAME__


find "$workdir/werkzeuge" "$workdir/pilot-werkzeuge" \
  -type f -exec chmod 0755 {} +
chown -R "$pilot_uid:$pilot_gid" \
  "$workdir/leitung-zwei" \
  "$workdir/register" \
  "$workdir/meldungen" \
  "$workdir/protokolle" \
  "$workdir/status"
if [[ "$mode" == "system" ]]; then
  chown -R root:root "$workdir/werkzeuge" "$workdir/pilot-werkzeuge"
fi

: >"$workdir/protokolle/xebico-dienst.log"
chown "$pilot_uid:$pilot_gid" "$workdir/protokolle/xebico-dienst.log"

default_dev="$(
  ip -o -4 route show default |
    awk 'NR==1 {for (i=1; i<=NF; i++) if ($i=="dev") {print $(i+1); exit}}'
)"
[[ -n "$default_dev" ]] ||
  fail "Keine IPv4-Standardschnittstelle gefunden."

station_ip="$(
  ip -o -4 addr show dev "$default_dev" scope global |
    awk 'NR==1 {split($4,a,"/"); print a[1]}'
)"
[[ -n "$station_ip" && "$station_ip" != 127.* ]] ||
  fail "Keine geeignete lokale Stationsadresse gefunden."

route_context="$(
  ip -o -4 route show |
    awk -v dev="$default_dev" \
      '$0 !~ /^default / && $0 ~ ("dev " dev "([[:space:]]|$)") {print; exit}'
)"
if [[ -z "$route_context" ]]; then
  route_context="$(ip -o -4 route show default | head -n 1)"
fi

printf '%s\n' "$station_ip" >"$workdir/status/stationsadresse"
printf '%s\n' "$route_context" >"$workdir/status/routenkontext"
chown "$pilot_uid:$pilot_gid" \
  "$workdir/status/stationsadresse" \
  "$workdir/status/routenkontext"
chmod 0644 \
  "$workdir/status/stationsadresse" \
  "$workdir/status/routenkontext"

if [[ "$mode" == "system" ]]; then
  printf '%s\n' 'nachtstation' >/etc/hostname
  hostname nachtstation >/dev/null 2>&1 || true
  /usr/bin/python3 -I "$install_dir/interne-skripte/station_host.py"

  install -m 0755 -o root -g root \
    "$install_dir/interne-skripte/register-apply-root" \
    /usr/local/sbin/labforge-xebico-hosts-apply

  sudoers_tmp="$(mktemp)"
  trap 'rm -f "$sudoers_tmp"' EXIT
  printf '%s\n' \
    'telegrafist ALL=(root) NOPASSWD: /usr/local/sbin/labforge-xebico-hosts-apply' \
    >"$sudoers_tmp"
  chmod 0440 "$sudoers_tmp"
  visudo -cf "$sudoers_tmp" >/dev/null ||
    fail "Die begrenzte Sudoers-Regel ist ungültig."
  install -m 0440 -o root -g root \
    "$sudoers_tmp" /etc/sudoers.d/labforge-xebico-hosts
  rm -f "$sudoers_tmp"
  trap - EXIT
else
  install -d -m 0755 "$(dirname "$hosts_file")"
  cat >"$hosts_file" <<'HOSTS'
127.0.0.1 localhost
127.0.1.1 nachtstation
198.51.100.7 fremder-eintrag
HOSTS
  chmod 0644 "$hosts_file"
fi

cat >"$lab_home/.bash_profile" <<PROFILE
PS1='\u@\h:\w\$ '
alias ls='ls --color=auto'
cd "$workdir"
clear 2>/dev/null || printf '\\033[2J\\033[H'
PROFILE
chown "$pilot_uid:$pilot_gid" "$lab_home/.bash_profile"
chmod 0644 "$lab_home/.bash_profile"

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

service_port="$(
  /usr/bin/python3 -I \
    "$install_dir/interne-skripte/config_parser.py" \
    --config "$workdir/leitung-zwei/xebico.conf" \
    --base-dir "$workdir" \
    --get PORT
)"

for _ in {1..30}; do
  if curl --noproxy '*' --connect-timeout 1 --max-time 2 \
    -fsS "http://127.0.0.1:${service_port}/healthz" |
    grep -qx 'bereit'; then
    break
  fi
  sleep 0.2
done

curl --noproxy '*' --connect-timeout 1 --max-time 3 \
  -fsS "http://127.0.0.1:${service_port}/healthz" |
  grep -qx 'bereit' ||
  fail "Der Dienst wurde nicht rechtzeitig bereit."

curl --noproxy '*' --connect-timeout 1 --max-time 3 \
  -fsS "http://127.0.0.1:${service_port}/architektur" |
  grep -q 'Interaktive Netzwerkarchitektur' ||
  fail "Die interaktive Architektur-Web-App ist nicht erreichbar."

if [[ "$mode" == "sandbox" ]]; then
  printf '%s\n' 'Sandbox-Pilot erfolgreich vorbereitet.'
  printf 'Arbeitsverzeichnis: %s\n' "$workdir"
  printf 'Dienstport: %s\n' "$service_port"
  exit 0
fi

[[ "$(stat -c '%U:%G:%a' "$workdir/leitung-zwei/xebico.conf")" == \
  "telegrafist:telegrafist:644" ]] ||
  fail "Die Konfigurationsdatei besitzt falsche Rechte."

[[ "$(stat -c '%U:%G:%a' "$workdir/werkzeuge/konfiguration-anwenden")" == \
  "root:root:755" ]] ||
  fail "Das sichtbare Anwendungswerkzeug besitzt falsche Rechte."

[[ "$(stat -c '%U:%G:%a' "$install_dir/dienst/xebico_dienst.py")" == \
  "root:root:755" ]] ||
  fail "Der interne Dienst besitzt falsche Rechte."

clear 2>/dev/null || printf '\033[2J\033[H'
exec su - telegrafist
