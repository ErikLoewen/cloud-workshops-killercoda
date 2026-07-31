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
ls
cat notiz-aus-der-wand.txt
flag-einreichen 'FLAG{der_waerter_war_hier}'
```

## Gefahrenanalyse

Die im Teilnehmertext gezeigte Meme-Zeile ist nicht kopierbarer HTML-Text und
wird niemals ausgeführt. `sudo`, `rm`, `-r`, `-f` und `~/` werden einzeln
analysiert. Sicher ausgeführt wird nur eine `printf`-Ausgabe von `$HOME`.

## Grenze des CHECKs

Der Hintergrundprozess legt unmittelbar nach dem Entfernen der Ecke die Datei
`notiz-aus-der-wand.txt` an. `flag-einreichen` prüft die gefundene
Zeichenfolge; der anschließende CHECK bestätigt ausschließlich diese
erfolgreiche Abgabe. Dateisystem-Endzustand, Befehlsreihenfolge und bewusstes
Einhalten der Sicherheitsroutine müssen außerhalb des CHECKs beurteilt werden.
