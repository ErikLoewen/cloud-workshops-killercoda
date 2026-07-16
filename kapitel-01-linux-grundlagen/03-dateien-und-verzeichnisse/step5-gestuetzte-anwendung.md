# Schritt 5: Bekannte Handlungen verbinden

Du arbeitest weiterhin im Verzeichnis `/root/dateilabor/uebung`.

## Aufgabe

Erzeuge im bereits vorhandenen Verzeichnis `sammlung` eine Datei `merkzettel.txt` mit dem Inhalt `ok`.

Diesmal ist die Hilfe kürzer. Ergänze gedanklich den fehlenden Dateinamen:

```text
echo ok > sammlung/________
```

Tippe anschließend den vollständigen Befehl selbst ein.

## Inhalt prüfen

Zeige danach genau diese eine Datei mit `cat` an.

**Erwartete Ausgabe:**

```text
ok
```

## Relativen und vollständigen Pfad verbinden

Der verwendete relative Pfad lautet:

```text
sammlung/merkzettel.txt
```

Welcher vollständige Pfad ergibt sich aus deinem aktuellen Standort?

<details>
<summary>Antwort prüfen</summary>

```text
/root/dateilabor/uebung/sammlung/merkzettel.txt
```

</details>

## Beobachtung

Der gleiche relative Pfad würde von einem anderen aktuellen Arbeitsverzeichnis aus auf einen anderen Ort verweisen oder dort nicht existieren. Prüfe deshalb vor unsicheren relativen Dateioperationen deinen Standort mit `pwd`.
