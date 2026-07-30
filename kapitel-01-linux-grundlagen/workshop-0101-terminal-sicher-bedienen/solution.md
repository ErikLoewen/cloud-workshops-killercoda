# Musterlösung: Moin Terminal

Diese Datei ist für Wartung, Pilot und Betreuung gedacht. Sie wird nicht in `index.json` referenziert.

## Vollständiger Musterablauf

### Technischer Startzustand

Die sichtbare Login-Shell läuft als normaler Benutzer `waerter`. Für die
technische Kontrolle gelten:

```text
whoami        → waerter
hostname      → leuchtturm
echo "$HOME"  → /home/waerter
pwd           → /home/waerter
sudo whoami   → root
```

`id` zeigt für `waerter` eine UID ungleich 0.

### 1. System und Oberfläche zuordnen

- Linux ist streng genommen der Kernel und im Alltag oft die Bezeichnung für
  das gesamte Linux-System.
- Eine Distribution kombiniert Kernel, Programme, Werkzeuge und
  Paketverwaltung. Das Lab verwendet Ubuntu.
- Das **Terminal** ist die sichtbare Ein- und Ausgabefläche.
- Die **Shell** verarbeitet die eingegebenen Befehle; hier wird Bash verwendet.
- Der **Prompt** zeigt, dass die Shell auf eine neue Eingabe wartet.
- Der Prompt `waerter@leuchtturm:~$` zeigt Benutzer, Rechnername und aktuelles
  Verzeichnis. Das `$` kennzeichnet hier einen normalen Benutzer; `#` würde
  typischerweise auf Root hinweisen.
- **Eingabe** ist der Text, den die lernende Person vor dem Ausführen tippt.
- **Ausgabe** ist die Antwort, die nach der Ausführung erscheint.

### 2. Ersten Befehl beobachten

Den anklickbaren Demonstrationsbefehl ausführen:

```text
whoami
```

Erwartete Beobachtung:

```text
waerter
```

Danach erscheint der Prompt erneut.

### 3. `echo` kennenlernen und selbst eingeben

Anklickbare Demonstration:

```text
echo "Moin Terminal"
```

Erwartete Ausgabe:

```text
Moin Terminal
```

Danach selbst eingeben:

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
waerter
```

Die Fehlermeldung zeigt, welchen Namen die Shell nicht gefunden hat. Sie ist eine verwertbare Rückmeldung und kein Beweis für eine Beschädigung.

### 5. Vordergrundprozess unterbrechen

Die anklickbare Demonstration `sleep 30` starten.

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

- Der externe Beobachter registriert einen exakt als `sleep 30` gestarteten
  Vordergrundprozess. Er ordnet die Ziel-Shell gezielt der UID von `waerter`
  zu, bevorzugt die TTY-Zuordnung und nutzt in technischen Umgebungen ohne
  sichtbare TTY als Rückfall eine Bash dieses Benutzers.
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
