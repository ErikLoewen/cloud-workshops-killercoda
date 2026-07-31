# Musterlösung und Erklärung

Diese interne Datei ist nicht in `index.json` referenziert.

Ausgangsort:

```text
/home/waerter/leuchtturm/obergeschoss/kartenraum
```

## Lösung

```bash
pwd
ls original/erste-spur.txt sicherung
cat original/erste-spur.txt
cp original/erste-spur.txt sicherung/erste-spur-kopie.txt
ls original/erste-spur.txt sicherung/erste-spur-kopie.txt
cat sicherung/erste-spur-kopie.txt
```

`cp` erhält das Root-geschützte Original und erzeugt eine eigenständige Kopie
im beschreibbaren Sicherungsordner.

```bash
pwd
ls arbeitstisch/alte-abschrift.txt
rm arbeitstisch/alte-abschrift.txt
ls arbeitstisch
```

```bash
pwd
ls arbeitstisch/leere-mappe
rmdir arbeitstisch/leere-mappe
rmdir arbeitstisch/volle-kiste
ls arbeitstisch/volle-kiste
cat arbeitstisch/volle-kiste/inhalt.txt
```

Der Fehler von `rmdir` ist beabsichtigt: Die volle Kiste und ihr Inhalt
bleiben erhalten.

```bash
pwd
ls eingestuerzte-ecke
cat eingestuerzte-ecke/nasse-notiz.txt
ls eingestuerzte-ecke/splitter
cat eingestuerzte-ecke/splitter/rest.txt
rm -r eingestuerzte-ecke
ls
```

```bash
ls original/erste-spur.txt sicherung/erste-spur-kopie.txt
cat original/erste-spur.txt
cat sicherung/erste-spur-kopie.txt
ls arbeitstisch/volle-kiste
cat arbeitstisch/volle-kiste/inhalt.txt
```

## Gefahrenanalyse

Die im Teilnehmertext gezeigte Meme-Zeile ist nicht kopierbarer HTML-Text und
wird niemals ausgeführt. `sudo`, `rm`, `-r`, `-f` und `~/` werden einzeln
analysiert. Sicher ausgeführt wird nur eine `printf`-Ausgabe von `$HOME`.

## Grenze des CHECKs

Der CHECK prüft den Dateisystem-Endzustand, nicht die Befehlsreihenfolge oder
ob die Sicherheitsroutine bewusst eingehalten wurde.
