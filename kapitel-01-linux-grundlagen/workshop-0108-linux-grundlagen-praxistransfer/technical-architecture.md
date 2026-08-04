# Technische Zielarchitektur – Workshop 0108

Status: verbindliche Architektur in schrittweiser Umsetzung  
Arbeitstitel: `01.08 – Das fragmentierte Archiv`

Diese Datei legt die technische Zielarchitektur und den jeweils erreichten
Migrationsstand fest.

## 1. Architekturziele

- reproduzierbarer Start als `waerter@leuchtturm`;
- Startverzeichnis `/home/waerter/leuchtturm/archiv`;
- keine sichtbare Root-Shell und keine sichtbare Setupausgabe;
- kein `sudo` im Teilnehmerweg;
- keine künstliche Wartezeit oder sichtbare Ready-Schleife;
- ein klar begrenzter, wiederholbarer Diagnose- und Korrekturzyklus über
  `./leuchtturm-stabilisieren`;
- genau ein neues kleines Bedienkonzept: `ps ... | grep SUCHTEXT`;
- sichere Prozessidentifikation und begrenzte Löschziele;
- Konfigurationsdaten niemals mit `source` oder `eval` auswerten;
- sitzungsgebundene Flag-Abgabe und ein reiner Flag-only-CHECK;
- ein ausdrücklich priorisierter, im Lerntext unsichtbarer Speedrun-Testpfad.

## 2. Unterstützte Killercoda-Struktur

`index.json` verwendet weiterhin ausschließlich bereits im Repository
belegte Felder:

- `details.intro.text`;
- `details.intro.foreground` mit `setup.sh`;
- `details.steps[].text`;
- optional `details.steps[].background`, falls der Prozessstart später vom
  Setup getrennt werden muss;
- `details.steps[].verify` ausschließlich beim Abschluss;
- `details.finish.text`;
- `backend.imageid` mit dem bestehenden Wert `ubuntu`.

Der bevorzugte Entwurf startet `altes_echo` bereits still im
Intro-Foreground. Ein Killercoda-Background-Skript ist dafür nicht nötig.

## 3. Benutzer- und Startmodell

Das Setup übernimmt das nachweislich funktionierende Muster aus Workshop 7:

1. Gruppe und Benutzer `waerter` bei Bedarf anlegen.
2. Home auf `/home/waerter` und Shell auf `/bin/bash` festlegen.
3. Hostname bestmöglich auf `leuchtturm` setzen.
4. Arbeitsbaum reproduzierbar als `waerter:waerter` anlegen.
5. `.bash_profile` erzeugen, `.bashrc` laden und in das Archiv wechseln.
6. `.bashrc` mit dem Workshop-Prompt sowie der üblichen farbigen
   `ls`-Ausgabe ausstatten.
7. Setupausgabe vor dem Benutzerwechsel leeren.
8. Mit `exec su - waerter` in die Teilnehmer-Shell wechseln.

Die `.bash_profile` wechselt exakt nach:

```text
/home/waerter/leuchtturm/archiv
```

Interne Installations-, Prozessstart- und Bereitschaftsprüfungen schreiben
nur in ein technisches Log. Eine gegebenenfalls nötige, kurze und begrenzte
interne Prozessprüfung erscheint nicht im Teilnehmerterminal und enthält
keine künstliche Mindestwartezeit.

## 4. Teilnehmerstruktur

Ausgangszustand:

```text
/home/waerter/leuchtturm/archiv/
├── stabilisierungsplan.txt
├── leuchtturm-stabilisieren
├── erinnerungen/
│   ├── ERINNERUNG_KEHRT_ZURUECK.txt
│   └── archivschluessel.txt
├── nachrichten/
│   ├── letzte_nachricht.txt
│   ├── letzte_nachricht_2.txt
│   ├── letzte_nachricht_alt.txt
│   ├── letzte_nachricht_final.txt
│   └── letzte_nachricht_backup.txt
├── protokolle/
├── steuerung/
│   ├── archiv.conf
│   ├── archiv-pruefen
│   └── archiv-status
├── fragment_FFD700/
│   └── das_gelbe_zeichen.txt
├── fragment_8B0000/
│   └── der_letzte_raum.txt
├── fragment_D6C84B/
│   └── muster_hinter_der_wand.txt
└── fragment_7G00FF/
    └── farbe_ohne_wert.txt
```

