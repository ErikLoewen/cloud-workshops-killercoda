# Schnellpfad – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

Diese interne Lösung ist für Betreuung und technische Tests bestimmt. Sie
verwendet keine feste PID: Jede Prozessnummer wird unmittelbar vor dem
Beenden neu aus der aktuellen Ausgabe übernommen.

## 1. Ressourcen grob prüfen

```bash
nproc
free -h
df -h /
```

## 2. Aktuelle Auslastung beobachten

Beim ersten Öffnen von Step 2 startet die vorbereitete Störung unsichtbar im
Hintergrund. Dafür ist kein Teilnehmerbefehl nötig. Ein erneutes Öffnen des
Schritts startet sie in derselben Workshop-Sitzung nicht noch einmal.

```bash
top
```

Mindestens zwei Aktualisierungen beobachten und `top` mit `q` verlassen.

## 3. Sortierte Prozessansicht erzeugen

```bash
ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu
```

Vor einem Eingriff immer `USER`, `PID`, `%CPU` und `COMMAND` gemeinsam
prüfen.

## 4. Reguläres Beenden am Übungsprozess durchführen

```bash
sleep 300 &
pgrep -a sleep
kill GEFUNDENE_UEBUNGS_PID
pgrep -a sleep
```

In der `pgrep`-Ausgabe die Instanz mit der Befehlszeile `sleep 300`
identifizieren. `GEFUNDENE_UEBUNGS_PID` durch deren aktuell angezeigte PID
ersetzen. Die zweite Suche dient der Nachkontrolle.

## 5. Tatsächlichen Ressourcenfresser beenden

```bash
ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu
pgrep -a beschwoerung
kill GEFUNDENE_PID
pgrep -a beschwoerung
```

Vor `kill` prüfen, dass der Prozess `waerter` gehört und der Name sowie die
aktuelle PID zur auffälligen Instanz gehören. `GEFUNDENE_PID` durch genau
diese Prozessnummer ersetzen. Die letzte Suche soll keinen passenden Eintrag
mehr liefern.

## 6. Arbeitsbereich und Startdatei prüfen

```bash
pwd
ls
ls -l
```

Erwarteter Arbeitsbereich:

```text
/home/waerter/leuchtturm/aussenstation
```

## 7. Leuchtfeuer starten und kontrollieren

```bash
./leuchtfeuer-start
pgrep -a leuchtfeuer
```

Die Prozesssuche soll genau eine Instanz zeigen. Der erfolgreiche Start gibt
die Flag aus.

## 8. Flag einreichen

```bash
flag-einreichen 'FLAG{das_licht_brennt_wieder}'
```

Danach den CHECK starten. Er prüft ausschließlich den erfolgreichen
Flag-Abgabemarker.

## Typische Fehler

| Fehler | Einordnung und nächster Schritt |
|---|---|
| `PID` oder `GEFUNDENE_PID` wörtlich eingegeben | Den Platzhalter durch die unmittelbar zuvor angezeigte Zahl ersetzen. |
| Falschen Prozess ausgewählt | Vor dem Eingriff Benutzer, Name, Befehlszeile und PID gemeinsam prüfen. |
| `top` nicht verlassen | Mit `q` zur Shell zurückkehren. |
| `beschwoerung` läuft noch | Prozess erneut eindeutig identifizieren und regulär beenden. |
| Leuchtfeuer doppelt gestartet | Keine weitere Instanz starten; den vorhandenen Prozess mit `pgrep -a leuchtfeuer` kontrollieren. |
| Falsches Arbeitsverzeichnis | Mit `pwd` prüfen und in die Außenstation wechseln. |
| Ausführungsdatei ohne `./` aufgerufen | Eine Datei aus dem aktuellen Verzeichnis mit `./leuchtfeuer-start` starten. |
