# Kapitel 02 – Killercoda-Technikpilot

Dieses Paket ist ein echtes, eigenständiges Killercoda-Szenario. Es prüft die gemeinsame technische Architektur des Kapitels und die Darstellung interaktiver Demonstrationen in Markdown.

## Enthaltene Plattformtests

- Intro-`foreground`-Setup
- Verify-Skript je Schritt
- einzelne und mehrzeilige `{{exec}}`-Aktionen
- `{{copy}}`
- `{{exec interrupt}}`
- ausführbare Blöcke innerhalb von `<details>`
- `{{TRAFFIC_HOST1_8080}}`
- Prozessname und PID-Sichtbarkeit in `ss -ltnp`
- Ports 8080 und 8081
- Bindung an Loopback und alle lokalen IPv4-Schnittstellen
- HTTP 200, 404 und 500
- begrenzter `/etc/hosts`-Apply-Wrapper
- finaler technischer Gesamtnachweis

## Integration

Der Ordner kann als einzelnes Szenario in das Repository kopiert werden. Bei einer Root-`structure.json` muss der Pilot für den Test explizit ergänzt werden. Das Paket verändert die Strukturdatei nicht automatisch.

Siehe `integration/README.md`.

## Lokale Vorprüfung

```bash
./validate-package.sh
./test-local.sh
```

Die lokale Prüfung kann die Killercoda-UI, den Traffic-Proxy und die Prozesssichtbarkeit im tatsächlichen Backend nicht vollständig simulieren. Diese Punkte stehen in `test-checklist.md`.

## Systemänderungen im Killercoda-Szenario

Das Intro-Setup:

- erstellt beziehungsweise verwendet `telegrafist`;
- setzt den Laufzeithostnamen `nachtstation`;
- installiert interne Skripte unter `/opt/labforge/kapitel-02-killercoda-pilot`;
- legt das Arbeitsverzeichnis `/home/telegrafist/nachtstation` an;
- installiert einen exakt begrenzten Hosts-Helper;
- verwaltet markierte Blöcke in `/etc/hosts`;
- startet genau eine validierte Instanz von `xebico-dienst`.

Das Szenario ist für eine frische, entbehrliche Killercoda-Umgebung vorgesehen.

## Interaktive Demonstrationen

Die Markdown-Seiten verwenden keine Bilddateien für Architekturdiagramme. Stattdessen erzeugen root-eigene Pilotwerkzeuge bei jedem Klick eine aktuelle ASCII-Live-Ansicht aus Prozess-, Socket-, Resolver- und HTTP-Zustand.

Die automatische Prüfung bestätigt, dass die Aktionen ausgeführt wurden. Ob Klickflächen, Kopieraktion, Ausklappbereich und Traffic-Link visuell korrekt erscheinen, muss im echten Killercoda-Frontend manuell bestätigt werden.