Der Name `fragment_7G00FF` wird trotz des nicht hexadezimalen Zeichens `G`
absichtlich exakt übernommen. Er ist Teil der erzählten Inkonsistenz und
kein Farbwert, den die Technik interpretieren darf.

Normaler Zielzustand:

- alle vier `fragment_*`-Verzeichnisse fehlen;
- `altes_echo` läuft nicht;
- `ERINNERUNG_KEHRT_ZURUECK.txt` fehlt dauerhaft;
- `archivschluessel.txt` liegt unter `steuerung/` statt unter
  `erinnerungen/`;
- die fünf Nachrichten bleiben als Ermittlungsquellen unverändert;
- eine Sicherung der Ausgangskonfiguration kann im Lernweg verlangt werden,
  ist aber bewusst keine technische Erfolgsbedingung;
- `steuerung/archiv.conf` enthält kanonisch `ERINNERUNG=klar`;
- `protokolle/archiv-status.txt` bleibt der getrennte angewendete
  Ausgangsstatus; das Diagnosewerkzeug verändert ihn nicht.

## 5. Interne Struktur

```text
/usr/local/lib/labforge/workshop-0108/
├── altes_echo
├── altes-echo-starten
├── archiv-parser
└── optional: workshop-cleanup

/var/lib/labforge/fragmentiertes-archiv/
├── session-id
├── altes-echo.marker
└── setup.log
```

Interne Programme werden `root:root` mit Modus `0755` installiert. Sie sind
für Teilnehmer nicht beschreibbar.

## 6. Datei-für-Datei-Verantwortlichkeiten

### Repositorydateien

| Datei | Verantwortung |
|---|---|
| `index.json` | Sichtbare Reihenfolge, Titel, Intro-Foreground und Abschluss-CHECK. |
| `setup.sh` | Idempotenter Reset, Benutzerstart, Dateibaum, Installation interner Werkzeuge, Prozessstart und Session-ID. |
| `verify.sh` | Ausschließlich erfolgreiche, sitzungsgebundene Flag-Abgabe prüfen; keinen Missionszustand verändern oder erneut validieren. |
| `intro.md` | Geschichte, Mission, Startzustand und wiederholtes Stabilisierungskommando einführen. |
| `step*.md` | Jeweils einen Diagnosezustand bearbeiten; bekannte Werkzeuge selbstständig auswählen lassen. |
| `challenge.md` | Letzte selbstständige Gesamtkontrolle, Flag lesen, einreichen und CHECK starten. |
| `finish.md` | Kapitelabschluss, Wirkungskette, Abruf und Plot-Twist nach erfolgreicher Stabilisierung. |
| `solution.md` | Vollständiger normaler Lösungsweg; interner Hinweis auf Speedrun nur klar getrennt als Testpfad. |
| `trainer-guide.md` | Hilfestufen, Sicherheitsgrenzen, Prozess- und Löschinterventionen sowie menschlich zu prüfende Transferleistung. |
| `test-plan.md` | Statische, technische, negative, Speedrun-, Flag-, Killercoda- und Pilottests. |
| `test-results.md` | Tatsächlich ausgeführte Tests mit Umgebung und offengebliebenen Browserprüfungen. |
| `CHANGELOG.md` | Historie der vollständigen Migration. |

### Teilnehmerdateien

| Datei | Verantwortung |
|---|---|
| `stabilisierungsplan.txt` | Rollen, Schutzgrenzen, Diagnosezyklus und zulässige Zielzustände beschreiben, ohne vollständige Befehlsfolge. |
| `leuchtturm-stabilisieren` | Speedrun priorisieren, normalen Zustand diagnostizieren, genau den nächsten Fehler melden und bei Erfolg Flag und Plot-Twist ausgeben, ohne Dateien zu verändern. |
| `ERINNERUNG_KEHRT_ZURUECK.txt` | Sichtbarer Effekt des laufenden Prozesses; wird von `altes_echo` erneut erzeugt. |
| `archivschluessel.txt` | Muss unverändert von `erinnerungen/` nach `steuerung/` verschoben werden. |
| fünf Nachrichtendateien | Widersprüchliche Aussagen liefern, aus denen `ERINNERUNG=klar` begründet abgeleitet wird; sie werden nicht verändert. |
| `steuerung/archiv.conf` | Zu sichernde und anschließend mit Nano zu korrigierende aktive Konfiguration. |
| `steuerung/archiv-pruefen` | Öffentlicher, nicht verändernder Wrapper um den internen Parser. |
| `steuerung/archiv-status` | Den zuletzt atomar angewendeten beziehungsweise stabilisierten Status anzeigen. |
| vier Fragmentdateien | Kontrollierte Löschziele innerhalb eindeutig benannter Fragmentordner. |

