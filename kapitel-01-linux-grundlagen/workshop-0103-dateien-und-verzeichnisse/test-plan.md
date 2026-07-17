# Testplan – Workshop 3

## Status

Geplant. Die Ergebnisse werden erst nach tatsächlicher Durchführung protokolliert.

## Testumgebungen

- lokale Bash-Testumgebung
- frische Killercoda-Umgebung mit bestätigtem Ubuntu-Backend
- Pilot mit geübten Teilnehmenden
- Pilot mit absoluten Anfängern

Der Startpfad `/root` ist im realen Killercoda-Test zu bestätigen.

## Allgemeine Erfolgskriterien

- Setup ist reproduzierbar und idempotent.
- Setup verändert ausschließlich `/root/dateilabor`.
- Der Ausgangszustand ist exakt.
- Verify verändert den Lernzustand nicht.
- Verify liefert bei Fehlern Exit-Code ungleich 0 und konkrete Meldungen.
- Verify liefert im vollständigen Positivfall Exit-Code 0.
- Zusätzliche fachlich nicht störende Dateien werden akzeptiert.
- Unterschiedliche gültige Lösungswege werden akzeptiert.
- Nur `mkdir sammlung` ist als anklickbare Ausführung markiert.

## Testfälle

### 1. Frischer Szenariostart

**Aktion:** Szenario in einer frischen Umgebung öffnen.  
**Erwartung:** Setup läuft vor der ersten Teilnehmerhandlung; Intro und erster Schritt sind erreichbar.

### 2. Setup einmal ausführen

**Aktion:** `setup.sh` einmal ausführen.  
**Erwartung:** Ausgangsbaum und Inhalt entsprechen der Spezifikation.

### 3. Setup zweimal ausführen

**Aktion:** `setup.sh` unmittelbar erneut ausführen.  
**Erwartung:** identischer Ausgangszustand; keine Fehlermeldung.

### 4. Ausgangsbaum prüfen

**Erwartung:**

```text
/root/dateilabor/
├── eingang/
│   └── entwurf.txt
└── uebung/
```

`entwurf.txt` enthält bytegenau `vorlage` mit abschließendem Zeilenumbruch. `projekt` existiert nicht.

### 5. Hauptverzeichnis fehlt

**Zustand:** Ausgangszustand unverändert.  
**Erwartung:** Verify meldet das fehlende Hauptverzeichnis und schlägt fehl.

### 6. Unterverzeichnis fehlt

**Zustand:** `projekt` existiert, `projekt/texte` fehlt.  
**Erwartung:** Verify meldet das fehlende Unterverzeichnis.

### 7. `status.txt` fehlt

**Zustand:** Haupt- und Unterverzeichnis existieren; keine Statusdatei.  
**Erwartung:** Verify meldet die fehlende Statusdatei.

### 8. `status.txt` liegt am falschen Ort

**Zustand:** Eine reguläre Datei namens `status.txt` liegt innerhalb von `/root/dateilabor`, aber nicht am Zielpfad.  
**Erwartung:** Verify nennt den tatsächlich gefundenen falschen Pfad.

### 9. Statusinhalt lautet `Bereit`

**Zustand:** Statusdatei liegt richtig, besitzt aber falsche Großschreibung.  
**Erwartung:** Verify meldet einen nicht exakten Inhalt.

### 10. Statusinhalt besitzt eine zusätzliche Zeile

**Zustand:** Statusdatei enthält `bereit` und eine weitere Zeile.  
**Erwartung:** Verify meldet einen nicht exakten Inhalt.

### 11. `hinweis.txt` fehlt und Quelle existiert noch

**Zustand:** Statusbereich ist korrekt; Ziel fehlt; Quelldatei ist vorhanden.  
**Erwartung:** Verify meldet zuerst das fehlende Verschiebe- und Umbenennungsziel.

### 12. Ziel existiert, Quelle existiert zusätzlich noch

**Zustand:** Beide Zieldateien sind korrekt; alter Quellpfad ist weiterhin vorhanden.  
**Erwartung:** Verify meldet den noch vorhandenen alten Quellpfad.

### 13. Inhalt von `hinweis.txt` wurde verändert

**Zustand:** Ziel liegt richtig, enthält aber nicht mehr exakt `vorlage`.  
**Erwartung:** Verify meldet den veränderten Zielinhalt.

### 14. Zusätzliche irrelevante Datei vorhanden

**Zustand:** Vollständiger Sollzustand plus eine weitere nicht störende Datei.  
**Erwartung:** Verify besteht.

### 15. Vollständige Referenzlösung

**Aktion:** Die vier verändernden Teilnehmerbefehle ausführen.  
**Erwartung:** Verify besteht; Inhalte und Pfade stimmen.

### 16. CHECK wiederholt ausführen

**Aktion:** Verify im vollständigen Sollzustand zweimal ausführen.  
**Erwartung:** beide Prüfungen bestehen; Dateisystemzustand bleibt bytegenau unverändert.

### 17. Vollständiger Szenarioneustart

**Aktion:** Szenario neu starten.  
**Erwartung:** Setup stellt wieder ausschließlich den Ausgangszustand her.

### 18. Realer Killercoda-Test

Prüfen:

- bestätigtes Ubuntu-Backend startet;
- Startpfad wird angezeigt und dokumentiert;
- Setup läuft zuverlässig vor der ersten Handlung;
- Markdown, Dropdown-Hinweise und CHECK werden korrekt dargestellt;
- nur die vorgesehene Demonstration ist anklickbar;
- CHECK kann nach einer Korrektur wiederholt werden.

### 19. Zeitmessung mit geübten Teilnehmenden

**Zielkorridor:** 33–40 Minuten.  
**Regel:** Bei wiederholter Unterschreitung nicht künstlich verlängern.

### 20. Pilot mit absoluten Anfängern

**Zielkorridor:** 43–49 Minuten.  
**Mindestpuffer:** 11 Minuten.  
**Beobachten:** Umleitung, stille Erfolge, Quelle und Ziel, relative Pfade, Nutzung der Hinweisstufen.
