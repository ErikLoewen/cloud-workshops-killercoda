# Testplan – Workshop 01.07

## Zweck und Testregeln

Dieser Plan prüft den Workshop
`01.07 – Falsches Signal: Die Konfiguration des Leuchtfeuers reparieren`.

- Ergebnisse werden erst nach der Ausführung in `test-results.md` eingetragen.
- Lokale statische Prüfungen, lokale Laufzeittests und Tests in einer echten
  Killercoda-Sitzung werden getrennt dokumentiert.
- Jeder Test erhält den Status `bestanden`, `fehlgeschlagen` oder `nicht
  ausgeführt` sowie Datum, Umgebung und eine kurze Evidenz.
- Zustandsverändernde Tests beginnen mit einem frischen Setup oder einem zuvor
  dokumentierten Ausgangszustand.
- Für Negativtests wird die Konfiguration jeweils aus einer temporären Kopie
  erzeugt oder anschließend durch ein vollständiges Setup zurückgesetzt.
- Tests dürfen keine Dateien außerhalb der ausdrücklich genannten Workshop-,
  internen Programm- und State-Pfade verändern.

## Referenzzustand

Teilnehmerbereich:

```text
/home/waerter/leuchtturm/lichtsteuerung/
├── leuchtfeuer.conf
├── dokumentation/
│   └── wartungsanleitung.txt
├── protokolle/
│   └── leuchtfeuer.log
├── konfiguration-pruefen
├── leuchtfeuer-neu-laden
├── leuchtfeuer-status
└── status/
    └── angewendete-konfiguration
```

Ausgangskonfiguration:

```ini
# Konfiguration der Leuchtfeuersteuerung
ROTATION=impuls
GESCHWINDIGKEIT=langsam
BEREICH=meer
```

Ausgangsstatus:

```ini
LEUCHTFEUER=aktiv
ROTATION=impuls
GESCHWINDIGKEIT=langsam
BEREICH=meer
```

Vollständiger Missionszustand:

```ini
ROTATION=kreis
GESCHWINDIGKEIT=langsam
BEREICH=kueste
```

Erwartete Flag:

```text
FLAG{die_spur_fuehrt_vom_turm_fort}
```

## A. Setup

| ID | Test | Durchführung | Erwartetes Ergebnis |
|---|---|---|---|
| A01 | Frischer Workshopstart | Neue Killercoda-Sitzung starten und den ersten Prompt abwarten. | Keine sichtbare Root-Shell, Warteschleife, Paketinstallation oder zeilenweise Setup-Ausgabe; Prompt zeigt `waerter@leuchtturm`. |
| A02 | Wiederholter Workshopstart | `setup.sh` in einer isolierten Testumgebung zweimal vollständig ausführen. | Beide Läufe enden mit Exit-Code 0; der zweite Lauf erzeugt denselben definierten Ausgangszustand. |
| A03 | Benutzer | Im Teilnehmerterminal `id -un` ausführen. | Ausgabe ist exakt `waerter`. |
| A04 | Startverzeichnis | Direkt nach dem Start `pwd` ausführen. | Ausgabe ist `/home/waerter/leuchtturm/lichtsteuerung`. |
| A05 | Nano vorhanden | `command -v nano` und `nano --version` prüfen. | Nano ist ohne `sudo` aufrufbar. Falls eine Installation nötig war, ist sie nur im globalen Setup-Log sichtbar. |
| A06 | Arbeitsstruktur vollständig | Verzeichnisse und Dateien mit `find` beziehungsweise `ls -la` prüfen. | Die Referenzstruktur ist vollständig; keine alten Workshopdateien liegen im Teilnehmerbereich. |
| A07 | Eigentümer | `stat -c '%U:%G %n'` für Teilnehmerbereich und alle enthaltenen Dateien ausführen. | Alle Teilnehmerdateien und -verzeichnisse gehören `waerter:waerter`. Interner Parser und interne State-Pfade bleiben wie vorgesehen geschützt. |
| A08 | Dateirechte | Rechte aller Teilnehmerdateien mit `stat` prüfen und Lese-/Schreibtest als `waerter` durchführen. | Konfiguration und Textdateien sind für `waerter` les- und bearbeitbar; Verzeichnisse sind betretbar; keine unnötigen weltweiten Schreibrechte. |
| A09 | Hilfsskripte ausführbar | Als `waerter` alle drei Hilfsskripte direkt aufrufen. | `konfiguration-pruefen`, `leuchtfeuer-neu-laden` und `leuchtfeuer-status` sind ausführbar und benötigen kein `sudo`. |
| A10 | Keine Altlasten | Teilnehmerbereich, interne Workshoppfade und Setup-Ausgabe nach `lab-worker`, alten Prozessmarkern, Units und Dienststatusdateien durchsuchen. | Keine technische Altlast des früheren Prozess-/Dienstworkshops ist vorhanden. |
| A11 | Ausgangskonfiguration | Datei byte- beziehungsweise zeilengenau mit dem Referenztext vergleichen. | Kommentar und exakt die drei erwarteten Schlüssel mit den Ausgangswerten sind vorhanden. |
| A12 | Ausgangslog | `protokolle/leuchtfeuer.log` lesen und mit dem definierten Anfangslog vergleichen. | Start, geladene Konfiguration, drei Werte, Warnung und Dokumentationshinweis sind enthalten; die Lösung wird nicht genannt. |
| A13 | Ausgangsstatus | `status/angewendete-konfiguration` lesen. | Inhalt entspricht exakt dem Referenzstatus. |
| A14 | Keine alte Sicherung | Vor Lernhandlungen nach `leuchtfeuer.conf.bak` suchen. | Die Sicherungsdatei existiert nicht. |
| A15 | Keine alte Flag | Status- und State-Pfade auf Abschlussflagge, Abgabe-, Erfolgs- und Sitzungsmarker einer früheren Sitzung prüfen. | Keine alte Abschlussflagge und kein alter Erfolgsmarker sind verwendbar; eine neue Sitzung besitzt nur den für sie neu erzeugten Ausgangszustand. |

