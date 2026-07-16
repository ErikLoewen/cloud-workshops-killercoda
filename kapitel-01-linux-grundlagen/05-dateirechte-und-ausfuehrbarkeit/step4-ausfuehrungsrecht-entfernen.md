# Schritt 4: Das Besitzer-Ausführungsrecht wieder entfernen

Die Demo-Datei soll nach der Übung wieder ihren Ausgangszustand besitzen.

## Den Befehl zerlegen

```text
chmod        u-x        ohne-ausfuehrungsrecht
Befehl       Rechte-    Ziel
             argument
```

Das zusammengehörige Rechteargument `u-x` wird so gelesen:

```text
u        -             x
Besitzer entfernen     ausführen
```

- `-` bedeutet innerhalb dieses Arguments: das Recht entfernen.
- Dieser Bindestrich ist nicht das Dateitypzeichen.
- Er ist auch nicht der Platzhalter für ein fehlendes Recht in einer Anzeige.
- Nur das Ausführungsrecht des Besitzers wird entfernt.
- Lesen und Schreiben bleiben erhalten.
- Gruppe und andere bleiben unverändert.
- Der Dateiinhalt bleibt unverändert.

## Recht entfernen und kontrollieren

Gib selbst ein:

```bash
chmod u-x ohne-ausfuehrungsrecht
```

Kontrolliere danach:

```bash
ls -l
```

Erwarteter Rechteblock:

```text
-rw-r--r--
```

Ein zweiter Ausführungsfehler ist nicht erforderlich.

## Kurze Anwendung

Ergänze gedanklich das fehlende Stück:

```text
chmod u__ dateiname
```

- Für das Hinzufügen des Besitzer-Ausführungsrechts fehlt `+x`.
- Für das Entfernen des Besitzer-Ausführungsrechts fehlt `-x`.

Vorhersage:

```text
-rw-r--r--
```

Würde `./dateiname` für den Besitzer direkt funktionieren?

Vergleiche danach:

```text
-rwxr--r--
```

Welche einzelne Stelle ist anders? Welche beiden Rechtebereiche sind unverändert?

## Sicherheitsprinzip

> Ergänze nur das Recht, das für die konkrete Aufgabe benötigt wird, und nur für den vorgesehenen Rechtebereich.

Für unsere Aufgabe bedeutet das: Nur der Besitzer benötigt das Ausführungsrecht. Gruppe und andere erhalten kein neues Recht.
