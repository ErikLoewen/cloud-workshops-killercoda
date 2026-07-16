# Schritt 5: Einen Vordergrundprozess unterbrechen

In diesem Schritt wird `sleep` erstmals vollständig eingeführt.

## Der Befehl `sleep`

### Was macht er?

`sleep` wartet für die Zahl von Sekunden, die als Argument angegeben wird.

### Warum brauchen wir ihn?

Der Befehl erzeugt ungefährlich einen laufenden **Vordergrundprozess**. Solange dieser Prozess läuft, wartet die Shell und zeigt keinen neuen Prompt.

### Was erwarten wir?

Nach dem Start erscheint zunächst keine normale Textausgabe und kein neuer Prompt.

Betrachte die Eingabe:

```text
sleep 30
```

- `sleep` ist der Befehl.
- `30` ist das Argument.
- Die Zahl steht hier für 30 Sekunden Wartezeit.

## Vorhersage

Was wird während der Wartezeit fehlen: die ganze Terminaloberfläche oder nur der neue Prompt?

## Übung

1. Klicke in das Terminal.
2. Tippe `sleep 30`{{}}.
3. Drücke **Enter**.
4. Beobachte zwei bis drei Sekunden lang:
   - Es erscheint keine normale Ausgabe.
   - Es erscheint noch kein neuer Prompt.
5. Halte **Ctrl** gedrückt und drücke einmal **C**.

Häufig erscheint kurz:

```text
^C
```

Danach sollte der Prompt zurückkehren.

## Beobachtungsfrage

Woran erkennst du, dass der Vordergrundprozess beendet ist und die Shell wieder eine Eingabe annimmt?

## Typischer Fehler

Tippe nicht die Buchstaben `Ctrl+C` in das Terminal. Halte die Taste **Ctrl** gedrückt und drücke währenddessen **C**.
