# Workshop abgeschlossen

Der technische CHECK hat bestätigt, dass die Bestandsdatei zum aktuellen lokalen Netzwerkzustand passt.

## Rufe das Vorgehen ab

Beantworte ohne unmittelbare Lösungshilfe:

1. Was ist eine Netzwerkschnittstelle?
2. Worin unterscheiden sich Loopback und primäre Schnittstelle?
3. Woran erkennst du eine IPv4-Adresse?
4. Welche Bedeutung hat die Zahl hinter `/` in diesem Workshop?
5. Welches Wort kennzeichnet die Standardroute?
6. Wo steht der gesuchte Name der primären Schnittstelle?
7. Wie ordnest du diesem Namen eine IPv4-Adresse zu?
8. Warum können Name und primäre IPv4-Adresse in einer anderen Umgebung anders aussehen?

## Ordne die Befehlsbestandteile ein

```text
ip        -brief       addr
Befehl    Option       Informationsbereich

ip        route
Befehl    Informationsbereich
```

- `-brief` fordert eine kompaktere Darstellung an.
- `addr` wählt Adressinformationen.
- `route` wählt vorhandene Routen.
- Beide Befehlsformen lesen Informationen und verändern keine Netzwerkkonfiguration.

## Doppelte Anführungszeichen

Erkläre:

- Warum standen die doppelten Anführungszeichen in deiner Eingabe?
- Warum erscheinen sie nicht in der Datei?

Erwartung: Sie begrenzen für die Shell das zusammengehörige Textargument mit Leerzeichen. Die Anführungszeichen selbst gehören nicht zum ausgegebenen Text.

## Grenzen des technischen CHECKs

Der CHECK hat nicht technisch bewiesen:

- welche Diagnosebefehle du verwendet hast;
- ob du `default` und `dev` selbstständig gefunden hast;
- ob du Loopback und Präfixlänge erklären kannst;
- ob du sichtbare Adressen mit Doppelpunkten bewusst ausgeschlossen hast;
- ob du die Wirkung der doppelten Anführungszeichen verstanden hast.

Diese Aspekte werden durch deine Antworten und Beobachtungen geprüft.

## Übergang

Im nächsten Workshop wird das Loopback-Konzept wieder aufgegriffen. Dort kommen Ports und ein lokaler HTTP-Dienst hinzu. Diese Inhalte waren bewusst noch nicht Teil dieses Workshops.
