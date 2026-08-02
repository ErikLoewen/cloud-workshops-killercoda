# Testprotokoll – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

**Datum:** 2. August 2026
**Testumgebung:** Repository-Prüfungen auf dem Host; vollständiger Funktionslauf
in einem frischen `ubuntu:latest`-Container mit Init-Prozess und dem Hostnamen
`leuchtturm`

## Zusammenfassung

Die technische Mission funktioniert nach der Reparatur vom synchronisierten
Login bis zum wiederholbaren CHECK. Die sichtbare Shell startet erst nach dem
atomaren Ready-Signal als `waerter@leuchtturm` im vorgesehenen Arbeitsbereich.
Der Störprozess erscheint in `/proc`, `pgrep`, `ps` und `top` eindeutig als
`beschwoerung` und lag in den Messungen stabil bei ungefähr 60 Prozent CPU.

## Ursache des realen Fehlers

Das bisherige `setup.sh` war zugleich technische Vorbereitung und
Foreground-Shell. Es gab kein Ready-Signal zwischen einem unsichtbaren Setup
und dem sichtbaren Teilnehmerterminal. Im realen Backend blieb deshalb die
ursprüngliche Shell `root@ubuntu` sichtbar. Der Lastprozess war außerdem eine
kopierte `yes`-Datei ohne Duty-Cycle. Sein mehrstufiger Launcher und Fortbestand
waren nicht unabhängig vom Setup-Lebenszyklus abgesichert; die erwartete
Prozessinstanz war im Browserlauf nicht vorhanden.

Die neue Umsetzung trennt beide Lebenszyklen. `setup.sh` läuft im Background
und schreibt die Ready-Datei erst nach allen technischen Selbstprüfungen.
`foreground.sh` wartet darauf und startet anschließend die Login-Shell. Der
Worker ist eine Kopie von Bash unter dem echten Dateinamen `beschwoerung`. Ein
separat identifizierter Regler pausiert ihn jeweils 40 Millisekunden und lässt
ihn anschließend 60 Millisekunden rechnen. Beide Prozesse werden mit
`setsid --fork` vom kurzlebigen `runuser`-Launcher gelöst.

## Statische Prüfungen

| Prüfung | Reales Ergebnis | Status |
|---|---|---|
| `bash -n` für Setup, Foreground, Verify und Flag-Werkzeug | keine Syntaxfehler | bestanden |
| JSON-Syntax von `index.json` | `jq empty` ohne Fehler | bestanden |
| Dateien aus `index.json` | alle Text-, Background-, Foreground-, Verify- und Asset-Referenzen vorhanden | bestanden |
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
| Ready-Synchronisation | Foreground vor Setup gestartet; Login erst nach abgeschlossenem Setup | bestanden |
| sichtbare Identität | `whoami` = `waerter`, Hostname = `leuchtturm` | bestanden |
| Startverzeichnis | `/home/waerter/leuchtturm/aussenstation` | bestanden |
| Anzahl Störprozesse | genau eine lebende Instanz | bestanden |
| `/proc/PID/comm` | `beschwoerung` | bestanden |
| `pgrep -a beschwoerung` | PID und Workshoppfad sichtbar | bestanden |
| Besitzer und Priorität | `waerter`, Nice-Wert 15 | bestanden |
| CPU-Last, erste Messung | 59,7 % | bestanden |
| CPU-Last, zweite Messung | 59,5 % | bestanden |
| CPU-Last in `top` | 61,0 % | bestanden |
| RAM-Verbrauch | 3552 KiB RSS, 0,0 % MEM | bestanden |
| Plattenwachstum über zehn Sekunden | 0 Byte | bestanden |
| wiederholtes Setup | alte PID 74 entfernt, neue PID 176; genau eine Instanz und ein Regler | bestanden |
| normales `kill PID` | Worker und zugehöriger Regler anschließend nicht mehr vorhanden | bestanden |

`top` zeigte den Worker mit großem Abstand an erster Stelle. Nach dem regulären
Beenden sanken Worker- und Regleranzahl auf null; damit entfiel die gemessene
Lastquelle vollständig. Das Terminal blieb während aller Messungen bedienbar.

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
| Reset | genau eine neue Störprozessinstanz und ein Regler; kein altes Leuchtfeuer oder Abgabemarker | bestanden |

## Finaler Teilnehmerweg

Der End-to-End-Lauf bestand Ready-Warten, Login-Prüfung, zweimaliges Setup,
Prozess- und Ressourcenmessung, verweigerten vorzeitigen Leuchtfeuerstart,
reguläres Beenden von `beschwoerung`, erfolgreichen Leuchtfeuerstart, negative
und positive Flag-Abgabe, zweimaligen erfolgreichen CHECK sowie finalen Reset.
Ein vorzeitiger Start erzeugte weder Leuchtfeuer noch Flag.

## Noch im Killercoda-Backend prüfen

- Browserdarstellung des Prompts `waerter@leuchtturm` nach Killercodas
  tatsächlichem Background-/Foreground-Start;
- Ressourcenverhalten über eine vollständige reale Labordauer;
- vollständiger Browserdurchlauf einschließlich anklickbarer Codeblöcke und
  CHECK-Eingabe;
- tatsächliche Bilddarstellung der vier Assets im Browser.
