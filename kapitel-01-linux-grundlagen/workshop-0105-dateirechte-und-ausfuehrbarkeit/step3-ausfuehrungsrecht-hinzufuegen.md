# Das Besitzerrecht ergänzen

`chmod u+x signaltest` fügt ausschließlich dem Besitzer das
Ausführungsrecht hinzu. `u` meint den Besitzer der Datei – nicht automatisch
die Person vor dem Bildschirm.

```bash
chmod u+x signaltest
ls -l signaltest
./signaltest
```

Erwartete Ausgabe:

```text
Signalprüfung erfolgreich: Die Schalttafel reagiert.
```

Nur im Besitzerblock ist nun `x` hinzugekommen. Mit `chmod u-x signaltest`
könntest du genau dieses Recht wieder entfernen; für den weiteren Ablauf bleibt
es gesetzt.
