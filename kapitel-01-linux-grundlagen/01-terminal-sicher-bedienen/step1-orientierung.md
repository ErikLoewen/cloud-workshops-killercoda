# Schritt 1: Terminal, Shell und Prompt

## Ziel

Du lernst den Bereich kennen, in den du gleich etwas eintippen wirst.

## Drei Begriffe

Auf dem Bildschirm siehst du einen Bereich mit Text. Dort kannst du dem Computer kurze Anweisungen geben. Der Computer antwortet ebenfalls mit Text.

Du kannst dir das ein wenig wie einen Chat vorstellen:

1. Du schreibst eine Anweisung.
2. Du drückst die Eingabetaste.
3. Der Computer führt die Anweisung aus und schreibt eine Antwort darunter.

Für die einzelnen Teile gibt es drei Namen:

- Das **Terminal** ist der sichtbare Bereich auf dem Bildschirm. Hier tippst du deine Anweisungen ein und hier erscheinen die Antworten des Computers.
- Die **Shell** arbeitet im Hintergrund. Sie liest deine Anweisung und versucht, sie für dich auszuführen. Du musst die Shell nicht öffnen oder bedienen – du schreibst einfach in das Terminal.
- Der **Prompt** ist das kurze Zeichen oder die kurze Textzeile direkt vor der Stelle, an der du schreiben kannst. Er bedeutet: „Ich bin bereit. Du kannst jetzt etwas eingeben.“

Ein Prompt kann zum Beispiel so aussehen:

```text
$
```

oder so:

```text
root@host:~#
```

Wie der Prompt genau aussieht, ist zunächst nicht wichtig. Du musst seine Zeichen weder verstehen noch selbst eintippen.

> **Wichtig: Warte auf den Prompt.**
>
> Solange kein neuer Prompt zu sehen ist, arbeitet der Computer möglicherweise noch an der letzten Anweisung. Tippe in dieser Zeit nichts ein, wenn du nicht genau weißt, was das laufende Programm mit deiner Eingabe macht. Deine Eingabe könnte sonst beim laufenden Programm landen oder später unerwartet als neue Anweisung ausgeführt werden.
>
> Erst wenn der Prompt wieder erscheint, ist die Shell bereit für deine nächste Anweisung.

## Terminal fokussieren

1. Klicke einmal in den Terminalbereich.
2. Suche den Prompt. Direkt dahinter befindet sich die Stelle für deine Eingabe. Oft blinkt dort ein kleiner Strich oder ein Kästchen.
3. Tippe noch nichts.

## Text kopieren und einfügen

Im Terminal funktionieren die üblichen Tastenkombinationen zum Kopieren und Einfügen etwas anders:

- **Kopieren:** Markiere den gewünschten Text mit der Maus. Drücke dann **Strg+Umschalt+C**.
- **Einfügen:** Klicke hinter den Prompt und drücke **Strg+Umschalt+V**.

Auf manchen Tastaturen steht **Ctrl** statt **Strg** und **Shift** statt **Umschalt**. Dann heißen die Kombinationen **Ctrl+Shift+C** und **Ctrl+Shift+V**.

> **Vor dem Einfügen prüfen:** Ist der Prompt sichtbar? Ein eingefügter Text steht zunächst nur in der Eingabezeile. Lies ihn noch einmal und drücke erst danach **Enter**, um ihn auszuführen.

Verwende zum Kopieren im Terminal nicht nur **Strg+C**. Diese Tastenkombination ist dort bereits dafür vorgesehen, ein laufendes Programm zu unterbrechen.

## Diagnosefrage

Was erwartest du: Verändert ein einfacher Tippfehler sofort das System, oder antwortet die Shell mit einer Meldung?

Diese Frage wird nicht bewertet. Halte deine Vermutung kurz fest.

## Merksatz

**Prompt sichtbar:** Die Shell ist bereit für eine neue Eingabe.
