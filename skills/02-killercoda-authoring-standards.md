---
title: Killercoda Authoring- und Qualitätssicherungsstandard
purpose: Technische Referenz für Repository, Szenarien, JSON, Markdown, Skripte und Tests
language: de
last_reviewed: 2026-07-15
authority: Offizielle Killercoda-Dokumentation und offizielle Beispiel-Repositories
priority: Hoch – technische Syntax vor Ausgabe aktuell verifizieren
---

# Killercoda Authoring- und Qualitätssicherungsstandard

## 1. Zweck und Geltungsbereich

Diese Datei beschreibt bestätigte Grundmuster für Killercoda-Szenarien. Sie dient der Erstellung und Prüfung von:

- GitHub-Repositories,
- Szenarioordnern,
- Gruppen und Kursen,
- `structure.json`,
- `index.json`,
- Markdown-Schritten,
- Code-Aktionen,
- Setup-Skripten,
- Verify-Skripten,
- Assets,
- Browserzugriff auf Dienste.

Killercoda kann sich ändern. Vor der Ausgabe produktiver Szenariodateien sollen aktuelle technische Details anhand folgender Quellen geprüft werden:

1. offizielle Creator-Dokumentation,
2. offizielles Repository `killercoda/scenario-examples`,
3. offizielles Repository `killercoda/scenario-examples-groups`.

Keine nicht dokumentierten Felder oder Platzhalter erfinden.

---

# 2. Grundmodell

Killercoda lädt Szenarien aus einem verbundenen GitHub-Repository. Der Creator-Zugang erhält über einen GitHub Deploy Key Lesezugriff. Ein Webhook meldet neue Pushes, damit Änderungen synchronisiert werden.

Autoren schreiben insbesondere:

- JSON für Szenario-Metadaten,
- Markdown für Lerntexte,
- Bash für Vorbereitung und Verifikation.

Jeder Szenarioordner ist eine unabhängige Umgebung. Ein Folgeszenario darf nicht auf Daten einer vorherigen Sitzung angewiesen sein.

---

# 3. Empfohlene Repository-Struktur

```text
cloud-workshops-killercoda/
├── README.md
├── LICENSE
├── structure.json
│
├── kapitel-01-linux-grundlagen/
│   ├── structure.json
│   ├── 01-terminal-erste-schritte/
│   │   ├── index.json
│   │   ├── intro.md
│   │   ├── step1.md
│   │   ├── challenge.md
│   │   ├── finish.md
│   │   └── verify.sh
│   └── 02-dateien-und-verzeichnisse/
│       └── ...
│
└── kapitel-02-container/
    └── ...
```

## Namensregeln

- nur Kleinbuchstaben für Ordner und technische Dateinamen,
- keine Leerzeichen,
- Wörter mit Bindestrichen trennen,
- Kapitel und Szenarien nummerieren,
- veröffentlichte Pfade möglichst stabil halten.

Beispiel:

```text
kapitel-01-linux-grundlagen/
01-terminal-erste-schritte/
```

---

# 4. Gruppen, Kapitel und `structure.json`

Szenarien in einem gemeinsamen Unterordner werden als Gruppe beziehungsweise Kurs behandelt.

Eine `structure.json` ermöglicht:

- Reihenfolge festzulegen,
- Szenarien oder Gruppen gezielt zu referenzieren,
- Titel und Beschreibungen zu überschreiben,
- nicht gewünschte Ordner auszuschließen.

## Kritische Regel

Sobald in einem Verzeichnis eine `structure.json` vorhanden ist, berücksichtigt Killercoda dort nur die aufgeführten Einträge. Andere Szenarien oder Ordner werden ignoriert.

## Bestätigtes Minimalbeispiel

```json
{
  "items": [
    {
      "path": "scenario2"
    },
    {
      "path": "course1",
      "title": "Überschriebener Kurstitel"
    },
    {
      "path": "course2"
    }
  ]
}
```

## Empfohlene Root-Struktur

```json
{
  "items": [
    {
      "path": "kapitel-01-linux-grundlagen"
    },
    {
      "path": "kapitel-02-container"
    }
  ]
}
```

## Empfohlene Kapitelstruktur

