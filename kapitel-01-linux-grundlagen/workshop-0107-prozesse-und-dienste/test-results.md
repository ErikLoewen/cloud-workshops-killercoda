# Testprotokoll – Workshop 01.07

## Allgemeine Angaben

- Testdatum: 2. August 2026
- Tester: Codex
- Repository: `cloud-workshops-killercoda`
- Workshop: `kapitel-01-linux-grundlagen/workshop-0107-prozesse-und-dienste`
- Lokale Umgebung: Linux-Host, statische Prüfungen mit Bash, jq, Python und ripgrep
- Laufzeitumgebung: kurzlebige Docker-Container auf Basis von `ubuntu:24.04`
- Teilnehmerkonto im Container: `waerter`
- Arbeitsverzeichnis im Container: `/home/waerter/leuchtturm/lichtsteuerung`
- Ergebnis: alle ausgeführten automatisierten Prüfungen bestanden; echte
  Killercoda-Browser- und Nano-Interaktionsprüfungen sind noch offen

Am selben Tag wurde anschließend ein vollständiger Abschlussreview zu Story,
Fachlichkeit, Didaktik, Technik, Scope und Dateikonsistenz durchgeführt. Nach
der Korrektur des Übergangs zum Deichserver wurden die statischen Prüfungen und
der technische End-to-End-Weg erneut ausgeführt.

## Ausgeführte Befehlsgruppen

Die folgenden Befehle beziehungsweise gleichwertigen automatisierten
Prüfsequenzen wurden tatsächlich ausgeführt:

```bash
bash -n setup.sh verify.sh
jq empty index.json
git diff --check -- kapitel-01-linux-grundlagen/workshop-0107-prozesse-und-dienste
```

Zusätzlich wurden mit `rg`, `stat` und einem kleinen lesenden Python-Skript
geprüft:

- Referenzen aus `index.json`,
- ausgeglichene `<details>`-Blöcke,
- offene Flags in Teilnehmertexten,
- aktive Altverweise auf Prozess- und Dienstinhalte,
- `/root`- beziehungsweise Root-Prompt-Altlasten,
- `eval`, feste PIDs und unsicheres Laden von `leuchtfeuer.conf`,
- Ausführungsrechte von `setup.sh` und `verify.sh`.

Die Laufzeittests starteten jeweils einen frischen Ubuntu-Container und führten
das echte Setup aus:

```bash
bash /scenario/setup.sh
```

Danach liefen die Teilnehmerbefehle als `waerter` im vom Setup gesetzten
Arbeitsverzeichnis. Dateiänderungen wurden im automatisierten Test mit `sed`
beziehungsweise kontrolliertem Schreiben simuliert. Die interaktive Bedienung
von Nano wurde dadurch nicht als getestet gewertet.

## Statische Prüfungen

