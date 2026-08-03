# Trainerleitfaden – Falsches Signal

## Metadaten

- Workshop: `01.07 – Falsches Signal: Die Konfiguration des Leuchtfeuers reparieren`
- Zielgruppe: Linux-Anfänger nach Workshops 0101 bis 0106
- Arbeitskonto: `waerter`
- Arbeitsbereich: `/home/waerter/leuchtturm/lichtsteuerung`
- Richtwert: ungefähr 60 Minuten einschließlich Fehlerkorrektur und Reflexion
- CHECK-Grenze: ausschließlich erfolgreiche Flag-Abgabe der aktuellen Sitzung

## Didaktisches Gesamtziel

Die Lernenden führen erstmals einen vollständigen, aber stark reduzierten
Konfigurationsablauf aus:

```text
lesen → sichern → ändern → kontrollieren → prüfen → anwenden → Status kontrollieren
```

Der Workshop verbindet bekannte Datei- und Navigationsbefehle mit drei neuen
Elementen: Dokumentation als Entscheidungshilfe, Nano als Terminaleditor und
die Trennung zwischen gespeichertem, gültigem und angewendetem Zustand.

## Didaktische Progression

### Intro – Problem und Leitfrage

**Funktion:** Das fehlerhafte Lichtsignal wird sichtbar, obwohl Mechanik und
Prozess funktionieren. Damit entsteht ein plausibler Anlass, Einstellungen zu
untersuchen.

**Trainerfokus:** Die Leitfrage etablieren und noch keine Nano-Tasten oder
Lösungswerte nennen. Die Sicherheitsroutine soll vor der ersten Bearbeitung
mental verfügbar sein.

### Step 1 – Betriebsprotokoll lesen

**Funktion:** `pwd`, `ls`, `cd` und `cat` werden abgerufen. Neu ist nur die
Logdatei als chronologische Informationsquelle. Der Schritt ist stark geführt,
damit die neue Dateirolle nicht mit neuer Befehlssyntax konkurriert.

**Beobachten:** Finden die Lernenden den Hinweis auf die geladene
Konfiguration, den aktuellen Rotationswert, die Warnung und den Verweis auf die
Dokumentation?

### Step 2 – Dokumentation und Konfiguration unterscheiden

**Funktion:** Log, Dokumentation und Konfiguration erhalten klar getrennte
Rollen. Das Modell `SCHLUESSEL=WERT` sowie Kommentarzeilen werden geführt
eingeführt.

**Trainerfokus:** Nicht direkt `ROTATION=kreis` nennen. Zuerst auf den Abschnitt
`ROTATION` in der Wartungsanleitung zurückverweisen und die Beschreibung mit
dem beobachteten Signal vergleichen lassen.

### Step 3 – Sicherungsroutine aufbauen

**Funktion:** Eine einzelne Datei wird vor der Änderung kopiert. Quelle,
Zielkopie und `.bak`-Benennung werden nachvollziehbar gemacht.

**Abgrenzung:** Dies ist kein allgemeiner Backupkurs. Aufbewahrung,
Versionierung, externe Datenträger und Wiederherstellungsstrategien werden
nicht vertieft.

### Step 4 – Nano gefahrlos kennenlernen

**Funktion:** Dies ist das einzige vollständige Worked Example zur
Nano-Grundbedienung. Die Datei wird geöffnet, der Cursor bewegt und Nano ohne
beabsichtigte Änderung verlassen.

**Trainerfokus:** Editorangst reduzieren. `^` als Strg-Taste erklären und die
Tasten `Strg+O`, `Enter`, `Strg+X` bei Bedarf einzeln wiederholen. Keine
weiteren Nano-Funktionen ergänzen.

### Step 5 – Eine begrenzte Änderung

**Funktion:** Die bekannte Nano-Bedienung wird auf genau einen fachlich
begründeten Wert übertragen. Geschwindigkeit und Bereich bleiben unverändert.

