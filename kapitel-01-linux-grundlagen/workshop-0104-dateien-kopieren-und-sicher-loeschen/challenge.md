# Abschluss: die Spur sichern und kontrolliert räumen

Arbeite im Kartenraum und löse den Auftrag zunächst ohne vollständige
Befehlsfolge:

1. Kopiere `original/erste-spur.txt` nach
   `sicherung/erste-spur-kopie.txt`.
2. Prüfe, dass Original und Kopie existieren, und vergleiche ihre Inhalte.
3. Entferne `arbeitstisch/alte-abschrift.txt`.
4. Entferne das leere Verzeichnis `arbeitstisch/leere-mappe`.
5. Prüfe, warum `arbeitstisch/volle-kiste` von `rmdir` abgelehnt wird, und
   lasse Kiste sowie Inhalt erhalten.
6. Untersuche vollständig den Inhalt von `eingestuerzte-ecke`.
7. Entferne rekursiv **ausschließlich** `eingestuerzte-ecke`.
8. Prüfe direkt danach mit `ls`, was neu im Kartenraum erschienen ist, und
   lies die neue Datei mit `cat`.
9. Reiche die darin gefundene Flagge mit
   `flag-einreichen 'GEFUNDENE_FLAG'` ein.
10. Kontrolliere erneut Original, Sicherung und volle Kiste.
11. Starte den CHECK.

Wende vor jeder Löschung die Routine an: Standort prüfen → Ziel prüfen →
Wirkung vorhersagen → Befehl selbst tippen → Ergebnis kontrollieren.

<details>
<summary>Hinweis 1 – Werkzeuge</summary>

Du benötigst `cp`, `rm`, `rmdir`, `rm -r`, `pwd`, `ls` und `cat`.

</details>

<details>
<summary>Hinweis 2 – Befehlsmuster</summary>

```text
cp QUELLE ZIEL
rm DATEI
rmdir LEERES_VERZEICHNIS
rm -r GEPRUEFTES_VERZEICHNIS
```

</details>

<details>
<summary>Hinweis 3 – vollständige Methode</summary>

```bash
pwd
ls original/erste-spur.txt sicherung
cat original/erste-spur.txt
cp original/erste-spur.txt sicherung/erste-spur-kopie.txt
ls original/erste-spur.txt sicherung/erste-spur-kopie.txt
cat sicherung/erste-spur-kopie.txt
```

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

```bash
pwd
ls eingestuerzte-ecke
cat eingestuerzte-ecke/nasse-notiz.txt
ls eingestuerzte-ecke/splitter
cat eingestuerzte-ecke/splitter/rest.txt
rm -r eingestuerzte-ecke
ls
cat notiz-aus-der-wand.txt
flag-einreichen 'GEFUNDENE_FLAG'
```

```bash
ls original/erste-spur.txt sicherung/erste-spur-kopie.txt
cat original/erste-spur.txt
cat sicherung/erste-spur-kopie.txt
ls arbeitstisch/volle-kiste
cat arbeitstisch/volle-kiste/inhalt.txt
```

</details>
