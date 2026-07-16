# Lauschenden TCP-Port mit `ss -ltn` prüfen

`ss -ltn` ist eine neue feste Befehlsform.

```text
ss        -ltn
Befehl    feste Optionsgruppe
```

## Was macht sie?

`ss` zeigt Netzwerkendpunkte an. Die feste Optionsgruppe `-ltn` schränkt die Ausgabe für diese Aufgabe ein:

- `l`: nur lauschende Endpunkte;
- `t`: TCP;
- `n`: Adressen und Ports numerisch.

Der Bindestrich gehört zur Optionsgruppe. Die drei Buchstaben stehen hier für drei konkrete Auswahl- und Darstellungsentscheidungen. Du lernst nicht allgemein, beliebige Kurzoptionen zu kombinieren. Weitere `ss`-Optionen werden nicht verwendet.

## Erster Aufruf

Nur dieser erste vollständige Aufruf ist anklickbar:

`ss -ltn`{{exec}}

## Relevante Beobachtung

Suche die Zeile mit dem lokalen Endpunkt:

```text
127.0.0.1:8000
```

Die Abstände und Spaltenbreiten können je nach System leicht anders aussehen. Relevant sind nur:

- der Zustand `LISTEN`;
- die lokale Adresse `127.0.0.1`;
- der lokale Port `8000`.

Ignoriere für diese Aufgabe:

- `Recv-Q`;
- `Send-Q`;
- die Gegenstellenangabe;
- andere vorhandene Listener.

## Beobachtungsfragen

1. In welcher Angabe steht der lokale Endpunkt?
2. Was ist die IP-Adresse?
3. Was ist die Portnummer?
4. Was bedeutet `LISTEN`?
5. Beweist diese Zeile bereits, dass der Text `Demo-Server erreichbar` ausgeliefert wird?

Die letzte Antwort lautet **nein**: Der Listener zeigt, dass ein Prozess auf TCP-Verbindungen wartet. Ob die richtige Datei als HTTP-Antwort kommt, prüfst du als Nächstes.
