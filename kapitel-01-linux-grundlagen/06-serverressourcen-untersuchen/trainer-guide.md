# Dozentenleitfaden – Workshop 6

## Kurzprofil

- Titel: Linux-Serverressourcen untersuchen
- Zielzeit geübte Teilnehmende: 30–35 Minuten
- Zielzeit absolute Anfänger: 38–45 Minuten
- Mindestpuffer: 15 Minuten
- direkte Abhängigkeit: Workshop 3
- neue Teilnehmerbefehle: `nproc`, `free -h`, `df -h /`
- erste Option des Kapitels: `-h`

## Menschlich zu prüfende Lernziele

Teilnehmende sollen:

1. CPU, RAM und Dateisystemspeicher unterscheiden;
2. die `nproc`-Ausgabe nicht automatisch als physische Kernzahl bezeichnen;
3. Befehl, Option und Argument am konkreten Beispiel unterscheiden;
4. `free` und `available` auseinanderhalten;
5. RAM-Zeile und Swap-Zeile unterscheiden;
6. `Used` und `Avail` fachlich zuordnen;
7. für eine Ressourcenfrage den passenden Befehl wählen;
8. begründen, warum RAM und Dateisystemspeicher nicht austauschbar sind;
9. stabile und dynamische Werte in einfacher Form unterscheiden.

Der technische CHECK darf für diese Ziele nicht als vollständiger Nachweis verwendet werden.

## Beobachtung der ersten Optionsverwendung

Vor `free -h` prüfen:

- Wird das bisherige Modell „Befehl“ beziehungsweise „Befehl + Argument“ aktiviert?
- Versteht die Person, dass `-h` erstmals eine Option ist?
- Wird der Bindestrich als Bestandteil der Option gelesen?
- Wird `-h` fälschlich als Variable, Pfad oder Dateiname bezeichnet?
- Kann die Person sagen, dass `-h` hier nur die Darstellung der Größen verändert?

Keine allgemeine Optionenlehre ergänzen. Insbesondere nicht behandeln:

- Kurz- und Langoptionen allgemein;
- kombinierte Optionen;
- weitere Optionen von `free` oder `df`;
- interne Argumentverarbeitung.

## Leitfragen

### CPU

- Was zeigt `nproc` tatsächlich?
- Welche Aussage über physische Kerne wäre nicht belegt?
- Ist die Ausgabe eine Zahl oder Tabelle?

### Option

- Welcher Teil von `free -h` ist der Befehl?
- Welcher Teil ist die Option?
- Was verändert `-h`?
- Gehört der Bindestrich zur Option?

### RAM

- Welche Zeile ist der Arbeitsspeicher?
- Welche Zeile bleibt unberücksichtigt?
- Was bedeutet `total`?
- Warum sind `free` und `available` verschieden?
- Welcher Wert beantwortet die Frage nach noch nutzbarem RAM besser?

### Dateisystem

- Was ist bei `df -h /` Befehl, Option und Argument?
- Warum ist `/` ein Argument?
- Welche Zeile gehört zum Root-Dateisystem?
- Was bedeuten `Used` und `Avail`?
- Warum ist `Use%` nicht der verlangte verfügbare Größenwert?

### Ressourcentrennung

- Kann viel Dateisystemspeicher vorhanden sein, obwohl RAM knapp ist?
- Welcher Befehl passt zu einer fehlgeschlagenen Dateispeicherung?
- Welcher Befehl passt zu einer RAM-Frage?

## Typische Fehlvorstellungen und Reaktionen

| Fehlvorstellung | Rückfrage oder Reaktion |
|---|---|
| `nproc` zeigt physische Kerne. | „Welche Formulierung verwendet der Workshop ausdrücklich für die aktuelle Umgebung?“ |
| `-h` ist eine Variable. | „Welcher Teil verändert hier nur die Darstellung des Befehls?“ |
| `/` ist eine Option. | „Worauf soll sich `df` beziehen, und welches Zeichen beginnt die Option?“ |
| Swap ist zusätzlicher normaler RAM. | „Welche Zeile wurde als eigentlicher Arbeitsspeicher festgelegt?“ |
| `free` ist immer der beste freie RAM-Wert. | „Welches Feld schätzt, was neuen Anwendungen noch zur Verfügung steht?“ |
| `Size` ist belegter Speicher. | „Welche Überschrift bedeutet ausdrücklich belegt?“ |
| `Use%` ist verfügbarer Speicher. | „Ist dieser Wert eine Größe mit Einheit oder ein Prozentanteil?“ |
| `overlay` ist eine neue Ressource. | Technische Bezeichnung nicht vertiefen; zur Spalte `Mounted on` und zu `/` zurückführen. |
| RAM und Dateisystem sind derselbe Speicher. | Ein laufendes Programm und eine gespeicherte Datei gegenüberstellen. |

## Unterstützung bei der Spaltenzuordnung

1. Zuerst die Kopfzeile benennen lassen.
2. Dann die relevante Datenzeile bestimmen lassen.
3. Danach senkrecht von der Spaltenüberschrift zum Wert lesen lassen.
4. Nur die verlangten Felder markieren lassen.
5. Keine automatische Filterung oder Zusatzbefehle anbieten.

## Vier Hinweisstufen

1. Nur Ressourcenarten und Kategorien nennen.
2. Befehle und relevante Spalten nennen.
3. Vollständiges Statusformat mit Platzhaltern zeigen.
4. Vollständigen Musterablauf mit selbst einzusetzenden Momentwerten zeigen.

Regeln:

- Erst nach einem eigenen Versuch weiterstufen.
- Keine festen Werte nennen.
- Hinweis 4 nicht vorzeitig öffnen.
- Bei Tippfehlern zunächst auf den betroffenen Teil lenken.
- Keine ausgeschlossenen Befehle als Abkürzung einsetzen.

## Zeitmessung

Pilotprotokoll je Person:

| Abschnitt | Ziel Anfänger |
|---|---:|
| Intro und Vorwissen | 3–4 Min. |
| Servermodell und `nproc` | 7–8 Min. kumuliert |
| `free -h` | 13–15 Min. kumuliert |
| `df -h /` | 18–21 Min. kumuliert |
| Vergleich | 22–26 Min. kumuliert |
| Challenge | 32–40 Min. kumuliert |
| CHECK und Reflexion | 38–45 Min. gesamt |

## Eingriffskriterien

Eingreifen, wenn:

- eine Person länger als etwa zwei Minuten dieselbe Spaltenüberschrift nicht zuordnen kann;
- `-h` trotz Rückfrage weiterhin als Variable oder Pfad gelesen wird;
- RAM- und Dateisystemwerte wiederholt vertauscht werden;
- die lange Statuszeile das Ressourcenlernen vollständig überlagert;
- ein CHECK-Fehler ohne handlungsfähige Diagnose bleibt;
- die Anfängerzeit voraussichtlich 45 Minuten überschreitet.

Zuerst die nächste passende Hinweisstufe verwenden. Keine neuen Befehle einführen.

## Technische und fachliche Prüfung trennen

Der CHECK bestätigt nur den Endzustand und robuste Systembezüge. Dynamische Momentwerte werden in Version 1.0.0 nicht streng verglichen.

Formativ zusätzlich prüfen:

- Wurde `available` statt `free` gewählt?
- Wurden `Used` und `Avail` richtig zugeordnet?
- Kann die Person die Werkzeugwahl begründen?
- Kann sie Befehl, Option und Argument unterscheiden?
- Kann sie die drei Ressourcen fachlich trennen?
