# Den Python-Serverbefehl vorbereiten

Den Abschlussserver startest du später selbst. Vorher zerlegst du die Befehlsform vollständig.

## Bestandteile

| Bestandteil | Rolle |
|---|---|
| `python3` | Befehl |
| `-m` | konkrete Python-Option |
| `http.server` | Modulname |
| `--bind` | konkrete lange Option |
| `127.0.0.1` | Argument zu `--bind`, die Bind-Adresse |
| `8080` | Portargument |
| `&` | bekannte Shell-Syntax |

### `python3`

`python3` startet den Python-Interpreter. Python-Programmierung ist kein Lernziel dieses Workshops.

### `-m`

`-m` ist eine konkrete Option von Python. Sie führt das danach angegebene vorhandene Modul aus. Eine allgemeine Python-Optionslehre ist nicht vorgesehen.

### `http.server`

`http.server` ist der Modulname. Der Punkt gehört zum Modulnamen. Du schreibst keinen eigenen Python-Code.

Der Server ist nur für dieses lokale Übungsszenario geeignet und kein produktiver Webserver.

### `--bind`

`--bind` ist eine konkrete lange Option. Sie legt die Bind-Adresse fest. Eine allgemeine Lehre zu Langoptionen ist nicht Teil des Workshops.

### `127.0.0.1`

`127.0.0.1` ist das Argument zu `--bind`. Es ist die bekannte Loopback-Adresse. Der Server soll ausschließlich lokal erreichbar sein.

### `8080`

`8080` ist das Portargument. Es ist:

- keine PID;
- kein Bestandteil der IP-Adresse;
- der feste Abschlussport.

### `&`

`&` ist bekannte Shell-Syntax aus Workshop 7. Sie startet den Prozess im Hintergrund. Der Prompt kehrt zurück, obwohl der Server weiterläuft. Job-Control wird nicht erneut eingeführt.

## Schematische Befehlsform

Die folgende Zeile erklärt nur die Struktur:

```text
python3 -m http.server --bind 127.0.0.1 <PORT> &
```

`<PORT>` ist ein Platzhalter. Die spitzen Klammern werden nicht eingegeben. In der Abschlussaufgabe setzt du den vorgegebenen Zielport ein.

Diese schematische Zeile ist kein auszuführender Befehl.

## Arbeitsverzeichnis

Ohne eine zusätzliche Verzeichnisoption bedient der Server Dateien aus seinem aktuellen Arbeitsverzeichnis.

Darum gilt:

```text
zuerst in /root/httplabor/abschluss wechseln
        ↓
dort index.html erstellen
        ↓
dort den Serverprozess starten
```

Die Dateiendung `.html` ist in dieser Übung nur Bestandteil des Dateinamens. Es erfolgt keine HTML-Einführung.

## Dateiinhalt vorbereiten

Der verbindliche Abschlussinhalt lautet:

```text
HTTP-Server auf Port 8080 bereit
```

Für die Datei verwendest du später erneut:

- `echo`;
- doppelte Anführungszeichen;
- `>`;
- `cat`.

## Asynchrone Servermeldungen

Der selbst gestartete Hintergrundprozess läuft weiter und kann später eigene Meldungen im Terminal ausgeben.

Beachte:

- Eine Servermeldung ist kein neuer Teilnehmerbefehl.
- Servermeldung, Prompt und `curl`-Antwort können optisch nahe beieinander erscheinen.
- Den relevanten Seiteninhalt erkennst du am exakten Text:
  `HTTP-Server auf Port 8080 bereit`.

Es wird keine zusätzliche Ausgabeumleitung eingeführt.

## Transferfrage

Beim Demo-Server war der Port `8000`. Welche zwei Stellen müssen für den Abschlussport `8080` zusammenpassen?

Den vollständigen Abschlussbefehl setzt du erst in der Challenge selbst zusammen.
