# Schritt 5: Einen Vordergrundprozess unterbrechen

In diesem Schritt wird `sleep` erstmals vollständig eingeführt.

## Der Befehl `sleep`

Das englische Wort **„sleep“** bedeutet **„schlafen“**. Der Befehl wartet für die angegebene Zeit, bevor er endet.

### Was macht er?

`sleep` wartet für die Zahl von Sekunden, die als Argument angegeben wird.

### Warum brauchen wir ihn?

Der Befehl erzeugt ungefährlich einen laufenden **Vordergrundprozess**. Solange dieser Prozess läuft, wartet die Shell und zeigt keinen neuen Prompt.

### Was erwarten wir?

Nach dem Start erscheint zunächst keine normale Textausgabe und kein neuer Prompt.

Betrachte die Eingabe `sleep 30`:

- `sleep` ist der Befehl.
- `30` ist das Argument.
- Die Zahl steht hier für 30 Sekunden Wartezeit.

## Vorhersage

Was wird während der Wartezeit fehlen: die ganze Terminaloberfläche oder nur der neue Prompt?

## Anklickbare Demonstration

Starte den neuen Befehl beim ersten Kontakt durch Anklicken:

`sleep 30`{{exec}}

1. Beobachte zwei bis drei Sekunden lang:
   - Es erscheint keine normale Ausgabe.
   - Es erscheint noch kein neuer Prompt.
2. Halte **Strg** gedrückt und drücke einmal **C**.

Häufig erscheint kurz:

```text
^C
```

Danach sollte der Prompt zurückkehren.

In der Abschlussaufgabe startest du dieselbe Warteübung ohne anklickbaren
Befehl.

## Beobachtungsfrage

Woran erkennst du, dass der Vordergrundprozess beendet ist und die Shell wieder eine Eingabe annimmt?

## Typischer Fehler

Tippe nicht die Buchstaben `Strg+C` in das Terminal. Halte die Taste **Strg** gedrückt und drücke währenddessen **C**. Auf manchen Tastaturen ist **Strg** mit **Ctrl** beschriftet.
