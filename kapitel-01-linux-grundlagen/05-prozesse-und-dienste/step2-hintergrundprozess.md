# Einen Prozess im Hintergrund starten

## Vordergrund und Hintergrund

Ohne `&` läuft ein gestartetes Programm zunächst im **Vordergrund**. Solange dieser Vordergrundprozess läuft, wartet die Shell normalerweise auf sein Ende.

Ein `&` am Ende der Eingabe weist die Shell an, das Programm im **Hintergrund** zu starten:

- Der Prompt kehrt zurück, obwohl der Prozess weiterlaufen kann.
- `&` ist Shell-Syntax.
- `&` ist weder Teil des Programmnamens noch ein Argument des Programms.
- Ein sichtbarer Prompt beweist nicht, dass der Hintergrundprozess beendet ist.

## Vorhersage

Was erwartest du nach dem Start?

1. Erscheint der Prompt sofort wieder?
2. Läuft das Übungsprogramm trotzdem weiter?

## Erster Hintergrundstart

Führe dieses erste vollständige Beispiel aus:

`lab-worker &`{{exec}}

`lab-worker` ist ein eigens für diesen Workshop bereitgestelltes Lab-Programm. Es ist kein allgemein zu lernender Linux-Standardbefehl.

## Beobachtung

Prüfe nur mit deinen Augen:

- Ist der Prompt wieder sichtbar?
- Kann oberhalb des Prompts eine Zahl in eckigen Klammern und eine weitere Zahl stehen?

Eine Zahl in eckigen Klammern ist eine Shell-Information, die du in diesem Workshop nicht benötigst. Für die zuverlässige Prozesssuche verwendest du gleich `ps` und `pgrep`.

## Erkläre

Vervollständige den Satz in eigenen Worten:

> Der sichtbare Prompt bedeutet hier nicht, dass `lab-worker` beendet ist, weil …
