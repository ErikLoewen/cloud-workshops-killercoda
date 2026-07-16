# Musterlösung und Erklärung

Diese interne Datei ist nicht in `index.json` referenziert.

## Sicherheitsroutine

Vor jeder destruktiven Handlung:

1. Standort mit `pwd` prüfen.
2. Zielpfad lesen.
3. Zielobjekt mit `ls` bestätigen.
4. Erwartete Wirkung vorhersagen.
5. Löschbefehl selbst eingeben.
6. Ergebnis und Schutzbereich kontrollieren.

## Vollständiger Demoablauf

```bash
cd /root/dateilabor/demo
```

Wechselt in den ausdrücklich freigegebenen Demo-Bereich.

```bash
pwd
```

Bestätigt den Standort.

```bash
ls
```

Zeigt die vorbereiteten Demo-Objekte.

```bash
cat quelle.txt
```

Kontrolliert den Inhalt `Kopieren erhaelt die Quelle`.

```bash
cp quelle.txt kopie.txt
```

Erzeugt am Ziel eine zusätzliche reguläre Datei. Die Quelle bleibt erhalten.

```bash
ls
```

Bestätigt Quelle und Kopie.

```bash
cat quelle.txt
```

Kontrolliert die Quelle.

```bash
cat kopie.txt
```

Kontrolliert den Inhalt der Kopie.

```bash
pwd
```

Beginnt die Sicherheitsroutine vor dem ersten Löschen.

```bash
ls einzeldatei.txt
```

Bestätigt das konkrete Ziel.

Erwartete Wirkung: Nur `einzeldatei.txt` verschwindet.

```bash
rm einzeldatei.txt
```

Entfernt ausschließlich die freigegebene einzelne Demo-Datei.

```bash
ls
```

Kontrolliert den Zustand.

```bash
ls /root/dateilabor/auftrag/schutzbereich
```

Bestätigt den Schutzbereich.

```bash
cat /root/dateilabor/auftrag/schutzbereich/wichtig.txt
```

Bestätigt den unveränderten Inhalt `Dieser Inhalt muss erhalten bleiben`.

```bash
pwd
```

Prüft erneut den Standort.

```bash
ls leerer-ordner
```

Bestätigt das leere Zielverzeichnis.

```bash
rmdir leerer-ordner
```

Entfernt das leere Verzeichnis.

```bash
ls
```

Kontrolliert den Erfolg.

```bash
ls nicht-leer
```

Zeigt den enthaltenen Eintrag.

```bash
cat nicht-leer/inhalt.txt
```

Kontrolliert `Das Verzeichnis ist nicht leer`.

```bash
rmdir nicht-leer
```

Ist der didaktisch erwartete Fehlversuch. Der Befehl darf mit Fehlerstatus enden; die Shell bleibt verwendbar.

```bash
ls
```

Zeigt, dass `nicht-leer` weiterhin vorhanden ist.

```bash
ls nicht-leer
```

Zeigt die weiterhin vorhandene Datei.

```bash
cat nicht-leer/inhalt.txt
```

Bestätigt den unveränderten Inhalt.

## Vollständige Abschlusslösung

```bash
cd /root/dateilabor/auftrag
```

Wechselt in den Auftragsbereich.

```bash
pwd
```

Bestätigt den Standort.

```bash
ls
```

Zeigt Quelle, Arbeitsbereich und Schutzbereich.

```bash
ls quelle
```

Bestätigt die Quelle.

```bash
cat quelle/bericht.txt
```

Kontrolliert `Bericht fuer die Sicherung`.

```bash
ls arbeitsbereich
```

Zeigt die drei freigegebenen Arbeitsobjekte.

```bash
ls schutzbereich
```

Bestätigt den Schutzbereich.

```bash
cat schutzbereich/wichtig.txt
```

Kontrolliert `Dieser Inhalt muss erhalten bleiben`.

```bash
cp quelle/bericht.txt arbeitsbereich/bericht-kopie.txt
```

Erzeugt eine zusätzliche Datei im Arbeitsbereich. Die Quelle bleibt bestehen.

