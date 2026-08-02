# Was frisst die Ressourcen?

Das Schiff ist inzwischen näher gekommen. Der Sturm verdeckt immer wieder
seine Positionslichter.

Im Inneren des Leuchtturms läuft das gleichmäßige Brummen weiter. Jetzt musst
du den Verursacher eindeutig identifizieren und ausschließlich diesen einen
Prozess beenden.

![Diagnosekreislauf aus Beobachten, Identifizieren, Prüfen, Handeln und Nachkontrolle.](./assets/0106-diagnosekreislauf.png)

```text
Beobachten
→ auffälligen Prozess finden
→ Benutzer, Namen und PID prüfen
→ gezielt handeln
→ erneut kontrollieren
```

## Diagnoseauftrag

Untersuche die Prozesslage erneut.

Finde den Prozess, der anhaltend deutlich mehr CPU beansprucht als die übrigen
Einträge.

Prüfe vor dem Eingriff:

1. Unter welchem Benutzer läuft er?
2. Wie lautet sein Prozessname?
3. Welche PID gehört genau zu dieser Instanz?

Beende ausschließlich den eindeutig identifizierten Verursacher.

Kontrolliere anschließend, ob er tatsächlich verschwunden ist.

<details>
<summary>Hinweis 1 – Beobachten</summary>

Nutze das bereits bekannte Live-Werkzeug. Beobachte in der Prozessliste
besonders die Spalte `%CPU` über mehrere Aktualisierungen.

</details>

<details>
<summary>Hinweis 2 – Sortierte Momentaufnahme</summary>

Nutze die bekannte reduzierte `ps`-Ausgabe, bei der hohe CPU-Werte zuerst
stehen:

```bash
ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu
```

</details>

<details>
<summary>Hinweis 3 – Gezielt suchen</summary>

Bestätige einen zuvor ermittelten Namen mit diesem Muster:

```text
pgrep -a NAME
```

Ersetze `NAME` durch den Prozessnamen aus deiner Diagnose.

</details>

<details>
<summary>Hinweis 4 – Prozessname</summary>

Der ungewöhnliche Prozess trägt den Namen `beschwoerung`.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu
pgrep -a beschwoerung
kill GEFUNDENE_PID
pgrep -a beschwoerung
```

Ersetze `GEFUNDENE_PID` durch die PID, die du unmittelbar zuvor für den
eindeutig identifizierten Prozess gefunden hast. Verwende keine alte oder
geratene Zahl.

</details>

## Ergebnis

Das Brummen im Turm verstummt. Die Prozesssuche liefert keinen passenden
Eintrag mehr. Der Rechner reagiert wieder normal.

Das Leuchtfeuer bleibt jedoch dunkel. Einen Fehler zu entfernen startet nicht
automatisch den gewünschten Prozess.
