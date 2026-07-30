# Bekannte Wege selbst übertragen

Du befindest dich im `kontrollraum`. Jetzt setzt du die bekannten
Navigationsbausteine selbst zusammen.

## Aufgabe 1: zwei Ebenen nach oben

Dein Ziel ist der `funkraum` im `obergeschoss`. Ergänze:

```text
cd ../../obergeschoss/________
```

Prüfe danach mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm/obergeschoss/funkraum
```

Warum waren zwei aufeinanderfolgende `..` nötig?

## Aufgabe 2: Home und Tab verbinden

Wechsle mit `cd ~/leuchtturm` zurück in den Hauptbereich.

Navigiere anschließend mit Tab in den `vorratsraum`:

1. Beginne mit `cd u` und drücke Tab.
2. Tippe `v` und drücke erneut Tab.
3. Drücke Enter und prüfe mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm/untergeschoss/vorratsraum
```

## Erkläre in eigenen Worten

1. Warum hängt ein relativer Weg vom Ausgangsort ab?
2. Warum funktioniert `~/leuchtturm` von jedem Verzeichnis aus?
3. Warum konnte Tab beide Namen eindeutig ergänzen?
