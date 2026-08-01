# Das Signal testen

`./` bezeichnet das aktuelle Verzeichnis. Mit `./signaltest` versuchst du,
die dort liegende Datei direkt auszuführen.

Sage zuerst voraus, ob das gelingt. Probiere es dann:

`./signaltest`{{exec}}

Die Ablehnung ist beabsichtigt. Prüfe erneut mit `ls -l signaltest`: Im
Besitzerblock fehlt `x`. Die Datei ist lesbar, aber noch nicht ausführbar.
`cat` würde nur Inhalt anzeigen und wäre keine Ausführung.
