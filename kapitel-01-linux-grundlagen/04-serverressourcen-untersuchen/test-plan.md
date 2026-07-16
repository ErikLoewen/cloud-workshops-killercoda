# Testplan – Workshop 4

## Status

Dieser Plan definiert statische, lokale und reale Tests. Ein bestandener lokaler Test ersetzt keinen realen Killercoda-Test.

## Voraussetzungen für lokale Tests

- Bash
- `nproc`
- `free`
- `df`
- `awk`
- Schreibrecht auf `/root/ressourcenlabor` oder ein gleichwertiger isolierter Testkontext
- keine produktiven Daten im Übungspfad

## Testfälle

| Nr. | Testfall | Vorgehen | Erwartung |
|---:|---|---|---|
| 1 | Frischer Szenariostart | Szenario in frischer Umgebung öffnen | Intro erscheint; Setup ist abgeschlossen |
| 2 | Setup einmal | `setup.sh` einmal ausführen | Exit 0; Zielordner vorhanden; Statusdatei fehlt |
| 3 | Setup zweimal | `setup.sh` zweimal ausführen | beide Ausführungen Exit 0; gleicher Ausgangszustand |
| 4 | Zielverzeichnis | Zustand prüfen | `/root/ressourcenlabor` ist ein Verzeichnis |
| 5 | Statusdatei nach Setup | Zustand prüfen | `serverstatus.txt` existiert nicht |
| 6 | Korrekte Statusdatei | aktuelle Werte korrekt eintragen | CHECK Exit 0 |
| 7 | Fehlende Datei | Datei entfernen | CHECK Exit ungleich 0; konkrete Meldung |
| 8 | Verzeichnis statt Datei | Zielpfad als Verzeichnis anlegen | CHECK Exit ungleich 0; reguläre Datei verlangt |
| 9 | Leere Datei | leere Datei erzeugen | CHECK Exit ungleich 0 |
| 10 | Zusätzliche Datenzeile | zweite nicht leere Zeile ergänzen | CHECK Exit ungleich 0 |
| 11 | Fehlender Schlüssel | einen vorgeschriebenen Schlüssel entfernen | CHECK Exit ungleich 0; Schlüssel genannt |
| 12 | Doppelter Schlüssel | einen Schlüssel doppelt eintragen | CHECK Exit ungleich 0 |
| 13 | Leerer Wert | `SCHLUESSEL=` verwenden | CHECK Exit ungleich 0 |
| 14 | Ungültiger CPU-Wert | Text oder Null eintragen | CHECK Exit ungleich 0 |
| 15 | Falscher CPU-Wert | andere positive Zahl eintragen | CHECK Exit ungleich 0 |
| 16 | Fehlende Speichereinheit | reine Zahl als Speicherwert | CHECK Exit ungleich 0 |
| 17 | Zulässige RAM-Einheit | bestätigte `Mi`- oder `Gi`-Darstellung | Format wird akzeptiert |
| 18 | Zulässige Dateisystemeinheit | bestätigte `M`- oder `G`-Darstellung | Format wird akzeptiert |
| 19 | RAM verfügbar größer als gesamt | eindeutig größeren Wert eintragen | CHECK Exit ungleich 0 |
| 20 | Zusätzliche irrelevante Datei | zweite Datei im Laborordner anlegen | korrekte Statusdatei bleibt erfolgreich |
| 21 | Abweichende Schlüsselreihenfolge | fünf Paare umordnen | CHECK Exit 0 |
| 22 | Mehrere Leerzeichen | Paare durch mehrere Leerzeichen trennen | CHECK Exit 0 |
| 23 | Wiederholter CHECK | CHECK zweimal ausführen | beide Ergebnisse identisch |
| 24 | Hashvergleich | Hash vor und nach CHECK bilden | Statusdatei unverändert |
| 25 | Realer Killercoda-Test | gesamtes Szenario im echten Backend ausführen | alle Schritte und CHECK funktionieren |
| 26 | Dynamische Schwankungen | Werte über realistische Bearbeitungszeit messen | Messreihe dokumentiert; keine Toleranz ohne Begründung |
| 27 | Zeitmessung geübt | geübte Personen pilotieren | etwa 30–35 Minuten oder schneller ohne künstliche Verlängerung |
| 28 | Anfängerpilot | absolute Anfänger pilotieren | etwa 38–45 Minuten; mindestens 15 Minuten Puffer |

