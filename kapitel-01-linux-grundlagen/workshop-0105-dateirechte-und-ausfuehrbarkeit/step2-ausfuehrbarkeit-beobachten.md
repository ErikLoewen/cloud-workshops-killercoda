# Warum startet die Datei nicht?

Eine Datei kann vorhanden und lesbar sein, ohne direkt ausführbar zu sein.
Der relative Aufruf `./dateiname` bedeutet: Starte die Datei dieses Namens aus
dem aktuellen Verzeichnis.

Sage voraus, ob sich deine eigene Signaldatei starten lässt. Probiere den
relativen Aufruf und untersuche danach die Rechteanzeige erneut.

Die Ablehnung ist ein erwartetes Untersuchungsergebnis, kein Szenariofehler.
Welcher Rechtebereich ist für dich maßgeblich? Welches Recht fehlt dort?

<details>
<summary>Hinweis 1: Woran sollte ich zuerst denken?</summary>

Vergleiche `whoami` mit der Besitzerspalte. Lies dann nur die zugehörige
Dreiergruppe im Rechteblock.

</details>

<details>
<summary>Hinweis 2: Welches Werkzeug brauche ich?</summary>

Nutze `ls -l DATEINAME` für die Rechte und `./DATEINAME` für den
Ausführungsversuch.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
whoami
ls -l signaltest
./signaltest
ls -l signaltest
```

Erwartet wird ein fehlendes `x` im Besitzerblock und eine
Berechtigungsfehlermeldung beim Ausführungsversuch.

</details>
