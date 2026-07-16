# Dozentenleitfaden – Workshop 3

## Zweck

Dieser Leitfaden unterstützt die formative Begleitung von „Dateien und Verzeichnisse erstellen“. Er ist nicht für die Teilnehmeroberfläche bestimmt.

## Verbindlicher Zeitkorridor

- geübte Teilnehmende: 33–40 Minuten
- absolute Anfänger: 43–49 Minuten
- Puffer: mindestens 11 Minuten

Der Workshop wird nicht künstlich verlängert.

## Menschlich zu prüfende Lernziele

Teilnehmende sollen:

1. Datei und Verzeichnis unterscheiden;
2. Dateiname, Dateiinhalt und Dateipfad an einem konkreten Objekt zuordnen;
3. erklären, was `>` bewirkt;
4. erklären, warum umgeleiteter Text normalerweise nicht zusätzlich im Terminal erscheint;
5. wissen, dass vorhandener Dateiinhalt ersetzt werden kann;
6. mit `mv` eine Datei verschieben und umbenennen sowie Quelle und Ziel korrekt zuordnen;
7. erklären, warum relative Pfade vom aktuellen Arbeitsverzeichnis abhängen;
8. erkennen, dass `mkdir` und `mv` bei Erfolg normalerweise keine eigene Ausgabe erzeugen.

Der technische CHECK darf nicht als Nachweis dieser Verständnisziele ausgelegt werden.

## Typische Fehlvorstellungen

### Fehlende Ausgabe bedeutet Fehler

Geeignete Rückfrage:

> Welche sichtbare Zustandsänderung erwartest du, und mit welchem bekannten Befehl kannst du sie prüfen?

### `>` gehört zu `echo`

Geeignete Rückfrage:

> Was zeigt `echo start` direkt an, und was ändert sich, wenn die Shell die Ausgabe an einen Zielpfad weitergibt?

### Dateiname und Dateiinhalt sind dasselbe

Geeignete Rückfrage:

> Welcher Text steht außen am Objekt, welcher Text steht darin, und wie lautet der Weg dorthin?

### `mv` erstellt eine Kopie

Geeignete Rückfrage:

> Welcher alte Pfad sollte nach dem Verschieben noch existieren? Vergleiche Quelle und Ziel mit `ls`.

### Quelle und Ziel werden vertauscht

Geeignete Rückfrage:

> Welches Objekt existiert bereits und soll bewegt werden? Dieser Pfad steht zuerst.

### Relative Pfade sind überall gleich

Geeignete Rückfrage:

> Welchen vollständigen Pfad erhältst du, wenn du den aktuellen Standort aus `pwd` vor den relativen Pfad setzt?

## Beobachtungskriterien

Achte darauf, ob Teilnehmende:

- vor einer unsicheren relativen Operation ihren Standort prüfen;
- nach einer stillen Operation den Zustand kontrollieren;
- Pfade vollständig und mit korrekter Groß- und Kleinschreibung eingeben;
- bei einer Fehlermeldung zunächst Standort und vorhandene Objekte untersuchen;
- beim selbstständigen Abschluss ohne neue Syntax auskommen;
- den letzten vollständigen Hinweis erst nach einem eigenen Versuch öffnen.

## Vier Hinweisstufen

1. **Konzept:** nur die fachliche Reihenfolge nennen.
2. **Werkzeug:** passende bekannte Befehle nennen.
3. **Struktur:** nahezu vollständige Befehlsformen mit ausgelassenen Dateinamen zeigen.
4. **Musterlösung:** vollständige Lösung mit Erklärung zeigen.

Nicht direkt zu Stufe 4 springen, außer eine Barriere verhindert nachweislich jede weitere Lernhandlung.

## Zeitmessung

Erfasse getrennt:

- Start bis Ende der Orientierung;
- geführte Arbeit bis Abschluss von Schritt 4;
- gestützte Anwendung;
- selbstständige Challenge;
- Fehlersuche und CHECK;
- technische Wartezeit.

Gemessen wird der Kernpfad ohne freiwillige Wiederholungen.

## Eingriffskriterien

Gezielt eingreifen, wenn:

- ein Teilnehmer länger als etwa zwei Minuten ohne neue Diagnosehandlung feststeckt;
- ein falscher Pfad wiederholt eingegeben wird, ohne `pwd` oder `ls` zu verwenden;
- eine Fehlermeldung als Systemschaden interpretiert wird;
- die Abschlussaufgabe wegen einer nicht eingeführten Handlung unlösbar erscheint;
- der Zeitkorridor für Anfänger voraussichtlich überschritten wird.

Zuerst eine Beobachtungs- oder Diagnosefrage stellen. Danach die nächste Hinweisstufe anbieten.

## Formative Kurzfragen

- Was bewirkt `>`?
- Warum erscheint bei der Umleitung kein zusätzlicher Text im Terminal?
- Was ist bei `status.txt`, `bereit` und dem vollständigen Pfad jeweils gemeint?
- Welches Argument von `mv` ist die Quelle?
- Warum ist der alte Pfad nach einem Verschieben nicht mehr vorhanden?
- Warum kann derselbe relative Pfad von einem anderen Standort aus etwas anderes bedeuten?

## Endzustandsprüfung und Verständnisprüfung

Der CHECK prüft ausschließlich:

- Verzeichnistypen,
- Dateitypen,
- Zielpfade,
- bytegenaue Inhalte,
- Abwesenheit des alten Quellpfades.

Die Lehrperson oder angeleitete Selbstreflexion prüft:

- verwendete Begriffe,
- Erklärungen,
- Vorhersagen,
- bewusste Pfadwahl,
- Zuordnung von Quelle und Ziel,
- Einordnung fehlender Ausgabe.

Ein erfolgreicher CHECK darf nicht als vollständiger Kompetenznachweis bezeichnet werden.
