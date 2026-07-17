# Primäre Schnittstelle und IPv4-Adresse zuordnen

Du hast den Namen der primären Schnittstelle aus der Standardroute ermittelt.

Jetzt ordnest du diesem Namen eine aktuelle IPv4-Adresse zu.

## Methode

1. Führe `ip -brief addr` erneut selbst aus oder betrachte die vorhandene Ausgabe erneut.
2. Suche die Zeile derselben Schnittstelle, deren Name in `ip route` direkt hinter `dev` stand.
3. Suche in genau dieser Zeile eine Adresse mit vier durch Punkte getrennten Zahlengruppen.
4. Übernimm die Adresse einschließlich der Präfixlänge hinter `/`.
5. Übernimm keine Adresse aus einer anderen Schnittstellenzeile.

Die Loopback-Adresse gehört zur Loopback-Schnittstelle. Die Adresse hinter `via` aus der Routenausgabe ist ebenfalls nicht die gesuchte eigene IPv4-Adresse.

## Mögliche mehrere IPv4-Adressen

Falls die primäre Schnittstelle mehrere aktuelle Nicht-Loopback-IPv4-Adressen besitzt, ist jede davon fachlich gültig, sofern du:

- die Adresse aus genau dieser Schnittstellenzeile übernimmst;
- die zugehörige Präfixlänge erhältst.

## Zuordnungsprüfung

Vervollständige in Gedanken:

```text
default ... dev <PRIMAERE_INTERFACE>
                    │
                    └── denselben Namen in ip -brief addr suchen
                         und dort PRIMAERE_IPV4 ablesen
```

## Erklärungsfragen

1. Warum ist die Adresse hinter `via` nicht automatisch die eigene primäre IPv4-Adresse?
2. Warum darf eine IPv4-Adresse aus einer anderen Schnittstellenzeile nicht übernommen werden?
3. Warum können Name und Adresse in einer anderen Lernumgebung anders aussehen?
