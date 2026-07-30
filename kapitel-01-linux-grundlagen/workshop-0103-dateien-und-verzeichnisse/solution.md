# Musterlösung – Dateien, Ordner und die erste Spur

Diese interne Datei wird nicht in `index.json` angezeigt.

## Startzustand

```text
whoami   → waerter
hostname → leuchtturm
pwd      → /home/waerter/leuchtturm/untergeschoss/lagerraum/archiv
```

Der vollständige Leuchtturmbaum aus Workshop 01.02 wird neu hergestellt.
`letzter_eintrag.txt` liegt ausschließlich im Archiv und enthält zunächst
keine Flag.

## Lernweg

```text
pwd
ls
cat letzter_eintrag.txt
cd /home/waerter/leuchtturm/obergeschoss/kartenraum
mkdir notizen
echo Logbuch im Archiv gefunden. > notizen/arbeitsnotiz.txt
cat notizen/arbeitsnotiz.txt
mv notizen/arbeitsnotiz.txt notizen/fundnotiz.txt
mv notizen/fundnotiz.txt .
mv fundnotiz.txt notizen/arbeitsnotiz.txt
```

`mkdir` erstellt den Notizordner. Die Shell leitet die Ausgabe von `echo`
mit `>` in die Arbeitsnotiz. Ein einzelnes `>` ersetzt vorhandenen Inhalt.
Bei `mv` steht der vorhandene Quellpfad zuerst und der Zielpfad danach.

## Abschlussaufgabe

Quelle ist die vorbereitete Datei im Archiv. Ziel ist
`erste-spur.txt` direkt im Kartenraum. Ein vollständiger `mv`-Aufruf
verschiebt die Quelle und ändert gleichzeitig ihren Namen. Danach wird die
Datei mit `cat` gelesen und die dort gefundene Flag mit
`flag-einreichen 'GEFUNDENE_FLAG'` abgegeben.

Die konkrete Flag steht absichtlich nicht in dieser Musterlösung.

## Technische Besonderheit

Erst nach dem echten Verschieben erkennt das Hintergrundskript die
vorbereitete Datei anhand von Gerät und Inode sowie ihres ursprünglichen
Hashes. Es ersetzt den Inhalt atomar und erzeugt einen Enthüllungsmarker.
Der technische CHECK verlangt zusätzlich die erfolgreiche Flag-Abgabe.
