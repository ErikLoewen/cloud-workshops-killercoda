# Trainerleitfaden – Dateien, Ordner und die erste Spur

## Zielgruppe und Zeit

- absolute Linux-Anfänger;
- Zielzeit ungefähr 30 Minuten;
- geführte Arbeit 18–20 Minuten;
- Abschluss und CHECK 7–10 Minuten.

## Menschlich zu prüfen

Teilnehmende sollen:

1. Datei, Dateiname, Inhalt und Pfad unterscheiden;
2. die stille Zustandsänderung bei `mkdir` und `mv` einordnen;
3. erklären, dass `>` Inhalt erzeugt oder ersetzt;
4. Quelle und Ziel bei `mv` richtig zuordnen;
5. Umbenennen, Verschieben sowie Verschieben mit Umbenennen unterscheiden;
6. wissen, dass `mv` normalerweise keinen Inhalt verändert.

## Typische Fehlvorstellungen

- **„Keine Ausgabe bedeutet Fehler.“** Mit `ls` oder `cat` den Zustand
  prüfen lassen.
- **„`>` gehört zu `echo`.“** Zwischen erzeugter Ausgabe und Umleitung durch
  die Shell unterscheiden.
- **„`mv` kopiert.“** Alten Quellort und neuen Zielort mit `ls` vergleichen.
- **„Der Zielpfad steht zuerst.“** Nach dem bereits vorhandenen Objekt
  fragen; dieses ist die Quelle.
- **„Die neuen Zeilen sind eine normale Wirkung von `mv`.“** Erst nach
  erfolgreichem CHECK die technische Inszenierung aus `finish.md` erklären.

## Hintergrundprozess

Der Hintergrundprozess wartet auf den Setup-Marker. Er reagiert nur, wenn
die vorbereitete Quelldatei nicht mehr im Archiv liegt und am exakten
Zielpfad mit passender Geräte-/Inode-Identität sowie unverändertem
Ausgangshash erscheint. Eine Kopie oder nachgebaute Datei genügt nicht.

Die Meldung wird bevorzugt einmalig an eine Bash-TTY von `waerter`
geschrieben. Ist keine geeignete TTY auffindbar, zeigt `PROMPT_COMMAND` eine
vorbereitete Fallbackdatei am nächsten Prompt genau einmal an.

## Prüfung

Der CHECK bestätigt ausschließlich die erfolgreiche Flag-Abgabe. Die
Dateioperationen, die Verwendung einzelner Lernbefehle und das Verständnis
der Konzepte müssen beobachtet oder erfragt werden.