### Interne Dateien

| Datei | Verantwortung |
|---|---|
| `altes_echo` | Als `waerter` laufender, eindeutig benannter Prozess; erzeugt nur die festgelegte Erinnerungsdatei erneut und beendet sich sauber bei `TERM` oder `INT`. |
| `altes-echo-starten` | Genau eine Instanz starten, Prozessidentität prüfen und Marker atomar schreiben. |
| `archiv-parser` | `archiv.conf` ohne Codeausführung syntaktisch und semantisch validieren sowie normalisiert ausgeben. |
| `workshop-cleanup` | Optional dieselbe eng begrenzte Prozess- und Pfadbereinigung für Tests kapseln; kein Teilnehmerwerkzeug. |
| `session-id` | Neue UUID pro Setup; reguläre, nicht symbolische Datei. |
| `altes-echo.marker` | Session-ID, PID, Prozessname, Executable und Ergebnis des Starts. |
| `protokolle/stabilisierung.marker` | Sitzungsgebundener technischer Erfolgsnachweis des Stabilisierungsskripts. |
| `protokolle/flag-submitted.marker` | Ausschließlich durch korrekte Flag-Abgabe atomar erzeugter CHECK-Nachweis. |
| `/usr/local/bin/flag-einreichen` | Genau ein Flag-Argument exakt prüfen und nur bei Erfolg den sitzungsgebundenen Abgabemarker atomar erzeugen. |

## 7. Prozessarchitektur `altes_echo`

Der Prozess verwendet eine eigene installierte Executable mit dem eindeutigen
Namen `altes_echo`. Ein generischer `sleep`-, `bash`- oder `python`-Name ist
nicht zulässig.

Startbedingungen:

- genau eine zur aktuellen Session gehörende Instanz;
- Besitzer `waerter`;
- erwarteter `/proc/PID/comm`;
- erwartetes erstes Argument aus `/proc/PID/cmdline`;
- von Terminalein- und -ausgabe getrennt;
- keine nennenswerte CPU-Last;
- Prüfintervall ungefähr drei Sekunden;
- ausschließlich Schreibzugriff auf
  `erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt`.

Der Teilnehmerweg zur Beendigung lautet konzeptionell:

```text
ps ... | grep altes_echo
→ pgrep -a altes_echo
→ eindeutige PID begründen
→ kill PID
→ pgrep -a altes_echo
→ zurückkehrende Datei entfernen
→ kurz durch erneute Sichtkontrolle bestätigen, dass sie fortbleibt
```

Die Pipe wird nur als Weiterleitung der linken Ausgabe an den rechten Filter
erklärt. `grep` wird ausschließlich als Zeilenfilter nach einem Suchtext
eingeführt. `pgrep` bleibt der bekannte eindeutige Sicherheitsnachweis vor
`kill`.

## 8. Parservertrag

`archiv-parser` akzeptiert im normalen Modus:

- genau eine reguläre, lesbare Datei;
- keinen Symlink;
- Zeilen im Format `SCHLUESSEL=WERT`;
- optional leere Zeilen und Kommentarzeilen, die mit `#` beginnen;
- ausschließlich den Schlüssel `ERINNERUNG`;
- genau ein Vorkommen dieses Schlüssels;
- die Werte `fragmentiert`, `strukturiert`, `eins`, `ungeteilt`, `vereint`
  und `klar`; nur `klar` ist fachlich stabil.

Abgelehnt werden insbesondere:

- fehlende, nicht reguläre oder nicht lesbare Dateien;
- Symlinks;
- leere Werte;
- Leerzeichen um `=`;
- unbekannte oder doppelte Schlüssel;
- zusätzliche Trennzeichen;
- unbekannte Werte;
- Shellsyntax und andere Sonderzeichen.