```bash
ls quelle
```

Bestätigt die erhaltene Quelle.

```bash
ls arbeitsbereich
```

Bestätigt die neue Kopie.

```bash
cat quelle/bericht.txt
```

Kontrolliert den Quellinhalt.

```bash
cat arbeitsbereich/bericht-kopie.txt
```

Kontrolliert den gleichen Inhalt der Kopie.

```bash
pwd
```

Beginnt die Sicherheitsroutine vor der Einzeldatei.

```bash
ls arbeitsbereich/alt.txt
```

Bestätigt den konkreten Zielpfad.

Erwartete Wirkung: Nur `arbeitsbereich/alt.txt` verschwindet.

```bash
rm arbeitsbereich/alt.txt
```

Entfernt die freigegebene einzelne Datei.

```bash
ls arbeitsbereich
```

Kontrolliert den Zustand.

```bash
pwd
```

Prüft den Standort vor dem leeren Verzeichnis.

```bash
ls arbeitsbereich/leeres-archiv
```

Bestätigt das konkrete leere Ziel.

```bash
rmdir arbeitsbereich/leeres-archiv
```

Entfernt das leere Verzeichnis.

```bash
ls arbeitsbereich
```

Kontrolliert den Zustand.

Vor dem rekursiven Schritt lautet der vollständig freigegebene Zielpfad:

```text
/root/dateilabor/auftrag/arbeitsbereich/temp-projekt
```

```bash
pwd
```

Prüft den Standort.

```bash
ls arbeitsbereich/temp-projekt
```

Bestätigt das konkrete Ziel und seine direkten Inhalte.

```bash
cat arbeitsbereich/temp-projekt/notiz.txt
```

Bestätigt `Temporäre Notiz`.

```bash
ls arbeitsbereich/temp-projekt/unterordner
```

Bestätigt den Unterordner.

```bash
cat arbeitsbereich/temp-projekt/unterordner/rest.txt
```

Bestätigt `Temporärer Rest`.

```bash
ls schutzbereich
```

Kontrolliert den getrennten Schutzbereich.

```bash
cat schutzbereich/wichtig.txt
```

Bestätigt vor der Handlung den unveränderten Schutzinhalt.

Erwartete Wirkung: `temp-projekt`, `notiz.txt`, `unterordner` und `rest.txt` verschwinden gemeinsam. Quelle, Kopie und Schutzbereich bleiben erhalten.

```bash
rm -r arbeitsbereich/temp-projekt
```

Entfernt ausschließlich das vollständig geprüfte und freigegebene rekursive Ziel.

```bash
ls quelle
```

Bestätigt die Quelle.

```bash
ls arbeitsbereich
```

Bestätigt den bereinigten Arbeitsbereich und die Kopie.

```bash
ls schutzbereich
```

Bestätigt den Schutzbereich.

```bash
cat quelle/bericht.txt
```

Kontrolliert die Quelle.

```bash
cat arbeitsbereich/bericht-kopie.txt
```

Kontrolliert die Kopie.

```bash
cat schutzbereich/wichtig.txt
```

Kontrolliert den Schutzinhalt.

## Gefahrenanalyse

Die Kombination `rm -rf` wird nicht ausgeführt und nicht mit einem Ziel dargestellt.

```text
rm     entfernt
-r     arbeitet rekursiv
-f     erzwingt die Handlung und unterdrückt bestimmte Rückmeldungen
```

`-f` ist keine normale Reaktion auf eine Fehlermeldung. Zuerst werden Zielpfad, Objektart und Fehlerursache geprüft.

## Grenzen des CHECKs

Der CHECK prüft den Endzustand. Er beweist nicht:

- dass `cp`, `rm`, `rmdir` oder `rm -r` verwendet wurden;
- dass die Sicherheitsroutine bewusst eingehalten wurde;
- dass der kontrollierte Fehlversuch ausgeführt und verstanden wurde;
- dass die Aufgabe selbstständig geplant wurde;
- dass die theoretische Gefahr vollständig verstanden wurde.
