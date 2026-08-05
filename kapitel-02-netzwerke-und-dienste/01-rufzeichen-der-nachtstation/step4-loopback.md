# Der Weg zurück zur eigenen Station: Loopback

Die Adresse `127.0.0.1` bezeichnet in dieser Umgebung die eigene Station. Verbindungen zu dieser Adresse verlassen den Host nicht.

Die Schnittstelle, auf der diese Adresse liegt, heißt **Loopback-Schnittstelle**. **Loopback** bedeutet: Der Host spricht mit sich selbst.

## Loopback gemeinsam bestimmen

Führe den bekannten Befehl diesmal selbst im Terminal aus:

```bash
ip address
```

Suche die Zeile mit:

```text
inet 127.0.0.1/...
```

Gehe von dieser Zeile nach oben zum Beginn desselben Schnittstellenabschnitts. Dort steht der Name der Loopback-Schnittstelle.

## Protokoll ergänzen

Öffne `stationsprotokoll.txt` und trage ein:

- `Loopback-Schnittstelle`
- `Loopback-Adresse`

Bei der Adresse übernimmst du nur:

```text
127.0.0.1
```

<details>
<summary>Hilfe 1: Konzept</summary>

Die Loopback-Schnittstelle ist der Abschnitt, in dem die IPv4-Adresse `127.0.0.1` steht.

</details>

<details>
<summary>Hilfe 2: Werkzeug</summary>

Der passende bekannte Befehl ist:

```bash
ip address
```

</details>

<details>
<summary>Hilfe 3: Relevante Ausgabestelle</summary>

Suche zuerst nach einer Zeile, die mit `inet 127.0.0.1/` beginnt. Der Schnittstellenname steht am Anfang des Abschnitts darüber.

</details>

<details>
<summary>Hilfe 4: Nahezu vollständiger Weg</summary>

1. Führe `ip address` aus.
2. Suche `127.0.0.1`.
3. Lies im selben Abschnitt den Schnittstellennamen.
4. Öffne `nano stationsprotokoll.txt`.
5. Trage Schnittstelle und Adresse ohne den Teil hinter `/` ein.

</details>

## Selbst-Erklärung

Warum kann ein Host zusätzlich zur Loopback-Adresse noch eine weitere IPv4-Adresse besitzen?
