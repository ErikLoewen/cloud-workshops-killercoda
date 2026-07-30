# Mit `mv` Namen und Orte ändern

`mv` steht für **move**. Das Grundmuster lautet:

```text
mv QUELLE ZIEL
```

Der vorhandene Quellpfad steht zuerst, der gewünschte Zielpfad danach. Ein
erfolgreiches `mv` bleibt normalerweise still und erzeugt keine Kopie.

## 1. Nur umbenennen

Die Arbeitsnotiz bleibt im Ordner `notizen`, erhält aber einen anderen Namen:

```text
mv notizen/arbeitsnotiz.txt notizen/fundnotiz.txt
```

Prüfe mit `ls notizen` und anschließend:

```text
cat notizen/fundnotiz.txt
```

## 2. Nur verschieben

Jetzt bleibt der Name gleich, aber die Datei wandert aus `notizen` in den
aktuellen Kartenraum:

```text
mv notizen/fundnotiz.txt .
```

`.` bezeichnet den aktuellen Ort. Prüfe mit `ls` und lies
`fundnotiz.txt` mit `cat`.

## 3. Verschieben und umbenennen

Bringe die Datei zurück und gib ihr wieder den ursprünglichen Namen:

```text
mv fundnotiz.txt notizen/arbeitsnotiz.txt
```

Prüfe Quelle und Ziel mit `ls` und `ls notizen`.

Normalerweise verändert `mv` den Inhalt einer Datei nicht. Der Satz in der
Arbeitsnotiz muss nach allen drei Varianten noch derselbe sein.
