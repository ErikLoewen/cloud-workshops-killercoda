# Testplan

## Statisch

- Bash-Syntax aller Skripte und JSON validieren.
- Alle `index.json`-Referenzen und drei Bildpfade prüfen.
- Nach alten Begriffen und Root-Prompts suchen.
- Offenen Haupttext getrennt von `details`-Blöcken prüfen: keine Passwörter,
  keine vollständige Fundkette und keine offene Komplettlösung.
- Geschlossene Hilfen auf die Eskalation Denkrichtung → Fundort/Werkzeug →
  konkreter Ansatz → vollständiger Walkthrough prüfen.

## Positiver Ablauf

1. Start als `waerter` im Schalttafelpfad prüfen.
2. Besitzer, Gruppen und Ausgangsmodus beider ausführbaren Dateien prüfen.
3. `signaltest` vor `chmod` ablehnen, danach ausführen.
4. Mit Passwort `sturmlicht` zu `nachtwache` wechseln.
5. Besitzer der beiden Logs als `mrs_ah` und `waerter` erkennen, die
   Kontonamen mit `getent passwd | cut -d: -f1` anzeigen und mit `tabitha` zu
   `mrs_ah` wechseln.
6. `letzte-nachricht` erst in der Abschlussprüfung vor `chmod` ablehnen,
   danach ausführen und die Flag erstmals anzeigen.
7. Falsche Flag ablehnen, korrekte Flag annehmen und CHECK wiederholt bestehen.

## Negative Fälle

- Korrekte Flag unabhängig von früheren technischen Lernwegzuständen annehmen.
- CHECK ohne oder mit falschem Marker ablehnen.
- Andere Benutzer dürfen nicht `chmod u+x` an einer fremden Zieldatei
  erfolgreich durchführen.

## Manuell in Killercoda

- Passwortdialoge, unsichtbare Passworteingabe und verschachtelte
  `su`-Sitzungen prüfen.
- Bilddarstellung, Prompt, Anfängerführung und Gesamtzeit testen.
- Alle vier Hinweisstufen und den vollständigen Walkthrough der
  Abschlussprüfung testen.
- Prüfen, dass die Flag erst bei der Abschlussmission ausgegeben wird.
