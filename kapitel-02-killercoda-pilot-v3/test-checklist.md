# Testcheckliste – Killercoda-Technikpilot V3

## Start

- [ ] Assets werden aus `assets/` nach `/tmp` hochgeladen
- [ ] `/tmp/kapitel-02-killercoda-entry.sh` vorhanden und ausführbar
- [ ] `/tmp/kapitel-02-killercoda-wait.sh` vorhanden und ausführbar
- [ ] Hintergrund-Setup erfolgreich
- [ ] Vordergrund-Warter meldet „Technikpilot bereit“
- [ ] kein `No such file or directory`
- [ ] kein `502 Bad Gateway` nach abgeschlossenem Setup

## Interaktive Demonstrationen

- [ ] vier `<details>`-Bereiche lassen sich öffnen
- [ ] die Befehle innerhalb der Bereiche sind anklickbar
- [ ] jeder Befehl erzeugt aktuelle Live-Ausgabe
- [ ] Traffic-Link `/architektur` öffnet die Web-App
- [ ] CSS-Layout der Web-App sichtbar
- [ ] Schaltfläche wechselt die aktive Diagnoseebene
- [ ] Zurücksetzen funktioniert
- [ ] keine Bilddateien erforderlich

## Technische Architektur

- [ ] Prozessname `xebico-dienst`
- [ ] `ss -ltnp` zeigt Prozess und PID
- [ ] Port 8080
- [ ] Port 8081
- [ ] Loopback-Bindung
- [ ] Wildcard-Bindung
- [ ] HTTP 200, 404 und 500
- [ ] Namensauflösung
- [ ] kontrollierter Hosts-Block
- [ ] Reset und mehrfacher Szenariostart
