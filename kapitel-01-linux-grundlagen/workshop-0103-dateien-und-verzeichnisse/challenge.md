# Abschluss: die erste Spur sichern

Das Logbuch liegt noch im Archiv. Im Kartenraum lassen sich die verwischten
Zeilen vielleicht besser lesen.

## Dein Auftrag

Verschiebe `letzter_eintrag.txt` aus dem Archiv direkt in den Kartenraum und
benenne die Datei dabei in `erste-spur.txt` um.

Erfolgskriterien:

- `erste-spur.txt` liegt direkt im Kartenraum;
- `letzter_eintrag.txt` liegt nicht mehr im Archiv;
- es wurde die vorbereitete Logbuchdatei verschoben, keine neue Datei
  gleichen Namens angelegt;
- die gefundene Flag wurde anschließend eingereicht.

Nutze `pwd`, `ls`, `mv` und `cat`. Führe zuerst einen eigenen Versuch aus.

Wenn das Licht flackert und das Terminal dich auf neue Zeilen hinweist, lies
`erste-spur.txt` noch einmal mit `cat`.

Gib die gefundene Flag danach so ab:

```text
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch den vollständigen Text aus der Datei. Starte
nach der erfolgreichen Abgabe den CHECK.

## Hinweise

<details>
<summary>Hinweis 1 – das Prinzip</summary>

Du brauchst genau eine Dateioperation. Das vorhandene Logbuch ist die
Quelle; der gewünschte Ort mit neuem Namen ist das Ziel.

</details>

<details>
<summary>Hinweis 2 – das Werkzeug</summary>

Das Muster lautet `mv QUELLE ZIEL`. Beide Pfade dürfen vollständig
ausgeschrieben sein.

</details>

<details>
<summary>Hinweis 3 – die beiden Wege</summary>

Die Quelle liegt unter
`/home/waerter/leuchtturm/untergeschoss/lagerraum/archiv/`.
Das Ziel liegt unter
`/home/waerter/leuchtturm/obergeschoss/kartenraum/` und heißt
`erste-spur.txt`.

</details>

<details>
<summary>Hinweis 4 – vollständiger Ablauf</summary>

```bash
mv /home/waerter/leuchtturm/untergeschoss/lagerraum/archiv/letzter_eintrag.txt /home/waerter/leuchtturm/obergeschoss/kartenraum/erste-spur.txt
cat /home/waerter/leuchtturm/obergeschoss/kartenraum/erste-spur.txt
flag-einreichen 'GEFUNDENE_FLAG'
```

Der erste Pfad bezeichnet die vorhandene Quelle. Der zweite Pfad legt Ort
und neuen Namen fest. Ersetze bei der Abgabe `GEFUNDENE_FLAG` durch den
vollständigen Flag-Text aus der Ausgabe von `cat` und starte danach den CHECK.

</details>
