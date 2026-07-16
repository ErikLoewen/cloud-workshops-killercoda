# Eine lokale HTTP-Anfrage senden

## `localhost` und Loopback

`localhost` ist in dieser Übung ein Name für den lokalen Rechner. Du verbindest ihn mit dem bekannten Loopback-Konzept und mit `127.0.0.1`.

Die Anfrage verlässt dieses System nicht.

DNS, Nameserver und Konfigurationsdateien zur Namensauflösung sind nicht Teil dieses Workshops.

## Die konkrete Demo-URL

```text
http://      localhost      :8000      /
Protokoll    lokaler Name    Port       angeforderter Pfad
```

- `http://` bezeichnet das verwendete Anwendungsprotokoll;
- `localhost` bezeichnet den lokalen Rechner;
- `:8000` bezeichnet den Port;
- `/` ist der angeforderte Ausgangspfad.

Die vollständige URL ist das Argument von `curl`.

## `curl URL`

```text
curl                         http://localhost:8000/
Befehl                       Argument
```

`curl` sendet eine lokale HTTP-Anfrage. Der sichtbare Antwortinhalt stammt vom Server.

`curl` liest die Datei nicht unmittelbar. Der Server liest die Datei aus seinem Arbeitsverzeichnis und sendet ihren Inhalt als HTTP-Antwort.

## Demo-Anfrage

Tippe selbst:

```bash
curl http://localhost:8000/
```

Erwarteter Nutztext:

```text
Demo-Server erreichbar
```

Verwende keine zusätzliche `curl`-Option.

## Datei und Antwort vergleichen

Tippe danach erneut selbst:

```bash
cat index.html
```

Vergleiche beide Ausgaben.

- `cat` liest die Datei unmittelbar.
- `curl` sendet eine HTTP-Anfrage.
- Der Server liest `index.html`.
- Der Server sendet den Inhalt als HTTP-Antwort.

## Selbst-Erklärung

Erkläre die Wirkungskette mit eigenen Worten:

```text
/root/httplabor/demo/index.html
        ↓
Python-Serverprozess
        ↓
TCP + 127.0.0.1 + 8000
        ↓
curl http://localhost:8000/
        ↓
Demo-Server erreichbar
```

Warum reicht die `LISTEN`-Zeile allein nicht aus, um den korrekten Antwortinhalt zu beweisen?
