# Wurzel, Home und absolute Wege

Ein Pfad beschreibt einen Weg zu einem Verzeichnis. Jetzt vergleichst du zwei
wichtige Ausgangspunkte.

## Das Wurzelverzeichnis `/`

`/` allein bezeichnet die oberste Ebene des Verzeichnisbaums.

Gib `cd /` ein und prüfe anschließend mit `pwd`.

**Erwartete Ausgabe:**

```text
/
```

## Das Home-Verzeichnis `~`

`~` ist die Kurzform für das Home-Verzeichnis des aktuellen Benutzers. Für
`waerter` ist das `/home/waerter`.

Gib `cd ~` ein und prüfe wieder mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter
```

Damit gilt:

- `/` ist die oberste Ebene des gesamten Systems.
- `~` führt in dein persönliches Home-Verzeichnis.

## Ein absoluter Pfad

Ein ausgeschriebener absoluter Pfad beginnt mit `/`. Er wird unabhängig vom
aktuellen Standort vom Wurzelverzeichnis aus gelesen.

Wechsle direkt in den Kartenraum:

```text
cd /home/waerter/leuchtturm/obergeschoss/kartenraum
```

Prüfe mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm/obergeschoss/kartenraum
```

Warum funktioniert dieser Weg unabhängig davon, wo du vorher warst?

Wechsle zum Schluss mit `cd ~/leuchtturm/eingang` zurück in den Eingang und
prüfe deinen Standort.
