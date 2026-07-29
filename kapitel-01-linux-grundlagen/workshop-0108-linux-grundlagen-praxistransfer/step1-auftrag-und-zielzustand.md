# Schritt 1: Auftrag und Zielzustand

## Ausgangsstruktur

```text
/root/abschlusslabor/
├── vorlage/
│   └── startseite.txt
├── web/
│   ├── alt.txt
│   ├── leeres-archiv/
│   └── temp-build/
│       ├── notiz.txt
│       └── cache/
│           └── rest.txt
├── pruefung/
│   └── systemcheck
├── dokumentation/
└── schutzbereich/
    └── wichtig.txt
```

Untersuche die Struktur zunächst nur lesend. Verändere noch nichts.

## Ordne die Rollen zu

- Welche Datei ist die Quelle für die spätere Webseite?
- In welchen drei Bereichen darfst du Änderungen vornehmen?
- Welcher Bereich darf weder inhaltlich noch bei Rechten oder Eigentum
  verändert werden?
- Welche Objekte sollen am Ende weiterhin vorhanden sein?
- Welche drei Altobjekte sollen am Ende fehlen?

## Vorhersage

Formuliere vor der ersten Änderung:

1. Welche neue Datei soll entstehen?
2. Welche Ausgangsdatei muss trotzdem erhalten bleiben?
3. Warum benötigen die drei Altobjekte unterschiedliche bekannte
   Löschhandlungen?
4. Welche Datei erhält ein zusätzliches Recht?
5. Welche Adresse und welcher Port sollen später zusammengehören?

## Zielzustand in Kurzform

- `vorlage/startseite.txt` bleibt unverändert.
- `web/index.html` ist eine eigenständige Kopie der Vorlage.
- `web/alt.txt`, `web/leeres-archiv` und `web/temp-build` fehlen.
- `pruefung/systemcheck` besitzt zusätzlich nur das
  Besitzer-Ausführungsrecht und wurde ausgeführt.
- `dokumentation/status.txt` enthält die aktuelle CPU-Anzahl und die primäre
  Schnittstelle in genau einer Zeile.
- Der Schutzbereich ist vollständig unverändert.
- Ein Python-HTTP-Server läuft aus `/root/abschlusslabor/web`.
- Er lauscht ausschließlich an `127.0.0.1` auf TCP-Port `9090`.
- Die lokale HTTP-Antwort enthält den Text aus `index.html`.

Noch keine vollständige Befehlsfolge aufschreiben. Plane zuerst die
Teilziele und die Prüfreihenfolge.