```json
{
  "items": [
    {
      "path": "01-terminal-erste-schritte"
    },
    {
      "path": "02-dateien-und-verzeichnisse"
    }
  ]
}
```

Nur fertige Szenarien mit gültiger `index.json` aufnehmen.

---

# 5. `index.json`

## 5.1 Minimales Ubuntu-Szenario

Das offizielle Beispiel verwendet:

```json
{
  "title": "Ubuntu simple",
  "backend": {
    "imageid": "ubuntu"
  }
}
```

Das aktuell bestätigte `ubuntu`-Beispiel startet Ubuntu 24.04. Vor Verwendung anderer Backend-IDs aktuelle Dokumentation prüfen.

## 5.2 Standardszenario mit Intro, Schritten und Abschluss

```json
{
  "title": "Workshop 01 – Erste Schritte im Terminal",
  "description": "Grundlegende Terminalbedienung und Dateiarbeit.",
  "details": {
    "intro": {
      "text": "intro.md"
    },
    "steps": [
      {
        "title": "Orientierung im Dateisystem",
        "text": "step1.md"
      },
      {
        "title": "Abschlussaufgabe",
        "text": "challenge.md",
        "verify": "verify.sh"
      }
    ],
    "finish": {
      "text": "finish.md"
    }
  },
  "backend": {
    "imageid": "ubuntu"
  }
}
```

## 5.3 Bestätigte zentrale Felder

Top-Level:

- `title`
- `description`
- `details`
- `backend`

Innerhalb von `details`:

- `intro`
- `steps`
- `finish`
- `assets`

Innerhalb eines Intro-, Schritt- oder Finish-Eintrags:

- `title`
- `text`
- `foreground`
- `background`
- `verify` bei Schritten

Nicht jeder Eintrag benötigt alle Felder.

## 5.4 Mehrstufiges Beispiel mit Skripten

Bestätigtes Muster:

```json
{
  "title": "Mehrstufiges Szenario",
  "description": "Schritte mit Vordergrund-, Hintergrund- und Prüfroutinen.",
  "details": {
    "intro": {
      "title": "Einführung",
      "text": "intro/text.md",
      "foreground": "intro/foreground.sh",
      "background": "intro/background.sh"
    },
    "steps": [
      {
        "title": "Schritt 1",
        "text": "step1/text.md",
        "foreground": "step1/foreground.sh",
        "background": "step1/background.sh",
        "verify": "step1/verify.sh"
      }
    ],
    "finish": {
      "title": "Abschluss",
      "text": "finish/text.md",
      "foreground": "finish/foreground.sh",
      "background": "finish/background.sh"
    }
  },
  "backend": {
    "imageid": "ubuntu"
  }
}
```

## 5.5 Kubernetes-Beispiel

Das offizielle Zwei-Node-Beispiel verwendet:

```json
{
  "backend": {
    "imageid": "kubernetes-kubeadm-2nodes"
  }
}
```

Keine weiteren Backend-Namen aus dem Gedächtnis ergänzen. Vor jeder Verwendung aktuell prüfen.

---

# 6. JSON-Anforderungen

- Dateiname exakt `index.json`.
- Gültiges JSON ohne Kommentare.
- Doppelte Anführungszeichen verwenden.
- Keine abschließenden Kommas.
- Groß- und Kleinschreibung bei Dateipfaden beachten.
- Alle referenzierten Dateien müssen existieren.
- Relative Pfade beziehen sich auf den Szenarioordner.
- Schrittfolge in `index.json` muss der didaktischen Reihenfolge entsprechen.

## Lokale Syntaxprüfung

```bash
jq empty index.json
```

oder:

```bash
python -m json.tool index.json >/dev/null
```

Keine Ausgabe und Exit-Code 0 bedeuten gültige Syntax.

---

# 7. Markdown-Dateien

Killercoda verwendet Markdown für Intro, Schritte und Abschluss.

## Empfohlener didaktischer Aufbau

```markdown
# Schritt 1: Titel

## Ziel

## Erklärung

## Aufgabe

## Erwartete Beobachtung

## Prüfe dein Ergebnis

## Hinweis
```

Nicht jede Überschrift ist zwingend nötig. Teilnehmertexte sollen kurz, klar und handlungsorientiert sein.

