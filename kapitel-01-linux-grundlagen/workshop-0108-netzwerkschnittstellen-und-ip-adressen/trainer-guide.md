# Trainerleitfaden

## Ziel und Rolle des Workshops

Der Workshop führt sechs fachliche Konzeptcluster ein:

1. Netzwerkschnittstelle
2. Loopback
3. IPv4-Adresse
4. Präfixlänge
5. Route
6. Standardroute und primäre Schnittstelle

Doppelte Anführungszeichen sind ein eng begrenztes neues Shell-Syntaxelement und kein zusätzlicher Netzwerk-Konzeptcluster.

## Menschlich zu prüfende Lernziele

Teilnehmende sollen:

- eine Netzwerkschnittstelle als Verbindungspunkt beschreiben;
- Name, Zustand und Adresse unterscheiden;
- Loopback als Bezug auf das eigene System erklären;
- Loopback und primäre Schnittstelle unterscheiden;
- IPv4 an der Punktnotation erkennen;
- die Präfixlänge als Teil der Adressschreibweise erkennen;
- erklären, dass keine Subnetzberechnung verlangt wird;
- die Standardroute an `default` erkennen;
- den Namen hinter `dev` zuordnen;
- die primäre IPv4-Adresse aus der passenden Schnittstellenzeile übernehmen;
- `-brief` als Option einordnen;
- `addr` und `route` als Informationsbereiche einordnen;
- sichtbare Adressen mit Doppelpunkten nicht übernehmen;
- dynamische Namen und Adressen begründen;
- die Wirkung der doppelten Anführungszeichen erklären;
- erklären, warum die Anführungszeichen nicht im Dateiinhalt stehen.

## Beobachtung der Befehlsfamilie

Vor dem ersten Aufruf muss klar sein:

```text
ip        -brief       addr
Befehl    Option       Informationsbereich
```

Später:

```text
ip        route
Befehl    Informationsbereich
```

`addr` und `route` nicht als Optionen oder frei wählbare Werte bezeichnen. Keine allgemeine Befehlsgrammatik daraus ableiten.

## Typische Fehlvorstellungen und Rückfragen

### Zustand wird als Adresse gelesen

Rückfrage:

> Welcher sichtbare Bereich besitzt vier durch Punkte getrennte Zahlengruppen?

### `UNKNOWN` wird als Defekt interpretiert

Rückfrage:

> Ist dieses Wort ein Name, ein Zustand oder eine Adresse?

Danach knapp erklären, dass der Zustand nur zur Orientierung dient.

### Erste Nicht-Loopback-Zeile gilt automatisch als primär

Rückfrage:

> Welche Ausgabe legt in diesem Workshop die primäre Schnittstelle fest?

### Adresse hinter `via` wird übernommen

Rückfrage:

> Welches Wort steht vor dem gesuchten Schnittstellennamen, und in welcher Ausgabe findest du danach die eigene IPv4-Adresse?

### Fester Name wird angenommen

Rückfrage:

> Welcher Name steht in deiner aktuellen `default`-Zeile direkt hinter `dev`?

### Präfixlänge wird weggelassen

Rückfrage:

> Welcher vollständige Adresswert steht in der Schnittstellenzeile?

### Sichtbare Adressen mit Doppelpunkten lenken ab

Rückfrage:

> Welche Adressform ist für diese Aufgabe an der Punktnotation erkennbar?

IPv6 nicht als eigenen Theorieblock eröffnen.

### Subnetting-Frage

Antwort:

> Die Zahl hinter `/` wird heute nur als Teil der Adressschreibweise übernommen. Berechnungen gehören nicht zu diesem Workshop.

## Erste Verwendung doppelter Anführungszeichen

Unmittelbar vor der Dateierstellung beobachten:

1. Wurde die Vorhersagefrage gestellt?
2. Können die Teilnehmenden erklären, dass der Text mit Leerzeichen zusammengehalten wird?
3. Verstehen sie, dass die Anführungszeichen nicht in der Datei erscheinen?
4. Unterscheiden sie Befehl, Textargument, Umleitung und Zielpfad?
5. Kontrollieren sie den Inhalt mit `cat`?

Keine allgemeinen Quoting-Regeln oder Alternativformen ergänzen.

## Regeln für die vier Hinweisstufen

1. Erst Konzeptzusammenhang nennen.
2. Danach Werkzeuge und Marker nennen.
3. Danach Dateistruktur zeigen.
4. Erst zuletzt vollständige Methode mit dynamischen Platzhaltern zeigen.

Die nächste Stufe nur anbieten, wenn die vorherige Stufe nicht genügt. Die Musterlösung nicht vor dem ersten selbstständigen Versuch sichtbar machen.

## Zeitmessung

Zu erfassen:

- Orientierung und Modell;
- erste Adressauswertung;
- Loopback und Präfixlänge;
- Standardroute;
- Zuordnung der primären IPv4-Adresse;
- Einführung doppelter Anführungszeichen;
- Challenge und CHECK;
- Gesamtzeit;
- Zahl der geöffneten Hinweise.

Zielkorridore:

- geübt: 31–37 Minuten;
- absolute Anfänger: 40–47 Minuten;
- mindestens 13 Minuten Puffer.

## Eingriffskriterien

Überarbeiten, wenn:

- absolute Anfänger regelmäßig mehr als 47 Minuten benötigen;
- die Einführung der Anführungszeichen länger als zwei Minuten beansprucht;
- Name, Zustand und Adresse häufig verwechselt werden;
- `default` und `dev` nicht zuverlässig gefunden werden;
- die Dateisyntax das Netzwerklernziel überlagert;
- gültige dynamische Werte vom CHECK abgelehnt werden.

## Mögliche Killercoda-Besonderheiten

### Schnittstellenname mit `@`

Virtualisierte oder containerisierte Umgebungen können in einer Adressausgabe einen technischen Zusatz zeigen, etwa schematisch `<NAME>@<ZUSATZ>`.

Teilnehmerwert bleibt der Name hinter `dev` aus der Standardroute. Der CHECK ordnet intern sowohl einen exakten Namen als auch einen unmittelbar folgenden `@`-Zusatz zu.

Diesen Sonderfall nur nach Bestätigung im realen Killercoda-Pilot in den Teilnehmertext aufnehmen.

### Mehrere Standardrouten

Der Workshop benötigt eine eindeutig verwendbare Standardroute. Der CHECK darf bei mehreren Routen keine willkürliche Auswahl treffen. Der Zustand ist als technischer Umgebungsfehler zu behandeln.

### Mehrere IPv4-Adressen

Jede aktuelle Nicht-Loopback-IPv4-Adresse einschließlich Präfix auf der primären Schnittstelle ist gültig.

## Technische und fachliche Prüfung trennen

Der CHECK prüft Datei und aktuellen lokalen Zustand.

Trainerbeobachtung und Fragen prüfen Verständnis, Vorgehen und Begriffe. Ein erfolgreicher CHECK darf nicht als vollständiger Verständnisnachweis bezeichnet werden.
