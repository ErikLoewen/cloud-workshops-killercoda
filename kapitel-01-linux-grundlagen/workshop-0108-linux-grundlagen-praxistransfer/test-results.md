# Testergebnisse – Workshop 0108

## Teststand

- **Datum:** 3. August 2026
- **Repository:** lokaler Arbeitsstand nach Prompt 25
- **Technische Umgebung:** isolierter Container `ubuntu:24.04`
- **Statische Umgebung:** lokaler Repository-Checkout
- **Bestanden:** 80 Prüfgruppen, darunter eine Matrix mit 15 Parserfällen
- **Fehlgeschlagen:** 0 Workshopprüfungen
- **Nicht als bestanden gewertet:** 1
- **Reale Killercoda-Browserprüfung:** nicht ausgeführt

Die Zahl der Prüfgruppen ist nicht mit den 118 Test-IDs des Testplans
gleichzusetzen. Mehrere eng zusammengehörige IDs wurden in einer technischen
Assertion gemeinsam geprüft. Nur tatsächlich ausgeführte Assertions sind in
diesem Bericht als bestanden markiert.

## Zusammenfassung

| Bereich | Ausgeführt | Ergebnis |
|---|---:|---|
| Statische Repositoryprüfungen | 14 Prüfgruppen | 14 bestanden |
| Hauptsuite: Setup, regulärer Weg, Fehlerpfade, Parser, Speedrun und CHECK | 49 Prüfgruppen | 48 bestanden, 1 offen |
| Ergänzungssuite: Rechte, Dateitypen, Fremdprozess, Session und Reset | 16 Prüfgruppen | 16 bestanden |
| Separater sichtbarer Teilnehmerweg | 1 Prüfgruppe | 1 bestanden |
| Abschließender Kernreview nach Korrekturen | 1 Prüfgruppe | 1 bestanden |
| Gesamt | 81 Prüfgruppen | 80 bestanden, 0 fehlgeschlagen, 1 offen |

Ein erster Lauf der Ergänzungssuite wurde wegen eines Fehlers im temporären
Testharness abgebrochen: Der Harness wollte ein bereits zuvor entferntes
Fragment nochmals löschen. Nach Korrektur dieses Testschritts wurde die
gesamte Ergänzungssuite von einem frischen Containerzustand aus wiederholt und
bestand mit 16 von 16 Prüfgruppen. Dies war kein Fehler im Workshop.

## 1. Setup, Start und Ausgangszustand

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| Frischer Setup-Lauf | Exit-Code 0; gemessene Laufzeit 108 ms. | bestanden |
| Zweiter Setup-Lauf | Exit-Code 0; gemessene Laufzeit 55 ms; eigene alte PID durch genau eine neue ersetzt. | bestanden |
| Benutzer | `waerter` mit Home `/home/waerter`; Teilnehmerstamm vorhanden. | bestanden |
| Startstruktur | Plan, Werkzeuge, Erinnerungen, Steuerung, Nachrichten und vier Fragmente vorhanden. | bestanden |
| Rechte | Archivstamm `waerter:waerter:755`, Stabilisierung `waerter:waerter:755`, interner Parser `root:root:755`. | bestanden |
| Ausgangskonfiguration | Beide Kommentare, Leerzeile und `ERINNERUNG=fragmentiert` bytegenau vorhanden. | bestanden |
| Erzeugte Skripte | Stabilisierung, Parser, Prozessstarter, Status, Flag-Abgabe und Wrapper mit `bash -n` geprüft. | bestanden |
| Prozessanzahl | Genau eine Instanz mit Besitzer `waerter` und `comm=altes_echo`. | bestanden |
| Alte Zustände | Künstliche Sicherung und Flag-Abgabemarker beim zweiten Setup entfernt. | bestanden |
| Sichtbare Setupausgabe | Keine Benutzeranlage, Setupbefehle oder Ready-Meldung in der Ausgabe. | bestanden |
| Nano-Verfügbarkeit | `command -v nano` lieferte im minimalen lokalen Ubuntu-Container keinen Pfad. | **offen** |