| Testbereich | Ergebnis | Reale Evidenz |
|---|---|---|
| Bash-Syntax der Repositoryskripte | bestanden | `bash -n setup.sh verify.sh` endete mit Exit-Code 0. |
| Bash-Syntax der erzeugten Skripte | bestanden | Parser, Flag-Abgabe und alle drei Teilnehmerwerkzeuge wurden nach realem Setup mit `bash -n` geprüft. |
| JSON-Syntax | bestanden | `jq empty index.json` endete mit Exit-Code 0. |
| Indexreferenzen | bestanden | Alle 12 aus `index.json` gelesenen Datei- und Skriptreferenzen existieren. |
| Dropdown-Struktur | bestanden | In jeder Markdown-Datei war die Anzahl öffnender und schließender `details`-Tags gleich. |
| Offene Flag | bestanden | Intro, Steps, Challenge und Finish enthalten kein `FLAG{`. |
| Alte aktive Lerninhalte | bestanden | Außerhalb ausdrücklich historischer Qualitätsdokumente wurden keine aktiven `lab-worker`-, systemd- oder Dienstinhalte gefunden. |
| Root-Altlasten | bestanden | Keine Teilnehmeranweisung und kein Startpfad verweist auf `/root` oder `root@leuchtturm`. |
| Parser-Sicherheit | bestanden | Kein `eval`; `leuchtfeuer.conf` wird weder mit `source` noch mit `.` geladen. |
| Feste PIDs | bestanden | Keine fest codierte PID oder PID-basierte Hintergrundlogik gefunden. |
| Ausführungsrechte im Repository | bestanden | `setup.sh` und `verify.sh` besitzen Modus `755`. |
| Whitespace | bestanden | `git diff --check` meldete keinen Fehler. |
| Storykontinuität | bestanden | Workshop 6 endet mit dem laufenden, falsch sendenden Leuchtfeuer; Workshop 7 übernimmt dieses Muster direkt und führt über Laterne und Fußspuren zum Deichserver aus Workshop 8. |
| Fachliche Rollentrennung | bestanden | Log beantwortet „Was geschah?“, Dokumentation erklärt zulässige Werte, Konfiguration enthält den gespeicherten Solltext und Status zeigt ausschließlich angewendete Werte. |
| Didaktische Reihenfolge | bestanden | Geführte Untersuchung, Sicherung, Nano-Worked-Example, teilgeführte Änderung, Validierung, Anwendung und selbstständiger Transfer sind getrennt und vollständig. |
| Scope-Review | bestanden | Treffer zu alten Themen erscheinen nur als Changelog-Historie, Testausschluss oder bewusste fachliche Reduktion; keine unpassende Altlast ist teilnehmerwirksam. |

## Setup und Ausgangszustand

| Test | Ergebnis | Reale Evidenz |
|---|---|---|
| Frisches Setup | bestanden | Das echte `setup.sh` erzeugte Benutzer, Verzeichnisse, Dateien, internen Parser, Flag-Werkzeug und State. |
| Teilnehmerbenutzer | bestanden | `id -un` ergab `waerter`. |
| Startverzeichnis | bestanden | `$PWD` ergab `/home/waerter/leuchtturm/lichtsteuerung`. |
| Nano-Verfügbarkeit | bestanden | `command -v nano` ergab `/usr/bin/nano`; Nano wurde im frischen Ubuntu-Image durch das Setup bereitgestellt. |
| Log, Anleitung und Konfiguration | bestanden | Alle drei Dateien waren als `waerter` lesbar und enthielten den definierten Ausgangstext. |
| Ausgangsstatus | bestanden | Status enthielt `LEUCHTFEUER=aktiv`, `ROTATION=impuls`, `GESCHWINDIGKEIT=langsam`, `BEREICH=meer`. |
| Keine alte Sicherung oder Flag | bestanden | `leuchtfeuer.conf.bak` und `status/abschlussflagge` fehlten nach frischem Setup. |
| Eigentümer und Rechte | bestanden | Konfiguration `waerter:waerter:644`; drei Teilnehmerwerkzeuge `waerter:waerter:755`; interner Parser `root:root:755`. |
| Wiederholtes Setup | bestanden | Zweites reales Setup setzte Konfiguration, Status und Log zurück und entfernte Sicherung, Flag sowie Abgabemarker. |
| Begrenzter Reset | bestanden | Eine fremde Sentinel-Datei außerhalb des Workshopbereichs blieb samt Hash unverändert. |

Hinweis zur Testumgebung: Nach dem absichtlich herbeigeführten EOF der
nichtinteraktiven Teilnehmer-Shell liefert `su - waerter` im Container den
Exit-Code 1. Das Setup verwendet diese Shell im realen Szenario dauerhaft als
Teilnehmerterminal. Deshalb wurde der EOF-Code nicht als Setupfehler gewertet;
der erzeugte Zustand und der zweite Resetlauf wurden danach vollständig geprüft.

## Validierung und Fehlerpfade

