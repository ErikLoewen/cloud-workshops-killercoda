# Durch den Leuchtturm: Verzeichnisse wechseln

Du hast den Bereich `leuchtturm` mit `ls` entdeckt. Jetzt wechselst du hinein.

## `cd`: den Standort ändern

`cd` steht für **„change directory“**. Der Befehl ändert das aktuelle
Verzeichnis der Shell.

Was erwartest du bei einem erfolgreichen Wechsel: eine Meldung oder zunächst
keine Ausgabe?

Gib ein:

```text
cd leuchtturm
```

Ein erfolgreiches `cd` bleibt normalerweise still. Das ist kein Fehler.
Prüfe den neuen Standort mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm
```

Untersuche nun mit `ls` die sichtbaren Bereiche:

```text
eingang
obergeschoss
technik
untergeschoss
```

Wechsle anschließend in den `eingang` und prüfe wieder mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm/eingang
```

## Beobachtung

- Welcher Befehl veränderte den Standort?
- Welcher Befehl machte die Veränderung sichtbar?

Eine Meldung mit `No such file or directory` weist meist auf einen falschen
Namen, einen falschen Ausgangsort oder abweichende Groß- und Kleinschreibung
hin. Prüfe dann zuerst mit `pwd` und `ls`.
