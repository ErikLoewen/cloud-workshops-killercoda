# Die eingestürzte Ecke beurteilen

`rm -r VERZEICHNIS` entfernt rekursiv den genannten Ordner, alle enthaltenen
Dateien und alle Unterverzeichnisse. Deshalb muss der vollständige Zielbaum
vorher bekannt sein. Das einzige freigegebene rekursive Ziel ist:

```text
/home/waerter/leuchtturm/obergeschoss/kartenraum/eingestuerzte-ecke
```

Untersuche ihn jetzt vollständig, ohne ihn schon zu entfernen:

```bash
pwd
ls eingestuerzte-ecke
cat eingestuerzte-ecke/nasse-notiz.txt
ls eingestuerzte-ecke/splitter
cat eingestuerzte-ecke/splitter/rest.txt
```

## Einen gefährlichen Meme-Befehl nur analysieren

Die folgende Zeichenfolge darfst du **niemals ausführen**. Sie ist bewusst
nicht kopierbar und kein Lösungsvorschlag:

<pre><code>sudo rm -rf ~/</code></pre>

- `sudo`: mit administrativen Rechten ausführen;
- `rm`: entfernen;
- `-r`: Verzeichnisse samt Inhalt rekursiv bearbeiten;
- `-f`: erzwingen und Rückfragen beziehungsweise bestimmte Meldungen unterdrücken;
- `~/`: Home-Verzeichnis des aktuellen Benutzers, hier `/home/waerter/`.

Die Shell erweitert `~` schon vor dem Start von `sudo`. Zur sicheren
Demonstration führe ausschließlich dies aus:

`printf 'Dein Home-Verzeichnis ist: %s\n' "$HOME"`{{exec}}

> Kopiere keinen Terminalbefehl, dessen Befehl, Optionen und Ziel du nicht
> erklären kannst.

Prüfe immer: Welcher Befehl? Welche Optionen? Welches Ziel? Warum `sudo`?
Kannst du die Wirkung vorher gefahrlos prüfen?