**Guidance Fading:** Der Hauptauftrag beschreibt nur die gewünschte Wirkung.
Die gestuften Hinweise nennen nacheinander Schlüssel, Zielwert, Speicherfolge
und vollständigen Ablauf. Den letzten Hinweis erst nach einem eigenen Versuch
öffnen lassen.

### Step 6 – Kontrollieren und validieren

**Funktion:** Die Lernenden unterscheiden:

```text
gespeichert ≠ gültig ≠ angewendet
```

Die Sichtkontrolle mit `cat` und die technische Validierung sind getrennte
Handlungen. Fehlermeldungen werden als Hilfe zur Korrektur genutzt.

**Trainerfokus:** Fehlermeldungen laut und vollständig lesen lassen. Keine
Datei automatisch reparieren. Nach einer Korrektur erneut lesen und prüfen.

### Step 7 – Anwenden und Laufzeitstatus kontrollieren

**Funktion:** Eine gültige Datei wird bewusst angewendet. Anschließend wird der
tatsächlich geladene Zustand mit dem gespeicherten Text verglichen.

**Trainerfokus:** Nachfragen, ob die Steuerung den neuen Wert bereits verwendet
oder ob bislang nur die Datei verändert wurde. Der Status ist der Nachweis für
den angewendeten Zustand.

### Challenge – Selbstständiger Transfer

**Funktion:** Der vollständige Wartungsablauf wird auf einen zweiten Wert
übertragen. Es kommt keine neue Syntax hinzu. Die Lernenden bestimmen den
passenden Bereich aus der Dokumentation und arbeiten mit reduzierter Hilfe.

**Trainerfokus:** Zuerst nur auf das Suchgebiet und später auf den Schlüssel
`BEREICH` lenken. Den Wert `kueste` erst über die vorgesehene zweite
Hinweisstufe nennen. Der vollständige Walkthrough bleibt die letzte Hilfe.

## Zentrale Trainerfragen

- Was sagt das Log über den aktuellen Zustand?
- Woher weißt du, welche Werte zulässig sind?
- Welche Datei enthält den aktuell gespeicherten Konfigurationstext?
- Welche Datei dient als Sicherung?
- Was bedeutet `^O` in Nano?
- Hast du die Datei nur gespeichert oder auch geprüft?
- Welche konkrete Information liefert die Fehlermeldung?
- Verwendet die Steuerung bereits den neuen Wert?
- Woran erkennst du den angewendeten Zustand?
- Welche Einstellung bestimmt das Suchgebiet?
- Warum wird der Status nach dem Anwenden erneut kontrolliert?

## Unterstützungsverhalten

1. Zuerst nach dem aktuell sichtbaren Zustand fragen.
2. Bei fachlichen Unsicherheiten auf Log und Dokumentation verweisen.
3. Nano-Tasten nur einzeln und passend zum aktuellen Dialog wiederholen.
4. Fehlermeldungen laut lesen und Schlüssel, Wert oder Format benennen lassen.
5. Keine Datei für die Lernenden automatisch korrigieren.
6. Nach jeder Korrektur erneut Dateiinhalt und Validatorausgabe prüfen lassen.
7. Vollständige Walkthroughs erst nach einem eigenen Versuch und den früheren
   Hinweisstufen öffnen lassen.

Die Lösung nicht durch sofortiges Nennen von `ROTATION=kreis` vorwegnehmen.

## Häufige Lernprobleme

| Beobachtung | Didaktische Reaktion |
|---|---|
| `cat` wird mit einem Editor verwechselt | Fragen, ob der Befehl nur anzeigt oder den Text zur Bearbeitung öffnet. |
| `^` wird als einzugebendes Zeichen verstanden | Erneut erklären: `^O` bedeutet die Tastenkombination `Strg+O`. |
| Bei `Strg+O` wird der Dateiname überschrieben | Den angezeigten Namen prüfen und unverändert mit `Enter` bestätigen lassen. |
| Wert oder Schlüssel enthält einen Tippfehler | Validatorausgabe vollständig lesen und nur die betroffene Stelle korrigieren lassen. |
| Speichern wird mit Anwenden verwechselt | Gespeicherte Datei und Laufzeitstatus direkt vergleichen lassen. |
| Statusdatei wird mit der Konfigurationsdatei verwechselt | Nach der Rolle beider Dateien fragen: gewünschter Text gegenüber angewendetem Zustand. |
| Sicherung wurde vergessen | Vor jeder Bearbeitung zur Wartungsroutine zurückkehren. |
| Sicherung wurde nach der Änderung überschrieben | Workshopzustand zurücksetzen und die Sicherung erneut vor der Bearbeitung anlegen. |

