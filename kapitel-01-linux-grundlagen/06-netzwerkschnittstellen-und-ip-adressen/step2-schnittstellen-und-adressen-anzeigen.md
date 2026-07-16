# Schnittstellen und Adressen anzeigen

## Die `ip`-Befehlsfamilie

`ip` ist das gemeinsame Verwaltungs- und Diagnosewerkzeug für Netzwerkinformationen.

In diesem Workshop liest du damit ausschließlich vorhandene Informationen. Du veränderst keine Schnittstelle, keine Adresse und keine Route.

Die erste Befehlsform lautet:

```text
ip        -brief       addr
Befehl    Option       Informationsbereich
```

### Die drei Bestandteile

- `ip` ist der **Befehl** und startet das Netzwerkwerkzeug.
- `-brief` ist eine konkrete **Option**. Sie fordert eine kompaktere Darstellung an. Der Bindestrich gehört zur Option.
- `addr` ist der **Informationsbereich**. Er wählt die Anzeige von Adressinformationen.

`addr` ist keine Option, kein Dateiname und kein frei einzusetzender Wert.

## Warum die kompakte Darstellung?

Die Ausgabe soll übersichtlich bleiben. Für diese Aufgabe brauchst du nur:

1. den Schnittstellennamen;
2. den sichtbaren Zustand zur Orientierung;
3. eine IPv4-Adresse einschließlich Präfixlänge.

Eine schematische Ausgabe kann so aussehen:

```text
lo        UNKNOWN        127.0.0.1/8 ...
eth0      UP             192.0.2.10/24 ...
```

Die zweite Zeile ist ausdrücklich fiktiv. `eth0` ist nur ein möglicher Name und `192.0.2.10/24` nur eine Beispieladresse.

## Erster Aufruf

Nur dieser erste vollständige Aufruf ist anklickbar:

`ip -brief addr`{{exec}}

## Beobachte die Ausgabe

- Der erste Bereich jeder Zeile enthält den Schnittstellennamen.
- Ein Wort wie `UP` oder `UNKNOWN` ist ein Zustand und keine Adresse.
- Eine IPv4-Adresse erkennst du an vier durch Punkte getrennten Zahlengruppen.
- Die Zahl hinter `/` gehört zur Adressangabe.
- Eine Adressform mit Doppelpunkten gehört nicht zur aktuellen Aufgabe.

Die primäre Schnittstelle lässt sich aus dieser Ausgabe allein noch nicht sicher bestimmen.

## Beobachtungsfrage

Zeige in einer Zeile deiner Ausgabe nacheinander:

1. den Schnittstellennamen;
2. den sichtbaren Zustand;
3. eine IPv4-Adresse einschließlich Präfixlänge.
