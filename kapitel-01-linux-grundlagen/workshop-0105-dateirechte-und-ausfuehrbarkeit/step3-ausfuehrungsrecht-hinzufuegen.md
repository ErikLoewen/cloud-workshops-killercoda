# Nur das benötigte Recht ergänzen

`chmod` verändert Dateirechte. Das symbolische Argument wird aus
Rechtebereich, Operation und Recht zusammengesetzt:

```text
chmod   u   +   x   ZIEL
Befehl  │   │   │   └ Datei
        │   │   └ Ausführen
        │   └ hinzufügen
        └ Besitzer
```

Bestimme selbst, auf welche eigene Datei du dieses Muster anwenden musst.
Vergleiche anschließend den alten und neuen Rechteblock und führe die Datei
erneut aus.

Was hat sich verändert? Was blieb unverändert? `chmod` ändert Rechte, nicht
den Dateiinhalt. Die Gegenoperation `u-x` würde dasselbe Besitzerrecht wieder
entfernen.

<details>
<summary>Hinweis 1: Welches Ziel ist gemeint?</summary>

Ändere nur die Datei, deren Ausführung im vorherigen Schritt abgelehnt wurde
und deren Besitzer du selbst bist.

</details>

<details>
<summary>Hinweis 2: Konkrete Syntax</summary>

Setze das Muster `chmod u+x DATEINAME` ein. Kontrolliere davor und danach mit
`ls -l`.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
ls -l signaltest
chmod u+x signaltest
ls -l signaltest
./signaltest
```

Erwartete Ausgabe:

```text
Signalprüfung erfolgreich: Die Schalttafel reagiert.
```

</details>