## B. Lernmaterialien

| ID | Prüfung | Erwartetes Ergebnis |
|---|---|---|
| B01 | Betriebsprotokoll in Setup und Step 1 lesen. | Das Log zeigt Störung und Dokumentationshinweis, nennt aber weder `ROTATION=kreis` noch den Abschlusszustand. |
| B02 | Wartungsanleitung prüfen. | Alle Werte für `ROTATION`, `GESCHWINDIGKEIT` und `BEREICH` werden verständlich und widerspruchsfrei erklärt. |
| B03 | Ausgangskonfiguration prüfen. | Sie enthält genau die Schlüssel `ROTATION`, `GESCHWINDIGKEIT` und `BEREICH`, jeweils einmal. |
| B04 | Intro, Steps, Challenge, Finish und Solution querlesen. | Befehle, Pfade, Werte, Nano-Tasten, Reihenfolge und erwartete Zustände widersprechen sich nicht. |
| B05 | Offene Lerntexte nach `FLAG{` durchsuchen. | Intro, Steps, Challenge und Finish enthalten keine offen sichtbare Flag. Vorkommen bleiben auf technische Dateien, Lösung und interne Testdokumentation begrenzt. |
| B06 | Lerntexte nach alten Themen durchsuchen. | Es gibt keine Lehre zu `lab-worker`, Prozessbeendigung, systemd oder Serviceverwaltung. Historische Hinweise in Qualitätsdokumenten dürfen nur ausdrücklich als entfernte Altlast erscheinen. |
| B07 | `<details>` und `</details>` je Markdown-Datei zählen und visuell rendern. | Jedes Dropdown ist geschlossen, korrekt verschachtelt und lesbar. |
| B08 | Vollständige Befehlsfolgen prüfen. | Komplettlösungen stehen nur in geschlossenen vollständigen Walkthroughs und in `solution.md`; der offene Lernweg bleibt gestuft. |
| B09 | Bilder und Alternativtexte prüfen. | Alle fünf Bilddateien sind vorhanden, ihre technischen Namen enthalten weder Leerzeichen noch Umlaute und alle sechs Markdown-Referenzen zeigen auf den passenden Asset-Pfad. |
| B10 | Didaktische Progression prüfen. | Bekanntes wird vor Neuem wiederholt; Nano wird gefahrlos eingeführt; erste Änderung, Prüfung, Anwendung und Transfer sind getrennt. |

Verwendete Assets:

```text
assets/0107-einstieg-falsches-signal.png
assets/0107-konfigurationszeile.png
assets/0107-nano-bedienung.png
assets/0107-konfigurationsablauf.png
assets/0107-abschluss-spuren-am-deich.png
```

## C. Nano – manueller Killercoda-Test

