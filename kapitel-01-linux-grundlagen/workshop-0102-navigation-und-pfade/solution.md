# Musterlösung – Navigation im Nebel

Diese Datei ist eine interne Referenz und wird nicht in `index.json` angezeigt.

## Technischer Startzustand

```text
whoami   → waerter
hostname → leuchtturm
pwd      → /home/waerter
```

Die sichtbare Shell ist eine echte Login-Shell des normalen Benutzers
`waerter`.

## Lernweg

### Standort und Wechsel

```text
pwd
ls
cd leuchtturm
pwd
ls
cd eingang
pwd
```

### Wurzel, Home und absoluter Pfad

```text
cd /
pwd
cd ~
pwd
cd /home/waerter/leuchtturm/obergeschoss/kartenraum
pwd
cd ~/leuchtturm/eingang
```

`/` ist die oberste Ebene. `~` steht für `/home/waerter`. Der ausgeschriebene
Weg zum Kartenraum beginnt mit `/` und ist daher absolut.

### Relative Pfade und Tab

```text
cd .
pwd
cd ..
pwd
cd ./eingang
cd ../obergeschoss/./kartenraum
pwd
cd ~/leuchtturm
```

Für die Tab-Übung wird `cd technik/kontrollraum/` aus den eindeutigen
Präfixen `t` und `k` ergänzt. Tab ergänzt nur; Enter führt aus.

### Transfer

Vom Kontrollraum:

```text
cd ../../obergeschoss/funkraum
pwd
```

Zwei `..` führen vom Kontrollraum zunächst nach `technik` und dann in den
Hauptbereich des Leuchtturms.

## Abschlussaufgabe

Ausgangspunkt:

```text
/home/waerter/leuchtturm/eingang
```

Schrittweise Lösung:

```text
cd ..
ls
cd untergeschoss
ls
cd lagerraum
ls
cd archiv
pwd
ls
eintrag-bestaetigen
```

Erwarteter Fundort:

```text
/home/waerter/leuchtturm/untergeschoss/lagerraum/archiv
```

`ls` zeigt dort `letzter_eintrag.txt`. Die Datei wird in diesem Workshop
nicht geöffnet oder verändert.

Eine ebenfalls gültige direkte Navigation ist:

```text
cd ../untergeschoss/lagerraum/archiv
ls
eintrag-bestaetigen
```

## Grenzen des technischen CHECKs

Die Prüfaktion kontrolliert:

- Aufruf ohne Argument,
- exakten aktuellen Fundort,
- Existenz von `letzter_eintrag.txt`.

Erst danach erzeugt sie einen neutralen Marker. Sie verändert den letzten
Eintrag nicht. Der CHECK liest nur diesen Marker und weist weder den
Navigationsweg noch die Verwendung von Tab oder das Begriffsverständnis nach.
