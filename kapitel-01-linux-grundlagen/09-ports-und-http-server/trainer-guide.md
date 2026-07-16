# Dozentenleitfaden

## Workshopprofil

- Titel: Ports prüfen und einen HTTP-Server bereitstellen
- Slug: `ports-und-http-server`
- Ordner: `09-ports-und-http-server`
- Voraussetzungen: Workshops 3, 5 und 6
- Zielzeit geübt: 35–40 Minuten
- Zielzeit absolute Anfänger: 44–50 Minuten
- Mindestpuffer: 10 Minuten

## Menschlich zu prüfende Lernziele

Teilnehmende sollen erklären oder zeigen können:

- IP-Adresse und Portnummer unterscheiden;
- einen Port als logische Nummer eines Netzwerkendpunkts erklären;
- Port von PID und physischer Buchse unterscheiden;
- TCP dem lauschenden Endpunkt zuordnen;
- `LISTEN` richtig einordnen;
- Bind-Adresse und Port unterscheiden;
- die Loopback-Bindung erklären;
- `localhost` mit Loopback und `127.0.0.1` verbinden;
- die vier gezeigten URL-Bestandteile zuordnen;
- erklären, was `curl` anfragt;
- HTTP-Anfrage und HTTP-Antwort unterscheiden;
- `cat` und `curl` vergleichen;
- Arbeitsverzeichnis und ausgelieferte Datei verbinden;
- `-m`, `http.server`, `--bind`, Adresse, Port und `&` unterscheiden;
- den zurückgekehrten Prompt bei weiterlaufendem Server erklären;
- asynchrone Servermeldungen nicht als Teilnehmerbefehle einordnen.

## Typische Fehlvorstellungen

### IP-Adresse, Port und PID

Achten Sie auf Aussagen wie:

- „8080 ist die letzte Zahl der IP-Adresse.“
- „Der Port ist die Prozessnummer.“
- „Port bedeutet Netzwerkbuchse am Gerät.“

Korrekturfrage:

> Welche Angabe beantwortet „an welcher Adresse?“ und welche „an welchem logischen Zugang?“?

### `LISTEN` und korrekte HTTP-Antwort

Fehlvorstellung:

> Wenn `LISTEN` sichtbar ist, muss die richtige Webseite geliefert werden.

Korrektur:

`LISTEN` belegt nur einen wartenden TCP-Endpunkt. Erst die Anfrage mit `curl` prüft die HTTP-Antwort und deren Inhalt.

### Loopback und `localhost`

Fehlvorstellung:

> `localhost` ist ein externer Servername.

Korrekturfrage:

> Verlässt die Anfrage in diesem Workshop das lokale System?

DNS, Nameserver und lokale Namenskonfigurationsdateien nicht vertiefen.

### Arbeitsverzeichnis

Fehlvorstellung:

> Der Server findet `index.html` unabhängig vom Startort.

Korrekturfrage:

> Aus welchem Verzeichnis wurde der Serverprozess gestartet, und welche Datei liegt dort?

## Beobachtung der Wiederverwendung von `&`

`&` ist Wiederholung aus Workshop 7. Prüfen Sie:

- Wird es ohne erneute Job-Control-Lehre eingesetzt?
- Versteht die Person, warum der Prompt zurückkehrt?
- Wird der weiterlaufende Server anschließend mit `ss` und `curl` beobachtet?

Der technische CHECK kann die tatsächliche Verwendung von `&` nicht nachweisen.

## Asynchrone Servermeldungen

Der selbst gestartete Server kann Meldungen in das Terminal schreiben.

Intervention:

1. auf den Prompt zeigen;
2. Servermeldung und eingegebenen Befehl sprachlich trennen;
3. den erwarteten Nutztext exakt benennen;
4. keine neue Umleitung oder Job-Control einführen.

## Vier Hinweisstufen

Hinweise nur schrittweise freigeben:

1. **Konzept:** Pfad, Datei, Loopback, Port, zwei Prüfungen.
2. **Werkzeuge:** ausschließlich die freigegebenen Befehle und Syntax.
3. **Struktur:** Lückengerüst ohne vollständige Lösung.
4. **Musterlösung:** erst nach einem eigenen Lösungsversuch.

Nicht direkt zur Stufe 4 springen, außer ein technischer Fehler verhindert die Aufgabe vollständig.

## Zeitmessung

Messen Sie getrennt:

- Orientierung und Endpunktmodell;
- Demo-Datei;
- `ss`-Interpretation;
- `curl`-Vergleich;
- Befehlszerlegung;
- selbstständige Challenge;
- CHECK und Reflexion.

Zielkorridore:

- geübt: 35–40 Minuten;
- absolute Anfänger: 44–50 Minuten.

Bei wiederholter Überschreitung von 50 Minuten Inhalte oder Textdichte reduzieren. Nicht den Puffer opfern.

## Eingriffskriterien

Eingreifen, wenn:

- Port 8000 erneut gestartet werden soll;
- ein nicht freigegebener Befehl oder eine neue Option nötig zu sein scheint;
- ein externer Netzwerkzugriff versucht wird;
- die Person `8080` als PID behandelt;
- die `ss`-Ausgabe systematisch an falschen Spalten gelesen wird;
- asynchrone Servermeldungen die Bedienung blockieren;
- der CHECK einen möglichen Umgebungsfehler bei `localhost` meldet.

Nicht vorschnell eingreifen bei normalen Tippfehlern. Zuerst Diagnosemeldung und gestufte Hinweise nutzen.

## Technische Killercoda-Besonderheiten

Vor Veröffentlichung real prüfen:

- `setup.sh` als Intro-`foreground` läuft vollständig vor der ersten Handlung;
- Demo-Server bleibt nach Ende des Setups aktiv;
- `ss -ltn` zeigt den lokalen Endpunkt verständlich;
- `curl` ohne Option zeigt eine für Anfänger verständliche Ausgabe;
- `localhost` erreicht zuverlässig den IPv4-Loopback-Listener;
- Hintergrundausgaben bleiben bedienbar;
- der Challenge-CHECK kann `/proc` vollständig genug lesen;
- die HTML-`details`-Elemente für Hinweise werden korrekt dargestellt.

## Technische und fachliche Prüfung trennen

Der CHECK darf nur belegte Zustände melden. Eine erfolgreiche Prüfung bedeutet nicht automatisch, dass die Person:

- selbstständig gearbeitet hat;
- Port und IP verstanden hat;
- `localhost` fachlich zuordnen kann;
- Anfrage und Antwort erklären kann.

Nutzen Sie die Abruffragen in `finish.md` für die menschliche Prüfung.