Der Parser führt niemals Dateiinhalte aus. Exit-Code `0` bedeutet ausschließlich
den stabilen Wert `klar`; bekannte instabile und vollständig unbekannte Werte
werden mit unterscheidbaren Diagnosen und Exit-Code `1` gemeldet.

## 9. Prüfpriorität von `leuchtturm-stabilisieren`

Verbindliche Priorität:

```text
0  technische Vorbedingungen und Parser verfügbar
1  Speedrun-Prädikat prüfen
2  alle fragment_*-Ordner prüfen
3  zurückkehrende Datei und altes_echo prüfen
4  Ort und Unverändertheit des Archivschlüssels prüfen
5  archiv.conf im normalen Missionskontext prüfen
6  Erfolg, Flag und Plot-Twist ausgeben
```

Normale Diagnosemeldungen erscheinen in dieser Reihenfolge:

1. Fremde Fragmentbereiche verhindern eine eindeutige Archivstruktur.
2. Eine gelöschte Erinnerung wird durch `altes_echo` erneut erzeugt.
3. Der Archivschlüssel liegt im falschen Verzeichnis.
4. Die fünf letzten Nachrichten widersprechen sich oder die
   Archivkonfiguration steht noch auf `ERINNERUNG=fragmentiert`.
5. Der Zustand ist stabil; Flag und Plot-Twist werden ausgegeben.

Pro Aufruf wird höchstens der erste fachliche Fehler gemeldet. Die Meldung
enthält Beobachtung, erwarteten Zustand und einen nächsten lesenden
Prüfschritt, stellt die Lösung aber nicht selbst her.

### Fragmentregeln

Alle vier Fragmentordner sind freigegebene Ziele. Damit bekannte
Löschhandlungen tatsächlich kombiniert werden, legt der Lerntext verbindlich
fest:

- einzelne Fragmentdateien dürfen zunächst mit `rm` entfernt werden;
- danach werden leere Fragmentordner mit `rmdir` entfernt;
- genau ein ausdrücklich benannter, noch nicht leerer Fragmentordner darf als
  kontrollierter Transfer mit `rm -r` entfernt werden;
- `/home/waerter/leuchtturm/archiv` und jeder Elternpfad sind niemals
  rekursive Ziele.

Der technische Erfolg hängt nur am Endzustand und nicht an der verwendeten
Befehlsreihenfolge.

## 10. Zustandsdiagramm

```text
                    ┌─────────────────────────────┐
                    │ Setup / Ausgangszustand     │
                    │ Session + altes_echo aktiv  │
                    └──────────────┬──────────────┘
                                   │
                         Parser technisch nutzbar?
                                   │ nein
                                   ▼
                    [technischer Szenariofehler]
                                   │
                                   │ ja
                                   ▼
                    archiv.conf exakt kanonisch klar?
                         │ ja                 │ nein
                         ▼                    ▼
                [SPEEDRUN-ERFOLG]     Fragmentordner vorhanden?
                         │                    │ ja
                         │                    ▼
                         │           [FRAGMENTE BESEITIGEN]
                         │                    │ nein
                         │                    ▼
                         │        Datei oder altes_echo vorhanden?
                         │                    │ ja
                         │                    ▼
                         │           [ECHO SICHER STOPPEN]
                         │                    │ nein
                         │                    ▼
                         │        Archivschlüssel am Zielort?
                         │                    │ nein
                         │                    ▼
                         │           [SCHLÜSSEL VERSCHIEBEN]
                         │                    │ ja
                         │                    ▼
                         │      Konfiguration fragmentiert/ungültig?
                         │                    │ ja
                         │                    ▼
                         │       [SICHERN, BEARBEITEN, PRÜFEN]
                         │                    │
                         └────────────────────┴───────────────┐
                                                             ▼
                                         [FLAG + PLOT-TWIST]
                                                             │
                                                             ▼
                                             [FLAG-ABGABE → CHECK]
```

## 11. Speedrun-Konzept

Der Speedrun ist ein absichtlicher Testpfad für schnelle technische
Regressionstests. Er ist ausdrücklich kein Produktionsmuster: In einem realen
Stabilisierungssystem wäre es fachlich falsch, einen einzelnen
Konfigurationswert über unabhängige Dateisystem- und Prozessfehler zu stellen.
Hier wird diese Priorität ausschließlich verlangt, damit Parser, Erfolgspfad,
Flag und CHECK schnell und deterministisch getestet werden können.

