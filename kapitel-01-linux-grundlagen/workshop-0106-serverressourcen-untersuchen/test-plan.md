# Testplan – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

## Setup

| Nr. | Test | Erwartung |
|---:|---|---|
| 1 | Setup erstmals ausführen | Umgebung ohne künstliche Wartezeit vorbereitet; keine technische Ausgabe |
| 2 | sichtbaren Benutzer prüfen | `whoami` ergibt `waerter` |
| 3 | Hostname prüfen | `leuchtturm`, soweit vom Backend erlaubt |
| 4 | Startverzeichnis mit `pwd` prüfen | `/home/waerter/leuchtturm/aussenstation` |
| 5 | Startinhalt prüfen | `leuchtfeuer-start`, `status/` und Wartungsnotiz vorhanden |
| 6 | Intro und Step 1 prüfen | keine `beschwoerung`, kein Regler, kein Aktivierungsmarker |
| 7 | `nproc`, `free -h`, `df -h /` | funktionieren ohne künstliche Last |

## Step-2-Aktivierung

| Nr. | Test | Erwartung |
|---:|---|---|
| 8 | Step 2 erstmals öffnen | Background-Skript startet genau eine `beschwoerung` |
| 9 | Aktivierungsmarker prüfen | erst nach validiertem Worker und Regler atomar vorhanden |
| 10 | Step 2 erneut öffnen | Exit 0; dieselbe PID; keine zweite Instanz |
| 11 | Prozess regulär beenden und Step 2 erneut öffnen | kein Neustart; Marker bleibt vorhanden |
| 12 | vollständiges Setup erneut ausführen | Prozesse und Marker entfernt; vor Step 2 keine Störung |
| 13 | Step 2 nach vollständigem Setup öffnen | genau eine neue Instanz mit neu ermittelter PID |

## Ressourcenfresser

| Nr. | Test | Erwartung |
|---:|---|---|
| 14 | `pgrep`, `top` und sortiertes `ps` prüfen | `beschwoerung` klar sichtbar und weit oben |
| 15 | CPU-Last nach kurzer Einlaufzeit messen | ungefähr 10 bis 20 Prozent |
| 16 | Priorität prüfen | Nice-Wert 15 |
| 17 | `/proc/PID/comm` und Kommandozeile prüfen | exakt `beschwoerung`; ausführbare Datei ist der Workshoppfad |
| 18 | Verzeichnisgrößen vor/nach Lasttest vergleichen | kein Disk-Wachstum |
| 19 | RSS und `%MEM` beobachten | geringer RAM-Verbrauch |
| 20 | Besitzer prüfen | Prozess gehört `waerter` |
| 21 | reguläres `kill PID` | Worker und Regler enden ohne `kill -9` |

## Übungsprozess

| Nr. | Test | Erwartung |
|---:|---|---|
| 22 | `sleep 300 &` starten | Shell bleibt nutzbar |
| 23 | `pgrep -a sleep` | Übungsinstanz mit Befehlszeile `sleep 300` auffindbar |
| 24 | gefundene PID regulär beenden | Übungsprozess endet |
| 25 | dieselbe Suche wiederholen | Übungsinstanz nicht mehr vorhanden |

## Leuchtfeuer

| Nr. | Test | Erwartung |
|---:|---|---|
| 26 | Start bei laufendem Störprozess | verweigert; keine Flag; kein Leuchtfeuer |
| 27 | Start nach regulärem Beenden | erfolgreich |
| 28 | `pgrep -a leuchtfeuer` | genau eine Instanz als `waerter` sichtbar |
| 29 | zweiten Start versuchen | abgelehnt; weiterhin genau eine Instanz |
| 30 | Erfolgsausgabe prüfen | korrekte Flag erscheint |
| 31 | falsche Flag einreichen | abgelehnt; kein gültiger Abgabemarker |
| 32 | korrekte Flag einreichen | atomarer Abgabemarker entsteht |
| 33 | CHECK vor/nach Abgabe wiederholen | vorher Fehler, danach wiederholt Erfolg |
| 34 | Setup erneut ausführen | alte Workshopprozesse und Marker entfernt |

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

- Alle vorhandenen Shellskripte einschließlich `step2-background.sh` mit
  `bash -n` prüfen.
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
