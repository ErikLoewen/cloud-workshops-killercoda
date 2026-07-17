# Abschlussauftrag: Bericht sichern und Arbeitsbereich bereinigen

## Ausgangslage

```text
/root/dateilabor/auftrag/
├── quelle/
│   └── bericht.txt
├── arbeitsbereich/
│   ├── alt.txt
│   ├── leeres-archiv/
│   └── temp-projekt/
│       ├── notiz.txt
│       └── unterordner/
│           └── rest.txt
└── schutzbereich/
    └── wichtig.txt
```

## Ziel

```text
/root/dateilabor/auftrag/
├── quelle/
│   └── bericht.txt
├── arbeitsbereich/
│   └── bericht-kopie.txt
└── schutzbereich/
    └── wichtig.txt
```

Die Quelle darf gelesen und kopiert, aber nicht verändert oder entfernt werden. Der Schutzbereich muss vollständig unverändert bleiben.

## Dein Auftrag

Bearbeite die Aufgabe zunächst ohne vollständige Befehlsfolge:

1. Untersuche `/root/dateilabor/auftrag`.
2. Identifiziere Arbeitsbereich und Schutzbereich.
3. Kontrolliere die Quelle `quelle/bericht.txt`.
4. Kopiere sie nach `arbeitsbereich/bericht-kopie.txt`.
5. Kontrolliere Quelle, Kopie und beide Inhalte.
6. Entferne ausschließlich die einzelne Datei `arbeitsbereich/alt.txt`.
7. Entferne ausschließlich das leere Verzeichnis `arbeitsbereich/leeres-archiv`.
8. Entferne rekursiv ausschließlich `arbeitsbereich/temp-projekt`.
9. Wende vor jeder destruktiven Handlung die Sicherheitsroutine an.
10. Kontrolliere den Schutzbereich.
11. Starte anschließend den CHECK.

Vor dem rekursiven Schritt muss ausdrücklich feststehen:

```text
Freigegebenes Ziel:
/root/dateilabor/auftrag/arbeitsbereich/temp-projekt
```

Der CHECK prüft den Endzustand. Er kann nicht beweisen, dass du die Sicherheitsroutine bewusst eingehalten oder bestimmte Befehle verwendet hast.

<details>
<summary>Hinweis 1 – Konzept</summary>

- Kopieren erhält die Quelle.
- Einzeldatei, leeres Verzeichnis und nicht leeres Verzeichnis benötigen unterschiedliche Handlungen.
- Der Schutzbereich darf nicht verändert werden.
- Vor jedem Löschen wird der Zielpfad geprüft.

</details>

<details>
<summary>Hinweis 2 – Werkzeuge</summary>

Du benötigst ausschließlich:

- `cp`
- `rm`
- `rmdir`
- `rm -r`
- `pwd`
- `ls`
- `cat`

</details>

<details>
<summary>Hinweis 3 – Struktur</summary>

```text
cp <QUELLE> <ZIELKOPIE>

rm <EINZELDATEI>

rmdir <LEERES_VERZEICHNIS>

rm -r <FREIGEGEBENES_NICHT_LEERES_VERZEICHNIS>
```

Die Platzhalter werden nicht wörtlich eingegeben. Der Schutzbereich gehört in keinen Löschbefehl. Bestätige vor jedem Löschbefehl den konkreten Pfad.

</details>

<details>
<summary>Hinweis 4 – vollständige Methode</summary>

Gib jeden Befehl einzeln ein:

```bash
cd /root/dateilabor/auftrag
pwd
ls
ls quelle
ls arbeitsbereich
ls schutzbereich
cat schutzbereich/wichtig.txt
```

```bash
cp quelle/bericht.txt arbeitsbereich/bericht-kopie.txt
ls quelle
ls arbeitsbereich
cat quelle/bericht.txt
cat arbeitsbereich/bericht-kopie.txt
```

```bash
pwd
ls arbeitsbereich/alt.txt
rm arbeitsbereich/alt.txt
ls arbeitsbereich
```

```bash
pwd
ls arbeitsbereich/leeres-archiv
rmdir arbeitsbereich/leeres-archiv
ls arbeitsbereich
```

Prüfe vor dem rekursiven Schritt noch einmal Zielbaum und Schutzbereich:

```bash
pwd
ls arbeitsbereich/temp-projekt
ls arbeitsbereich/temp-projekt/unterordner
cat arbeitsbereich/temp-projekt/notiz.txt
cat arbeitsbereich/temp-projekt/unterordner/rest.txt
ls schutzbereich
cat schutzbereich/wichtig.txt
```

Der vollständig freigegebene Zielpfad lautet:

```text
/root/dateilabor/auftrag/arbeitsbereich/temp-projekt
```

Gib anschließend selbst ein:

```bash
rm -r arbeitsbereich/temp-projekt
```

Kontrolliere den Endzustand:

```bash
ls quelle
ls arbeitsbereich
ls schutzbereich
cat quelle/bericht.txt
cat arbeitsbereich/bericht-kopie.txt
cat schutzbereich/wichtig.txt
```

</details>
