# Abschlussaufgabe: Nur das benötigte Recht setzen

Nun überträgst du das bekannte Vorgehen selbstständig.

## Ausgangsbereich

```text
/root/rechtelabor/auftrag/
├── arbeitsbereich/
│   └── pruefdatei
└── schutzbereich/
    └── wichtig.txt
```

Die Datei `pruefdatei` ist technisch vorbereitet. Du schreibst oder veränderst ihren Inhalt nicht. Bei erfolgreicher Ausführung zeigt sie:

```text
Prüfdatei erfolgreich ausgeführt
```

Zusätzlich erzeugt sie einen internen technischen Nachweis.

Die Datei `wichtig.txt` und ihre Rechte müssen unverändert bleiben.

## Dein Auftrag

1. Wechsle in den Auftragsbereich.
2. Identifiziere Arbeitsbereich und Schutzbereich.
3. Untersuche die Rechte der Auftragsdatei.
4. Stelle fest, in welchem Bereich das `x` fehlt.
5. Ergänze ausschließlich bei der Auftragsdatei das Ausführungsrecht des Besitzers.
6. Kontrolliere die neue Rechteanzeige.
7. Führe die Auftragsdatei über ihren relativen Pfad aus.
8. Beobachte die erwartete Ausgabe.
9. Kontrolliere den Schutzbereich.
10. Starte anschließend den technischen CHECK.

## Erfolgskriterien

Am Ende gilt:

- `pruefdatei` zeigt `rwx` für den Besitzer;
- Gruppe zeigt nur `r--`;
- andere zeigen nur `r--`;
- der Dateiinhalt ist unverändert;
- Besitzer und Gruppe sind unverändert;
- die vorbereitete Datei wurde erfolgreich ausgeführt;
- der Schutzbereich enthält weiterhin nur `wichtig.txt`;
- Inhalt und Rechte der Schutzdatei sind unverändert.

Vor deinem ersten eigenen Versuch ist keine vollständige Befehlsfolge sichtbar.

<details>
<summary>Hinweis 1 – Konzept</summary>

- Prüfe zuerst die Rechteanzeige.
- Im Besitzerbereich fehlt das Ausführungsrecht.
- Ergänze nur dieses eine Recht.
- Führe die Datei danach aus dem aktuellen Verzeichnis aus.
- Der Schutzbereich bleibt unverändert.

</details>

<details>
<summary>Hinweis 2 – Werkzeuge</summary>

Du kannst ausschließlich diese bereits bekannten oder eingeführten Werkzeuge verwenden:

- `cd`
- `pwd`
- `ls`
- `ls -l`
- `chmod u+x`
- `./dateiname`
- `cat`

`cat` wird nur zur Kontrolle der Schutzdatei verwendet.

</details>

<details>
<summary>Hinweis 3 – Struktur</summary>

```text
cd <ARBEITSVERZEICHNIS>

ls -l

chmod u+x <DATEI>

ls -l

./<DATEI>
```

Die Platzhalter werden nicht wörtlich eingegeben. Nur die Auftragsdatei wird verändert. Die Schutzdatei gehört in keinen `chmod`-Befehl.

</details>

<details>
<summary>Hinweis 4 – vollständige Methode</summary>

Nutze diese vollständige Methode erst nach einem eigenen Lösungsversuch:

```bash
cd /root/rechtelabor/auftrag
```

```bash
pwd
```

```bash
ls
```

```bash
cd arbeitsbereich
```

```bash
ls -l
```

```bash
chmod u+x pruefdatei
```

```bash
ls -l
```

```bash
./pruefdatei
```

```bash
cd ../schutzbereich
```

```bash
ls -l
```

```bash
cat wichtig.txt
```

`chmod u+x` ergänzt ausschließlich das Besitzer-Ausführungsrecht. `./pruefdatei` versucht danach, die Datei aus dem aktuellen Verzeichnis auszuführen. Die abschließenden Anzeigen kontrollieren den Arbeits- und Schutzbereich.

</details>

## Technischer CHECK

Der CHECK prüft den Endzustand. Er verändert keine Rechte, führt die Auftragsdatei nicht aus und repariert keine Dateien.

Ein erfolgreicher CHECK beweist nicht, welchen genauen Befehl du verwendet hast oder ob du alle Begriffe erklären kannst. Diese Lernziele werden zusätzlich durch die Reflexionsfragen geprüft.
