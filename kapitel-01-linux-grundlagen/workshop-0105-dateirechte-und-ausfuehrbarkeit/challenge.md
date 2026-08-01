# Abschlussprüfung: die letzte Nachricht

Du arbeitest jetzt als `mrs_ah` in `/home/mrs_ah`. Löse den letzten Auftrag
zunächst ohne vollständige Befehlsfolge:

1. Kontrolliere Benutzer und Standort.
2. Untersuche die Rechte von `letzte-nachricht`.
3. Probiere die direkte Ausführung und ordne die erwartete Ablehnung ein.
4. Ergänze ausschließlich das Ausführungsrecht des Besitzers.
5. Kontrolliere die neue Rechteanzeige.
6. Führe `letzte-nachricht` aus und lies die erstmals sichtbare Flag.
7. Reiche die Flag mit `flag-einreichen 'GEFUNDENE_FLAG'` ein.
8. Starte nach erfolgreicher Abgabe den CHECK.

Der CHECK bestätigt ausschließlich die korrekte Flag-Abgabe. Er prüft weder
die frühere Ausführung von `signaltest` noch Befehlsreihenfolge oder
Benutzerwechsel.

<details>
<summary>Hinweis 1 – Konzept</summary>

Eine lesbare Datei ist nicht automatisch ausführbar. Vergleiche im
Besitzerblock, ob `x` vorhanden ist, und ergänze nur das fehlende Recht.

</details>

<details>
<summary>Hinweis 2 – Werkzeuge</summary>

Du benötigst `whoami`, `pwd`, `ls -l`, `./dateiname`, `chmod u+x` und
`flag-einreichen`.

</details>

<details>
<summary>Hinweis 3 – Befehlsmuster</summary>

```text
ls -l DATEI
./DATEI
chmod u+x DATEI
ls -l DATEI
./DATEI
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze die Platzhalter durch Dateiname und vollständigen Flag-Text.

</details>

<details>
<summary>Hinweis 4 – vollständiger Walkthrough</summary>

```bash
whoami
pwd
ls -l letzte-nachricht
./letzte-nachricht
chmod u+x letzte-nachricht
ls -l letzte-nachricht
./letzte-nachricht
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch den vollständigen Text aus der Ausgabe von
`./letzte-nachricht`. Starte anschließend den CHECK.

</details>
