# Route und Standardroute

## Eine Route in einfacher Form

Eine **Route** ist eine Regel dafür, über welchen Netzwerkweg ein Ziel erreicht werden soll.

Die **Standardroute** ist die allgemeine Route für Ziele, für die keine speziellere Route vorhanden ist.

In diesem Workshop wird sie nur verwendet, um die primäre Schnittstelle der aktuellen Umgebung zu bestimmen. Die Netzwerkkonfiguration wird nicht verändert.

## Die zweite Befehlsform

```text
ip        route
Befehl    Informationsbereich
```

- `ip` ist der Befehl.
- `route` ist der Informationsbereich und wählt die Anzeige vorhandener Routen.

`route` ist hier keine Option, keine Variable und kein Dateiname.

## Relevante Ausgabe

Eine schematische Zeile kann so aussehen:

```text
default via <Adresse> dev <Schnittstelle> ...
```

Für deine Aufgabe werden ausschließlich ausgewertet:

- `default`;
- `dev`;
- der Schnittstellenname direkt hinter `dev`.

Andere sichtbare Angaben werden nicht systematisch ausgewertet. Die Adresse hinter `via` ist insbesondere nicht die IPv4-Adresse, die du später als eigene primäre Adresse dokumentierst.

## Vorhersage

Reicht die erste Nicht-Loopback-Zeile aus der Adressausgabe, um die primäre Schnittstelle sicher festzulegen? Begründe kurz.

## Führe den Befehl selbst aus

Tippe `ip route` in das Terminal und führe den Befehl mit Enter aus.

## Bestimme die primäre Schnittstelle

1. Suche die Zeile mit `default`.
2. Suche in dieser Zeile das Wort `dev`.
3. Lies den Namen unmittelbar hinter `dev`.
4. Notiere diesen aktuellen Namen für den nächsten Schritt.

**Primär** bedeutet in diesem Workshop ausschließlich: die Schnittstelle hinter `dev` in der aktuellen Standardroute.

## Beobachtungsfragen

- Welche Zeile enthält `default`?
- Welcher Name steht direkt hinter `dev`?
- Warum darfst du nicht pauschal `eth0` eintragen?
