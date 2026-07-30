# Relative Wege im Nebel und Tab

Ein relativer Pfad wird vom aktuellen Standort aus gelesen. Du startest im
`eingang`.

## `.` und `..`

`.` bezeichnet das aktuelle Verzeichnis. Gib `cd .` ein und prüfe mit `pwd`:
Der Standort bleibt unverändert.

`..` bezeichnet genau eine Ebene darüber. Sage voraus, welchen Ort du mit
`cd ..` erreichst. Führe den Wechsel aus und prüfe mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm
```

Wechsle mit `cd ./eingang` wieder zurück. Das `.` beginnt den Weg am
aktuellen Standort.

## Ein relativer Weg

Vom Eingang führt dieser relative Pfad in den Kartenraum:

```text
cd ../obergeschoss/./kartenraum
```

Prüfe mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm/obergeschoss/kartenraum
```

Der Weg beginnt mit `..` eine Ebene oberhalb des Eingangs. Das spätere `.`
ändert den Standort nicht.

## Tab-Vervollständigung

Tab ergänzt einen begonnenen Namen, wenn er eindeutig ist. Tab führt den
Befehl nicht aus – das geschieht erst mit Enter.

Wechsle zuerst mit `cd ~/leuchtturm` in den Hauptbereich und prüfe mit `pwd`.

Stelle dann die Eingabe schrittweise her:

1. Tippe `cd t`.
2. Drücke Tab. Daraus wird `cd technik/`.
3. Tippe `k`.
4. Drücke Tab. Daraus wird `cd technik/kontrollraum/`.
5. Drücke erst jetzt Enter.

Prüfe anschließend mit `pwd`.

**Erwartete Ausgabe:**

```text
/home/waerter/leuchtturm/technik/kontrollraum
```

Was ergänzte Tab, und was geschah erst nach Enter?
