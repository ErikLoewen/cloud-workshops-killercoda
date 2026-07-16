# Abschlussaufgabe: Eine Projektstruktur herstellen

## Ausgangslage

Wechsle zuerst in den gemeinsamen Ausgangsbereich:

```bash
cd /root/dateilabor
```

Prüfe bei Bedarf deinen Standort mit `pwd`.

Vorbereitet ist die Datei:

```text
/root/dateilabor/eingang/entwurf.txt
```

Sie enthält exakt:

```text
vorlage
```

Das Hauptverzeichnis `projekt` ist noch nicht vorhanden.

## Auftrag

Stelle selbstständig diesen Zustand her:

```text
/root/dateilabor/
├── eingang/
│   └── entwurf.txt ist nicht mehr vorhanden
└── projekt/
    ├── hinweis.txt
    └── texte/
        └── status.txt
```

Dabei gelten diese Erfolgskriterien:

1. `projekt` ist ein Verzeichnis.
2. `projekt/texte` ist ein Verzeichnis.
3. `projekt/texte/status.txt` ist eine reguläre Datei.
4. `status.txt` enthält exakt eine Zeile `bereit`.
5. Die vorbereitete Datei `eingang/entwurf.txt` liegt danach unter `projekt/hinweis.txt`.
6. Der Inhalt von `hinweis.txt` bleibt exakt `vorlage`.
7. Der alte Quellpfad `eingang/entwurf.txt` existiert danach nicht mehr.

Du darfst relative oder absolute Pfade verwenden. Die genaue Befehlsreihenfolge ist nicht vorgegeben. Kontrolliere Struktur und Inhalte bei Bedarf mit den bekannten Befehlen.

Versuche die Aufgabe zuerst ohne die vollständige Lösung.

<details>
<summary>Hinweis 1 – konzeptionelle Reihenfolge</summary>

Erstelle zuerst das Hauptverzeichnis und danach das Unterverzeichnis.

Erzeuge anschließend den vorgegebenen Text und leite ihn an den Zielpfad um.

Zum Schluss übernimmst du die vorbereitete Datei mit einem Quellpfad und einem neuen Zielpfad.

</details>

<details>
<summary>Hinweis 2 – passende Werkzeuge</summary>

- Verzeichnisse: `mkdir`
- Textausgabe und Datei: `echo` mit `>`
- vorbereitete Datei verschieben und umbenennen: `mv`
- Kontrolle: `pwd`, `ls` und `cat`

</details>

<details>
<summary>Hinweis 3 – nahezu vollständige Befehlsstruktur</summary>

```text
cd /root/dateilabor
mkdir projekt
mkdir projekt/texte
echo bereit > projekt/texte/________
mv eingang/entwurf.txt projekt/________
```

Die beiden fehlenden Dateinamen stehen im Zielbaum.

</details>

<details>
<summary>Hinweis 4 – vollständige Musterlösung mit Erklärung</summary>

```bash
cd /root/dateilabor
mkdir projekt
mkdir projekt/texte
echo bereit > projekt/texte/status.txt
mv eingang/entwurf.txt projekt/hinweis.txt
cat projekt/texte/status.txt
cat projekt/hinweis.txt
ls eingang
ls projekt
```

Die ersten beiden verändernden Befehle erstellen Haupt- und Unterverzeichnis.

`echo` erzeugt den Text `bereit`. Die Shell leitet diese Ausgabe mit `>` in `projekt/texte/status.txt` um.

Bei `mv` ist `eingang/entwurf.txt` die Quelle und `projekt/hinweis.txt` das Ziel. Die Datei wird verschoben und gleichzeitig umbenannt. Sie wird nicht kopiert.

Die letzten vier Befehle kontrollieren nur Inhalte und Struktur.

</details>

## Technischen Endzustand prüfen

Starte jetzt den Killercoda-CHECK.

Der CHECK prüft ausschließlich den Dateisystem-Endzustand. Er erkennt weder deine konkrete Befehlsfolge noch dein Verständnis. Bei einem Fehler nennt er den mangelhaften Teilzustand, damit du gezielt nachbessern und erneut prüfen kannst.