## Statische Prüfungen

- `index.json` mit einem JSON-Parser prüfen.
- Alle in `index.json` referenzierten Dateien auf Existenz und exakte Groß-/Kleinschreibung prüfen.
- `bash -n setup.sh` und `bash -n verify.sh`.
- Ausführungsrechte der Shellskripte prüfen.
- Vollständige Dateiliste prüfen.
- Sicherstellen, dass keine `structure.json` existiert.
- In Teilnehmerdateien genau ein `{{exec}}` feststellen.
- Sicherstellen, dass dieses `{{exec}}` ausschließlich beim ersten `nproc`-Aufruf steht.
- Teilnehmerdateien nach ausgeschlossenen Befehlen und Operatoren durchsuchen.
- Nach internen Citation-Tokens suchen.
- Nach auffälligen Satzabbrüchen und doppelten Zeilen suchen.
- Prüfen, dass `-h` erstmals in `step2-arbeitsspeicher.md` als Option eingeführt wird.
- Prüfen, dass `-h` nicht als Variable bezeichnet wird.
- Prüfen, dass `/` bei `df -h /` als Argument bezeichnet wird.
- Prüfen, dass interne Dateien nicht in `index.json` referenziert sind.

## Bestimmung späterer dynamischer Toleranzen

Version 1.0.0 lehnt `RAM_VERFUEGBAR`, `DATEISYSTEM_BELEGT` und `DATEISYSTEM_VERFUEGBAR` nicht aufgrund eines aktuellen Momentwertvergleichs ab.

Eine spätere Toleranz darf nur nach einem realen Killercoda-Pilot ergänzt werden:

1. Szenario frisch starten.
2. Direkt vor der Challenge mindestens eine Referenzmessung erfassen.
3. Werte in festen Abständen während einer realistischen Anfängerbearbeitungszeit erfassen.
4. Unmittelbar vor und nach dem CHECK erneut messen.
5. Rundungseinheit und Dezimalstellen dokumentieren.
6. minimale, maximale und typische Abweichungen bestimmen.
7. mehrere frische Sitzungen vergleichen.
8. Ausreißer und Setup-Einflüsse getrennt dokumentieren.
9. eine Toleranz aus Rundung plus beobachteter Schwankung plus begründetem Sicherheitsaufschlag ableiten.
10. Negativfälle mit bewusst vertauschten Werten gegen diese Toleranz testen.
11. Toleranz nur übernehmen, wenn gültige Lösungen zuverlässig akzeptiert und klare Fehler zuverlässig erkannt werden.
12. Entscheidung und Messwerte im Testprotokoll festhalten.

Keine Toleranz allein aus Vermutung oder einer einzigen Sitzung ableiten.

## Killercoda-Pilot

1. Repository mit dem Workshopordner verbinden.
2. Synchronisierung abwarten und Importfehler prüfen.
3. Szenario frisch öffnen.
4. Prüfen, ob das bestätigte Ubuntu-Backend startet.
5. Kontrollieren, dass Setup vor der ersten Handlung abgeschlossen ist.
6. `nproc`, `free -h` und `df -h /` auf Vorhandensein prüfen.
7. sichtbare Sprache, Spalten und Einheiten dokumentieren.
8. Challenge zunächst bewusst fehlerhaft lösen.
9. jede CHECK-Diagnose auf Verständlichkeit prüfen.
10. korrekte aktuelle Werte eintragen.
11. CHECK erfolgreich ausführen.
12. Szenario neu starten und Unabhängigkeit bestätigen.
13. tatsächliche Bearbeitungszeit messen.
14. Ergebnisse ausschließlich in `test-results.md` eintragen.

## Lokal bestätigte zusätzliche Einheit

Die lokale Sandbox-Ausgabe von `df -h /` kann `E` verwenden. Der interne Parser akzeptiert deshalb zusätzlich `P`, `E`, `Pi` und `Ei`. Ob diese Einheiten im Killercoda-Backend sichtbar werden, bleibt im realen Pilot zu prüfen.
