# Testprotokoll

## Lokal am 31. Juli 2026

- `bash -n setup.sh`: bestanden
- `bash -n verify.sh`: bestanden
- `jq empty index.json`: bestanden
- `git diff --check`: bestanden
- Referenzen aus `index.json`: vollständig
- Suche nach alten Laborpfaden und inkonsistenten Prompts: keine Treffer
- isolierter CHECK: Erfolg und unveränderte Wiederholung bestanden
- negative CHECK-Fälle: fehlende Kopie und verändertes Original erkannt
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

Noch im echten Killercoda-Lauf zu prüfen: Terminalhinweis, Asset-Übertragung
und Setup-Wiederholung mit installiertem `flag-einreichen`.
