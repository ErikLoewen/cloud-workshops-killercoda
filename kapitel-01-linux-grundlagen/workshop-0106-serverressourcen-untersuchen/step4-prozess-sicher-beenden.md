# Einen Prozess kontrolliert beenden

Einen Prozess zu beenden verändert den laufenden Zustand des Systems. Deshalb
üben wir den Ablauf zuerst mit einem harmlosen Prozess, den wir selbst starten.

> **Sichere Reihenfolge:**  
> Finden → Namen prüfen → PID prüfen → regulär beenden → erneut kontrollieren

## Einen Übungsprozess starten

```bash
sleep 300 &
```{{exec}}

`sleep 300` wartet 300 Sekunden. Das `&` startet den Prozess im Hintergrund.
Die Shell bleibt dadurch nutzbar und du kannst weitere Befehle eingeben.

Die Shell kann dabei eine Jobnummer in eckigen Klammern und eine PID anzeigen.
Für diese Übung genügt es zu wissen: Die Jobnummer gehört zur Verwaltung durch
die Shell; die PID kennzeichnet die laufende Prozessinstanz.

## Einen Prozess über seinen Namen finden

`pgrep` sucht laufende Prozesse anhand ihres Namens. Mit `-a` wird zusätzlich
die zugehörige Befehlszeile angezeigt.

## Regulär beenden

Das Grundmuster lautet:

```text
kill PID
```

`PID` ist ein Platzhalter. Er wird durch die tatsächlich gefundene Zahl
ersetzt. Ohne weitere Option sendet `kill` normalerweise zunächst ein
reguläres Beendigungssignal. Der Befehl löscht keine Dateien.

## Geführter Auftrag

Finde die PID deines `sleep`-Prozesses. Prüfe den Namen. Beende genau diese PID
und kontrolliere anschließend mit derselben Suche, ob der Prozess verschwunden
ist.

<details>
<summary>Hinweis 1 – Prozess finden</summary>

```bash
pgrep -a sleep
```

Suche in der Ausgabe die Befehlszeile deines Prozesses mit der Wartezeit
`300`.

</details>

<details>
<summary>Hinweis 2 – Prozess beenden</summary>

```text
kill PID
```

Ersetze `PID` durch die Zahl, die du unmittelbar zuvor für deinen
`sleep 300`-Prozess gefunden hast.

</details>

<details>
<summary>Vollständiger Übungsablauf</summary>

```bash
sleep 300 &
pgrep -a sleep
kill GEFUNDENE_PID
pgrep -a sleep
```

`GEFUNDENE_PID` ist kein wörtlicher Befehlsteil. Setze dort die aktuell
ermittelte PID deines eigenen `sleep 300`-Prozesses ein.

</details>

> **Wichtig:** `kill -9` erzwingt einen harten Abbruch und lässt dem Prozess
> keine normale Reaktion. Es ist nicht der erste Schritt und wird in diesem
> Workshop nicht benötigt.

## Kurz reflektieren

1. Warum wurde nach dem Beenden erneut gesucht?
2. Warum reicht es nicht, irgendeine PID aus der Liste zu verwenden?

Der Ablauf ist jetzt bekannt. Im nächsten Schritt überträgst du ihn auf die
echte Störung – ohne vorgegebene PID und ohne offenen Lösungsweg.
