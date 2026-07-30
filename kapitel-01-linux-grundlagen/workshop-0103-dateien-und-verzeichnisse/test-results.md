# Testprotokoll – Dateien, Ordner und die erste Spur

## Allgemeine Angaben

- Datum: 2026-07-30
- Umgebung: lokales Repository und isolierter Container `ubuntu:24.04`
- Reale Killercoda-Laufzeit: nicht ausgeführt

## Lokal ausgeführt

| Prüfung | Ergebnis | Befund |
|---|---|---|
| Bash-Syntax | bestanden | `setup.sh`, `verify.sh`, `reveal-first-flag.sh` und `assets/flag-einreichen` sind syntaktisch gültig. |
| JSON | bestanden | `index.json` ist gültig. |
| Referenzen | bestanden | Alle Text-, Skript- und VM-Asset-Referenzen existieren. |
| Bilder | bestanden | Beide PNGs sind gültig, liegen unter `assets/`, verwenden `./assets/...` und stehen nicht in `details.assets`. |
| Altbegriffe | bestanden | Keine Treffer für die geforderten alten Root-, Dateilabor- und Dateinamen in 01.03 oder der angepassten README-Beschreibung. |
| Sichtbare Flag | bestanden | In den sichtbaren Markdown-Dateien steht kein Flag-Klartext. |
| Diff-Prüfung | bestanden | `git diff --check` meldet keine Fehler. |
| Shellcheck | nicht ausgeführt | `shellcheck` ist lokal nicht installiert. |

## In Ubuntu 24.04 ausgeführt

| Prüfung | Ergebnis | Befund |
|---|---|---|
| Setup und Startzustand | bestanden | Reale Login-Shell als `waerter`, Hostname `leuchtturm`, Startpfad im Archiv, Datei im Modus 0644 und im Besitz von `waerter`. |
| Setup zweimal | bestanden | Beide Wiederholungen stellten denselben Ausgangszustand her und entfernten alte Marker. |
| Flag zu Beginn | bestanden | Im sichtbaren Inhalt des letzten Eintrags war keine Flag vorhanden. |
| Falsche Datei | bestanden | Eine beliebige Datei am Ziel löste nichts aus. |
| Kopie | bestanden | Eine Kopie bei weiterhin vorhandener Quelle löste nichts aus. |
| Falscher Zielordner | bestanden | Die echte Datei im Funkraum löste nichts aus. |
| Falsche Namen | bestanden | `erste_spur.txt` und `erste Spur.txt` lösten nichts aus. |
| Falsche Flag | bestanden | Kein Abgabemarker; CHECK blieb erfolglos. |
| Vorgesehener Lernweg | bestanden | Notizordner, Umleitung und alle drei `mv`-Varianten wurden ausgeführt. |
| Echte Verschiebung | bestanden | Die echte Quelle am exakten Ziel löste die Enthüllung genau einmal aus. |
| Datei nach Enthüllung | bestanden | Inhalt atomar ersetzt, Flag exakt einmal, Besitzer `waerter`, Modus 0644. |
| Meldungs-Fallback | bestanden | Vorbereitete Meldung wurde einmal ausgegeben, als gezeigt markiert und entfernt. |
| Flag-Abgabe und CHECK | bestanden | Exakte Flag erzeugte den Abgabemarker; `verify.sh` war erfolgreich. |
| Wiederholbarkeit | bestanden | Erneuter Watcher, erneute Abgabe und erneuter CHECK veränderten den Dateiinhalt nicht. |

## Noch in echter Killercoda-Laufzeit zu prüfen

- zeitliche Reihenfolge von Background- und Foreground-Skript;
- zuverlässige Zuordnung des Teilnehmer-TTY;
- direkte einmalige Anzeige der Terminalmeldung an der Browser-TTY;
- echter Benutzer, Hostname, Startpfad und sauberer Prompt;
- vollständiger Ablauf mit CHECK-Schaltfläche;
- Zeitmessung und Anfängerpilot.
