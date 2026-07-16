# Schritt 4: Eine Datei verschieben und umbenennen

## Der neue Befehl `mv`

`mv` kommt vom englischen Wort **„move“**, also **„verschieben“**.

Das Grundmodell lautet:

```text
mv QUELLE ZIEL
```

- Das erste Argument ist der Quellpfad.
- Das zweite Argument ist der Zielpfad.
- `mv` kann ein Objekt umbenennen oder an einen anderen Ort verschieben.
- Ein erfolgreicher Aufruf erzeugt normalerweise keine eigene Ausgabe.
- Es wird keine Kopie erzeugt.
- Das Objekt befindet sich danach nicht mehr am alten Ort.

Wir verwenden jetzt beide Möglichkeiten nacheinander: Zuerst verschieben wir `notiz.txt` in das Verzeichnis `sammlung`. Danach benennen wir die Datei dort in `meldung.txt` um.

## Teil 1: Datei verschieben

Der aktuelle Ort der Datei ist:

```text
/root/dateilabor/uebung/notiz.txt
```

Der neue Ort soll sein:

```text
/root/dateilabor/uebung/sammlung/notiz.txt
```

Der Dateiname bleibt dabei gleich. Nur der Ort ändert sich.

### Vorhersage

Wo erwartest du `notiz.txt` nach dem Verschieben: direkt in `uebung` oder innerhalb von `sammlung`?

### Verschieben

Tippe selbst:

```bash
mv notiz.txt sammlung/notiz.txt
```

**Erwartete Terminalausgabe:**

Normalerweise erscheint kein eigener Text. Der Prompt kehrt zurück.

### Alten und neuen Ort kontrollieren

Zeige zuerst den Inhalt des aktuellen Verzeichnisses:

```bash
ls
```

`notiz.txt` soll hier nicht mehr erscheinen. Zeige danach den Inhalt von `sammlung`:

```bash
ls sammlung
```

**Erwarteter Eintrag:**

```text
notiz.txt
```

Kontrolliere, dass der Inhalt mit verschoben wurde:

```bash
cat sammlung/notiz.txt
```

**Erwartete Ausgabe:**

```text
fertig
```

## Teil 2: Datei umbenennen

Nun bleibt die Datei im Verzeichnis `sammlung`, erhält dort aber den neuen Namen `meldung.txt`.

### Umbenennen

Tippe selbst:

```bash
mv sammlung/notiz.txt sammlung/meldung.txt
```

### Alten und neuen Namen kontrollieren

```bash
ls sammlung
```

**Erwarteter Eintrag:**

```text
meldung.txt
```

`notiz.txt` soll nicht mehr angezeigt werden.

### Inhalt kontrollieren

Tippe:

```bash
cat sammlung/meldung.txt
```

**Erwartete Ausgabe:**

```text
fertig
```

Der Name wurde geändert, der Dateiinhalt blieb erhalten.

## Erkläre selbst

Ordne in beiden ausgeführten Befehlen Quelle und Ziel zu:

```text
mv notiz.txt sammlung/notiz.txt
mv sammlung/notiz.txt sammlung/meldung.txt
```

Woran erkennst du am jeweiligen Zielpfad, ob sich der Ort, der Name oder beides ändert?

Warum entstehen durch `mv` keine zwei Dateien mit demselben Inhalt?
