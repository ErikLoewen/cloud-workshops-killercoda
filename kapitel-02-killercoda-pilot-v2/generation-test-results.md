# Tatsächlich ausgeführte Prüfungen – Killercoda-Technikpilot V2

Datum: 2026-08-05

## Bestanden

- `validate-package.sh`: Exit-Code 0
- `test-local.sh`: Exit-Code 0
- 45 ausgeführte lokale Prüfungen erfolgreich
- `details.assets.host01` und alle Assetreferenzen validiert
- Asset-Entry entpackt die Runtime und startet das Sandbox-Setup
- kein relativer Foreground-Pfad zu `/root/dienst`
- Intro-Background und Intro-Foreground verwenden absolute `/tmp`-Einstiege
- Runtime-Archiv vollständig und lesbar
- HTML/CSS/JavaScript-Demo-Endpunkt `/architektur`
- Verify-Logik für `supported`/`blocked`-UI-Befunde
- Bash- und Python-Syntax
- Konfigurationsparser einschließlich Negativ- und Injectionfällen
- Prozessname in `/proc/PID/comm`, `ps`, `pgrep` und `ss -ltnp`
- Schutz gegen Doppelstart und veraltete PID-Datei
- HTTP 200, 404 und 500
- Erfolgsheader und deterministischer Body
- Bindung an Loopback und alle lokalen IPv4-Schnittstellen
- Laufzeit auf Port 8081
- Hosts-Staging und idempotente Blocklogik in der Sandbox
- wiederholtes Sandbox-Setup und Reset
- keine Bilddateien im Paket

## Transparent übersprungen

- Laufzeittest auf Port 8080 in der Erzeugungsumgebung

Grund: Port 8080 war bereits durch einen fremden Plattformprozess belegt.
Der Pilot hat diesen Prozess weder beendet noch verändert.

## Nicht ausgeführt

- echter Killercoda-Asset-Upload
- Systemmodus gegen das reale Killercoda-Ubuntu
- visuelle Darstellung von Inline-HTML und CSS
- Ausführung von Inline-JavaScript im Killercoda-Markdown
- Einbettung des `iframe`
- Traffic-Link und CSP-/Sanitizer-Verhalten
- privilegierter Helper gegen das reale `/etc/hosts`
- Plattformlatenz und mehrfacher echter Szenariostart

Diese Punkte dürfen nicht als bestanden bezeichnet werden.
