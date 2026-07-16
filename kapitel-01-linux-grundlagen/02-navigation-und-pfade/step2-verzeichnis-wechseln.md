# Das Verzeichnis wechseln

Du hast mit `pwd` deinen Standort angezeigt und mit `ls` ein mögliches Ziel gefunden. Jetzt wechselst du dorthin.

## `cd`: den aktuellen Standort ändern

### Was macht `cd`?

`cd` ändert das aktuelle Verzeichnis der laufenden Shell.

### Warum brauchen wir `cd`?

Nur durch einen Verzeichniswechsel kann ein anderer Bereich des Baums zum aktuellen Standort werden.

### Welche Ausgabe oder Veränderung erwarten wir?

Ein erfolgreiches `cd` erzeugt normalerweise **keine eigene Erfolgsausgabe**. Die Veränderung ist der neue Standort. Diesen machen wir anschließend mit `pwd` sichtbar.

## Vorhersage

Wird die folgende Eingabe bei Erfolg den neuen Pfad ausgeben oder normalerweise still bleiben?

Gib selbst ein:

```text
cd navigation-labor
```

Drücke Enter.

Wenn keine Fehlermeldung erscheint, gib danach ein:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor
```

Untersuche nun die sichtbaren Einträge:

```text
ls
```

Die Ausgabe soll diese Namen enthalten; Reihenfolge und Zeilenumbruch können abweichen:

```text
abschlussgebiet
lernstrecke
startpunkt
uebungszone
```

Wechsle in den Startpunkt:

```text
cd startpunkt
```

Prüfe den Standort:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/startpunkt
```

## Beobachtung

- Welche Eingabe veränderte den Standort?
- Welche Eingabe zeigte den veränderten Standort als sichtbare Ausgabe?
- Warum ist eine leere Erfolgsausgabe von `cd` nicht dasselbe wie ein Fehler?

## Bei einer Fehlermeldung

Eine Meldung mit `No such file or directory` weist meist auf einen falschen Namen, einen falschen aktuellen Standort oder eine abweichende Groß- und Kleinschreibung hin.

Prüfe zuerst deinen Standort mit `pwd` und untersuche danach mit `ls` die tatsächlich sichtbaren Namen.
