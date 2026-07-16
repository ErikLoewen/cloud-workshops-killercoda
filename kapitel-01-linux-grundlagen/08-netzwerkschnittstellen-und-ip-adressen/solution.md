# Musterlösung – interne Datei

## Vollständige Methode

1. `ip -brief addr` ausführen.
2. Die Loopback-Schnittstelle und `127.0.0.1/8` ermitteln.
3. `ip route` ausführen.
4. In der eindeutig verwendbaren `default`-Zeile den Namen unmittelbar hinter `dev` ermitteln.
5. Genau diesen Namen in `ip -brief addr` wiederfinden.
6. In derselben Zeile eine aktuelle Nicht-Loopback-IPv4-Adresse einschließlich Präfixlänge ermitteln.
7. Alle vier aktuellen Werte in die Statuszeile einsetzen.
8. Die Datei mit `cat` kontrollieren.
9. Den CHECK ausführen.

## Schematische Ausgaben

```text
ip -brief addr

lo        UNKNOWN        127.0.0.1/8 ...
<NAME>    UP             <IPV4/PRAEFIX> ...
```

```text
ip route

default via <ADRESSE> dev <NAME> ...
```

Nur `default`, `dev` und der Name direkt hinter `dev` werden für die Bestimmung der primären Schnittstelle benötigt.

## Dynamische Teilnehmerform

```bash
echo "LOOPBACK_INTERFACE=<AKTUELLER_WERT> LOOPBACK_IPV4=<AKTUELLER_WERT> PRIMAERE_INTERFACE=<AKTUELLER_WERT> PRIMAERE_IPV4=<AKTUELLER_WERT>" > /root/netzwerklabor/netzwerkstatus.txt
```

Alle Platzhalter werden durch Werte der aktuellen Umgebung ersetzt.

Die doppelten Anführungszeichen begrenzen das zusammengehörige Textargument für `echo`. Sie gehören zur Eingabe, erscheinen aber nicht im Dateiinhalt.

## Mehrere IPv4-Adressen

Besitzt die primäre Schnittstelle mehrere aktuelle Nicht-Loopback-IPv4-Adressen, akzeptiert der CHECK jede dieser Adressen einschließlich ihrer Präfixlänge.

## Möglicher technischer Zusatz nach `@`

Die Standardroute liefert den verbindlichen Wert für `PRIMAERE_INTERFACE`.

Eine Adressausgabe kann intern einen Namen in der Form `<ROUTE_NAME>@<TECHNISCHER_ZUSATZ>` zeigen. Der CHECK darf diese Zeile der Route-Schnittstelle zuordnen. In der Bestandsdatei bleibt ausschließlich der Name aus der Standardroute hinter `dev`.

Dieser Sonderfall gehört nur dann in den Teilnehmertext, wenn ein realer Killercoda-Pilot seine Sichtbarkeit und Relevanz bestätigt.

## Grenzen des CHECKs

Der technische CHECK bestätigt nur:

- Struktur und Inhalt der Bestandsdatei;
- Übereinstimmung mit dem aktuellen lokalen Netzwerkzustand.

Er weist nicht nach, welche Befehle verwendet wurden oder ob Loopback, Präfixlänge, `default`, `dev` und doppelte Anführungszeichen verstanden wurden.