Diese Tests benötigen ein echtes interaktives Teilnehmerterminal. Terminaltyp,
Browser und Fenstergröße werden in `test-results.md` notiert.

| ID | Test | Erwartetes Ergebnis |
|---|---|---|
| C01 | `nano leuchtfeuer.conf` starten. | Nano öffnet die vorhandene Datei ohne Fehlermeldung und ohne neue Datei anzulegen. |
| C02 | Cursor mit allen vier Pfeiltasten bewegen. | Der Cursor bewegt sich erwartungsgemäß; keine Escape-Sequenzen werden als Text eingefügt. |
| C03 | Unverändert mit `Strg+X` verlassen. | Nano schließt ohne Speicherfrage; Dateiinhalt und Zeitstempel bleiben unverändert. |
| C04 | Einen kontrollierten Wert ändern und `Strg+O` drücken. | Der Dialog zum Schreiben der Datei erscheint. |
| C05 | Angezeigten Dateinamen mit `Enter` bestätigen. | Unter demselben Pfad wird gespeichert; keine Datei mit abweichendem Namen entsteht. |
| C06 | Nano mit `Strg+X` schließen und mit `cat` kontrollieren. | Änderung ist vollständig und ohne zusätzliche Zeichen gespeichert. |
| C07 | Eine unbeabsichtigte Änderung erzeugen, `Strg+X` drücken und `N` wählen. | Nano schließt, ohne die unbeabsichtigte Änderung zu speichern. |
| C08 | Nano bei kleiner und normaler Terminalhöhe bedienen. | Untere Hinweise, Speicherabfrage und Dateiname bleiben bedienbar; kein Prompt- oder Darstellungsfehler blockiert den Lernweg. |

Nach C04 bis C07 wird der Ausgangszustand vor dem nächsten unabhängigen Test
wiederhergestellt.

## D. Validierung

Für jede Variante wird `./konfiguration-pruefen` ausgeführt. Standardausgabe,
Standardfehler und Exit-Code werden dokumentiert. Vor und nach der Prüfung wird
der Hash von `status/angewendete-konfiguration` verglichen: Reines Prüfen darf
den angewendeten Zustand nicht verändern.

| ID | Eingabe oder Variante | Erwartetes Ergebnis |
|---|---|---|
| D01 | Gültige Ausgangsdatei. | Exit-Code 0; verständliche Erfolgsausgabe mit allen drei Werten. |
| D02 | `ROTATION=kreis`, übrige Ausgangswerte. | Exit-Code 0. |
| D03 | `BEREICH=kueste`, sonst gültig. | Exit-Code 0. |
| D04 | Jede Kombination aller zulässigen Einzelwerte: Rotation `stop`, `impuls`, `kreis`; Geschwindigkeit `langsam`, `normal`; Bereich `meer`, `kueste`. | Jede syntaktisch vollständige Kombination wird akzeptiert. |
| D05 | Je Schlüssel mindestens ein eindeutig ungültiger Wert. | Exit-Code ungleich 0; Meldung nennt Schlüssel, falschen Wert und zulässige Werte. |
| D06 | Tippfehler wie `kries`, `normla` und `kuste`. | Exit-Code ungleich 0; präzise Wertfehlermeldung. |
| D07 | Jeden erwarteten Schlüssel einzeln entfernen. | Exit-Code ungleich 0; Meldung nennt den fehlenden Schlüssel. |
| D08 | Jeden Schlüssel einzeln doppelt eintragen. | Exit-Code ungleich 0; Meldung nennt den mehrfach vorkommenden Schlüssel. |
| D09 | Unbekannten oder falsch geschriebenen Schlüssel ergänzen. | Exit-Code ungleich 0; Meldung nennt den unbekannten Schlüssel. |
| D10 | Leerzeichen vor oder nach `=` sowie vor Schlüssel oder nach Wert testen. | Exit-Code ungleich 0; Formatmeldung erklärt `SCHLUESSEL=WERT` und verbotene Leerzeichen um `=`. |
| D11 | `ROTATION=` sowie analoge leere Werte. | Exit-Code ungleich 0; leerer Wert wird verständlich gemeldet. |
| D12 | Kommentare vor, zwischen und nach Einstellungen. | Kommentare werden ignoriert; gültige Werte bleiben akzeptiert. |
| D13 | Mehrere leere Zeilen an verschiedenen Stellen. | Leere Zeilen werden ignoriert. |
| D14 | Shell-Sonderzeichen, Befehlsersetzung, Semikolon, Backticks und Umleitungen in Werten. | Exit-Code ungleich 0; kein Befehl wird ausgeführt und keine Nachweisdatei erzeugt. |
| D15 | Datei fehlt. | Exit-Code ungleich 0; verständliche Meldung nennt die fehlende Konfigurationsdatei. |
| D16 | Datei für den tatsächlich aufrufenden Teilnehmer nicht lesbar. | Exit-Code ungleich 0; verständliche Lesbarkeitsmeldung. Dieser Test muss als `waerter`, nicht als Root erfolgen. |
| D17 | Nicht reguläre Datei oder symbolischer Link als Eingabe. | Exit-Code ungleich 0; Eingabe wird nicht als Konfiguration akzeptiert. |
| D18 | Zeile ohne `=`, mehrere `=` oder zusätzliche Zeichen. | Exit-Code ungleich 0; Zeilennummer und Formatproblem werden gemeldet. |
| D19 | Prüfung bei unverändertem Status wiederholen. | Alle Läufe sind seiteneffektfrei; Status, Log, Flag und Marker bleiben unverändert. |

