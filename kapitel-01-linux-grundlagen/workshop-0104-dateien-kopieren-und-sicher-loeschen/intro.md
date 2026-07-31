# Kopieren, aufräumen, nichts versenken

Ein dumpfes Knacken geht durch den Kartenraum. Morsches Holz gibt nach, ein
Regal kippt und ein Teil der Wand bricht ein. Karten, Abschriften und Kisten
liegen durcheinander. Die erste Spur ist noch da. Bevor mehr verloren geht,
musst du sie sichern und den beschädigten Bereich kontrolliert räumen.

<!-- INTROBILD: Hier später das Bild des frisch beschädigten Kartenraums einfügen. -->

Du arbeitest wirklich als `waerter` am Rechner `leuchtturm` und startest hier:

```text
waerter@leuchtturm:~/leuchtturm/obergeschoss/kartenraum$
```

```text
kartenraum/
├── original/
│   └── erste-spur.txt
├── sicherung/
├── arbeitstisch/
│   ├── vorlage.txt
│   ├── alte-abschrift.txt
│   ├── leere-mappe/
│   └── volle-kiste/
│       └── inhalt.txt
└── eingestuerzte-ecke/
    ├── nasse-notiz.txt
    └── splitter/
        └── rest.txt
```

`original/erste-spur.txt` gehört `root` und ist nur lesbar. Du kannst sie
prüfen und kopieren, aber als `waerter` weder überschreiben noch entfernen.
Die übrigen Arbeitsbereiche gehören dir.

Neu sind `cp`, `rm`, `rmdir` und `rm -r`. `mv`, `pwd`, `ls` und `cat` kennst
du bereits. Für jede Löschung gilt die kurze Routine:

```text
Standort prüfen → Ziel prüfen → Wirkung vorhersagen
        → Befehl selbst tippen → Ergebnis kontrollieren
```

Passende Folge: `pwd` → `ls ZIEL` → Befehl → `ls`.
