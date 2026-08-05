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
        response = curl_response("http://127.0.0.1:8080/meldung")
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
