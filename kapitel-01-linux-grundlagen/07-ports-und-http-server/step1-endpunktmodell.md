# Datei, Serverprozess und Netzwerkendpunkt verbinden

Eine Datei ist zunächst nur im Dateisystem vorhanden. Damit ihr Inhalt über HTTP angefragt werden kann, benötigt sie in diesem Workshop einen laufenden Serverprozess und einen lokalen Netzwerkendpunkt.

## Sechs neue Konzeptcluster

### 1. Port

Ein **Port** ist eine logische Nummer eines Netzwerkendpunkts. In diesem Workshop verwenden wir `8000` für die vorbereitete Demonstration und `8080` für deine Abschlussaufgabe.

Ein Port ist:

- keine PID;
- keine physische Buchse;
- kein Bestandteil der IP-Adresse.

### 2. TCP

Der Server verwendet in diesem Workshop **TCP**. TCP und HTTP sind nicht dasselbe:

- TCP gehört zum Netzwerkendpunkt und zur Verbindung;
- HTTP beschreibt hier die Anfrage und die Antwort, die darüber ausgetauscht werden.

Eine allgemeine TCP- oder Protokolllehre ist nicht Teil dieses Workshops.

### 3. Lauschen

Ein Prozess **lauscht**, wenn er an einem TCP-Endpunkt auf Verbindungen wartet. In der späteren Ausgabe erkennst du diesen Zustand am Wort `LISTEN`.

Eine `LISTEN`-Zeile beweist noch nicht, dass der richtige Dateiinhalt ausgeliefert wird. Deshalb folgt später eine echte lokale HTTP-Anfrage.

### 4. Bind-Adresse

Die **Bind-Adresse** legt fest, an welcher lokalen IP-Adresse der Server seinen Netzwerkendpunkt bereitstellt. Hier ist das ausschließlich `127.0.0.1`.

### 5. HTTP-Anfrage

Eine **HTTP-Anfrage** wird später mit `curl` an den lokalen Server gesendet.

### 6. HTTP-Antwort

Die **HTTP-Antwort** kommt vom Server zurück. Als sichtbaren Nutztext erwarten wir den Inhalt der ausgelieferten Datei.

## Adresse und Port unterscheiden

```text
127.0.0.1:8000
───────── ────
Adresse   Port
```

Der Doppelpunkt trennt hier Adresse und Port. Er ist an dieser Stelle kein Shelloperator.

Ein erreichbarer Endpunkt wird in diesem Workshop mindestens mit diesen drei Angaben beschrieben:

```text
TCP + 127.0.0.1 + 8000
```

- `TCP`: verwendetes Netzwerkprotokoll;
- `127.0.0.1`: lokale Adresse;
- `8000`: TCP-Port.

## Vorhersage

Bevor ein Server gestartet wurde: Würdest du auf dem vorgesehenen Port bereits eine Zeile mit `LISTEN` erwarten? Begründe deine Vermutung.

In der Demonstration läuft der Server schon durch die technische Vorbereitung. Du vergleichst deine Vorhersage deshalb mit dem vorbereiteten Zustand.
