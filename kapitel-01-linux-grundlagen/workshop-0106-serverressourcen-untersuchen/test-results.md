# Testprotokoll – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

**Datum:** 2. August 2026
**Testumgebung:** Repository-Prüfungen auf dem Host, Funktionsprüfung in einem
frischen, kurzlebigen `ubuntu:latest`-Container

## Zusammenfassung

Die technische Mission funktioniert vom Setup bis zum wiederholbaren CHECK. Die
Shell- und JSON-Prüfungen bestehen ebenfalls. Die vier geplanten Bilddateien
sind eingebunden und ihre relativen Pfade wurden statisch geprüft. Im offenen
Lernendentext wird die konkrete Flag nicht vorweggenommen.

## Statische Prüfungen

| Prüfung | Reales Ergebnis | Status |
|---|---|---|
| `bash -n` für `setup.sh` und `verify.sh` | keine Syntaxfehler | bestanden |
| JSON-Syntax von `index.json` | `jq empty` ohne Fehler | bestanden |
| Dateien aus `index.json` | alle acht referenzierten Dateien vorhanden | bestanden |
| `git diff --check` im Workshop | keine Whitespacefehler | bestanden |
| `beschwoerung` vor Step 5 | keine Nennung in Intro oder Step 1 bis 4 | bestanden |
| Offen sichtbarer Teil von Step 5 | Prozessname erst im vierten Dropdown | bestanden |
| Veralteter Pfad `/root/ressourcenlabor` | keine Lernendenreferenz vorhanden | bestanden |
| Themenabgrenzung | keine Paketverwaltungs-, Netzwerk-, HTTP-, Port- oder systemd-Lehre; Nano nur als knapper Ausblick auf Workshop 7 | bestanden |
| Vollständige Befehlsfolgen | in Dropdowns beziehungsweise `solution.md` | bestanden |
| Konkrete Flag im offenen Challenge-Text | nicht vorhanden; nur im geschlossenen Walkthrough | bestanden |
| Konkrete Flag in sonstigem offenen Lernendentext | nicht vorhanden | bestanden |
| Bildreferenzen | vier relative Markdown-Bildpfade; alle Zieldateien vorhanden und korrekt geschrieben | bestanden |

## Setup und Ressourcenfresser

| Prüfung | Reales Ergebnis | Status |
|---|---|---|
| erster Setup-Start | ohne Fehler | bestanden |
| Benutzer | `waerter` vorhanden | bestanden |
| Hostname-Konfiguration | `/etc/hostname` enthält `leuchtturm` | bestanden |
| Arbeitsbereich | `/home/waerter/leuchtturm/aussenstation` und ausführbares Startskript vorhanden | bestanden |
| Anzahl Störprozesse | genau eine Instanz | bestanden |
| Besitzer | `waerter` | bestanden |
| Sichtbarkeit in `ps` | in der sortierten Ausgabe vorhanden | bestanden |
| Sichtbarkeit in `top` | in der Batch-Ausgabe vorhanden | bestanden |
| CPU-Last | in früherer Messreihe 90,9–100 % eines logischen Prozessors | bestanden |
| Priorität | Nice-Wert 15 | bestanden |
| CPU-Worker | auf maximal einen logischen Prozessor begrenzt | bestanden |
| Plattenwachstum | 0 Byte im Kontrollintervall | bestanden |
| RAM-Verbrauch | 3768 KiB RSS im finalen Lauf | bestanden |
| wiederholtes Setup | danach wieder genau eine `beschwoerung`, altes `leuchtfeuer` entfernt | bestanden |

Der sichtbare Laufzeithostname kann in einem unprivilegierten Container nicht
zuverlässig umgestellt werden. Die Hostdatei ist korrekt; die sichtbare
Killercoda-Shell bleibt deshalb ein Backend-Testpunkt.

## Übungsprozess

| Prüfung | Reales Ergebnis | Status |
|---|---|---|
| `sleep 300 &` als `waerter` | gestartet | bestanden |
| Suche mit `pgrep -a sleep` | tatsächliche PID und `sleep 300` sichtbar | bestanden |
| reguläres `kill PID` | Prozess beendet | bestanden |
| Nachkontrolle | PID anschließend nicht mehr aktiv | bestanden |

## Leuchtfeuer und CHECK

| Prüfung | Reales Ergebnis | Status |
|---|---|---|
| Start bei laufender `beschwoerung` | mit Hinweis auf hohe Last verweigert | bestanden |
| reguläres Beenden der Störung | Prozess anschließend verschwunden | bestanden |
| Start nach Fehlerbehebung | erfolgreich | bestanden |
| Prozessprüfung | genau ein `leuchtfeuer`, Besitzer `waerter` | bestanden |
| Doppelstart | verweigert | bestanden |
| Erfolgsausgabe | enthält `FLAG{das_licht_brennt_wieder}` | bestanden |
| falsche Flag | abgelehnt | bestanden |
| korrekte Flag | angenommen | bestanden |
| `verify.sh` | CHECK erfolgreich | bestanden |
| wiederholter CHECK | erneut erfolgreich | bestanden |
| Reset | eine neue Störprozessinstanz, kein altes Leuchtfeuer | bestanden |

## Finaler Teilnehmerweg

Der abschließende End-to-End-Lauf am 1. August 2026 bestand alle zehn
Stationen: Setup, `nproc`/`free -h`/`df -h /`, Beobachtung mit `top`, sortierte
`ps`-Ausgabe, `sleep 300`-Übung, Identifikation und reguläres Beenden von
`beschwoerung`, Leuchtfeuerstart, Flagausgabe, Flag-Abgabe mit wiederholtem
CHECK sowie Reset. Ein vorzeitiger Start erzeugte weder Leuchtfeuer noch Flag.

## Noch im Killercoda-Backend prüfen

- sichtbarer Hostname und automatischer Startpfad der Lernenden-Shell;
- Ressourcenverhalten über eine realistische Labordauer;
- vollständiger Browserdurchlauf einschließlich anklickbarer Codeblöcke und
  CHECK-Eingabe;
- tatsächliche Bilddarstellung der vier Assets im Browser.
