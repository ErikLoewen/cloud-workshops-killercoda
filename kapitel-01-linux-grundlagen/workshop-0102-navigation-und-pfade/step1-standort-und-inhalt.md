# Standort und Inhalt untersuchen

Ein Terminalbefehl wirkt immer in einem bestimmten aktuellen Verzeichnis. Deshalb klären wir zuerst den Standort und untersuchen danach, welche Verzeichnisse dort sichtbar sind.

## Vorhersage

Welche Information müsste ein Befehl liefern, damit du deinen aktuellen Standort eindeutig bestimmen kannst?

## `pwd`: den aktuellen Standort anzeigen

`pwd` steht für **„print working directory“**. Das bedeutet sinngemäß: **„Zeige das aktuelle Arbeitsverzeichnis an.“**

### Was macht `pwd`?

`pwd` zeigt den vollständigen Pfad des aktuellen Verzeichnisses.

### Warum brauchen wir `pwd`?

Vor und nach einer Navigation können wir damit prüfen, wo sich die Shell gerade befindet.

### Welche Ausgabe erwarten wir?

Wir erwarten genau eine Pfadangabe. Für dieses Lab ist als Startpfad `/root` vorgesehen.

Führe nur diesen ersten Aufruf anklickbar aus:

`pwd`{{exec}}

**Erwartete Ausgabe:**

```text
/root
```

Die Zeile mit `pwd` war die Eingabe. `/root` ist die Ausgabe.

> **Erinnerung zum Kopieren:** Einen Pfad kannst du mit der Maus markieren und mit **Strg+Umschalt+C** kopieren. Mit **Strg+Umschalt+V** fügst du ihn hinter dem Prompt ein. Auf anders beschrifteten Tastaturen heißen diese Tasten **Ctrl+Shift+C** und **Ctrl+Shift+V**. Prüfe den eingefügten Text, bevor du **Enter** drückst.

> Falls die Ausgabe im realen Lab von `/root` abweicht, beende nicht vorschnell die Übung. Der Startpfad muss im Killercoda-Pilot technisch bestätigt werden.

## `ls`: Verzeichnisinhalte untersuchen

`ls` kommt vom englischen Wort **„list“**, also **„auflisten“**.

### Was macht `ls`?

`ls` zeigt die sichtbaren Einträge des aktuellen Verzeichnisses.

### Warum brauchen wir `ls`?

Vor einem Verzeichniswechsel müssen wir mögliche Zielnamen finden.

### Welche Ausgabe erwarten wir?

Im aktuellen Verzeichnis soll mindestens `navigation-labor` erscheinen. Die Anordnung kann je nach Terminalbreite unterschiedlich aussehen.

Gib jetzt selbst ein:

```text
ls
```

Drücke Enter.

Suche in der Ausgabe nach:

```text
navigation-labor
```

## Beobachtung

Beantworte für dich:

1. Welche Ausgabe zeigte einen Standort?
2. Welche Ausgabe zeigte mögliche Inhalte dieses Standorts?
3. Was würdest du zuerst verwenden, wenn `ls` unerwartete Namen zeigt?
