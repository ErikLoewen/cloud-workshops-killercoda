# Bekannte Wege übertragen

Jetzt passt du die bekannten Navigationsmuster an. Die Befehle sind bekannt; ein Teil des Weges muss von dir ergänzt werden.

## Aufgabe 1: einen relativen Pfad vervollständigen

Dein Ausgangsort soll sein:

```text
/root/navigation-labor/uebungszone/nordfluegel/kartenraum
```

Prüfe ihn bei Bedarf mit `pwd`.

Das Ziel ist der `ruheraum` im `suedfluegel`.

Vervollständige diese Eingabe selbst:

```text
cd ../../suedfluegel/________
```

Prüfe danach mit `pwd`.

**Erwartete Ausgabe am Ziel:**

```text
/root/navigation-labor/uebungszone/suedfluegel/ruheraum
```

## Aufgabe 2: Home und Tab kombinieren

Wechsle zur Laborwurzel:

```text
cd ~/navigation-labor
```

Prüfe mit `pwd`, ob du dort angekommen bist.

Navigiere anschließend mit Tab in den `gruener-raum` unter `startpunkt`:

1. Beginne die Eingabe mit `cd s`.
2. Ergänze den ersten eindeutigen Namen mit Tab.
3. Tippe `g`.
4. Ergänze den zweiten eindeutigen Namen mit Tab.
5. Drücke Enter.
6. Prüfe den Standort mit `pwd`.

**Erwartete Ausgabe:**

```text
/root/navigation-labor/startpunkt/gruener-raum
```

Wechsle mit `cd ..` zurück zum `startpunkt` und prüfe erneut mit `pwd`.

**Erwartete Ausgabe:**

```text
/root/navigation-labor/startpunkt
```

## Erkläre in eigenen Worten

1. Warum waren vom `kartenraum` aus zwei aufeinanderfolgende `..` nötig?
2. Warum war `~/navigation-labor` unabhängig vom vorherigen Standort nutzbar?
3. Warum konnte Tab die verwendeten Namen eindeutig vervollständigen?