Prüfung unmittelbar am Anfang:

1. `steuerung/archiv.conf` existiert als reguläre, nicht symbolische Datei.
2. Der vollständige Parser akzeptiert die Datei.
3. Es gibt keine unbekannten oder doppelten Schlüssel.
4. Der effektive Konfigurationseintrag lautet exakt:

```text
ERINNERUNG=klar
```

Kommentare und Leerzeilen bleiben entsprechend dem Parservertrag erlaubt.
Weitere Schlüssel, doppelte Einträge und unbekannte Werte verhindern den
Speedrun.

Bei erfülltem Prädikat:

- Fragment-, Prozess-, Datei-, Schlüssel- und Nachrichtenprüfungen
  überspringen;
- keine Missionsprüfung und keine Datei verändern;
- Abschlussflagge ausgeben;
- denselben Plot-Twist wie im normalen Erfolgspfad ausgeben;
- Exit-Code `0` liefern.

Der Speedrun wird nicht in `intro.md`, Schritten, sichtbaren Dropdowns,
`challenge.md` oder `finish.md` erwähnt. Er wird nur intern, in der
Musterlösung als nicht teilnehmerwirksamer Testhinweis sowie in Testplan und
Testergebnissen dokumentiert.

## 12. Erfolgs- und Flagmodell

Normaler Zielzustand und Speedrun rufen dieselbe interne Erfolgsfunktion auf.
Sie gibt Stabilisierung, Plot-Twist und Flag im Terminal aus, verändert keine
Datei und funktioniert bei wiederholtem Aufruf identisch. Sobald
`ERINNERUNG=klar` sicher geparst wurde, ist technisch stets das priorisierte
Speedrun-Prädikat erfüllt; ein vollständig bereinigter normaler Zielzustand
wird deshalb als eigener Endzustand getestet, erreicht aber dieselbe
Erfolgsfunktion über dieses Prädikat.

Eine Konfigurationssicherung ist didaktisch sinnvoll, aber nicht Teil der
technischen Erfolgsbedingung. So bleibt das Diagnosewerkzeug zustandsbasiert
und verlangt weder einen bestimmten Sicherungsnamen noch eine bestimmte
Befehlsreihenfolge.

`flag-einreichen`:

- verlangt genau ein Argument;
- prüft die aktuelle Session-ID und vergleicht die eingegebene Flag exakt;
- akzeptiert weder führende noch nachgestellte Leerzeichen;
- erzeugt nur bei Erfolg atomar `flag-submitted.marker`;
- nennt danach den CHECK als nächsten Schritt.

Die Flag wird im sichtbaren Lernweg ausschließlich durch
`leuchtturm-stabilisieren` ausgegeben. `flag-einreichen` wiederholt sie weder
bei Erfolg noch bei Fehlern. `verify.sh` prüft ausschließlich Session-ID und
Abgabemarker. Es prüft weder Fragmente noch Prozess, Schlüssel, Nachrichten,
Konfiguration oder Befehlsreihenfolge und verändert keinen Zustand.

## 13. Cleanup-Konzept

Cleanup findet zu Beginn jedes Setups statt:

1. Statische Zielpfade auf Nichtleere, exakte Übereinstimmung und gefährliche
   Elternpfade prüfen.
2. Vorherige Session-ID und `altes-echo.marker` nur aus regulären Dateien
   lesen.
3. Gespeicherte PID nur beenden, wenn gleichzeitig gelten:
   - positive numerische PID;
   - `/proc/PID` lesbar;
   - Besitzer `waerter`;
   - erwarteter Prozessname `altes_echo`;
   - erwartete installierte Executable;
   - Marker gehört zur vorherigen Session.
4. Zunächst `TERM` senden und begrenzt intern prüfen, ob genau dieser Prozess
   beendet ist.
5. Kein pauschales `pkill`, `killall` oder Killen nur nach Namen.
6. Nur diese statischen Bäume reproduzierbar entfernen:
   - `/home/waerter/leuchtturm/archiv`;
   - `/var/lib/labforge/fragmentiertes-archiv`;
   - `/usr/local/lib/labforge/workshop-0108`.
