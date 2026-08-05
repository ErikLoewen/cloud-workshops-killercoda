# Musterlösung: 02.01 – Das Rufzeichen der Nachtstation

Diese Datei ist nicht in `index.json` referenziert. Die Werte werden nicht fest vorgegeben, weil Hostzustand, Schnittstellenname und IPv4-Adresse zur Laufzeit bestimmt werden.

## Lösungsweg

```bash
hostname
cat stationsauftrag.txt
ip address
nano stationsprotokoll.txt
cat stationsprotokoll.txt
```

## Zuordnung der Felder

| Feld | Quelle |
|---|---|
| `Hostname` | einzelne Ausgabezeile von `hostname` |
| `Loopback-Schnittstelle` | Schnittstellenabschnitt, der `inet 127.0.0.1/...` enthält |
| `Loopback-Adresse` | `127.0.0.1`, ohne den Teil hinter `/` |
| `Weitere Netzwerkschnittstelle` | vom Stationsauftrag verlangte Nicht-Loopback-Schnittstelle |
| `IPv4-Adresse dieser Schnittstelle` | passende `inet`-Zeile im ausgewählten Abschnitt, ohne den Teil hinter `/` |

Wenn `ip address` den Schnittstellennamen mit einem Zusatz nach `@` zeigt, wird für das Protokoll der Teil vor `@` verwendet.

## Dynamische Auswahlregel

Setup und Verify verwenden dieselbe Regel:

1. Aus allen Nicht-Loopback-Schnittstellen mit mindestens einer IPv4-Adresse werden geeignete Kandidaten gebildet.
2. Existiert eine IPv4-Standardroute über einen geeigneten Kandidaten, wird die Route mit der kleinsten numerischen Metrik gewählt; bei Gleichstand entscheidet der Schnittstellenname alphabetisch.
3. Existiert keine passende Standardroute, wird die alphabetisch erste geeignete Schnittstelle gewählt.
4. Besitzt die ausgewählte Schnittstelle mehrere IPv4-Adressen, wird eine globale Adresse bevorzugt. Danach folgen andere Bereiche in stabiler Reihenfolge; innerhalb derselben Stufe entscheidet der numerische Adresswert.
5. Die Standardroute ist nur interne Auswahltechnik. Sie wird im Teilnehmertext nicht als Lerngegenstand behandelt.

Bei mehreren Kandidaten nennt `stationsauftrag.txt` die ausgewählte Schnittstelle, damit keine unbehandelte Routingentscheidung verlangt wird.
