# Testplan – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

## Setup

| Nr. | Test | Erwartung |
|---:|---|---|
| 1 | Background-Setup erstmals ausführen | Exit 0; atomare Ready-Datei erst nach vollständiger Vorbereitung |
| 2 | Setup erneut ausführen | alter Zustand bereinigt; wieder genau ein Störprozess |
| 3 | Foreground vor Ready starten | wartet ohne technische Setup-Ausgaben |
| 4 | sichtbaren Prompt und Benutzer prüfen | `waerter@leuchtturm`, `whoami` ergibt `waerter` |
| 5 | Startverzeichnis mit `pwd` prüfen | `/home/waerter/leuchtturm/aussenstation` |
| 6 | Startinhalt prüfen | `leuchtfeuer-start`, `status/` und Wartungsnotiz vorhanden |
| 7 | Störprozess zählen | genau eine Instanz |

## Ressourcenfresser

| Nr. | Test | Erwartung |
|---:|---|---|
| 8 | `pgrep` und `top` prüfen | Prozessname und hohe CPU-Nutzung sichtbar |
| 9 | reduzierte, sortierte `ps`-Ausgabe prüfen | auffälliger Eintrag steht weit oben |
| 10 | CPU-Last nach mindestens fünf Sekunden mehrfach messen | ungefähr 50 bis 70 Prozent eines logischen Prozessors |
| 11 | Priorität prüfen | Nice-Wert 15 |
| 12 | `/proc/PID/comm` und Kommandozeile prüfen | exakt `beschwoerung`; ausführbare Datei ist der Workshoppfad |
| 13 | Verzeichnisgrößen vor/nach Lasttest vergleichen | kein Disk-Wachstum |
| 14 | RSS, `%MEM` und `free -h` beobachten | geringer RAM-Verbrauch |
| 15 | Besitzer prüfen | Prozess gehört `waerter` |
| 16 | reguläres `kill PID` | Prozess endet ohne `kill -9` |

## Übungsprozess

| Nr. | Test | Erwartung |
|---:|---|---|
| 17 | `sleep 300 &` starten | Shell bleibt nutzbar |
| 18 | `pgrep -a sleep` | Übungsinstanz mit Befehlszeile `sleep 300` auffindbar |
| 19 | gefundene PID regulär beenden | Übungsprozess endet |
| 20 | dieselbe Suche wiederholen | Übungsinstanz nicht mehr vorhanden |

## Leuchtfeuer

| Nr. | Test | Erwartung |
|---:|---|---|
| 21 | Start bei laufendem Störprozess | verweigert; keine Flag; kein Leuchtfeuer |
| 22 | Start nach regulärem Beenden | erfolgreich |
| 23 | `pgrep -a leuchtfeuer` | genau eine Instanz als `waerter` sichtbar |
| 24 | zweiten Start versuchen | abgelehnt; weiterhin genau eine Instanz |
| 25 | Erfolgsausgabe prüfen | korrekte Flag erscheint |
| 26 | falsche Flag einreichen | abgelehnt; kein gültiger Abgabemarker |
| 27 | korrekte Flag einreichen | atomarer Abgabemarker entsteht |
| 28 | CHECK vor/nach Abgabe wiederholen | vorher Fehler, danach wiederholt Erfolg |
| 29 | Setup erneut ausführen | beide alten Workshopprozesse entfernt; Ausgangszustand neu erstellt |

## Texte und Didaktik

- `beschwoerung` darf im offenen Teilnehmertext vor Step 5 nicht erscheinen.
- Der Prozessname darf in Step 5 erstmals in einem späten Dropdown stehen.
- Vollständige Befehlsfolgen dürfen nur in Dropdowns und `solution.md`
  erscheinen.
- Die konkrete Flag darf nicht als offene statische Lösung sichtbar sein.
- Keine Referenz auf `/root/ressourcenlabor`, Statusberichte oder
  abzuschreibende Messwerte.
- Keine Abschweifungen zu Paketverwaltung, Netzwerk oder verwalteten
  Systemdiensten.
- Der kurze Ausblick auf den Terminaleditor in Workshop 7 ist zulässig.
- Alle Markdown-Bildpfade müssen existieren oder ausdrücklich als noch nicht
  ausgelieferte Platzhalter dokumentiert sein.
- Unterstützungsprogression und CHECK-Grenze müssen mit Trainerleitfaden und
  Challenge übereinstimmen.
- Die sichtbare Prozentwert-Erklärung steht vor dem Arbeitsauftrag in Step 2
  und Step 3; der Prozessname wird dabei nicht verraten.

## Syntax und Referenzen

- Alle vorhandenen Shellskripte einschließlich `foreground.sh` mit `bash -n`
  prüfen.
- Das von `setup.sh` erzeugte `leuchtfeuer-start` extrahieren und mit
  `bash -n` prüfen.
- `index.json` mit `jq empty` validieren.
- Sämtliche `text`-, `foreground`-, `verify`- und Asset-Referenzen aus
  `index.json` auf Existenz und Groß-/Kleinschreibung prüfen.
- Relative Markdownlinks und Bildreferenzen prüfen.
- Ausführungsrechte der Shellskripte prüfen.
- Nach festen Lern-PIDs, unscharfem `pkill` und versehentlicher Ausgabe des
  CPU-Workers suchen.
- `git diff --check` ausführen.

## Reale Plattformprüfung

Alle Tests sind abschließend in einer frischen Killercoda-Ubuntu-Sitzung zu
wiederholen. Ein isolierter lokaler Ubuntu-Container bestätigt die
Skriptlogik, ersetzt aber nicht die sichtbare Terminal- und Bildprüfung im
echten Backend.