## Schreibregeln

- ein Schritt verfolgt ein klar begrenztes Teilziel,
- Befehle und Dateinamen mit Inline-Code markieren,
- längere Konfigurationen als Codeblock,
- erwartete Ausgabe nicht mit Eingabe vermischen,
- Fehlermeldungen erklären,
- keine produktiven Geheimnisse verwenden,
- anklickbare Befehle nicht als Ersatz für selbstständige Übung missbrauchen.

---

# 8. Bestätigte Code-Aktionen in Markdown

## 8.1 Inline-Code kopieren

Einzeiliger Inline-Code ist standardmäßig kopierbar:

```markdown
`copy me`
```

## 8.2 Kopieren deaktivieren

```markdown
`copying disabled`{{}}
```

## 8.3 Einzeiligen Befehl ausführen

```markdown
`ls -lh`{{exec}}
```

## 8.4 Laufenden Vordergrundbefehl unterbrechen und neuen ausführen

```markdown
`sleep 1d`{{exec}}

`whoami`{{exec interrupt}}
```

`interrupt` sendet vor der neuen Ausführung `Ctrl+C`.

## 8.5 Mehrzeiligen Block kopieren

````markdown
```bash
uname -r
pwd
```{{copy}}
````

## 8.6 Mehrzeiligen Block ausführen

````markdown
```bash
uname -r
pwd
```{{exec}}
````

## 8.7 Mehrzeiligen Block mit Unterbrechung ausführen

````markdown
```bash
uname -r
whoami
```{{exec interrupt}}
````

## Didaktische Verwendung

Für Anfänger:

- erste Ausführung anklickbar,
- nächste Eingabe selbst tippen,
- spätere Aufgabe nur beschreiben,
- CHECK prüft das Ergebnis.

Nicht jeden Befehl automatisch ausführbar machen.

---

# 9. Verify-Skripte

Ein Schritt kann über das Feld `verify` ein Skript referenzieren:

```json
{
  "title": "Datei erstellen",
  "text": "create-file.md",
  "verify": "verify.sh"
}
```

Das offizielle Minimalbeispiel prüft mit einem Shell-Befehl, ob eine Datei existiert. Shell-Konvention:

- Exit-Code 0: Prüfung erfolgreich,
- anderer Exit-Code: Prüfung nicht erfolgreich.

## Empfohlener Standard

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

## Beispiel mit verständlichen Meldungen

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

target="/root/cloud-app/data/status.txt"

if [[ ! -f "$target" ]]; then
  echo "Die Datei $target wurde nicht gefunden."
  echo "Prüfe mit pwd deinen aktuellen Standort und erstelle die Datei im Ordner data."
  exit 1
fi

if ! grep -qx 'bereit' "$target"; then
  echo "Die Datei existiert, enthält aber nicht exakt den Text 'bereit'."
  exit 1
fi

echo "Prüfung erfolgreich: Die Statusdatei ist korrekt."
```

## Verify-Regeln

Verify-Skripte müssen:

- den Endzustand prüfen,
- unterschiedliche valide Lösungswege akzeptieren,
- bei Erfolg Exit-Code 0 liefern,
- bei Fehler Exit-Code ungleich 0 liefern,
- konkrete Diagnose liefern,
- schnell laufen,
- nicht interaktiv sein,
- den Lernzustand nicht verändern,
- keine Lösung heimlich herstellen.

Nicht prüfen, welchen exakten Befehl der Lernende verwendet hat, sofern dies nicht selbst Lernziel ist.

---

# 10. Foreground- und Background-Skripte

Killercoda unterstützt Skripte für Intro, einzelne Schritte und Finish.

## Foreground

- Befehle werden im Terminal sichtbar ausgeführt.
- Geeignet, wenn Lernende die Vorbereitung beobachten sollen.
- Lange sichtbare Installationen können verwirren oder Zeit kosten.

## Background

- Befehle laufen ohne sichtbare Ausgabe im Teilnehmerterminal.
- Geeignet für technische Vorbereitung, die nicht Lernziel ist.
- Der Lerntext darf nicht fortfahren, bevor ein benötigter Dienst tatsächlich bereit ist.

## Beispielreferenz

```json
{
  "intro": {
    "text": "intro.md",
    "foreground": "foreground.sh",
    "background": "background.sh"
  }
}
```

## Robuste Skripte

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

Anforderungen:

- nichtinteraktiv,
- reproduzierbar,
- möglichst idempotent,
- mit Timeouts bei Wartebedingungen,
- keine echten Secrets,
- Fehler nicht verschlucken,
- benötigte Dienste auf Bereitschaft prüfen.

Beispiel einer begrenzten Wartebedingung:

```bash
for _ in {1..30}; do
  if curl -fsS http://127.0.0.1:8080/ >/dev/null; then
    exit 0
  fi
  sleep 1
