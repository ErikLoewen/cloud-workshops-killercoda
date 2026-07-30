# Ein Platz für Notizen

Wechsle mit dem bekannten absoluten Pfad in den Kartenraum:

```text
cd /home/waerter/leuchtturm/obergeschoss/kartenraum
```

Prüfe deinen Standort mit `pwd`.

## `mkdir`: ein Verzeichnis erstellen

`mkdir` steht für **make directory** und erstellt ein Verzeichnis. Für deine
Beobachtungen soll im Kartenraum der Ordner `notizen` entstehen.

Was erwartest du bei Erfolg: eine Meldung oder direkt den nächsten Prompt?

Führe die erste Demonstration anklickbar aus:

`mkdir notizen`{{exec}}

Ein erfolgreiches `mkdir` bleibt normalerweise still. Das ist kein Fehler.
Der zurückgekehrte Prompt zeigt nur, dass der Befehl beendet ist.

Gib selbst `ls` ein. In der Ausgabe muss nun `notizen` erscheinen.

Wenn stattdessen `File exists` gemeldet wird, gibt es den Namen bereits.
Prüfe den Kartenraum mit `ls`.
