# Schritt 1: Kurz orientieren, dann loslegen

## Was ist Linux?

Linux ist die technische Grundlage vieler Server, Cloud-Systeme und anderer
Geräte. Streng genommen ist Linux der **Kernel**, also der Kern des Systems.
Im Alltag meint „Linux“ aber häufig das gesamte System. Genau so ein System
bedienst du hier über das Terminal.

## Was ist eine Linux-Distribution?

Eine **Distribution** verbindet den Linux-Kernel mit Programmen, Werkzeugen
und einer Paketverwaltung zu einem vollständigen System. Beispiele sind
Ubuntu, Debian, Fedora und Arch Linux. Im Killercoda-Lab verwendest du
Ubuntu. Viele grundlegende Befehle funktionieren auch auf anderen
Distributionen.

## Linux, Terminal, Shell und Bash

Diese Begriffe dienen erst einmal nur als Wegweiser:

```text
Linux        = die technische Grundlage des Systems
Distribution = ein vollständiges Linux-System wie Ubuntu
Terminal     = die Oberfläche für die Eingabe von Befehlen
Shell        = das Programm, das Befehle verarbeitet
Bash         = eine häufig verwendete Shell
```

Du musst das noch nicht auswendig lernen. Für den Start reicht: Du tippst
einen Befehl ins Terminal, die Bash verarbeitet ihn und zeigt eine Antwort.

## Der Prompt zeigt: bereit

Vor deiner Eingabe steht der **Prompt**. Er kann etwa so aussehen:

```text
root@host:~#
```

Du musst diese Zeichen weder verstehen noch mittippen. Ist der Prompt
sichtbar, wartet die Shell auf deine nächste Eingabe. Fehlt er, läuft
möglicherweise noch ein Programm.

## Terminal fokussieren

1. Klicke einmal in den Terminalbereich.
2. Suche den Prompt und die Eingabestelle direkt dahinter.

## Text kopieren und einfügen

- **Kopieren:** Markiere den gewünschten Text mit der Maus. Drücke dann **Strg+Umschalt+C**.
- **Einfügen:** Klicke hinter den Prompt und drücke **Strg+Umschalt+V**.

Auf manchen Tastaturen steht **Ctrl** statt **Strg** und **Shift** statt
**Umschalt**. Prüfe vor dem Einfügen, ob der Prompt sichtbar ist. Mit
**Enter** führst du die fertige Eingabe aus.

## Diagnosefrage

Was erwartest du: Verändert ein einfacher Tippfehler sofort das System, oder antwortet die Shell mit einer Meldung?

Halte deine Vermutung kurz fest. Gleich probierst du es aus.

## Merksatz

**Prompt sichtbar:** Die Shell ist bereit für eine neue Eingabe.