done

echo "Der Dienst auf Port 8080 wurde nicht rechtzeitig verfügbar." >&2
exit 1
```

---

# 11. Assets

Killercoda kann Dateien aus einem `assets`-Ordner in die Umgebung übertragen.

Bestätigtes Grundmuster:

```json
{
  "details": {
    "assets": {
      "host01": [
        {
          "file": "run.sh",
          "target": "/my/location",
          "chmod": "+x"
        },
        {
          "file": "conf.yaml",
          "target": "~/",
          "chmod": "+w"
        }
      ]
    }
  }
}
```

Weitere Glob-Muster werden in offiziellen Beispielen verwendet. Für neue Szenarien nur die tatsächlich benötigten Dateien übertragen.

## Asset-Regeln

- Zielpfade eindeutig angeben.
- Skripte nur ausführbar setzen, wenn nötig.
- Keine Passwörter, API-Keys oder privaten Schlüssel ablegen.
- Musterlösungen so platzieren, dass sie nicht versehentlich sofort sichtbar sind.
- Große Images oder Binärdateien vermeiden, sofern sie nicht notwendig sind.

---

# 12. Browserzugriff auf Dienste

Das offizielle Netzwerkbeispiel nennt folgende Bedingungen:

- Dienst auf allen benötigten Interfaces binden, beispielsweise `0.0.0.0`, nicht ausschließlich `localhost`;
- externer Browserzugriff über HTTP, nicht HTTPS;
- Port im Szenario tatsächlich veröffentlichen beziehungsweise öffnen.

## Bestätigter Platzhalter

```markdown
[Anwendung öffnen]({{TRAFFIC_HOST1_8080}})
```

Die Portnummer wird im Platzhalter eingesetzt.

## Portauswahl anzeigen

```markdown
[Ports öffnen]({{TRAFFIC_SELECTOR}})
```

## Beispiel

```bash
docker run -d -p 8080:80 nginx:alpine
```

```markdown
[Nginx öffnen]({{TRAFFIC_HOST1_8080}})
```

## Prüfschritte bei fehlender Erreichbarkeit

1. Läuft der Prozess oder Container?
2. Lauscht er auf dem erwarteten Port?
3. Bindet er an `0.0.0.0` oder die passende Schnittstelle?
4. Ist Host-Port zu Container-Port korrekt zugeordnet?
5. Wird HTTP verwendet?
6. Liefert `curl http://127.0.0.1:PORT` lokal eine Antwort?

---

# 13. Szenarien unabhängig gestalten

Eine Killercoda-Sitzung ist temporär. Folgeszenarien müssen die Musterlösung des vorherigen Szenarios selbst herstellen.

## Beispiel

Workshop 1:

- Teilnehmer installieren oder konfigurieren eine Anwendung.

Workshop 2:

- Setup stellt die geprüfte Endlösung aus Workshop 1 automatisch her.
- Intro erklärt, welche Komponenten bereits vorbereitet sind.
- Workshop 2 beginnt mit dem neuen Lernziel.

Niemals davon ausgehen, dass Dateien, Container oder Einstellungen aus einer vorherigen Sitzung vorhanden sind.

---

# 14. Sicherheit

- keine echten Zugangsdaten,
- keine persönlichen Daten,
- keine produktiven Cloud-Konten,
- keine fremden Ziele,
- keine privaten SSH-Schlüssel,
- keine unkontrollierten Netzwerk- oder Scan-Ziele,
- temporäre Demo-Passwörter eindeutig kennzeichnen,
- Datenbanken nicht unnötig öffentlich machen,
- privilegierte Container nur bei echtem Lernbedarf,
- destruktive Befehle auf kontrollierte Verzeichnisse begrenzen.

