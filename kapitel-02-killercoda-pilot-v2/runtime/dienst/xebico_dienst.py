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
