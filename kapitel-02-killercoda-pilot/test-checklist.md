# Testcheckliste – Killercoda-Technikpilot

## Automatisch lokal prüfbar

- [ ] `index.json` ist gültiges JSON
- [ ] alle referenzierten Markdown-, Foreground- und Verify-Dateien existieren
- [ ] nur bestätigte Indexfelder werden verwendet
- [ ] Bash-Syntax
- [ ] Python-Syntax
- [ ] Ausführungsrechte
- [ ] Markdown enthält `{{exec}}`
- [ ] Markdown enthält mehrzeiliges `{{exec}}`
- [ ] Markdown enthält `{{copy}}`
- [ ] Markdown enthält `{{exec interrupt}}`
- [ ] Markdown enthält `<details>`
- [ ] Markdown enthält `{{TRAFFIC_HOST1_8080}}`
- [ ] Konfigurationsparser-Negativtests
- [ ] Prozessverwaltung und Doppelstartschutz
- [ ] HTTP 200, 404 und 500
- [ ] Bindungszustände
- [ ] Hosts-Block-Logik
- [ ] Reset

## In einer frischen Ubuntu-VM prüfbar

- [ ] Systemmodus des Setups
- [ ] Benutzer `telegrafist`
- [ ] Hostname `nachtstation`
- [ ] Prozessname in `/proc/PID/comm`
- [ ] Prozessname in `ps`
- [ ] `pgrep -x xebico-dienst`
- [ ] `ss -ltnp` als `telegrafist`
- [ ] PID-Sichtbarkeit als `telegrafist`
- [ ] Port 8080
- [ ] Port 8081
- [ ] Loopback-Bindung
- [ ] Wildcard-Bindung
- [ ] Systemauflösung über den kontrollierten Hosts-Block
- [ ] Sudoers-Regel ohne Passwortdialog
- [ ] keine allgemeine Sudo-Berechtigung
- [ ] fremde Hosts-Einträge bleiben erhalten
- [ ] Setup und Reset dreimal idempotent

## Nur im echten Killercoda-Frontend prüfbar

### Szenario und Markdown

- [ ] Intro-Foreground läuft vor dem ersten Schritt vollständig
- [ ] Einzelzeilen-`{{exec}}` zeigt eine anklickbare Aktion
- [ ] Mehrzeilen-`{{exec}}` zeigt eine anklickbare Aktion
- [ ] `{{copy}}` kopiert den vollständigen Block
- [ ] `{{exec interrupt}}` beendet den laufenden `sleep`
- [ ] `<details>` lässt sich ausklappen
- [ ] `{{exec}}` innerhalb von `<details>` bleibt anklickbar
- [ ] Live-ASCII-Demonstrationen sind lesbar
- [ ] keine Bilddatei ist für die Architekturvermittlung nötig

### Backend

- [ ] Ubuntu-Backend enthält alle benötigten Werkzeuge
- [ ] `ss -ltnp` zeigt Name und PID als `telegrafist`
- [ ] Stationsadresse wird korrekt ermittelt
- [ ] Loopback-Bindung ist über Traffic nicht erreichbar
- [ ] Wildcard-Bindung ist über Traffic erreichbar
- [ ] `{{TRAFFIC_HOST1_8080}}` öffnet den Dienst
- [ ] Traffic-Link zeigt nach der Body-Prüfung die Abschlussmeldung
- [ ] Plattformlatenz nach Dienstneustart dokumentiert
- [ ] jeder Schritt-CHECK reagiert auf Fehler und Erfolg
- [ ] CHECKs verändern den Lernzustand nicht
- [ ] mehrfacher Szenariostart erzeugt keine Doppelinstanz
- [ ] Reset erhält Killercoda-interne Hosts-Einträge

Nur tatsächlich ausgeführte Punkte markieren.