7. Fremde Prozesse, unklare PIDs und Symlink-Stämme nicht verändern, sondern
   als technischen Szenariofehler melden.
8. Erst danach neue Session und neuen Teilnehmerbaum anlegen.

Ein optionales internes Cleanup-Skript darf diesen Ablauf für automatisierte
Tests kapseln. `setup.sh` bleibt die maßgebliche Orchestrierung.

## 14. Eigentümer- und Rechtemodell

| Bereich | Eigentümer | Modus | Begründung |
|---|---|---:|---|
| `/home/waerter` | `waerter:waerter` | `0750` | Teilnehmer-Home. |
| Leuchtturm- und Archivverzeichnisse | `waerter:waerter` | `0755` | Navigation und kontrollierte Dateiarbeit. |
| Teilnehmertexte und Konfiguration | `waerter:waerter` | `0644` | Lesbar; Konfiguration mit Nano bearbeitbar. |
| Teilnehmerwerkzeuge | `waerter:waerter` | `0755` | Direkt ohne `sudo` ausführbar. |
| `letzte_nachricht.txt` | `olmstead:<Primärgruppe>` | `0644` | Strukturierte, aber widersprüchliche Quelle; bei Neuanlage wird die Gruppe `olmstead` erzeugt. |
| `letzte_nachricht_2.txt` | `root:root` | `0644` | Widersprüchliche Quelle. |
| `letzte_nachricht_alt.txt` | `waerter:waerter` | `0644` | Belastbare Quelle; Besitzer ist das einzige dokumentierte Auswahlkriterium. |
| `letzte_nachricht_final.txt` | `nobody:<Primärgruppe>` | `0644` | Widersprüchliche Quelle; im geprüften Zielimage ist die Gruppe `nogroup`. |
| `letzte_nachricht_backup.txt` | `daemon:daemon` | `0644` | Widersprüchliche Quelle. |
| `/usr/local/lib/labforge/workshop-0108` | `root:root` | Verzeichnis `0755` | Interne Implementierung nicht vom Teilnehmer veränderbar. |
| interne Programme | `root:root` | `0755` | Sicherer Parser und Prozessidentität. |
| State-Verzeichnis | `root:root` | `0755` | Technischer Stamm. |
| `session-id` | `root:root` | `0644` | Für sitzungsgebundene Teilnehmerwerkzeuge lesbar, nicht beschreibbar. |
| interne Prozessmarker | `root:root` | `0644` | Vom Root-Starter erzeugt. |
| sichtbare Protokolle | `waerter:waerter` | `0644` | Durch Teilnehmer lesbar. |
| Flag-Abgabemarker unter `protokolle/` | `waerter:waerter` | `0644` | Atomar durch das Abgabewerkzeug erzeugt; Session-Inhalt wird vom CHECK validiert. |
| `/usr/local/bin/flag-einreichen` | `root:root` | `0755` | Exakter, für Teilnehmer nicht veränderbarer Flagvergleich. |

Es gibt kein pauschales `chmod -R`. Modi werden nach Dateifunktion gesetzt
und anschließend mit `stat` geprüft.

## 15. Teststrategie

### Statische Tests

- `jq empty index.json`;
- `bash -n` für Setup, Verify und alle erzeugten beziehungsweise
  repositorybasierten Shellskripte;
- alle `index.json`-Referenzen vorhanden;
- Ausführungsrechte korrekt;
- Dropdowns ausgeglichen;
- keine Inhalte oder Referenzen des abgelösten Workshop-Szenarios;
- Speedrun in keinem sichtbaren Lerntext;
- `git diff --check`.

### Setup- und Starttests

- frischer Start als `waerter`;
- Prompt `waerter@leuchtturm`;
- Startpfad exakt `/home/waerter/leuchtturm/archiv`;
- keine Root-Shell, Setupausgabe oder Ready-Schleife sichtbar;
- vollständiger Ausgangsbaum mit exakten Inhalten und Modi;
- `altes_echo` genau einmal und als `waerter` aktiv;
- Setup zweimal ohne doppelte Instanz;
- eindeutig eigene Altinstanz beendet;
- fremde oder nicht eindeutig passende Prozesse nicht beendet;
- Sentinel außerhalb der drei Cleanup-Bäume unverändert.

### Diagnosefolge