RAM, CPU-Auslastung und Prozessdiagnose stammen aus Workshop 6 und sind für
dieses Problem irrelevant. Diese Themen nicht erneut eröffnen.

## Bewusste fachliche Reduktionen

Nicht behandelt werden:

- Vim oder andere Editoren,
- YAML und JSON,
- systemd und Serviceverwaltung,
- Konfigurationen unter `/etc`,
- `sudo nano`,
- Kubernetes-Manifeste,
- komplexe Logs und Logging-Infrastruktur,
- `grep` und `tail`,
- das Laden von Konfigurationsdateien mit Shell-Sourcing,
- komplexe Backup- und Rollbacksysteme.

Diese Reduktion hält den Fokus auf einem kleinen, sicheren und vollständig
beobachtbaren Konfigurationsablauf.

## Sicherheitsaspekte

- Ausschließlich Dateien im vorbereiteten Workshopbereich bearbeiten.
- Keine fremden Systemdateien verändern.
- Für sämtliche Lernhandlungen ist kein Rootzugriff erforderlich.
- Vor der ersten Änderung die Ausgangsdatei sichern.
- Nach der Bearbeitung erst kontrollieren und validieren, dann anwenden.
- Der interne Parser behandelt die Konfiguration als nicht vertrauenswürdige
  Daten. Er verwendet weder `source` noch `eval` und führt Werte nicht als
  Shellcode aus.
- Der CHECK verändert keine Dateien und bestätigt ausschließlich den
  sitzungsgebundenen Flag-Abgabemarker.

## Technische und menschliche Prüfung

Technisch prüfbar:

- vollständiger Missionszustand wurde vom Neuladeskript erkannt,
- Flagdatei wurde freigelegt,
- korrekte Flag wurde für die aktuelle Sitzung eingereicht,
- Flag-only-CHECK ist erfolgreich.

Nur durch Beobachtung oder Gespräch prüfbar:

- Log, Dokumentation und Konfiguration korrekt unterscheiden,
- Sicherung bewusst vor der Änderung anlegen,
- Nano selbstständig bedienen,
- Fehlermeldungen verstehen,
- gespeichert, gültig und angewendet erklären,
- Status als Laufzeitnachweis interpretieren.

## Zeitplanung

| Abschnitt | Richtwert | Schwerpunkt |
|---|---:|---|
| Intro | 4 Min. | Problem und Leitfrage |
| Step 1 | 5 Min. | Logdatei finden und lesen |
| Step 2 | 7 Min. | Dokumentation und Konfigurationsmodell |
| Step 3 | 5 Min. | Sicherung erstellen und kontrollieren |
| Step 4 | 7 Min. | Nano gefahrlos kennenlernen |
| Step 5 | 6 Min. | Rotation gezielt ändern |
| Step 6 | 6 Min. | Sichtkontrolle und Validierung |
| Step 7 | 5 Min. | Anwenden und Status prüfen |
| Challenge | 9 Min. | Selbstständiger Transfer und Flag-Abgabe |
| Finish und Reflexion | 3 Min. | Abruf und Ausblick |

Gesamt: ungefähr 57 Minuten. Die verbleibenden Minuten dienen als Puffer für
Nano-Dialoge, Tippfehler und Rückfragen. Wenn mehrere Lernende bereits in Step
4 deutlich mehr als zehn Minuten benötigen, die Challenge-Hinweise früher
staffeln, aber nicht die Datei für sie bearbeiten.
