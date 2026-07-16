# Dateien kopieren und sicher löschen

In diesem Workshop kopierst du eine Datei und entfernst ausschließlich ausdrücklich freigegebene Laborobjekte.

Das Hauptziel ist nicht möglichst schnelles Löschen:

> Entferne nur das ausdrücklich freigegebene Ziel und lasse den Schutzbereich vollständig unverändert.

## Voraussetzungen

Du verwendest bekannte Befehle und Begriffe aus den vorherigen Workshops:

- `pwd`, `ls`, `cd`, `cat` und `mv`;
- absolute und relative Pfade;
- Datei, Verzeichnis, Quelle und Ziel;
- technische Kontrolle mit einem CHECK.

Neu sind `cp`, `rm`, `rmdir` und die konkrete Form `rm -r`.

## Das Labor

Der sichtbare Teilnehmerbereich liegt unter `/root/dateilabor`.

```text
/root/dateilabor/
├── demo/
│   ├── quelle.txt
│   ├── verschoben.txt
│   ├── einzeldatei.txt
│   ├── leerer-ordner/
│   └── nicht-leer/
│       └── inhalt.txt
└── auftrag/
    ├── quelle/
    │   └── bericht.txt
    ├── arbeitsbereich/
    │   ├── alt.txt
    │   ├── leeres-archiv/
    │   └── temp-projekt/
    │       ├── notiz.txt
    │       └── unterordner/
    │           └── rest.txt
    └── schutzbereich/
        └── wichtig.txt
```

Du darfst nur Objekte in diesen Bereichen verändern:

- `/root/dateilabor/demo`
- `/root/dateilabor/auftrag/arbeitsbereich`

Die Datei `/root/dateilabor/auftrag/quelle/bericht.txt` darfst du lesen und kopieren, aber nicht verändern oder entfernen.

Der Bereich `/root/dateilabor/auftrag/schutzbereich` muss vollständig unverändert bleiben.

## Orientierung

Wechsle in das Demo-Verzeichnis und rufe dein Vorwissen ab. Gib jeden Befehl selbst ein:

```bash
cd /root/dateilabor/demo
pwd
ls
cat quelle.txt
```

Beantworte vor dem nächsten Schritt:

1. Welcher Befehl zeigt deinen aktuellen Standort?
2. Welcher Befehl zeigt vorhandene Dateien und Verzeichnisse?
3. Was sind Quelle und Ziel bei `mv`?
4. Bleibt nach einem Verschieben das ursprüngliche Objekt zusätzlich am Quellpfad erhalten?

Ein technisch ausführbarer Befehl ist nicht automatisch fachlich richtig. Der Pfad entscheidet, welches Objekt betroffen ist.