- erster normaler Aufruf meldet ausschließlich Fragmente;
- nach Fragmentbereinigung meldet der nächste Aufruf ausschließlich Echo;
- nach Prozessende und dauerhafter Dateientfernung ausschließlich den
  Schlüsselort;
- nach Verschieben des unveränderten Schlüssels ausschließlich Nachrichten
  beziehungsweise Konfiguration;
- nach Sicherung und kanonischer Korrektur Erfolg;
- wiederholter Erfolgsaufruf bleibt erfolgreich und idempotent.

### Prozess- und Löschtests

- Datei kehrt bei laufendem Prozess zurück;
- `ps ... | grep` zeigt die erwartete Zeile;
- `pgrep -a altes_echo` ist eindeutig;
- `TERM` beendet den Prozess sauber;
- nach Prozessende bleibt die entfernte Datei fort;
- falsche PID und fremder Besitzer werden nicht beendet;
- `rm`, `rmdir` und das eine kontrollierte `rm -r` erreichen denselben
  geforderten Endzustand;
- Elternpfade und Nicht-Fragmentbereiche bleiben erhalten.

### Parsertests

- gültig `fragmentiert` und `klar`;
- fehlende, nicht reguläre, nicht lesbare und symbolische Datei;
- leerer, unbekannter oder doppelter Schlüssel;
- leerer oder unbekannter Wert;
- Leerzeichen um `=`;
- Kommentare und Leerzeilen im normalen Modus;
- Shell-Sonderzeichen werden abgelehnt und niemals ausgeführt.

### Speedruntests

- unmittelbar nach frischem Setup nur `archiv.conf` kanonisch auf
  `ERINNERUNG=klar` setzen;
- Erfolg trotz vorhandener Fragmente, Echo, falschem Schlüsselort und
  widersprüchlichen Nachrichten;
- Flag wie im normalen Erfolgspfad;
- Kommentare und Leerzeilen bleiben erlaubt; kein Speedrun bei zusätzlichem
  Schlüssel, Duplikat, Symlink oder ungültigem Wert;
- Hintergrundprozess darf nach dem absichtlichen Speedrun weiterlaufen und
  wird spätestens vom nächsten Setup sicher bereinigt.

### Flag-only-CHECK

- CHECK vor Abgabe fehlschlägt;
- falsche Flag erzeugt keinen Marker;
- korrekte Flag erzeugt einen atomaren sitzungsgebundenen Marker;
- fremde Session wird abgelehnt;
- CHECK besteht sofort und wiederholt;
- spätere Änderungen an Missionsdateien oder Prozess beeinflussen den CHECK
  nach korrekter Abgabe nicht;
- CHECK verändert keine Datei und startet oder beendet keinen Prozess.

### Manuelle Killercoda-Prüfungen

- realer Browserstart und Prompt;
- Nano-Tastaturbedienung;
- Eingabe des Pipe-Zeichens;
- verständliche Prozessausgabe;
- Dropdown- und Bilddarstellung;
- tatsächliche Bearbeitungszeit;
- Anfängerpilot mit dokumentierter höchster Hinweisstufe.

## 16. Geplante Bildassets

Die folgenden Bildassets sind vorhanden und werden aus dem sichtbaren
Markdown referenziert:

- `assets/0108-einstieg-fragmentiertes-archiv.png`;
- `assets/0108-pipe-und-grep.png`;
- `assets/0108-abschluss-identitaet.png`;

## 17. Implementierungsstand

Technisch vorbereitet sind:

- Benutzer- und Startmechanismus;
- der neue Teilnehmerbaum;
- `altes_echo` und sein interner Starter;
- Session-, Prozess- und Setup-State;
- idempotenter, eng begrenzter Reset;
- sicherer Parser und Konfigurationsprüfung;
- vollständige priorisierte Stabilisationsdiagnose einschließlich Speedrun;
- neue Metadaten und sichtbare Step-Struktur;
- vollständige Lerntexte mit gestuften Dropdowns;
- Challenge, Flag-Abgabe und Flag-only-CHECK;
- Lösung, Trainerleitfaden, Testplan und ausgeführter lokaler Testbericht;
- Einstiegs-, Pipe-und-grep- sowie Abschlussgrafik.

Noch nicht umgesetzt sind reale Killercoda-Browser-, TTY-, Nano- und
Pilottests.
