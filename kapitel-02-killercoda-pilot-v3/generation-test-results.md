# Tatsächlich ausgeführte Prüfungen – Killercoda-Technikpilot V3

Datum: 2026-08-05

## Bestanden

- `validate-package.sh`: Exit-Code 0
- `test-local.sh`: Exit-Code 0
- 49 ausgeführte lokale Prüfungen erfolgreich
- alle in `index.json` referenzierten Upload-Dateien liegen unter `assets/`
- Asset-Archiv wird über denselben `/tmp`-Pfad wie in Killercoda verarbeitet
- Asset-Entry entpackt die Runtime und startet das Sandbox-Setup
- wiederholtes Setup erzeugt keine Doppelinstanz
- vier interaktive Textdemonstrationen erzeugen Live-Ausgaben
- HTML/CSS/JavaScript-Web-App unter `/architektur`
- Verify-Logik für Textdemonstrationen und Web-App
- Bash- und Python-Syntax
- Konfigurationsparser einschließlich Negativ- und Injectionfällen
- Prozessname in `/proc/PID/comm`, `ps`, `pgrep` und `ss -ltnp`
- Schutz gegen Doppelstart und veraltete PID-Datei
- HTTP 200, 404 und 500
- Erfolgsheader und deterministischer Body
- Bindung an Loopback und alle lokalen IPv4-Schnittstellen
- Laufzeit auf Port 8081
- Hosts-Staging und idempotente Blocklogik in der Sandbox
- wiederholter Reset
- keine Bilddateien im Paket
- keine Inline-`style`-, `script`- oder `iframe`-Elemente im Lernschritt

## Transparent übersprungen

- Laufzeittest auf Port 8080 in der Erzeugungsumgebung

Grund: Port 8080 war durch einen fremden Plattformprozess belegt.
Der Pilot hat diesen Prozess weder beendet noch verändert.

## Nicht ausgeführt

- tatsächlicher Killercoda-Asset-Upload
- Systemmodus in Killercoda
- visueller Test der `<details>`-Bereiche
- Traffic-Link auf Port 8080
- Browserbedienung der HTML/CSS/JavaScript-Web-App
- privilegierter Helper gegen das reale `/etc/hosts`
- Plattformlatenz
- mehrfacher echter Szenariostart

Diese Punkte dürfen nicht als bestanden bezeichnet werden.
