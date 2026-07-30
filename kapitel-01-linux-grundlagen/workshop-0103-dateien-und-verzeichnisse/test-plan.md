# Testplan – Dateien, Ordner und die erste Spur

## Statische Prüfungen

- `index.json` validieren und alle Referenzen auf Existenz prüfen.
- `bash -n` für `setup.sh`, `verify.sh`, `reveal-first-flag.sh` und
  `assets/flag-einreichen`.
- `shellcheck` verwenden, falls verfügbar.
- Bildpfade mit `./assets/...` und Ausschluss der PNGs aus `details.assets`
  prüfen.
- Alte Laborpfade, Root-Prompts und veraltete Begriffe suchen.

## Ausgangszustand

Nach dem Setup müssen `whoami`, `hostname` und `pwd` liefern:

```text
waerter
leuchtturm
/home/waerter/leuchtturm/untergeschoss/lagerraum/archiv
```

Der vollständige Leuchtturmbaum ist vorhanden. `letzter_eintrag.txt` liegt
nur im Archiv, gehört `waerter`, besitzt den exakten Ausgangsinhalt und die
Flag ist dort noch nicht sichtbar. Der Hintergrundprozess wartet.

## Negative Tests

- beliebige Datei `erste-spur.txt`;
- kopierte Quelle bei weiterhin vorhandenem Original;
- echte Quelle im falschen Zielordner;
- Namen `erste_spur.txt` und `erste Spur.txt`;
- Datei mit falschem Inhalt;
- falsche Flag-Abgabe;
- CHECK ohne Abgabemarker.

Keiner dieser Zustände darf die Enthüllung beziehungsweise den erfolgreichen
CHECK auslösen.

## Positiver Test

1. Quelle aus dem Archiv in den Kartenraum verschieben und zugleich in
   `erste-spur.txt` umbenennen.
2. Einmalige Terminalmeldung prüfen.
3. Datei mit `cat` lesen und Flag genau einmal nachweisen.
4. Flag exakt mit `flag-einreichen` abgeben.
5. `verify.sh` ausführen.

## Wiederholbarkeit

- Hintergrundskript erneut starten;
- Flag erneut einreichen;
- CHECK mehrfach ausführen.

Flag, Meldung und Inhalt dürfen nicht verdoppelt oder beschädigt werden.

## Echte Killercoda-Laufzeit

Zusätzlich im Browser prüfen:

- Reihenfolge von Foreground- und Background-Skript;
- echter Prompt, Benutzer, Hostname und Startpfad;
- vollständig geleertes Terminal nach dem Setup;
- zuverlässige Zuordnung der Teilnehmer-TTY;
- einmalige Anzeige der Meldung und Fallback am nächsten Prompt;
- CHECK-Schaltfläche und erneute Prüfung nach Korrektur;
- Bearbeitungszeit mit absoluten Anfängern.
