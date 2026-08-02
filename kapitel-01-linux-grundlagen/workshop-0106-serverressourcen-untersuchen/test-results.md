# Testprotokoll – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

**Datum:** 2. August 2026
**Testumgebung:** Repository-Prüfungen auf dem Host; vollständiger Funktionslauf
in einem frischen `ubuntu:latest`-Container mit Init-Prozess und dem Hostnamen
`leuchtturm`

## Zusammenfassung

Die technische Mission funktioniert nach der Step-spezifischen Umstellung vom
direkten Login bis zum wiederholbaren CHECK. Intro und Step 1 laufen ohne
künstliche Last. Erst `step2-background.sh` aktiviert genau einmal die
Störung. Der Prozess erscheint in `/proc`, `pgrep`, `ps` und `top` eindeutig
als `beschwoerung` und lag im Messlauf bei ungefähr 17 Prozent CPU.

## Ursache des realen Fehlers

Die vorherige Reparatur führte ein separates `foreground.sh` mit einer bis zu
45 Sekunden sichtbaren Ready-Schleife ein. Killercoda speiste diese Schleife in
das Teilnehmerterminal ein; dadurch blieb zunächst `root@ubuntu` sichtbar und
der Benutzerwechsel hing von der parallelen Setup-Fertigstellung ab. Zudem
startete das globale Setup den Ressourcenfresser bereits vor Intro und Step 1.

Die neue Umsetzung verwendet wieder direkt das im Repository vorhandene
`setup.sh`-Muster der Workshops 4 und 5. Das Setup bereitet ausschließlich
Benutzer, Arbeitsverzeichnis und Login vor und wechselt anschließend mit
`exec su - waerter` in die Login-Shell. Die technische Prozessvorbereitung
erfolgt erst durch Step 2. Der
aktive Hostname wird nur noch bestmöglich gesetzt und kann das Setup nicht vor
dem Benutzerwechsel abbrechen. Es gibt keine Ready-Datei und keine
Setup-Warteschleife. Der Worker wird nur vom Background-Skript des zweiten
Schritts gestartet. Ein sitzungsgebundener Marker verhindert jeden weiteren
Start bis zum vollständigen Workshopneustart. Der Lastregler pausiert den
Worker jeweils 85 Millisekunden und lässt ihn danach 15 Millisekunden rechnen.

## Statische Prüfungen

| Prüfung | Reales Ergebnis | Status |
|---|---|---|
| `bash -n` für Setup, Step-2-Background, Verify und Flag-Werkzeug | keine Syntaxfehler | bestanden |
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
| Setup und Login bis `exit` | 160 ms; außer Terminal-Clear keine technische Ausgabe | bestanden |
| sichtbare Identität | `whoami` = `waerter`, Hostname = `leuchtturm` | bestanden |
| Startverzeichnis | `/home/waerter/leuchtturm/aussenstation` | bestanden |
| `nproc`, `free -h`, `df -h /` vor Step 2 | erfolgreich | bestanden |
| Zustand vor Step 2 | kein Worker, kein Regler, kein Aktivierungsmarker | bestanden |
| erster Step-2-Aufruf | eine Instanz; Marker erst nach validiertem Start | bestanden |
| zweiter Step-2-Aufruf | gleiche PID 90; weiterhin genau eine Instanz | bestanden |
| `/proc/PID/comm` | `beschwoerung` | bestanden |
| `pgrep -a beschwoerung` | PID und Workshoppfad sichtbar | bestanden |
| Besitzer und Priorität | `waerter`, Nice-Wert 15 | bestanden |
| CPU-Last in `ps` | 16,9 bis 17,2 % | bestanden |
| CPU-Last in `top` | 17,0 % | bestanden |
| RAM-Verbrauch | 3716 bis 3728 KiB RSS, jeweils 0,0 % MEM | bestanden |
| Plattenwachstum über zehn Sekunden | 0 Byte | bestanden |
| normales `kill PID` | Worker und zugehöriger Regler anschließend nicht mehr vorhanden | bestanden |
| Step 2 nach `kill` erneut geöffnet | kein Neustart; Marker bleibt vorhanden | bestanden |
| vollständiger Neustart | vor Step 2 keine Störung; danach neue PID 470 und genau eine Instanz | bestanden |
| Hotfix bei unveränderbarem Hostnamen `ubuntu` | Login weiterhin als `waerter` im richtigen Arbeitsverzeichnis; Step-2-Start erfolgreich | bestanden |
| Hotfix-Messung unter Hostname `ubuntu` | 17,7 % CPU, 3668 KiB RSS, Nice 15, Besitzer `waerter` | bestanden |
| vollständig entkoppelter Start | Login als `waerter`, obwohl `start-beschwoerung` vor Step 2 noch nicht installiert ist | bestanden |
| Step 2 nach entkoppeltem Start | PID 99, 17,7 % CPU, 3848 KiB RSS, Besitzer `waerter` | bestanden |
| vollständiger Reset der entkoppelten Variante | alte PID 99 entfernt; Step 2 startet genau eine neue PID 322 | bestanden |
| Step-2-Background ausdrücklich als `waerter` | Exit 0; genau eine `beschwoerung` | bestanden |
| Messung bei Background-Ausführung als `waerter` | 17,3 % CPU, 3664 KiB RSS, Nice 15, Besitzer und `comm` korrekt | bestanden |
| wiederholte Background-Ausführung als `waerter` | weiterhin genau eine Instanz | bestanden |

`top` und das sortierte `ps` zeigten den Worker mit großem Abstand an erster
Stelle. Nach dem regulären Beenden sanken Worker- und Regleranzahl auf null;
damit entfiel die gemessene Lastquelle vollständig. Der Container blieb
während der Messung flüssig bedienbar.

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

Der End-to-End-Lauf bestand direktem Login, Ressourcenbefehlen ohne Störung,
zweimaligem Step-2-Aufruf, Prozess- und Ressourcenmessung, verweigertem
vorzeitigen Leuchtfeuerstart, regulärem Beenden von `beschwoerung`, erneutem
Step-2-Aufruf ohne Neustart, erfolgreichem Leuchtfeuerstart, negativer und
positiver Flag-Abgabe, zweimaligem erfolgreichen CHECK sowie vollständigem
Reset und neuer einmaliger Step-2-Aktivierung. Ein vorzeitiger Start erzeugte
weder Leuchtfeuer noch Flag.

## Noch im Killercoda-Backend prüfen

- Browserdarstellung des Prompts `waerter@leuchtturm` nach Killercodas
  tatsächlicher Foreground-Ausführung von `setup.sh`;
- bestätigen, dass Killercoda beim schnellen Setup keine Skriptzeilen in das
  sichtbare Teilnehmerterminal einblendet;
- Ressourcenverhalten über eine vollständige reale Labordauer;
- vollständiger Browserdurchlauf einschließlich anklickbarer Codeblöcke und
  CHECK-Eingabe;
- tatsächliche Bilddarstellung der vier Assets im Browser.