| Test | Ergebnis | Reale Ausgabe oder Befund |
|---|---|---|
| Alle zulässigen Werte | bestanden | Alle 12 Kombinationen aus drei Rotationen, zwei Geschwindigkeiten und zwei Bereichen wurden akzeptiert. |
| `ROTATION=kries` | bestanden | Exit-Code 1; `ROTATION kennt den Wert "kries" nicht.` |
| `BEREICH=kuste` | bestanden | Exit-Code 1; `BEREICH kennt den Wert "kuste" nicht.` |
| `ROTATION = kreis` | bestanden | Exit-Code 1; Formatmeldung zu `SCHLUESSEL=WERT`. |
| Fehlendes `BEREICH` | bestanden | Exit-Code 1; `Die Einstellung BEREICH fehlt.` |
| Doppeltes `ROTATION` | bestanden | Exit-Code 1; Mehrfachmeldung für `ROTATION`. |
| Unbekannter Schlüssel `FARBE` | bestanden | Exit-Code 1; unbekannter Schlüssel wurde genannt. |
| Leerer Wert | bestanden | Exit-Code 1. |
| Kommentare und Leerzeilen | bestanden | Gültige Datei mit mehreren Kommentaren und Leerzeilen wurde akzeptiert. |
| Fehlende Datei | bestanden | Exit-Code 1. |
| Nicht lesbare Datei | bestanden | Als `waerter` mit Modus `000` getestet; Exit-Code 1. |
| Symbolischer Link als Eingabe | bestanden | Exit-Code 1. |
| Shell-Sonderzeichen/Injection | bestanden | `ROTATION=$(touch /tmp/workshop0107-injected)` wurde mit Exit-Code 1 abgelehnt; Nachweisdatei entstand nicht. |
| Prüfen ohne Anwenden | bestanden | Hash des angewendeten Status blieb unverändert; Status zeigte weiterhin `impuls`, obwohl die Datei gültig `kreis` enthielt. |
| Ungültige Datei neu laden | bestanden | Exit-Code 1; Hashes von Status und Log blieben unverändert. |

## End-to-End, Anwenden, Sicherung und Flag

Der vollständige Teilnehmerweg wurde technisch simuliert:

1. Setup ausgeführt.
2. Als `waerter` im richtigen Verzeichnis gearbeitet.
3. Log, Wartungsanleitung und Konfiguration gelesen.
4. `leuchtfeuer.conf.bak` aus dem Ausgangszustand erstellt.
5. Rotation auf `kreis` geändert, kontrolliert und validiert.
6. Konfiguration neu geladen und Laufzeitstatus geprüft.
7. Bereich auf `kueste` geändert, erneut kontrolliert und validiert.
8. Konfiguration neu geladen, Status und Flag geprüft.
9. Falsche und richtige Flag-Abgabe sowie wiederholter CHECK geprüft.
10. Setup erneut ausgeführt und Ausgangszustand kontrolliert.

| Test | Ergebnis | Reale Evidenz |
|---|---|---|
| Rotation repariert, Bereich Meer | bestanden | Status: `kreis`, `langsam`, `meer`; keine Flag. |
| Datei geändert, nicht angewendet | bestanden | Status blieb auf dem zuvor angewendeten Wert. |
| Küstenzustand ohne Sicherung | bestanden | Zustand wurde angewendet, aber keine Flagdatei erzeugt; Hinweis auf fehlende Ausgangssicherung erschien. |
| Falsche Sicherung | bestanden | Sicherung mit verändertem Inhalt erfüllte die Flagbedingung nicht. |
| Falsche Geschwindigkeit | bestanden | `kreis`, `normal`, `kueste` erzeugte keine Flag. |
| Vollständiger Missionszustand | bestanden | Status: `kreis`, `langsam`, `kueste`; Flag exakt `FLAG{die_spur_fuehrt_vom_turm_fort}`. |
| Erneutes Neuladen | bestanden | Wiederholtes Anwenden blieb erfolgreich und gab dieselbe Flag erneut aus. |
| Falsche Flag | bestanden | Exit-Code 1; Ausgabe `Diese Flag ist nicht korrekt.` |
| Flag mit zusätzlichem Leerzeichen | bestanden | Führendes und nachfolgendes Leerzeichen wurden jeweils mit Exit-Code 1 abgelehnt. |
| CHECK nach falscher Flag | bestanden | Exit-Code 1; CHECK meldete, dass noch keine erfolgreiche Abgabe vorliegt. |
| Richtige Flag | bestanden | Abgabe wurde akzeptiert; CHECK endete erfolgreich. |
| CHECK wiederholt | bestanden | Zweiter CHECK blieb erfolgreich. |
| Fremde Sitzungskennung | bestanden | Manipulierter Abgabemarker wurde mit Exit-Code 1 abgelehnt. |
| Temporäre State-Dateien | bestanden | Nach erfolgreichen und fehlgeschlagenen Läufen blieben keine `*.tmp.*`-Dateien in Status oder Protokollen zurück. |
| Reset | bestanden | Sicherung, Flag und Abgabemarker entfernt; Konfiguration, Status und Log exakt auf Anfangszustand zurückgesetzt. |
| End-to-End-Wiederholung nach Abschlussreview | bestanden | Vollständiger Weg von Setup über beide Änderungen, Flag-Abgabe und wiederholten CHECK bis zum zweiten Setup erneut erfolgreich. |