Der Startpfad wurde technisch als vorbereitet geprüft. Sichtbarer Prompt,
automatischer Startpfad im Browserterminal und interaktive Nano-Bedienung
benötigen weiterhin eine reale Killercoda-Sitzung.

## 2. Fragmente und Nachrichten

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| Vier Fragmente | Exakt `fragment_FFD700`, `fragment_8B0000`, `fragment_D6C84B` und `fragment_7G00FF`. | bestanden |
| Absichtliches `G` | Datei bestätigt den absichtlich ungültigen Wert `7G00FF`. | bestanden |
| Erste Diagnose | Alle vier vorhandenen Namen konkret ausgegeben; Exit-Code 1. | bestanden |
| Nur ein Fragment entfernt | `fragment_FFD700` fehlte danach in der Diagnose; die drei verbleibenden Namen wurden weiter gemeldet. | bestanden |
| Vollständige Entfernung | Nach vier gezielten Pfaden wechselte die Diagnose zum Echozustand. | bestanden |
| Nachrichtenanzahl | Genau fünf Dateien mit den vorgesehenen Namen. | bestanden |
| Besitzer | In Dateireihenfolge `olmstead`, `root`, `waerter`, `nobody`, `daemon`. | bestanden |
| Lesbarkeit | Alle fünf Dateien als `waerter` lesbar. | bestanden |
| `ls -l` | Abweichende Eigentümer gleichzeitig sichtbar. | bestanden |
| Besitzerreset | Zwei Eigentümer manipuliert; Setup stellte alle fünf Vorgaben wieder her. | bestanden |

## 3. Wiederkehrende Datei, Prozess und Pipe

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| Prozess und Datei vorhanden | Eigene Diagnose für Zustand A; Exit-Code 1. | bestanden |
| Datei gelöscht, Prozess läuft | Eigene Diagnose für Zustand B; Exit-Code 1. | bestanden |
| Gemessene Rückkehr | Datei erschien nach 2935 ms erneut. | bestanden |
| Wiederhergestellter Inhalt | SHA-256 vor und nach Rückkehr identisch. | bestanden |
| Vorhandene Datei | Mtime blieb über vier Sekunden unverändert; keine fortlaufende Überschreibung. | bestanden |
| Ressourcen | Gemessen: 0,0 % CPU und 3908 KiB RSS im gültigen Ergänzungslauf. | bestanden |
| Pflichtpipe | `ps -eo user,pid,comm \| grep altes_echo` zeigte die Workshopinstanz. | bestanden |
| Prozessidentität | `USER=waerter`, dynamische PID und `COMMAND=altes_echo` gegen `/proc` validiert. | bestanden |
| Falsche PID | `kill 999999` lieferte ungleich 0; die gültige `altes_echo`-PID lief unverändert weiter. | bestanden |
| Normaler `kill` | Eindeutig geprüfte PID reagierte auf `TERM`; Prozess endete ohne erzwungenes Signal. | bestanden |
| Prozess beendet, Datei bleibt | Eigene Diagnose für Zustand C; Exit-Code 1. | bestanden |
| Endgültige Entfernung | Nach Prozessende entfernt; nach fünf Sekunden weder Datei noch Prozess vorhanden. | bestanden |
| Gefilterte Pipe-Ausgabe | Pflichtbefehl 30-mal ausgeführt; stets nur `COMMAND=altes_echo`, keine normale `COMMAND=grep`-Zeile. | bestanden |

### Präzisierung der Pipe-Ausgabe

Der Pflichtbefehl verwendet ausschließlich die Spalten `user,pid,comm`:

```bash
ps -eo user,pid,comm | grep altes_echo
```

