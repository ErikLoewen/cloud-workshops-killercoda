# Eine Arbeitsnotiz schreiben

`echo` kennst du bereits: Der Befehl erzeugt Textausgabe. Das Zeichen `>`
wird von der Shell verarbeitet und leitet diese Ausgabe in eine Datei um.

```text
echo TEXT > DATEIPFAD
```

- Links von `>` entsteht Text.
- Rechts davon steht die Zieldatei.
- Fehlt die Datei, wird sie angelegt.
- Existiert sie bereits, wird ihr bisheriger Inhalt ersetzt.

## Notiz anlegen

Sage voraus: Erscheint der Text nach dem nächsten Befehl im Terminal oder in
der Datei?

Gib selbst ein:

```text
echo Logbuch im Archiv gefunden. > notizen/arbeitsnotiz.txt
```

Der Prompt kehrt ohne Textausgabe zurück. Prüfe die Datei:

```text
cat notizen/arbeitsnotiz.txt
```

**Erwartete Ausgabe:**

```text
Logbuch im Archiv gefunden.
```

## Überschreiben bewusst erkennen

Ein einzelnes `>` ersetzt vorhandenen Inhalt. Führe denselben
`echo`-Befehl noch einmal aus und lies die Datei erneut mit `cat`.

Warum steht der Satz weiterhin nur einmal in der Datei?
