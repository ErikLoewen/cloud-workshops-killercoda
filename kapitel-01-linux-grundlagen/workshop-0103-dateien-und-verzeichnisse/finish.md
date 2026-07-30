# Die erste Spur ist sichtbar

Du hast den letzten Eintrag aus dem Archiv in den Kartenraum verschoben,
dabei umbenannt, erneut gelesen und die gefundene Flag eingereicht.

![Im Kartenraum liegt das Logbuch geöffnet auf einem Tisch. Zwischen den alten Zeilen ist die erste Spur sichtbar geworden.](./assets/0103-nachher-logbuch-offen-im-kartenraum.png)

## Was wirklich geschehen ist

`mv` hat die Datei verschoben und umbenannt. **Normalerweise verändert `mv`
keinen Dateiinhalt.** Die neuen Zeilen waren eine vorbereitete Inszenierung
dieses Workshops: Ein Hintergrundskript erkannte die echte verschobene
Logbuchdatei am richtigen Ziel und ersetzte ihren Inhalt genau einmal.

Eine **Flag** ist eine eindeutige Zeichenfolge, die in sogenannten
Capture-the-Flag-Aufgaben einen erfolgreichen Fund belegt. Der Befehl
`flag-einreichen` hat deine Eingabe mit der erwarteten Flag verglichen.

## Rufe das Wichtigste ab

1. Was erstellt `mkdir`?
2. Was bewirkt ein einzelnes `>` bei einer vorhandenen Datei?
3. Wozu hast du `cat` verwendet?
4. Welcher Pfad steht bei `mv QUELLE ZIEL` zuerst?
5. Woran erkennst du, dass eine Datei verschoben und nicht kopiert wurde?
6. Warum waren die neuen Zeilen keine normale Wirkung von `mv`?

## Ausblick

Im nächsten Workshop **„01.04 – Kopieren, aufräumen, nichts versenken“**
lernst du, Kopieren und Verschieben zu unterscheiden und ausdrücklich
freigegebene Dateien und Verzeichnisse kontrolliert zu entfernen. Die erste
Spur bleibt dabei sicher im Kartenraum.
