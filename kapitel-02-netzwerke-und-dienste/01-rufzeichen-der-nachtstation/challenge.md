# Abschlussaufgabe: Das Stationsprotokoll sichern

Vervollständige jetzt den tatsächlichen Zustand der Nachtstation.

## Ziel

Die Datei:

```text
/home/telegrafist/nachtstation/stationsprotokoll.txt
```

enthält passende Werte für:

- `Hostname`
- `Loopback-Schnittstelle`
- `Loopback-Adresse`
- `Weitere Netzwerkschnittstelle`
- `IPv4-Adresse dieser Schnittstelle`

## Randbedingungen

- Verwende den tatsächlichen Zustand dieser Sitzung.
- Verwende keine feste Schnittstellenannahme.
- Übernimm bei Adressen nur den Teil vor `/`.
- IPv6 und weitere sichtbare Angaben bleiben unbehandelt.
- Der CHECK bewertet weder den Editor noch die Befehlsreihenfolge.

## Selbstständiger Arbeitsauftrag

1. Untersuche die Station mit den beiden neuen Befehlen.
2. Beachte den `stationsauftrag.txt`.
3. Bearbeite das Protokoll mit einem bekannten Editor.
4. Lies die fertige Datei noch einmal.
5. Starte den CHECK.

<details>
<summary>Hilfe 1: Konzept</summary>

Du benötigst fünf Beziehungen:

- Host → Hostname
- Loopback-Schnittstelle → `127.0.0.1`
- weitere Schnittstelle → ihre IPv4-Adresse

</details>

<details>
<summary>Hilfe 2: Werkzeuge</summary>

Die beiden neuen Untersuchungsbefehle sind:

```bash
hostname
ip address
```

Für die vorbereitete Auswahlhilfe kannst du den bekannten Befehl `cat` verwenden.

</details>

<details>
<summary>Hilfe 3: Relevante Ausgabestellen</summary>

- `hostname`: die einzige Ausgabezeile
- `ip address`: Schnittstellenanfänge und Zeilen mit `inet`
- Loopback: der Abschnitt mit `127.0.0.1`
- weitere Schnittstelle: der im Stationsauftrag verlangte Abschnitt

</details>

<details>
<summary>Hilfe 4: Nahezu vollständiger Weg</summary>

```bash
hostname
cat stationsauftrag.txt
ip address
nano stationsprotokoll.txt
cat stationsprotokoll.txt
```

Vergleiche danach jedes Feld noch einmal mit der aktuellen Ausgabe.

</details>

<details>
<summary>Hilfe 5: Vollständige Musterlösung mit Erklärung</summary>

1. Führe `hostname` aus und übernimm die einzelne Ausgabezeile hinter `Hostname:`.
2. Führe `ip address` aus.
3. Suche den Abschnitt mit `inet 127.0.0.1/...`. Der Abschnittsname gehört hinter `Loopback-Schnittstelle:`; `127.0.0.1` gehört hinter `Loopback-Adresse:`.
4. Lies `stationsauftrag.txt`. Suche die dort verlangte weitere Schnittstelle in `ip address`.
5. Übernimm aus ihrer `inet`-Zeile nur den IPv4-Teil vor `/`.
6. Speichere die Datei und kontrolliere sie mit `cat stationsprotokoll.txt`.

Die Werte selbst sind absichtlich nicht vorgegeben, weil sie aus dem aktuellen Laufzeitzustand stammen.

</details>
