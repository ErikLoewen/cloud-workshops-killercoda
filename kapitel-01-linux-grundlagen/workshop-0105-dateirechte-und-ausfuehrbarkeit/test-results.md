# Testprotokoll

## Lokal

- Bash-Syntax von `setup.sh`, `verify.sh` und `assets/flag-einreichen`:
  bestanden.
- `jq empty index.json`: bestanden.
- Alle Text-, Foreground-, Verify-, Finish- und Asset-Referenzen: vorhanden.
- Startbild, Rechteillustration und Endbild: gültige PNG-Dateien und in den
  vorgesehenen Markdown-Dateien referenziert.
- Suche nach `rechtelabor`, `/root`, alten Root-Prompts, `demo` und
  `schutzbereich`: keine Treffer im aktuellen Workshopinhalt.
- `git diff --check`: bestanden.
- Abschlussprüfung mit vier Hinweisstufen und vollständigem Flag-Walkthrough:
  statisch geprüft.
- `flag-einreichen` vergleicht ausschließlich die Flag; der CHECK liest
  ausschließlich den atomaren Abgabemarker.
- Sichtbare Teilnehmertexte nach Entfernen aller `details`-Blöcke automatisiert
  auf `sturmlicht` und `tabitha` geprüft: keine Treffer.
- Offene Lerntexte enthalten keine vollständige Fund- oder Befehlskette;
  konkrete Fundorte, Kombinationen, Passwörter und Walkthroughs stehen in
  geschlossenen Hilfen.
- Flag-Literal erscheint nur in Setup, Abgabewerkzeug und interner
  Musterlösung; die Teilnehmerausgabe erfolgt erst in der Abschlussmission.
- Vollständiger Mehrbenutzerlauf: lokal nicht ohne isolierte Root-Umgebung
  ausführbar.

## Manuell erforderlich

- vollständiger Killercoda-Lauf mit Passwortdialogen;
- Darstellung aller drei Bilder;
- Anfängerpilot und Zeitmessung.
