# Schritt 3: Eine Datei erzeugen und prüfen

## `echo` kurz abrufen

`echo` ist bereits bekannt. Der Befehl erzeugt Textausgabe.

Tippe:

```bash
echo start
```

**Erwartete Ausgabe:**

```text
start
```

## Neue Shell-Syntax: `>`

Das Zeichen `>` wird von der Shell verarbeitet. Es ist kein Bestandteil des Befehls `echo`.

- Links von `>` entsteht eine Ausgabe.
- Rechts von `>` steht der Zielpfad oder Dateiname.
- Die Shell schreibt die Ausgabe in die Datei.
- Der Text erscheint normalerweise nicht zusätzlich im Terminal.
- Existiert die Datei noch nicht, wird sie erzeugt.
- Existiert sie bereits, kann ihr bisheriger Inhalt ersetzt werden.

Wir arbeiten deshalb nur im isolierten Übungsbereich. In diesem Workshop verwendest du ausschließlich ein einzelnes `>`.

## Vorhersage

Wo erwartest du das Wort `start` nach der nächsten Eingabe: im Terminal, in einer Datei oder an beiden Stellen?

## Datei erzeugen

Tippe selbst:

```bash
echo start > notiz.txt
```

**Erwartete Terminalausgabe:**

Normalerweise erscheint kein eigener Text. Der Prompt kehrt zurück.

**Erwartete Zustandsänderung:**

Die Datei `/root/dateilabor/uebung/notiz.txt` wurde erzeugt.

## Der neue Befehl `cat`

`cat` ist die Kurzform von **„concatenate“**, also **„aneinanderhängen“**. Der Befehl kann Dateiinhalte verbinden; hier verwenden wir ihn nur, um den Inhalt einer einzelnen Datei anzuzeigen.

`cat` zeigt hier den Inhalt einer kleinen Textdatei im Terminal an.

Wir benötigen den Befehl, um zu kontrollieren, ob die Datei den erwarteten Text enthält. Es werden keine Optionen verwendet, und es wird immer nur eine Datei angezeigt.

Tippe:

```bash
cat notiz.txt
```

**Erwartete Ausgabe:**

```text
start
```

Falls `No such file or directory` erscheint, prüfe deinen Standort, den Dateinamen und die Groß- und Kleinschreibung.

## Vorhandenen Inhalt ersetzen

Sage zuerst voraus, was mit `start` geschieht. Tippe danach:

```bash
echo fertig > notiz.txt
```

Prüfe den Inhalt:

```bash
cat notiz.txt
```

**Erwartete Ausgabe:**

```text
fertig
```

Der vorherige Inhalt wurde ersetzt.

## Name, Inhalt und Pfad unterscheiden

Für dieses Objekt gilt:

- **Dateiname:** `notiz.txt`
- **Dateiinhalt:** `fertig`
- **relativer Dateipfad:** `notiz.txt`
- **vollständiger Dateipfad:** `/root/dateilabor/uebung/notiz.txt`

Diese Begriffe bezeichnen unterschiedliche Eigenschaften derselben Datei.
