# Welcher Vorgang erzeugt die Erinnerung?

Die entfernte Datei ist zurückgekehrt. Lies sie noch einmal vollständig:

```bash
cat erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
```

Eine Datei kann sich nicht selbst neu erzeugen. Untersuche besonders die
letzte Zeile: Sie nennt den Vorgang, nach dem du in der Prozessliste suchen
sollst. Notiere diesen Namen, ohne ihn aus einem Hinweis zu übernehmen.

## Prozessliste mit `grep` filtern

Setze den selbst gefundenen Namen anstelle von `SUCHTEXT` ein:

```bash
ps -eo user,pid,comm | grep SUCHTEXT
```

`grep` zeigt nur Zeilen, die einen bestimmten Suchtext enthalten.
`|` leitet die Ausgabe des linken Befehls an den rechten Befehl weiter.

![Eine Prozessliste fließt durch eine Pipe zu grep; UNKNOWN steht dabei für einen noch zu ermittelnden Prozessnamen.](./assets/0108-pipe-und-grep.png)

`UNKNOWN` ist in der Grafik absichtlich nur ein Platzhalter. Ersetze ihn im
Terminal durch den Namen, den du in der Datei gefunden hast.

## Prozessidentität prüfen

Die gefilterte Ausgabe zeigt den gesuchten Vorgang, schematisch zum Beispiel:

```text
waerter  1842 GEFUNDENER_NAME
```

Entscheidend ist die Spalte `COMMAND`. Verwende ausschließlich eine Zeile, in
der `COMMAND` exakt dem Namen aus der untersuchten Datei entspricht.

Prüfe vor dem Beenden alle drei Angaben:

- `USER` ist `waerter`;
- `PID` ist eine eindeutige Zahl;
- `COMMAND` entspricht exakt dem gefundenen Namen.

Abhängig von der Art der Prozessausgabe kann auch der Suchvorgang `grep`
selbst erscheinen. Diese Zeile ist nicht das Ziel. Beim hier verwendeten
Feld `comm` bleibt sie normalerweise aus, weil dort nur `grep` steht.

## Prozess kontrolliert beenden

Setze die tatsächlich geprüfte PID in den bekannten Befehl ein:

```text
kill PID
```

`PID` ist ein Platzhalter. Gib die beobachtete Zahl ohne das Wort `PID` und
ohne zusätzliche Zeichen ein.

Kontrolliere danach erneut:

```bash
ps -eo user,pid,comm | grep SUCHTEXT
```

Alternativ kannst du den bereits bekannten, namensbezogenen Kontrollbefehl
verwenden:

```bash
pgrep -a SUCHTEXT
```

Nur eine Zeile, deren Prozessname tatsächlich dem Hinweis aus der Datei
entspricht, weist auf den erzeugenden Vorgang hin. Bleibt die gefilterte
Ausgabe leer, wurde kein passender Prozess gefunden.

## Erinnerung endgültig entfernen

Wenn die Kontrolle keinen laufenden Prozess mit dem gefundenen Namen mehr
zeigt, entferne die zurückgebliebene Datei:

```bash
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
```

Warte einen kurzen Moment und kontrolliere `erinnerungen` erneut. Die Datei
soll jetzt fortbleiben. Starte anschließend die Stabilisierung erneut, um den
nächsten Zustand zu prüfen.

<details>
<summary>Hinweis 1 – Prozessname finden</summary>

Lies die wiederkehrende Datei bis zur letzten Zeile. Der Text hinter
`Erstellt durch:` ist der Suchbegriff für die Prozessliste.

</details>

<details>
<summary>Hinweis 2 – Pipe verstehen</summary>

Ordne in der Grafik den linken Befehl, die Pipe in der Mitte und den rechten
Filter ihrer jeweiligen Beschriftung zu.

</details>

<details>
<summary>Hinweis 3 – richtige PID auswählen</summary>

Vergleiche nicht nur die Zahl. Verwende ausschließlich die Zeile, in der
gleichzeitig `USER` gleich `waerter` und `COMMAND` gleich dem selbst
ermittelten Prozessnamen ist.

</details>

<details>
<summary>Hinweis 4 – vollständiger Ablauf</summary>

Ersetze `<GEPRÜFTE_PID>` durch die Zahl aus der eindeutig passenden Zeile.
Die spitzen Klammern werden nicht eingegeben.

```bash
cat erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ps -eo user,pid,comm | grep altes_echo
kill <GEPRÜFTE_PID>
ps -eo user,pid,comm | grep altes_echo
pgrep -a altes_echo
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ls erinnerungen
./leuchtturm-stabilisieren
```

Wenn der erste Kontrollbefehl keine Zeile mehr zeigt und `pgrep` keine
passende Instanz findet, ist der erzeugende Vorgang beendet.

</details>

## Erkenntnis

Das Löschen einer erzeugten Datei beseitigt nicht ihre Ursache. Erst nachdem
der eindeutig geprüfte Prozess beendet wurde, bleibt die anschließend
entfernte Datei verschwunden.
