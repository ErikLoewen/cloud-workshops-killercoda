# Musterlösung: Das Terminal sicher bedienen

Diese Datei ist für Wartung, Pilot und Betreuung gedacht. Sie wird nicht in `index.json` referenziert.

## Vollständiger Musterablauf

### 1. Oberfläche zuordnen

- Das **Terminal** ist die sichtbare Ein- und Ausgabefläche.
- Die **Shell** verarbeitet die eingegebenen Befehle.
- Der **Prompt** zeigt, dass die Shell auf eine neue Eingabe wartet.
- **Eingabe** ist der Text, den die lernende Person vor dem Ausführen tippt.
- **Ausgabe** ist die Antwort, die nach der Ausführung erscheint.

### 2. Ersten Befehl beobachten

Den anklickbaren Demonstrationsbefehl ausführen:

```text
whoami
```

Erwartete Beobachtung:

```text
root
```

Danach erscheint der Prompt erneut.

### 3. `echo` selbst eingeben

```text
echo "Hallo Welt"
```

Erwartete Ausgabe:

```text
Hallo Welt
```

Erklärung:

- `echo` ist der Befehl.
- `"Hallo Welt"` ist das Argument. Die Anführungszeichen halten die beiden Wörter zusammen.
- Das Argument liefert den Text, den `echo` ausgibt.

Weitere Übungen:

```text
echo Sicher
echo Startklar
```

Erwartete Ausgaben:

```text
Sicher
Startklar
```

### 4. Fehler erzeugen und korrigieren

Absichtlich eingeben:

```text
whoam
```

Mögliche Meldung:

```text
bash: whoam: command not found
```

Danach:

1. Pfeiltaste nach oben drücken.
2. Das fehlende `i` ergänzen.
3. Enter drücken.

Korrigierte Eingabe:

```text
whoami
```

Erwartete Ausgabe:

```text
root
```

Die Fehlermeldung zeigt, welchen Namen die Shell nicht gefunden hat. Sie ist eine verwertbare Rückmeldung und kein Beweis für eine Beschädigung.

### 5. Vordergrundprozess unterbrechen

```text
sleep 30
```

Erwartete Beobachtung:

- keine normale Ausgabe,
- kein neuer Prompt,
- die Shell wartet auf den Vordergrundprozess.

Dann Strg gedrückt halten und C drücken.

Häufig sichtbar:

```text
^C
```

Anschließend erscheint der Prompt erneut.

### 6. Abschlussaufgabe

```text
echo terminal-bereit
```

Danach Pfeiltaste nach oben und Enter verwenden. Die erwartete Ausgabe erscheint zweimal:

```text
terminal-bereit
terminal-bereit
```

Anschließend:

```text
sleep 30
```

Den Prozess mit Strg+C unterbrechen und erst nach Rückkehr des Prompts den CHECK starten.

## Grenzen des technischen CHECKs

Der CHECK kann nur eine eng begrenzte technische Teilprüfung durchführen:

- Der externe Beobachter registriert einen exakt als `sleep 30` gestarteten Vordergrundprozess. Er bevorzugt die Zuordnung über das interaktive Bash-Terminal und nutzt nur in Umgebungen ohne sichtbare TTY-Zuordnung eine engere Zuordnung als direkter Kindprozess der ermittelten interaktiven Shell.
- Der CHECK prüft, ob genau der registrierte Prozess zum Prüfzeitpunkt nicht mehr existiert.

Der CHECK weist nicht nach:

- dass Enter verwendet wurde,
- dass die Pfeiltaste nach oben verwendet wurde,
- dass Strg+C verwendet wurde,
- dass der Prozess vorzeitig statt regulär endete,
- dass `echo terminal-bereit` ausgeführt wurde,
- dass die Ausgabe zweimal erzeugt wurde,
- dass die Begriffe verstanden wurden.

Diese Lernziele werden im Pilot beziehungsweise in betreuten Durchläufen durch Beobachtung und Fragen geprüft.
