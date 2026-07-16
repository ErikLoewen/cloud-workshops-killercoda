# Linux-Serverressourcen untersuchen

In diesem Workshop untersuchst du drei verschiedene Ressourcen einer Linux-Serverumgebung:

- CPU beziehungsweise logische Prozessoren,
- RAM beziehungsweise Arbeitsspeicher,
- persistenten Speicherplatz auf einem Dateisystem.

Am Ende dokumentierst du fünf aktuelle Werte in einer kleinen Statusdatei.

## Zeitrahmen

- geübte Teilnehmende: etwa 30–35 Minuten;
- absolute Anfänger: etwa 38–45 Minuten;
- mindestens 15 Minuten bleiben für Fragen, Tippfehler und Wiederholungen.

Der Workshop wird nicht künstlich auf 60 Minuten verlängert.

## Kurzer Abruf

Beantworte vor dem Start:

1. Welcher bekannte Befehl zeigt den Inhalt einer kleinen Textdatei?
2. Welche bekannte Schreibweise leitet die Ausgabe von `echo` in eine Datei um?
3. Ist `/root/ressourcenlabor/serverstatus.txt` nur ein Dateiname oder ein vollständiger Pfad?

<details>
<summary>Antworten anzeigen</summary>

1. `cat`
2. ein einzelnes `>`
3. ein vollständiger absoluter Dateipfad

</details>

## Vorbereiteter Ausgangszustand

Das Szenario hat diesen Ordner vorbereitet:

```text
/root/ressourcenlabor
```

Diese Datei existiert noch nicht:

```text
/root/ressourcenlabor/serverstatus.txt
```

Du erzeugst sie erst in der Abschlussaufgabe.

## Zwei Arten der Prüfung

Der technische CHECK kann später prüfen, ob die Statusdatei vorhanden und formal plausibel ist. Er kann aber nicht beweisen, dass du die Ausgaben manuell gelesen oder CPU, RAM und Dateisystemspeicher fachlich verstanden hast.

Deshalb gehören zu diesem Workshop zusätzlich kurze Beobachtungs- und Erklärungsfragen.
