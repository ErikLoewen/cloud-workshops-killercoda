# Abschluss: Rechte lesen, gezielt ändern und prüfen

Du hast eine Rechteanzeige gelesen, einen erwarteten Berechtigungsfehler beobachtet, das Besitzer-Ausführungsrecht ergänzt, eine vorbereitete Datei direkt ausgeführt und das Recht im Demo wieder entfernt.

## Die sechs Kernideen

1. **Dateirechte:** Regeln für mögliche Handlungen mit einer Datei.
2. **Rechteanzeige:** Der erste Kernblock von `ls -l` zeigt Objekttyp und Grundrechte.
3. **Lesen, Schreiben und Ausführen:** `r`, `w` und `x`.
4. **Besitzer, Gruppe und andere:** drei Dreiergruppen nach dem ersten Zeichen.
5. **Symbolische Rechteänderung:** `u+x` fügt das Besitzer-Ausführungsrecht hinzu, `u-x` entfernt es.
6. **Ausführen über einen relativen Pfad:** `./dateiname` verweist auf eine Datei im aktuellen Verzeichnis.

## Wirkungsmodell

```text
Dateiinhalt
    +
Dateirechte
    ↓
bestimmen gemeinsam, welche Handlung mit der Datei möglich ist
```

`cat` zeigt einen Inhalt, führt die Datei aber nicht aus. `chmod` verändert in diesem Workshop Rechte, nicht den Dateiinhalt.

## Rufe das Wissen ab

Beantworte ohne zur Lösung zurückzuscrollen:

1. Welches Zeichen gehört nicht zu den neun Rechtepositionen?
2. Welche drei Rechtebereiche folgen danach?
3. Wofür stehen `r`, `w` und `x`?
4. Was bedeutet ein Bindestrich innerhalb einer Dreiergruppe?
5. Was bedeutet `u` in `u+x`?
6. Was bewirkt `u-x`?
7. Wofür steht `./`?
8. Warum erhält nur der Besitzer ein neues Ausführungsrecht?
9. Warum ist `cat` keine Ausführung?
10. Was kann der technische CHECK nicht über deinen Lösungsweg beweisen?

## Sicherheitsgrundsatz

> Ergänze nur das Recht, das für die konkrete Aufgabe benötigt wird, und nur für den vorgesehenen Rechtebereich.

Der technische CHECK bestätigt ausschließlich den vorgesehenen Endzustand. Verständnis, Diagnose und selbstständiges Vorgehen müssen zusätzlich erklärt und beobachtet werden.