Bei defensiven Cybersecurity-Szenarien nur isolierte, ausdrücklich vorbereitete Ziele verwenden.

---

# 15. Statische Qualitätsprüfung

## JSON

```bash
find . -name index.json -print0 |
while IFS= read -r -d '' file; do
  jq empty "$file" || exit 1
done
```

## Bash

```bash
find . -name '*.sh' -print0 |
while IFS= read -r -d '' file; do
  bash -n "$file" || exit 1
done
```

## Ausführungsrechte

```bash
find . -name '*.sh' -exec chmod +x {} +
```

## Referenzprüfung

Für jede `index.json` prüfen:

- existiert jede `text`-Datei?
- existiert jedes `foreground`-Skript?
- existiert jedes `background`-Skript?
- existiert jedes `verify`-Skript?
- stimmen Groß- und Kleinschreibung?
- sind alle `structure.json`-Pfade vorhanden?

## Inhaltstest

- Szenario in frischer Killercoda-Umgebung starten,
- jeden Schritt in Reihenfolge ausführen,
- Verify zunächst bewusst fehlschlagen lassen,
- Fehlermeldung bewerten,
- Aufgabe korrekt lösen,
- Verify erneut ausführen,
- Browserlinks testen,
- Neustart des gesamten Szenarios testen,
- tatsächliche Bearbeitungszeit messen.

Statische Prüfung ersetzt keinen realen Killercoda-Test.

---

# 16. Empfohlene Szenariodateien

## Teilnehmerdateien

```text
index.json
intro.md
step1.md
step2.md
challenge.md
finish.md
setup.sh
verify.sh
```

## Interne Wartungsdateien

```text
solution.md
trainer-guide.md
test-plan.md
CHANGELOG.md
```

Interne Dateien werden nur referenziert, wenn sie in Killercoda sichtbar sein sollen.

---

# 17. Freigabecheckliste

## Repository

- [ ] GitHub-Verbindung aktiv
- [ ] richtiger Branch
- [ ] Webhook erfolgreich
- [ ] keine Geheimnisse
- [ ] `structure.json` listet nur fertige Inhalte

## Szenario

- [ ] gültige `index.json`
- [ ] bestätigte Backend-ID
- [ ] alle Referenzen vorhanden
- [ ] Intro erklärt Ausgangslage und Ziel
- [ ] Schritte sind didaktisch geordnet
- [ ] Abschluss enthält Abruf und Transfer
- [ ] unabhängiger Startzustand

## Skripte

- [ ] Bash-Syntax gültig
- [ ] ausführbare Rechte
- [ ] nichtinteraktiv
- [ ] Timeouts vorhanden
- [ ] Verify verändert nichts
- [ ] Fehlermeldungen verständlich

## Browser und Netzwerk

- [ ] Dienst läuft
- [ ] bindet korrekt
- [ ] HTTP-Link funktioniert
- [ ] Port stimmt
- [ ] lokaler Curl-Test funktioniert

## Didaktik

- [ ] Zeitbudget realistisch
- [ ] nicht nur anklickbare Befehle
- [ ] selbstständige Challenge
- [ ] Lernziel und Verify deckungsgleich
- [ ] keine unbemerkten Voraussetzungen

---

# 18. Offizielle Quellen

1. Killercoda Creator Documentation  
   https://killercoda.com/creators

2. Killercoda Creator Get Started  
   https://killercoda.com/creators/get-started

3. Offizielle Szenariobeispiele  
   https://github.com/killercoda/scenario-examples

4. Offizielle Gruppen- und Kursbeispiele  
   https://github.com/killercoda/scenario-examples-groups

## Besonders relevante offizielle Beispiele

- `ubuntu-simple`
- `code-actions`
- `verification`
- `foreground-background-scripts`
- `foreground-background-scripts-multi-step`
- `network-traffic`
- `upload-assets`
- `kubernetes-2node-multi-step-verification`

## Aktualitätsregel

Vor Erstellung neuer Szenarien aktuelle offizielle Beispiele erneut prüfen. Diese Datei dokumentiert den verifizierten Stand vom 15. Juli 2026.
