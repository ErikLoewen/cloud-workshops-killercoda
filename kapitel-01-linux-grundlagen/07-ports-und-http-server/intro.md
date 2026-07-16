# Ports prüfen und einen HTTP-Server bereitstellen

## Ziel

Du untersuchst zuerst einen vorbereiteten lokalen Demo-Server. Danach stellst du selbstständig einen zweiten einfachen HTTP-Server auf Port `8080` bereit und prüfst seinen Endzustand.

Geplante Bearbeitungszeit:

- geübte Teilnehmende: 35–40 Minuten;
- absolute Anfänger: 44–50 Minuten;
- mindestens 10 Minuten bleiben für Fragen, Tippfehler und Wiederholung.

Der Workshop wird nicht künstlich auf 60 Minuten verlängert.

## Ausschließlich lokal

Beide Server sind an die Loopback-Adresse `127.0.0.1` gebunden. Die Anfragen bleiben auf diesem Linux-System. Es werden keine externen Ziele angesprochen.

Der verwendete Python-Server ist nur für dieses lokale Übungsszenario gedacht. Er ist kein produktiver Webserver.

## Das bringst du aus früheren Workshops mit

Aus Workshop 3:

- Datei, Verzeichnis und aktuelles Arbeitsverzeichnis;
- `cd`, `echo`, `cat`;
- doppelte Anführungszeichen und `>`.

Aus Workshop 5:

- Prozess und Hintergrundprozess;
- die Shell-Syntax `&`.

Aus Workshop 6:

- Loopback;
- die Adresse `127.0.0.1`.

## Zielbild

```text
Datei im aktuellen Arbeitsverzeichnis
        ↓
Python-Serverprozess
        ↓
Bind-Adresse 127.0.0.1
        +
TCP-Port
        ↓
lokaler Netzwerkendpunkt
        ↓
HTTP-Anfrage mit curl
        ↓
HTTP-Antwort mit dem Dateiinhalt
```

## Zwei Arten der Prüfung

Der technische CHECK prüft später den Endzustand: Datei, Listener, Prozesszuordnung und lokale HTTP-Antwort.

Dein Verständnis wird getrennt geprüft. Du erklärst unter anderem den Unterschied zwischen IP-Adresse und Port, die Bedeutung von `LISTEN` und den Zusammenhang zwischen Datei, Prozess, Anfrage und Antwort.
