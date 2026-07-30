# Schritt 6: Die Kontrolle behalten – `sleep` abbrechen

Für einen Moment scheint der Deichserver nur noch zu warten. Du lernst jetzt
eine wichtige Sicherheitsleine kennen: **Strg+C**.

## Der Befehl `sleep`

Das englische Wort **„sleep“** bedeutet **„schlafen“**. Der Befehl wartet für die angegebene Zeit, bevor er endet.

### Was macht er?

`sleep` wartet für die Zahl von Sekunden, die als Argument angegeben wird.

### Warum brauchen wir ihn?

Der Befehl erzeugt ungefährlich einen laufenden **Vordergrundprozess**. Das
ist ein Programm, das gerade das Terminal belegt. Solange es läuft, wartet
die Shell und zeigt keinen neuen Prompt.

### Was erwarten wir?

Nach dem Start erscheint zunächst keine normale Textausgabe und kein neuer Prompt.

Betrachte die Eingabe `sleep 30`:

- `sleep` ist der Befehl.
- `30` ist das Argument.
- Die Zahl steht hier für 30 Sekunden Wartezeit.

## Vorhersage

Was wird während der Wartezeit fehlen: die ganze Terminaloberfläche oder nur der neue Prompt?

## Eine stille Wartezeit

Starte den neuen Befehl beim ersten Kontakt durch Anklicken:

`sleep 30`{{exec}}

1. Stell dir vor, der Server wartet im Sturm auf ein Signal. Beobachte zwei
   bis drei Sekunden lang:
   - Es erscheint keine normale Ausgabe.
   - Es erscheint noch kein neuer Prompt.
2. Übernimm wieder die Kontrolle: Halte **Strg** gedrückt und drücke einmal
   **C**.

Häufig erscheint kurz:

```text
^C
```

Danach sollte der Prompt zurückkehren. Du hast den laufenden Befehl
abgebrochen; du musst nicht 30 Sekunden warten.

In der Abschlussaufgabe startest du dieselbe Warteübung ohne anklickbaren
Befehl.

## Beobachtungsfrage

Woran erkennst du, dass der Vordergrundprozess beendet ist und die Shell wieder eine Eingabe annimmt?

## Typischer Fehler

Tippe nicht die Buchstaben `Strg+C` in das Terminal. Halte die Taste **Strg**
gedrückt und drücke währenddessen **C**. Auf manchen Tastaturen ist **Strg**
mit **Ctrl** beschriftet.

## Warum du das schon jetzt lernst

Prozesse behandelst du später ausführlicher. **Strg+C** gehört trotzdem an
den Anfang: Wenn ein Befehl länger läuft als erwartet, weißt du bereits, dass
du die Kontrolle behalten und ihn abbrechen kannst.