## Fehlgeschlagene Tests und Korrekturen

- Fehlgeschlagene Workshoptests: keine.
- Notwendige technische Korrekturen am Workshopcode: keine.
- Redaktionelle Korrektur: Der Abschluss nennt nun ausdrücklich die alten
  Gebäude am Deich und den Deichserver als Ziel der Spur. Damit ist der
  Übergang zum Titel und Schauplatz von Workshop 8 eindeutig.
- Im temporären Testharness wurde ausschließlich die Ausgabe des Exit-Codes
  erwarteter Negativtests korrigiert. Danach wurden die betroffenen Tests erneut
  ausgeführt und lieferten jeweils den realen Exit-Code 1.

## Offene Killercoda-Browserprüfungen

Die folgenden Punkte wurden nicht als bestanden markiert, weil sie in einem
lokalen Container keine echte Killercoda-Browser- und Terminaloberfläche
reproduzieren:

| Test | Status | Grund |
|---|---|---|
| Sichtbarer Prompt `waerter@leuchtturm` | offen | Benutzer und Startpfad sind bestätigt; der Docker-Container durfte seinen Kernel-Hostname nicht ändern. |
| Keine sichtbare Root-Shell oder Setup-Ausgabe | offen | Erfordert Beobachtung des Killercoda-Starts im Browser. |
| Nano startet im Browserterminal | offen | Programm ist installiert, aber interaktive Oberfläche wurde nicht im Browser geprüft. |
| Pfeiltasten in Nano | offen | Erfordert echtes interaktives Terminal. |
| `Strg+X` ohne Änderung | offen | Erfordert echtes interaktives Terminal. |
| `Strg+O` und Dateinamenbestätigung | offen | Speichern wurde technisch simuliert, nicht per Nano-Tastendruck. |
| Versehentliche Änderung mit `N` verwerfen | offen | Erfordert Nano-Dialog im Browserterminal. |
| Darstellung bei kleiner Terminalhöhe | offen | Browser- und terminalabhängig. |
| Anfängerpilot und Zeitmessung | offen | Benötigt reale Teilnehmende. |

## Finaler Teststatus

- Statische Repositoryprüfungen: **bestanden**
- Setup im isolierten Ubuntu-System: **bestanden**
- Benutzer, Arbeitsverzeichnis, Rechte und Nano-Verfügbarkeit: **bestanden**
- Parser und geforderte Fehlerpfade: **bestanden**
- Getrenntes Datei-/Laufzeitmodell: **bestanden**
- Anwenden, Log, Sicherung und Flaglogik: **bestanden**
- Flag-Abgabe und wiederholter CHECK: **bestanden**
- Reset und erneuter Lauf: **bestanden**
- Echte Killercoda-Browser-/Nano-Prüfung: **offen**

Technische Freigabe für einen Killercoda-Browserpilot: **ja**. Eine endgültige
Veröffentlichungsfreigabe erfolgt erst nach den offenen Browser- und
Nano-Prüfungen.
