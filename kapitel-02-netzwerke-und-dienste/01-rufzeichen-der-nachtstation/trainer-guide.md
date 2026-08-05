# Dozentenleitfaden: Das Rufzeichen der Nachtstation

Diese Datei ist nicht in `index.json` referenziert.

## Zielgruppe und Vorwissen

Erwachsene IT-Anfänger, die Kapitel 1 abgeschlossen haben. Erwartet werden:

- Terminalfokus und Enter;
- `pwd`, `cat` und Nano;
- einfache Dateien und Pfade;
- Unterscheidung von Prompt, Eingabe und Ausgabe.

Nicht vorausgesetzt werden Netzwerkbegriffe, Routing oder Adressberechnung.

## Zielzeit

- geübte Lernende: etwa 30 bis 35 Minuten;
- typischer Kernpfad: etwa 35 bis 42 Minuten;
- absolute Anfänger: höchstens ungefähr 45 bis 48 Minuten;
- Puffer: mindestens 12 Minuten.

Der Workshop soll nicht künstlich bis zur Sitzungsgrenze verlängert werden.

## Concept, Command und Interaction Budget

### Neue Kernbegriffe

- Host
- Hostname
- Netzwerkschnittstelle
- IPv4-Adresse
- Loopback
- `127.0.0.1`

Die sechs Begriffe bilden eine einzige Beziehungskette und werden nicht um Routing, Ports, TCP, DNS, MAC-Adressierung oder IPv6-Details erweitert.

### Neue Befehle

- `hostname`
- `ip address`

Bekannte Werkzeuge aus Kapitel 1:

- `pwd`
- `cat`
- Nano

### Neue Bedienhandlungen

Keine. Die Lernenden lesen längere Terminalausgaben, verwenden aber bekannte Terminal- und Editorhandlungen.

## Beobachtbare Lernziele

Beobachte beziehungsweise erfrage, ob die lernende Person:

1. den Hostnamen mit `hostname` anzeigt;
2. Schnittstellenabschnitte in `ip address` erkennt;
3. IPv4-Zeilen an `inet` erkennt;
4. Loopback anhand von `127.0.0.1` von einer weiteren Schnittstelle unterscheidet;
5. erklärt, dass ein Host mehrere Schnittstellen und Adressen besitzen kann;
6. den aktuellen Zustand korrekt im Stationsprotokoll dokumentiert.

Der technische CHECK prüft Ziel 6 und die dafür benötigten Werte. Die Selbst-Erklärung wird menschlich beziehungsweise durch die Abschlussfragen geprüft.

## Didaktische Progression

1. Orientierung und Vorhersage
2. vollständige Einführung von `hostname`
3. geführte Übertragung des Hostnamens
4. vollständige Einführung von `ip address`
5. reduzierte Beispielausgabe
6. gemeinsam bestimmtes Loopback
7. reduzierte Hilfen bei der weiteren Schnittstelle
8. selbstständige Fertigstellung
9. technischer CHECK
10. Abruf und Selbst-Erklärung

## Dynamische Auswahlregel

Setup und Verify wählen identisch:

1. Schnittstelle der passenden IPv4-Standardroute, sofern sie eine Nicht-Loopback-IPv4-Adresse besitzt;
2. bei mehreren passenden Standardrouten kleinste Metrik, dann alphabetischer Schnittstellenname;
3. andernfalls alphabetisch erste Nicht-Loopback-Schnittstelle mit IPv4-Adresse;
4. bei mehreren Adressen globale IPv4 bevorzugen, danach stabile Auswahl nach Adressbereich und numerischem Wert.

Die Standardroute wird im Lerntext nicht erklärt. Bei mehreren geeigneten Schnittstellen erzeugt das Setup einen Stationsauftrag, der die intern ausgewählte Schnittstelle nennt. So wird keine unbehandelte Routenauswahl vorausgesetzt.

## Typische Fehlvorstellungen

- Der Prompt sei die Ausgabe von `hostname`.
- Ein Host könne nur eine Adresse besitzen.
- `127.0.0.1` sei die Adresse eines anderen Rechners.
- Jede Zahlenfolge in `ip address` sei eine IPv4-Adresse.
- `inet6` sei ebenfalls für das IPv4-Protokoll einzutragen.
- Die Zahl hinter `/` gehöre zwingend in das Feld.
- Der gesamte sichtbare Name einschließlich `@...` müsse übernommen werden.
- Loopback sei eine physische Buchse.

## Geeignete Trainerfragen

- Welche Zeile entstand erst nach dem Befehl?
- Woran erkennst du den Beginn eines neuen Schnittstellenabschnitts?
- Welche Zeichenfolge kündigt eine IPv4-Adresse an?
- Welche Adresse führt zur Station selbst zurück?
- Welche zwei Werte müssen aus demselben Abschnitt stammen?
- Warum prüft der CHECK nicht eine feste Schnittstelle?
- Was darf sichtbar sein, ohne Lernziel zu werden?

## Hilfeintervention

1. Auf Begriff oder Ausgabestelle hinweisen.
2. Den passenden Befehl nennen.
3. Den Abschnitt beziehungsweise die `inet`-Zeile eingrenzen.
4. Den nahezu vollständigen Weg zeigen.
5. Erst danach die Musterlösung erklären.

Nach direkter Hilfe soll die Person mindestens einen Wert erneut selbstständig in der echten Ausgabe finden.

## Technische Grenzen

- IPv6 darf sichtbar sein, wird aber nicht bewertet.
- Die Routentabelle wird intern nur für die deterministische Auswahl verwendet.
- Das Setup verändert keine Netzwerkschnittstelle und weist keine Adresse zu.
- Der Workshop setzt keinen Dienst und keinen Traffic-Link voraus.
- Ein fehlender geeigneter Nicht-Loopback-IPv4-Zustand ist ein Plattformfehler und kein Lernfehler.