Eine normale `grep`-Zeile besitzt in `comm` nur den Wert `grep` und enthält
damit den Suchtext `altes_echo` nicht. Lerntext, Grafik, Lösung, Testplan und
Trainerleitfaden wurden im Abschlussreview an dieses tatsächlich gemessene
Verhalten angepasst. Die didaktische Reduktion auf `USER`, `PID` und
`COMMAND` bleibt erhalten.

## 4. Archivschlüssel

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| Ausgangsort | Diagnose nennt `erinnerungen/archivschluessel.txt` und das erwartete Ziel. | bestanden |
| Fehlende Datei | Schlüssel temporär entfernt; eigene Fehlermeldung ohne Neuerzeugung. | bestanden |
| Doppelte Datei | Kopien in `erinnerungen` und `steuerung`; beide Fundorte als mehrdeutig erkannt. | bestanden |
| Falscher Ort | Datei unter `protokolle/falscher-ort`; tatsächlicher relativer Pfad ausgegeben. | bestanden |
| Beschädigter Inhalt | Datei am Ziel verändert; als nicht unverändert abgelehnt. | bestanden |
| Korrekter Zielzustand | Genau eine unveränderte Datei unter `steuerung`; Diagnose wechselte zur Konfiguration. | bestanden |

## 5. Parser und Konfigurationsfehler

Eine Matrix mit 15 Fällen wurde über
`./steuerung/archiv-pruefen` aus dem Teilnehmer-Startverzeichnis ausgeführt.
Hashes von Konfiguration und angewendetem Status blieben in jedem Matrixfall
unverändert.

| Fälle | Erwarteter und beobachteter Exit-Code | Status |
|---|---:|---|
| `fragmentiert`, `strukturiert`, `eins`, `ungeteilt`, `vereint` | 1 | bestanden |
| `klar` | 0 | bestanden |
| unbekannter Wert | 1 | bestanden |
| doppelter Schlüssel | 1 | bestanden |
| unbekannter Schlüssel | 1 | bestanden |
| Leerzeichen und leerer Wert | 1 | bestanden |
| ungültige freie Zeile | 1 | bestanden |
| Semikolon-Injection | 1, keine Ausführung | bestanden |
| Kommentare und Leerzeilen mit `klar` | 0 | bestanden |
| fehlende Datei | 1 | bestanden |

Zusätzlich aktiv geprüft:

| Fehlerpfad | Tatsächlicher Befund | Status |
|---|---|---|
| Falscher Nachrichtenwert | `ERINNERUNG=vereint` verwies auf widersprüchliche Quellen und zeigte die Lösung nicht. | bestanden |
| Formal beschädigte Nano-Datei | `ERINNERUNG =klar` wurde mit konkreter Leerzeichenmeldung abgelehnt. Die Beschädigung wurde technisch simuliert; keine interaktive Nano-Sitzung. | bestanden |
| Befehlsersetzungs-Injection | `ERINNERUNG=$(touch /tmp/workshop0108-injected)` abgelehnt; Nachweisdatei entstand nicht. | bestanden |
| Datei unlesbar | Modus `000` als Teilnehmer getestet und konkret abgelehnt. | bestanden |
| Symlink | Symlink auf reguläre Konfiguration abgelehnt. | bestanden |
| Schlüssel fehlt in Datei | Reine Kommentar-Datei meldete fehlendes `ERINNERUNG`. | bestanden |

## 6. Regulärer technischer Lernweg

Der vollständige technische Zustandsweg wurde aus einem frischen Setup
durchgeführt:

