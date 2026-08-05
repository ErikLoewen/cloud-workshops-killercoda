# Tatsächlich ausgeführte Prüfungen bei der Paketerzeugung

Datum: 2026-08-05

## Bestanden

- `validate-package.sh`: Exit-Code 0
- `test-local.sh`: Exit-Code 0
- 48 ausgeführte lokale Prüfungen erfolgreich
- gültiges `index.json`
- alle Killercoda-Referenzen vorhanden
- ausschließlich bestätigte Indexfelder verwendet
- Backend `ubuntu`
- statischer Nachweis der Markdown-Aktionen:
  - `{{exec}}`
  - mehrzeiliges `{{exec}}`
  - `{{copy}}`
  - `{{exec interrupt}}`
  - `<details>`
  - `{{TRAFFIC_HOST1_8080}}`
- Backendskripte der interaktiven Markdown-Demonstrationen ausgeführt
- Verify-Logik für die Markdown-Aktionsmarker ausgeführt
- Bash- und Python-Syntax
- Konfigurationsparser einschließlich Negativ- und Injectionfällen
- Prozessname in `/proc/PID/comm`, `ps`, `pgrep` und `ss -ltnp`
- Prozess-Doppelstartschutz
- Schutz eines fremden Prozesses bei veralteter PID-Datei
- HTTP 200, 404 und 500
- Erfolgsheader und deterministischer Body
- Bindung an Loopback und alle lokalen IPv4-Schnittstellen
- Laufzeit auf Port 8081
- Hosts-Staging, Validierung und idempotente Blocklogik in einer Sandbox-Datei
- Erhalt eines fremden Sandbox-Hosts-Eintrags
- wiederholtes Sandbox-Setup und Reset
- keine Bilddateien im Paket

## Transparent übersprungen

- Laufzeittest auf Port 8080 in der Erzeugungsumgebung

Grund: Port 8080 war bereits durch einen fremden Plattformprozess belegt. Der Pilot hat diesen Prozess weder beendet noch verändert. Der Laufzeittest auf 8080 bleibt für die frische Ubuntu-/Killercoda-Umgebung verpflichtend.

## Nicht ausgeführt

- Killercoda-Import
- Intro-Foreground im echten Killercoda-Frontend
- visuelle Darstellung und Bedienbarkeit der Markdown-Aktionen
- Kopieraktion im Browser
- `{{exec interrupt}}` im Browserterminal
- `<details>`-Rendering im Killercoda-Frontend
- Systemmodus gegen den echten Benutzer- und Hostzustand
- privilegierter Hosts-Helper gegen das reale `/etc/hosts`
- Killercoda-Traffic-Link
- Plattformlatenz
- mehrfacher echter Szenariostart

Diese Punkte dürfen nicht als bestanden bezeichnet werden.
