# Musterlösung – Dateien und Verzeichnisse erstellen

Diese interne Datei wird nicht in der Teilnehmeroberfläche referenziert.

## Ausgangszustand

```text
/root/dateilabor/
├── eingang/
│   └── entwurf.txt
└── uebung/
```

`entwurf.txt` enthält bytegenau:

```text
vorlage
```

mit einem abschließenden Zeilenumbruch.

## Referenzlösung mit relativen Pfaden

```bash
cd /root/dateilabor
mkdir projekt
mkdir projekt/texte
echo bereit > projekt/texte/status.txt
mv eingang/entwurf.txt projekt/hinweis.txt
```

Die vier verändernden Teilnehmerbefehle nach dem Standortwechsel sind:

1. `mkdir projekt`
2. `mkdir projekt/texte`
3. `echo bereit > projekt/texte/status.txt`
4. `mv eingang/entwurf.txt projekt/hinweis.txt`

Kontrollbefehle verändern den Abschlusszustand nicht:

```bash
pwd
ls
ls projekt
ls projekt/texte
cat projekt/texte/status.txt
cat projekt/hinweis.txt
ls eingang
```

## Alternative gültige Lösung mit absoluten Pfaden

```bash
mkdir /root/dateilabor/projekt
mkdir /root/dateilabor/projekt/texte
echo bereit > /root/dateilabor/projekt/texte/status.txt
mv /root/dateilabor/eingang/entwurf.txt /root/dateilabor/projekt/hinweis.txt
```

Diese Lösung ist ebenfalls gültig. Der technische CHECK verlangt kein bestimmtes Arbeitsverzeichnis und keine bestimmte Befehlsreihenfolge, solange alle Elternverzeichnisse rechtzeitig vorhanden sind und der Endzustand stimmt.

## Erwarteter Abschlussbaum

```text
/root/dateilabor/
├── eingang/
│   └── entwurf.txt ist nicht mehr vorhanden
├── projekt/
│   ├── hinweis.txt
│   └── texte/
│       └── status.txt
└── uebung/
```

Zusätzliche fachlich nicht störende Dateien sind zulässig.

## Erwartete Dateiinhalte

`/root/dateilabor/projekt/texte/status.txt`:

```text
bereit
```

`/root/dateilabor/projekt/hinweis.txt`:

```text
vorlage
```

Beide Dateien besitzen jeweils einen abschließenden Zeilenumbruch.

## Erklärung der Umleitung

`echo bereit` erzeugt die Textausgabe `bereit`.

Die Shell verarbeitet `>` und schreibt die Ausgabe links des Zeichens in den Zielpfad rechts davon. Deshalb erscheint der Text normalerweise nicht zusätzlich im Terminal. Eine fehlende Datei wird erzeugt. Ein bereits vorhandener Inhalt kann ersetzt werden.

## Quelle und Ziel bei `mv`

Im Befehl

```text
mv eingang/entwurf.txt projekt/hinweis.txt
```

ist `eingang/entwurf.txt` die Quelle und `projekt/hinweis.txt` das Ziel.

Die Datei wird an den Zielpfad verschoben und erhält dabei den neuen Namen `hinweis.txt`. Sie wird nicht kopiert. Nach erfolgreichem Abschluss existiert der alte Quellpfad nicht mehr.

## Grenzen des technischen CHECKs

Der CHECK kann nur den Dateisystem-Endzustand prüfen. Er kann nicht beweisen:

- dass `mkdir` verwendet wurde,
- dass `echo` und `>` verwendet wurden,
- dass `mv` verwendet wurde,
- dass relative Pfade bewusst eingesetzt wurden,
- dass die Teilnehmenden Datei, Inhalt und Pfad erklären können,
- dass Quelle und Ziel verstanden wurden.

Diese Aspekte werden durch Aufgabenbeobachtung und Fragen geprüft.