1. Plan und erste Diagnose;
2. vier Fragmente einzeln beseitigt;
3. Datei gelöscht und Rückkehr beobachtet;
4. Prozess über Pflichtpipe, Benutzer, PID und Name identifiziert;
5. falsche PID negativ getestet;
6. richtige PID normal beendet und Wirkung kontrolliert;
7. Datei endgültig entfernt;
8. Schlüssel gelesen und nach `steuerung` verschoben;
9. Besitzer der fünf Nachrichten verglichen;
10. Ausgangskonfiguration gesichert;
11. stabile Konfiguration hergestellt und mit `archiv-pruefen` geprüft;
12. finale Stabilisierung ausgeführt;
13. ausgegebene Flag exakt eingereicht und CHECK gestartet.

Zusätzlich wurde diese sichtbare Befehlsfolge in einem separaten frischen
Container noch einmal zusammenhängend ausgeführt. Dabei wurden Plan, alle vier
Fragmenttexte, zurückgekehrte Datei, Prozessliste, Schlüsselinhalt,
Nachrichtenmetadaten, `whoami`, echte Nachricht, Originalkonfiguration,
Sicherung, Konfigurationsprüfung, Stabilisierung, Flag-Abgabe und CHECK
tatsächlich aufgerufen.

Beobachteter Befund:

- finale Stabilisierung Exit-Code 0;
- exakte erwartete Flag in der Erfolgsausgabe;
- Flag-Abgabe Exit-Code 0;
- CHECK Exit-Code 0;
- wiederholte Flag-Abgabe und wiederholter CHECK erneut Exit-Code 0.

Die eigentliche Nano-Tastaturbedienung wurde mangels Nano im minimalen
Container nicht ausgeführt. Der resultierende gültige und der formal
beschädigte Dateiinhalt wurden direkt hergestellt und vollständig durch die
Workshopwerkzeuge geprüft. Ein vollständiger interaktiver Teilnehmerweg bleibt
daher als Killercoda-Test offen.

## 7. Speedrun

Nach einem neuen Reset wurde ausschließlich ausgeführt:

```bash
printf '%s\n' 'ERINNERUNG=klar' > steuerung/archiv.conf
./leuchtturm-stabilisieren
```

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| Vorzustände ungelöst | Fragmente, `altes_echo`, Erinnerungsdatei und Schlüssel am Ausgangsort blieben vorhanden. | bestanden |
| Stabilisierung | Exit-Code 0 und exakte Flag. | bestanden |
| Flag und CHECK | Exakte Abgabe sowie CHECK Exit-Code 0. | bestanden |
| Doppelter Eintrag | Kein Speedrun, keine Flag, Exit-Code 1. | bestanden |
| Unbekannter Schlüssel | Kein Speedrun, keine Flag, Exit-Code 1. | bestanden |
| Syntaxfehler | Kein Speedrun, keine Flag, Exit-Code 1. | bestanden |
| Kommentare/Leerzeilen | Ein klarer Eintrag mit erlaubten Kommentaren und Leerzeilen wurde akzeptiert. | bestanden |

Für den Speedrun wurde kein `grep`-Befehl benötigt.

## 8. Flag-only-CHECK

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| CHECK vor Abgabe | Exit-Code 1. | bestanden |
| Falsche Flag | Exit-Code 1; kein gültiger Marker. | bestanden |
| Führendes Leerzeichen | Exit-Code 1. | bestanden |
| Nachgestelltes Leerzeichen | Exit-Code 1. | bestanden |
| Regulärer Weg | Abgabe und CHECK Exit-Code 0. | bestanden |
| Speedrun | Abgabe und CHECK Exit-Code 0. | bestanden |
| Wiederholung | Erneute Abgabe und CHECK Exit-Code 0. | bestanden |
| Fremde Session-ID | Manipulierter Marker abgelehnt. | bestanden |
| Missionsänderung nach Abgabe | Konfiguration wieder auf instabil gesetzt; CHECK blieb erfolgreich. | bestanden |

Der letzte Test bestätigt, dass `verify.sh` ausschließlich die aktuelle
Flag-Abgabe prüft und keine Missionsprüfung wiederholt.

## 9. Reset und Schutzgrenzen

