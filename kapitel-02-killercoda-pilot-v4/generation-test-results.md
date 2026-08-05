# Tatsächlich ausgeführte Prüfungen – Killercoda-Technikpilot V4

Datum: 2026-08-05

## Grundlage

V4 wurde gegen die aktuellen, funktionierenden Kapitel-1-Szenarien des
Repositorys ausgerichtet:

- Intro verwendet direkt `foreground: setup.sh`.
- `setup.sh` ist vollständig selbstständig.
- Das Setup erzeugt interne Dateien über Heredocs.
- Das Setup endet im vorbereiteten Arbeitskonto.
- Es gibt keinen Asset-Entry, kein Runtime-Archiv und keinen Warter.

## Bestanden

- `validate-package.sh`: Exit-Code 0
- `test-local.sh`: Exit-Code 0
- 49 ausgeführte lokale Prüfungen erfolgreich
- gültiges `index.json`
- Intro entspricht dem Kapitel-1-Foreground-Muster
- keine Asset-, `/tmp`-Entry- oder Wait-Abhängigkeit
- selbstständiges Setup im Sandboxmodus
- wiederholtes Setup ohne Doppelinstanz
- vier interaktive Textdemonstrationen
- HTML/CSS/JavaScript-Web-App unter `/architektur`
- Verify-Logik für Textdemos und Web-App
- Bash-Syntax aller Root-Skripte
- durch Setup erzeugte Python- und Bash-Runtime erfolgreich ausgeführt
- Konfigurationsparser einschließlich Negativ- und Injectionfällen
- Prozessname in `/proc/PID/comm`, `ps`, `pgrep` und `ss -ltnp`
- Schutz gegen Doppelstart und veraltete PID-Datei
- HTTP 200, 404 und 500
- Erfolgsheader und deterministischer Body
- Bindung an Loopback und alle lokalen IPv4-Schnittstellen
- Laufzeit auf Port 8081
- Hosts-Staging und idempotente Blocklogik in der Sandbox
- wiederholter Reset
- keine Bilddateien
- keine Inline-`style`-, `script`- oder `iframe`-Elemente im Markdown

## Transparent übersprungen

- Laufzeittest auf Port 8080 in der Erzeugungsumgebung

Grund: Port 8080 war durch einen fremden Plattformprozess belegt.
Der Pilot hat diesen Prozess weder beendet noch verändert.

## Nicht ausgeführt

- Systemmodus in einem echten Killercoda-Ubuntu
- tatsächlicher Intro-Foreground durch Killercoda
- `exec su - telegrafist` im Killercoda-Terminal
- Traffic-Link auf Port 8080
- Browserbedienung der HTML/CSS/JavaScript-Web-App
- privilegierter Helper gegen das reale `/etc/hosts`
- Plattformlatenz
- mehrfacher echter Szenariostart

Diese Punkte dürfen nicht als bestanden bezeichnet werden.
