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