| Test | Tatsächlicher Befund | Status |
|---|---|---|
| Prozessreset | Genau eine neue Workshopinstanz mit neuer dynamischer PID. | bestanden |
| Erinnerungsdatei | Exakter Ausgangsinhalt wieder vorhanden. | bestanden |
| Fragmente | Alle vier Bereiche wieder vorhanden. | bestanden |
| Schlüssel | Ausschließlich am Ausgangsort unter `erinnerungen`. | bestanden |
| Nachrichtenbesitzer | Alle fünf Vorgaben nach aktiver Manipulation wiederhergestellt. | bestanden |
| Konfiguration | Wieder `ERINNERUNG=fragmentiert`; Sicherung entfernt. | bestanden |
| Flagzustand | Abgabemarker entfernt; CHECK bis zur neuen Abgabe nicht erfolgreich. | bestanden |
| Session | Neue Session-ID erzeugt; alte ID verschieden. | bestanden |
| Fremder Prozess | Separater Prozess mit `comm=altes_echo` und anderer Executable blieb beim Setup aktiv. | bestanden |
| Externe Datei | `/tmp/workshop0108-sentinel` blieb unverändert. | bestanden |

## 10. Statische Repositoryprüfung

Vierzehn Prüfgruppen wurden ausgeführt und bestanden:

- `bash -n` für Repositoryskripte;
- `jq empty index.json`;
- `git diff --check`;
- alle `index.json`-Referenzen vorhanden;
- keine konkrete Flag in Intro, Steps, Challenge oder Finish;
- keine alte Workshopstruktur;
- keine Auswertung von `archiv.conf` mit `source`, Punktbefehl oder `eval`;
- keine feste PID in einem `kill`-Befehl;
- rekursive Setup-Löschung nur nach exaktem Pfadwächter;
- kein globales `pkill` oder `killall`;
- alle gerenderten Assetreferenzen vorhanden;
- Pipe-und-grep-PNG als gültiges Bild mit 1600 × 900 Pixeln;
- technische Dateinamen ohne Leerzeichen oder Umlaute;
- 28 sichtbare `<details>`-Dropdowns mit 28 schließenden Tags.

## 11. Offen: reale Killercoda-Prüfungen

Die folgenden Punkte wurden nicht ausgeführt und sind ausdrücklich nicht als
bestanden markiert:

- sichtbarer Browserstart ohne kurz sichtbare Root-Shell;
- Prompt `waerter@leuchtturm` und automatischer Startpfad im echten TTY;
- tatsächliche Nano-Installation und komplette Tastaturfolge;
- Eingabe des Pipe-Zeichens im Browserterminal;
- Darstellung und Lesbarkeit der PNG-Grafik in Killercoda;
- Verhalten aller Dropdowns im gerenderten Szenario;
- CHECK-Schaltfläche nach Flag-Abgabe;
- reale Bearbeitungszeit und Anfängerpilot.

## Gesamtbefund

Die lokal ausführbare technische Workshoplogik bestand ohne Fehler. Regulärer
Zustandsweg, Speedrun, negative Diagnosepfade, Parser, Flag-Abgabe, CHECK und
Reset sind reproduzierbar.

Nach der Präzisierung der Pipe-Darstellung wurde ein weiterer frischer
Kernreview ausgeführt. Er bestätigte Setup-Idempotenz, genau eine neue
`altes_echo`-Instanz, vollständige Fragmentdiagnose, 30 gefilterte
Pipe-Ausgaben ohne unpassende `grep`-Zeile, falschen Nachrichtenwert,
Injectionabwehr, regulären Erfolg, Flag-only-CHECK und Speedrun. Beobachtete
Setup-PIDs waren 97 und 196; die Werte sind ausschließlich Evidenz dieses
Laufs.

Vor einer Veröffentlichung muss die reale Killercoda-Umgebung Nano, Prompt,
Startpfad, Grafik und CHECK im Browser bestätigen.