## E. Anwenden und Statusmodell

| ID | Test | Erwartetes Ergebnis |
|---|---|---|
| E01 | Gültige Ausgangskonfiguration mit `./leuchtfeuer-neu-laden` anwenden. | Exit-Code 0; Status enthält die Ausgangswerte. |
| E02 | Gültige Konfiguration mit Rotation `kreis` und Bereich `meer` anwenden. | Status übernimmt exakt die drei geprüften Werte; Story meldet gleichmäßigen Rundlauf; keine Flag. |
| E03 | Vollständigen Küstenzustand anwenden. | Status zeigt Rotation `kreis`, Geschwindigkeit `langsam`, Bereich `kueste`; Küstenmeldung erscheint. |
| E04 | Ungültige Datei anwenden. | Exit-Code ungleich 0; keine teilweise Anwendung und keine Erfolgsmeldung. |
| E05 | Status vor und nach E04 hashen. | Status bleibt bytegenau unverändert. |
| E06 | Datei gültig ändern, aber nicht neu laden; anschließend `./leuchtfeuer-status`. | Laufzeitstatus zeigt weiterhin den zuvor angewendeten Wert und unterscheidet sich bewusst vom gespeicherten Text. |
| E07 | Gültige Änderung anwenden und Log vergleichen. | Log wird um Prüf-, Werte- und Anwendungsmeldungen mit nachvollziehbarem Zeitstempel ergänzt. Beim Küstenzustand kommen die zwei Storymeldungen hinzu. |
| E08 | Dieselbe gültige Konfiguration mehrfach anwenden. | Jeder Lauf endet erfolgreich; State-Datei bleibt vollständig und unbeschädigt; Log erhält vollständige neue Einträge. |
| E09 | Atomare Statusübernahme während und nach dem Schreiben beobachten beziehungsweise temporäre Dateien und Fehlerpfade prüfen. | Leser sehen nur den alten oder den vollständigen neuen Status, niemals eine teilweise Datei; temporäre Dateien bleiben nach Erfolg und Fehler nicht liegen. |
| E10 | `./leuchtfeuer-status` nach bloßer Dateibearbeitung und nach Neuladen vergleichen. | Das Skript zeigt ausschließlich den angewendeten Zustand. |
| E11 | Injectionversuch über die Konfiguration beim Neuladen. | Parser lehnt ab; kein Shellcode wird ausgeführt; Status und Log bleiben unverändert. |

## F. Sicherung, Flag und CHECK

Jeder Flagtest startet mit definiertem Status. Die Ausgabe des Neuladeskripts,
`status/abschlussflagge`, die Flag-Abgabe und `verify.sh` werden getrennt geprüft.

