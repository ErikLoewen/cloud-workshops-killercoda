# Testcheckliste – Killercoda-Technikpilot V2

## Automatisch lokal prüfbar

- [ ] `index.json` und alle Referenzen gültig
- [ ] `details.assets.host01` vorhanden
- [ ] Runtime-Archiv enthält `setup.sh`, Dienst und Werkzeuge
- [ ] Einstiegsskript entpackt die Runtime im Sandboxmodus
- [ ] Bash- und Python-Syntax
- [ ] HTML-Demo-Endpunkt liefert Status 200
- [ ] HTML-Demo enthält CSS und JavaScript
- [ ] Prozess-, Port-, HTTP-, Register- und Resettests
- [ ] ZIP-Integrität und Ausführungsrechte

## Nur im echten Killercoda-Frontend prüfbar

### Start

- [ ] Hintergrund-Setup startet ohne sichtbaren Skriptstrom
- [ ] Vordergrund zeigt nur Warten und Bereitschaft
- [ ] kein Zugriff auf `/root/dienst`
- [ ] erster Schritt wird erst nach erfolgreichem Setup freigegeben

### Inline-Markdown

- [ ] HTML-Karte wird dargestellt
- [ ] CSS-Raster und Hervorhebung werden dargestellt
- [ ] JavaScript-Status wechselt zu „aktiv“
- [ ] Schaltfläche wechselt die aktive Diagnoseebene
- [ ] Ergebnisdateien können als `supported` oder `blocked` dokumentiert werden

### Eingebettete Demo

- [ ] `iframe` wird im Text dargestellt
- [ ] `/architektur` lädt innerhalb des Frames
- [ ] Schaltflächen der eingebetteten Seite funktionieren
- [ ] Link-Fallback öffnet die Demo
- [ ] mögliche CSP-, Sanitizer- oder X-Frame-Blockade dokumentiert

### Weitere Plattformfunktionen

- [ ] `{{exec}}`, `{{copy}}` und `{{exec interrupt}}`
- [ ] Prozessname und PID in `ss -ltnp` als `telegrafist`
- [ ] Port 8080 und 8081
- [ ] Loopback- und Wildcard-Bindung
- [ ] Traffic-Link
- [ ] `/etc/hosts`-Wrapper
- [ ] mehrfacher Szenariostart
- [ ] Reset ohne Beschädigung fremder Hosts-Einträge
