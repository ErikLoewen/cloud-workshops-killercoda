# Trainerleitfaden – Navigation im Nebel

Diese Datei ist intern und wird nicht in der Teilnehmeroberfläche angezeigt.

## Zielgruppe und Zeit

- absolute Linux-Anfänger,
- Zielzeit: ungefähr 30 Minuten,
- Einführung: 2–3 Minuten,
- geführte Übungen: 18–20 Minuten,
- Abschlussaufgabe: 5–7 Minuten.

Die Angaben bleiben Schätzwerte, bis ein Anfängerpilot durchgeführt wurde.

## Technischer Startzustand

Die Teilnehmer-Shell muss tatsächlich als `waerter` auf `leuchtturm` im
Verzeichnis `/home/waerter` laufen. Ein lediglich optisch veränderter
Root-Prompt ist nicht zulässig.

## Menschlich zu prüfende Lernziele

1. `pwd`, `ls` und `cd` passend einsetzen;
2. die stille Zustandsänderung durch `cd` erklären;
3. absolute und relative Pfade unterscheiden;
4. `/`, `~`, `.` und `..` erklären;
5. Tab verwenden und von Enter unterscheiden;
6. einen relativen Pfad auf den Ausgangsort beziehen;
7. im Archiv `letzter_eintrag.txt` mit `ls` entdecken, ohne die Datei zu
   öffnen oder zu verändern.

## Beobachtung der Tab-Vervollständigung

Tab kann der CHECK nicht erkennen. Beobachte:

- Ist das Terminal fokussiert?
- Wird nur ein eindeutiges Präfix eingegeben?
- Ergänzt Tab den Namen?
- Wird erst danach Enter gedrückt?

## Typische Fehlvorstellungen

### „Keine Ausgabe bedeutet, dass `cd` nicht funktioniert hat.“

Rückfrage: Mit welchem bekannten Befehl kannst du den Standort prüfen?

### „`/` und `~` sind derselbe Ort.“

Rückfrage: Welche unterschiedlichen Ausgaben zeigt `pwd` an beiden Orten?

### „Ein relativer Pfad funktioniert überall.“

Rückfrage: Von welchem aktuellen Verzeichnis wird der Weg gelesen?

### „Tab führt den Befehl aus.“

Rückfrage: Was verändert nur die Eingabe, und was führt sie aus?

## Hinweisstufen der Abschlussaufgabe

- Stufe 1 erinnert nur an den übergeordneten Hauptbereich.
- Stufe 2 nennt die passenden bekannten Werkzeuge.
- Stufe 3 beschreibt die Bereiche des Weges ohne vollständigen Pfad.
- Stufe 4 zeigt eine schrittweise Lösung und erklärt sie.

## Abgrenzung zur Prüfung

Die technische Prüfung bestätigt nur, dass die Prüfaktion am korrekten
Fundort bei vorhandener Datei erfolgreich war. Tab, Pfadart,
Navigationsreihenfolge und Verständnis müssen beobachtet oder erfragt werden.