| ID | Zustand oder Aktion | Erwartetes Ergebnis |
|---|---|---|
| F01 | Original mit `cp leuchtfeuer.conf leuchtfeuer.conf.bak` sichern. | Sicherung existiert, gehört `waerter` und entspricht dem unveränderten Ausgangsinhalt. |
| F02 | Vollständigen Missionszustand ohne Sicherung anwenden. | Keine Flag und keine gültige Abschlussflaggen-Datei; Status darf dennoch den gültig angewendeten Betriebszustand zeigen. |
| F03 | Sicherung unter falschem Namen anlegen. | Sie erfüllt die Flagbedingung nicht. |
| F04 | Sicherung mit richtigem Namen, aber falschem oder verändertem Inhalt. | Sie erfüllt die Flagbedingung nicht. |
| F05 | Rotation `kreis`, Geschwindigkeit `langsam`, Bereich `meer`, gültige Originalsicherung. | Keine Flag. |
| F06 | Rotation nicht `kreis`, Bereich `kueste`, gültige Originalsicherung. | Keine Flag. |
| F07 | Rotation `kreis`, Geschwindigkeit nicht `langsam`, Bereich `kueste`, gültige Originalsicherung. | Keine Flag. |
| F08 | Rotation `kreis`, Geschwindigkeit `langsam`, Bereich `kueste`, gültige Originalsicherung. | Exakt `FLAG{die_spur_fuehrt_vom_turm_fort}` wird ausgegeben und sicher in der vorgesehenen Statusdatei bereitgestellt. |
| F09 | Vollständigen Zustand erneut laden. | Dieselbe exakte Flag darf erneut ausgegeben werden; State-Dateien bleiben konsistent. |
| F10 | Falsche Flag mit `flag-einreichen` abgeben. | Abgabe wird abgelehnt; kein gültiger Abgabemarker für die Sitzung entsteht. |
| F11 | Richtige Flag mit führenden oder nachfolgenden Leerzeichen beziehungsweise zusätzlichem Text abgeben. | Nicht-exakte Eingabe wird abgelehnt, sofern die Teilnehmeranweisung keine Normalisierung verspricht. |
| F12 | Exakte Flag abgeben. | Abgabe wird akzeptiert und Marker enthält aktuelle Sitzungskennung sowie erwartetes Ergebnis. |
| F13 | `verify.sh` vor korrekter Abgabe ausführen. | Exit-Code ungleich 0; CHECK erklärt den nächsten Schritt, ohne Zustand zu verändern. |
| F14 | `verify.sh` nach korrekter Abgabe ausführen. | Exit-Code 0; CHECK meldet Erfolg. |
| F15 | CHECK wiederholt ausführen. | Er bleibt erfolgreich; Marker und Workshopzustand werden nicht verändert. |
| F16 | Alten Abgabemarker mit fremder Sitzungskennung einsetzen. | CHECK lehnt ihn ab. |

## G. Reset und vollständiger Wiederholungsdurchlauf

Vor dem Reset werden absichtlich eine Sicherung, geänderte Konfiguration,
angewendeter Küstenstatus, ergänztes Log, Flagdatei und Erfolgsmarker erzeugt.
Zusätzlich wird eine eindeutig benannte fremde Testdatei außerhalb des
Workshopbereichs angelegt und ihr Hash notiert.

| ID | Test nach erneutem vollständigem Setup | Erwartetes Ergebnis |
|---|---|---|
| G01 | Sicherung prüfen. | `leuchtfeuer.conf.bak` wurde entfernt. |
| G02 | Konfiguration prüfen. | Exakter Ausgangstext mit `ROTATION=impuls`, `GESCHWINDIGKEIT=langsam`, `BEREICH=meer`. |
| G03 | Angewendeten Status prüfen. | Exakter Ausgangsstatus mit aktivem Leuchtfeuer und Ausgangswerten. |
| G04 | Log prüfen. | Exakter definierter Anfangslog; vorherige Laufzeitmeldungen sind entfernt. |
| G05 | Flagdatei, Abgabe-, Erfolgs- und alte Sitzungsmarker prüfen. | Keine alte Flag und kein alter Erfolg können den CHECK bestehen. |
| G06 | Fremde Testdatei und Hash prüfen. | Datei außerhalb des Workshopbereichs ist unverändert. Danach wird sie kontrolliert entfernt. |
| G07 | Zweiten kompletten Lernweg durchführen. | Sicherung, Rotation, Prüfung, Neuladen, Küstenänderung, Flag-Abgabe und CHECK funktionieren erneut vollständig. |

## H. Syntax und Repository

Diese Prüfungen laufen vom Workshopverzeichnis beziehungsweise Repository-Root.

