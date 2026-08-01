# Gesperrtes Signal

Hinter dem geräumten Kartenraum führt der Weg in den Flur. Neben der
Eingangstür steht eine alte Schalttafel, deren angeschlossener Rechner noch
reagiert. Darauf liegen mehrere Dateien – doch nicht alle gehören demselben
Benutzer.

![Im dunklen Flur des Leuchtturms steht neben der verriegelten Eingangstür eine alte Schalttafel mit drei Namensschildern.](./assets/0105-einstieg-schalttafel.png)

Du startest als `waerter` direkt an der Schalttafel:

```text
waerter@leuchtturm:~/leuchtturm/flur/schalttafel$
```

## Am Ende kannst du

- Rechte mit `ls -l` lesen und Besitzer, Gruppe und andere unterscheiden,
- `r`, `w` und `x` erklären,
- eine Datei mit `./dateiname` ausführen,
- fehlendes Ausführungsrecht erkennen und gezielt mit `chmod u+x` ergänzen,
- mit `su - BENUTZER` wechseln und mit `whoami` sowie `pwd` kontrollieren,
- erklären, warum Zugangsdaten nicht in Logs gehören.

Neu sind nur die Rechteanzeige, die gezielte Rechteänderung und der einfache
Benutzerwechsel. Benutzerverwaltung, numerische Rechte und Besitzeränderungen
gehören nicht zu diesem Workshop.
