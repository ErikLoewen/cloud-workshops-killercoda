# Was verhindert die Stabilisierung?

Das Archiv wirkt uneindeutig. Bevor du etwas veränderst, brauchst du zwei
Vergleichspunkte:

- den dokumentierten Sollzustand aus dem Stabilisierungsplan;
- den tatsächlich beobachteten Istzustand im Archiv.

Nutze dafür die bekannten Navigations- und Lesebefehle aus den bisherigen
Workshops. In dieser Abschlussmission entscheidest du selbst, welches
Werkzeug für die nächste Beobachtung passt.

## Auftrag

1. Verschaffe dir einen Überblick über deinen Standort und den Inhalt des
   aktuellen Verzeichnisses.
2. Lies `stabilisierungsplan.txt` vollständig.
3. Starte `./leuchtturm-stabilisieren` erneut und lies die gesamte
   Fehlermeldung.
4. Vergleiche die gemeldeten Bereiche mit den Verzeichnissen, die laut Plan
   zur stabilen Ordnung gehören.
5. Notiere, welche vorhandenen Bereiche nicht zum dokumentierten Sollzustand
   gehören.

Verändere in diesem Schritt noch nichts. Insbesondere leitest du aus einem
auffälligen Namen allein noch keine Löschentscheidung ab.

<details>
<summary>Hinweis 1 – Sollzustand finden</summary>

Welche Datei beschreibt ausdrücklich, welche Bereiche zur stabilen Ordnung
gehören?

</details>

<details>
<summary>Hinweis 2 – Plan lesen</summary>

Mit welchem bekannten Befehl zeigst du den vollständigen Inhalt einer kurzen
Textdatei im Terminal an?

</details>

<details>
<summary>Hinweis 3 – Diagnose starten</summary>

Ein ausführbares Skript im aktuellen Verzeichnis startest du über seinen
relativen Pfad. Welche Bedeutung hat dabei `./`?

</details>

<details>
<summary>Hinweis 4 – vollständiger Beobachtungsweg</summary>

Öffne diesen Hinweis erst, wenn du den Auftrag nicht mit den vorherigen
Erinnerungen lösen konntest.

```bash
pwd
ls
cat stabilisierungsplan.txt
./leuchtturm-stabilisieren
```

Lies nach dem letzten Befehl nicht nur die Überschrift, sondern auch die
aufgelisteten Bereiche und den empfohlenen nächsten Prüfschritt.

</details>

## Erkenntnis

Die Fehlermeldung ist kein Scheitern des Workshops. Sie ist die Diagnose des
nächsten Problems.

Ein gutes Diagnosewerkzeug nennt nicht nur, dass etwas falsch ist. Es grenzt
ein, welcher Zustand untersucht werden muss.

Für den nächsten Schritt kennst du damit die Abweichung zwischen Soll- und
Iststruktur. Wie sie kontrolliert behoben wird, entscheidest du erst nach der
nächsten Untersuchung.