| ID | Prüfung | Erwartetes Ergebnis |
|---|---|---|
| H01 | Alle Shellskripte einschließlich eingebetteter, von `setup.sh` erzeugter Skripte mit `bash -n` prüfen. | Keine Syntaxfehler. Für eingebettete Skripte Setup in isolierter Umgebung ausführen und die erzeugten Dateien zusätzlich prüfen. |
| H02 | `jq empty index.json`. | Exit-Code 0. |
| H03 | Alle in `index.json` referenzierten Markdown- und Skriptdateien prüfen. | Jeder Referenzpfad existiert mit exakter Groß-/Kleinschreibung. |
| H04 | Alle Markdown-Platzhalter und vorhandenen Asset-Referenzen prüfen. | Vorgesehene Namen sind konsistent; keine kaputte aktive Bildreferenz. |
| H05 | Ausführungsrechte von `setup.sh`, `verify.sh` und erzeugten Hilfsskripten prüfen. | Alle direkt auszuführenden Skripte besitzen das Ausführungsrecht. |
| H06 | `git diff --check`. | Keine Whitespace-Fehler. |
| H07 | Shellquellen prüfen: keine festen PIDs. | Keine fest codierte Prozess-ID und keine PID-basierte Hintergrundlogik. |
| H08 | Shellquellen nach `eval` durchsuchen. | Keine `eval`-Nutzung. |
| H09 | Prüfen, dass `leuchtfeuer.conf` nie mit `source` oder `.` geladen wird. | Teilnehmerkonfiguration wird ausschließlich als nicht vertrauenswürdiger Text geparst. Ein `source` einer normalen Shell-Profildatei ist getrennt zu bewerten und darf nicht mit Konfigurations-Sourcing verwechselt werden. |
| H10 | Intro, Steps, Challenge und Finish nach `FLAG{` durchsuchen. | Keine offene Flag in Lernschritten. |
| H11 | Workshopdateien nach `/root`, Root-Prompts und Root-Startpfaden durchsuchen. | Keine Teilnehmeranweisung und kein Startmechanismus führt in `/root` oder zeigt `root@leuchtturm`. Technisch notwendige Eigentümerangaben sind davon getrennt. |
| H12 | Titel in `index.json`, Intro, Qualitätsdateien und Metadaten vergleichen. | Neuer Titel ist konsistent; keine alten Workshop-7-Titel zu Prozessen oder Diensten. |
| H13 | Nach `lab-worker`, alten Units, Service-Markern und alter Flag suchen. | Keine aktive technische oder didaktische Altlast. Dokumentierte Negativprüfungen und Changelog-Historie sind zulässig. |
| H14 | `setup.sh` auf `set -Eeuo pipefail`, Quoting und begrenzte Löschziele prüfen. | Strikter Modus aktiv; variable Pfade sind sauber gequotet; Löschungen sind auf validierte Workshop-/State-Pfade begrenzt. |
| H15 | Prüfen, dass `verify.sh` nur den Flag-Abgabestatus liest. | CHECK ist schnell, verändert keinen Lernzustand und verlangt eine zur aktuellen Sitzung gehörende erfolgreiche Abgabe. |

## Empfohlene Ausführungsreihenfolge

1. H – statische Syntax- und Repositoryprüfungen
2. A – frisches und wiederholtes Setup
3. D – Parser und Validierung
4. E – Anwendung und Statusmodell
5. F – Sicherung, Flag und CHECK
6. G – Reset und zweiter Gesamtdurchlauf
7. B – redaktioneller und didaktischer Review
8. C – manueller Nano-Test im echten Killercoda-Terminal
9. vollständiger Anfängerpilot anhand des offenen Lernwegs

## Freigabekriterien

Eine Veröffentlichung wird blockiert, wenn mindestens einer dieser Punkte
zutrifft:

- Startbenutzer oder Startverzeichnis sind falsch;
- Setup ist nicht reproduzierbar oder löscht fremde Dateien;
- Nano ist im Teilnehmerterminal nicht zuverlässig bedienbar;
- der Parser akzeptiert ungültige oder ausführbare Eingaben;
- eine ungültige Konfiguration verändert Status oder Log;
- Status zeigt bloß gespeicherte statt angewendete Werte;
- die Flag erscheint ohne vollständigen Missionszustand und gültige Sicherung;
- CHECK akzeptiert eine falsche, alte oder nicht eingereichte Flag;
- Reset lässt Sicherung, Flag oder Erfolgszustand zurück;
- offene Lerntexte verraten Flag oder vollständige Lösung;
- Shell-, JSON-, Referenz- oder Ausführungsrechtprüfung schlägt fehl.
