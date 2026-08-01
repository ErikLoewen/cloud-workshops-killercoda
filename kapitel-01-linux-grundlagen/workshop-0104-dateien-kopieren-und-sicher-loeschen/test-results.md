# Testprotokoll

## Lokal am 31. Juli 2026

- `bash -n setup.sh`: bestanden
- `bash -n verify.sh`: bestanden
- `jq empty index.json`: bestanden
- `git diff --check`: bestanden
- Referenzen aus `index.json`: vollständig
- Suche nach alten Laborpfaden und inkonsistenten Prompts: keine Treffer
- isolierter CHECK: Erfolg und unveränderte Wiederholung bestanden
- ursprüngliche Endzustandsprüfungen: fehlende Kopie und verändertes Original
  erkannt; seit 2.1.0 bewusst nicht mehr Teil des CHECKs
- Ubuntu-24.04-Wegwerfcontainer: Setup zweimal, Benutzer, Hostname,
  Startstruktur, Originalschutz, vollständiger Lernweg und CHECK bestanden

## Noch manuell erforderlich

- echter Killercoda-Plattformtest einschließlich sichtbarer Start-Shell;
- visueller Plattformtest der eingefügten Intro- und Outrobilder;
- Anfängerpilot mit Zeitmessung und Beobachtung der Sicherheitsroutine.

## Änderung 2.1.0 – lokal geprüft

- Bash-Syntax von `setup.sh`, `verify.sh`, `reveal-wall-note.sh` und
  `assets/flag-einreichen`: bestanden
- `jq empty index.json` und `git diff --check`: bestanden
- isolierter Ubuntu-24.04-Ablauf: Wandnotiz nach 103 ms erschienen
- falsche Flag abgelehnt, korrekte Flag angenommen: bestanden
- CHECK und unveränderte Wiederholung: bestanden
- Flag-Abgabe und Wiederholung bei vollständig gesperrtem technischem
  `/var/lib`-Statusordner: bestanden
- CHECK ohne Abgabemarker abgelehnt: bestanden
- CHECK mit gültigem Abgabemarker ohne weitere Dateisystemprüfung: bestanden

Noch im echten Killercoda-Lauf zu prüfen: Terminalhinweis, Asset-Übertragung
und Setup-Wiederholung mit installiertem `flag-einreichen`.

## Änderung 2.1.1 – lokal geprüft

- Watcher-Ausgabe auf eigene Zeilen begrenzt und anschließende
  Readline-Neuzeichnung per `SIGWINCH` ergänzt.
- Bash-Syntax aller betroffenen Setup-, Reveal-, Verify- und Abgabeskripte:
  bestanden.
- `jq empty index.json`, Skill-Validierung und `git diff --check`: bestanden.
- Der CHECK prüft weiterhin ausschließlich den erfolgreichen Flag-Status.

Noch im echten Killercoda-Lauf zu prüfen: sichtbare Prompt-Neuzeichnung ohne
`Strg+C` im Browserterminal.
