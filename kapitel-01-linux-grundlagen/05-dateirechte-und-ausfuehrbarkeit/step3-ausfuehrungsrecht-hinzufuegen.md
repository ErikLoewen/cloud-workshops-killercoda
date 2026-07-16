# Schritt 3: Das Ausführungsrecht des Besitzers ergänzen

Nun ergänzt du genau ein Recht für genau einen Rechtebereich.

## Den Befehl zerlegen

```text
chmod        u+x        ohne-ausfuehrungsrecht
Befehl       Rechte-    Ziel
             argument
```

`chmod` verändert Dateirechte. In diesem Workshop verändert der Befehl ausschließlich Rechte und niemals den Dateiinhalt.

Das zusammengehörige Rechteargument `u+x` wird so gelesen:

```text
u        +              x
Besitzer hinzufügen     ausführen
```

- `u` bezeichnet hier den Besitzerbereich.
- `+` bedeutet innerhalb dieses Arguments: hinzufügen.
- `x` bezeichnet das Ausführungsrecht.
- `+` ist kein Rechenoperator.
- `u+x` ist kein eigener Befehl.
- `u+x` ist kein Shelloperator.
- Gruppe und andere erhalten dadurch kein neues Recht.

## Rechte gezielt ändern

Gib selbst ein:

```bash
chmod u+x ohne-ausfuehrungsrecht
```

Kontrolliere die Veränderung anschließend selbst:

```bash
ls -l
```

Erwarteter Rechteblock der Datei:

```text
-rwxr--r--
```

Beobachte genau:

- Nur eine Stelle wechselt von `-` zu `x`.
- Diese Stelle liegt im Besitzerbereich.
- Lesen und Schreiben des Besitzers bleiben erhalten.
- Gruppe und andere bleiben unverändert.

## Datei direkt ausführen

Gib selbst ein:

```bash
./ohne-ausfuehrungsrecht
```

Erwartete Ausgabe:

```text
Demo-Datei erfolgreich ausgeführt
```

## Erkläre

> Warum funktioniert dieselbe Ausführungsform jetzt, obwohl der Dateiinhalt nicht verändert wurde?

Eine passende Kernaussage lautet:

> Das Ausführungsrecht des Besitzers wurde ergänzt.
