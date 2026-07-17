# Loopback, IPv4 und Präfixlänge

## Die Loopback-Schnittstelle finden

Suche in deiner Ausgabe die Schnittstelle, die auf das eigene System verweist.

Der erwartete Name ist üblicherweise `lo`. Die bekannte IPv4-Adresse lautet:

`127.0.0.1/8`

Diese Zuordnung wird später zusätzlich technisch gegen den aktuellen lokalen Zustand geprüft.

## Was bedeutet Loopback?

Die Loopback-Schnittstelle:

- verweist auf das eigene System;
- benötigt keine externe Netzwerkverbindung;
- ist von der später bestimmten primären Schnittstelle zu unterscheiden.

Der sichtbare Zustand kann beispielsweise `UNKNOWN` lauten. Dieses Wort ist ein Zustand und keine IPv4-Adresse. Es bedeutet in dieser Aufgabe nicht automatisch, dass die Loopback-Schnittstelle defekt ist.

## IPv4-Adresse erkennen

Eine IPv4-Adresse besteht in der sichtbaren Grundform aus vier Zahlengruppen, die durch Punkte getrennt sind.

Beispiel:

```text
192.0.2.10/24
```

Diese Adresse ist fiktiv und nicht die Lösung für deine Umgebung.

## Präfixlänge erkennen

Die Zahl hinter `/` ist die **Präfixlänge**.

Für diesen Workshop gilt:

- die Präfixlänge gehört zur Adressschreibweise;
- sie wird gemeinsam mit der IPv4-Adresse übernommen;
- sie wird nicht berechnet;
- sie wird nicht in eine andere Schreibweise umgewandelt.

## Sichtbare Adressen mit Doppelpunkten

Eine weitere Adressform kann Doppelpunkte enthalten. Sie gehört nicht zur Aufgabe und wird nicht ausgewertet.

## Aufgaben

1. Finde die Loopback-Zeile.
2. Nenne den Schnittstellennamen.
3. Nenne die IPv4-Adresse einschließlich Präfixlänge.
4. Erkläre, woran du die IPv4-Adresse und die Präfixlänge unterschieden hast.

## Kurze Erklärung

Warum muss die Zeichenfolge `/8` beim späteren Dokumentieren erhalten bleiben, obwohl du keine Berechnung durchführst?
