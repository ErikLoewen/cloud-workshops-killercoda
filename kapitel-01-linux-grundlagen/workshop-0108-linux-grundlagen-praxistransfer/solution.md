# Musterlösung – Das fragmentierte Archiv

Diese Datei ist eine interne Qualitäts- und Trainerreferenz. Sie wird nicht
durch `index.json` als Teilnehmerschritt veröffentlicht.

## Regulärer Lernweg

### 1. Startzustand und Plan prüfen

Zuerst werden Standort, Archivstruktur und dokumentierter Sollzustand gelesen:

```bash
pwd
ls
cat stabilisierungsplan.txt
./leuchtturm-stabilisieren
```

Die erste Stabilisierung schlägt erwartungsgemäß fehl. Ihre Ausgabe listet
alle direkten `fragment_`-Verzeichnisse auf. Diese Fehlermeldung ist die
Diagnose des ersten zu untersuchenden Zustands.

### 2. Fragmentbereiche untersuchen und gezielt entfernen

Mindestens ein Inhalt wird vor der Löschung gelesen. Für den vollständigen
Lernweg werden alle vier Ziele einzeln kontrolliert:

```bash
ls fragment_FFD700
cat fragment_FFD700/das_gelbe_zeichen.txt

ls fragment_8B0000
cat fragment_8B0000/der_letzte_raum.txt

ls fragment_D6C84B
cat fragment_D6C84B/muster_hinter_der_wand.txt

ls fragment_7G00FF
cat fragment_7G00FF/farbe_ohne_wert.txt
```

Der Stabilisierungsplan schließt Bereiche mit dem Präfix `fragment_`
ausdrücklich aus. Deshalb dürfen genau diese bestätigten Verzeichnisse mit
vollständig ausgeschriebenen Namen entfernt werden:

```bash
rm -r fragment_FFD700
rm -r fragment_8B0000
rm -r fragment_D6C84B
rm -r fragment_7G00FF
ls
./leuchtturm-stabilisieren
```

Eine Wildcard-Löschung ist weder erforderlich noch sicher.

### 3. Rückkehr der Erinnerung beobachten

Die neue Diagnose verweist auf eine Datei unter `erinnerungen`. Zuerst wird
der Bereich angezeigt und die Datei einmal entfernt:

```bash
ls erinnerungen
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ls erinnerungen
```

Nach einem kurzen Moment wird erneut kontrolliert:

```bash
ls erinnerungen
cat erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
```

Die Datei ist zurückgekehrt. Ihr Inhalt nennt den erzeugenden Vorgang:

```text
Erstellt durch: altes_echo
```

### 4. Prozess mit Pipe und `grep` finden

Der verbindliche Prozessfilter lautet:

```bash
ps -eo user,pid,comm | grep altes_echo
```

`ps -eo user,pid,comm` erzeugt eine Liste mit Benutzer, PID und Prozessname.
Die Pipe `|` leitet diese Textausgabe an `grep altes_echo` weiter. `grep`
zeigt nur Zeilen, die den Suchtext enthalten.

Die gefilterte Ausgabe zeigt die passende Prozesszeile:

```text
waerter  1842 altes_echo
```

Vor dem Beenden werden verbindlich geprüft:

- `USER` ist `waerter`;
- `PID` ist eine eindeutige positive Zahl;
- `COMMAND` ist exakt `altes_echo`.

`pgrep` dient als zweite Kontrolle:

```bash
pgrep -a altes_echo
```

Danach wird die tatsächlich beobachtete PID eingesetzt:

```text
kill <GEPRUEFTE_PID>
```

`<GEPRUEFTE_PID>` ist kein wörtlicher Befehlsteil. Die spitzen Klammern und
der Platzhalter werden durch die Zahl aus der eindeutig geprüften
`altes_echo`-Zeile ersetzt. Eine automatische Übergabe aller Suchtreffer an
`kill` wäre hier unsicher.

Der Erfolg wird mit beiden bekannten Sichten kontrolliert:

```bash
ps -eo user,pid,comm | grep altes_echo
pgrep -a altes_echo
```

Die gefilterte Prozessliste soll leer bleiben und `pgrep` keine Instanz mehr
melden.

Erst jetzt wird die zurückgebliebene Datei endgültig entfernt und nach einem
kurzen Moment erneut kontrolliert:

```bash
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ls erinnerungen
./leuchtturm-stabilisieren
```

### 5. Archivschlüssel dem Zielbereich zuordnen

Die Diagnose nennt den aktuellen und den erwarteten Ort. Der Dateiinhalt
begründet die Zuordnung:

```bash
cat erinnerungen/archivschluessel.txt
```

`DOKUMENTTYP` und `ZIELBEREICH` zeigen, dass der Schlüssel in den Bereich
`steuerung` gehört. Er wird verschoben, nicht kopiert:

```bash
mv erinnerungen/archivschluessel.txt steuerung/
ls -l steuerung
./leuchtturm-stabilisieren
```

Damit existiert genau eine Schlüsseldatei am vorgesehenen Ort.

### 6. Echte Nachricht über den Besitzer bestimmen

Die fünf Nachrichten werden gemeinsam mit ihren Metadaten angezeigt:

```bash
ls nachrichten
ls -l nachrichten
whoami
```

`whoami` zeigt `waerter`. Im kontrollierten Szenario ist die Nachricht mit
demselben Besitzer das dokumentierte Vergleichskriterium. Dateinamen wie
`final`, `backup` oder `alt` sind allein kein Echtheitsnachweis.

Die passende Nachricht wird gelesen:

```bash
cat nachrichten/letzte_nachricht_alt.txt
```

Sie nennt:

```text
steuerung/archiv.conf
ERINNERUNG=klar
```

In realen Untersuchungen beweist ein Dateibesitzer allein keine Echtheit. Die
Auswahl ist hier nur deshalb belastbar, weil das kontrollierte Archiv dieses
Merkmal als Vergleichskriterium vorgibt.

### 7. Konfiguration lesen, sichern und bearbeiten

Der bekannte sichere Ablauf aus Workshop 7 wird vollständig angewendet:

```text
lesen
→ sichern
→ ändern
→ prüfen
→ stabilisieren
→ kontrollieren
```

Zuerst werden Original und Sicherung vorbereitet:

```bash
cat steuerung/archiv.conf
cp steuerung/archiv.conf steuerung/archiv.conf.bak
ls -l steuerung/archiv.conf steuerung/archiv.conf.bak
```

Danach wird ausschließlich die aktive Konfiguration geöffnet:

```bash
nano steuerung/archiv.conf
```

In Nano wird die vorhandene Zeile

```ini
ERINNERUNG=fragmentiert
```

zu dieser Zeile geändert:

```ini
ERINNERUNG=klar
```

`Strg+O` speichert, `Enter` bestätigt den Dateinamen und `Strg+X` beendet
Nano. Anschließend werden gespeicherter Inhalt und Syntax kontrolliert:

```bash
cat steuerung/archiv.conf
./steuerung/archiv-pruefen
```

`archiv-pruefen` liefert nur für die syntaktisch gültige stabile
Konfiguration Exit-Code `0`. Bei einem anderen bekannten Wert verweist es
zurück auf die widersprüchlichen Quellen.

### 8. Final stabilisieren und Flag einreichen

Die finale Diagnose wird erneut gestartet:

```bash
./leuchtturm-stabilisieren
```

Die vollständige Erfolgsausgabe enthält die Abschlussflagge. Im regulären
Lernweg wird genau dieser ausgegebene Wert eingereicht:

```bash
flag-einreichen 'FLAG{du_warst_schon_immer_der_waerter}'
```

Danach wird der Killercoda-CHECK gestartet. Der CHECK prüft ausschließlich
die erfolgreiche Flag-Abgabe und nicht erneut Fragmente, Prozess,
Schlüsselort oder Konfiguration.

## Kompakte vollständige Befehlsfolge

Diese Fassung bündelt den regulären Weg. Vor jedem `rm`, `rm -r` und `kill`
müssen die zuvor beschriebenen Sicht- und Identitätsprüfungen tatsächlich
erfolgt sein.

```bash
pwd
ls
cat stabilisierungsplan.txt
./leuchtturm-stabilisieren

ls fragment_FFD700
cat fragment_FFD700/das_gelbe_zeichen.txt
ls fragment_8B0000
cat fragment_8B0000/der_letzte_raum.txt
ls fragment_D6C84B
cat fragment_D6C84B/muster_hinter_der_wand.txt
ls fragment_7G00FF
cat fragment_7G00FF/farbe_ohne_wert.txt

rm -r fragment_FFD700
rm -r fragment_8B0000
rm -r fragment_D6C84B
rm -r fragment_7G00FF
./leuchtturm-stabilisieren

ls erinnerungen
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ls erinnerungen
cat erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt

ps -eo user,pid,comm | grep altes_echo
pgrep -a altes_echo
kill <GEPRUEFTE_PID>
ps -eo user,pid,comm | grep altes_echo
pgrep -a altes_echo
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ls erinnerungen
./leuchtturm-stabilisieren

cat erinnerungen/archivschluessel.txt
mv erinnerungen/archivschluessel.txt steuerung/
ls -l steuerung
./leuchtturm-stabilisieren

ls -l nachrichten
whoami
cat nachrichten/letzte_nachricht_alt.txt

cat steuerung/archiv.conf
cp steuerung/archiv.conf steuerung/archiv.conf.bak
ls -l steuerung/archiv.conf steuerung/archiv.conf.bak
nano steuerung/archiv.conf
cat steuerung/archiv.conf
./steuerung/archiv-pruefen
./leuchtturm-stabilisieren
flag-einreichen 'FLAG{du_warst_schon_immer_der_waerter}'
```

Für `kill <GEPRUEFTE_PID>` wird keine feste Zahl dokumentiert, weil sich PIDs
bei jedem Workshopstart ändern.

## Typische Fehler und Diagnose

| Fehler | Auswirkung und Korrektur |
|---|---|
| `rm` oder `rm -r` am falschen Pfad | Nicht absenden beziehungsweise sofort stoppen. Standort, vollständigen Zielnamen und Stabilisierungsplan erneut prüfen. Bei beschädigtem Zustand Workshop zurücksetzen. |
| Ein `fragment_`-Ordner bleibt bestehen | Die Stabilisierung listet weiterhin alle vorhandenen fremden Bereiche. Nur den konkret bestätigten Rest untersuchen und entfernen. |
| `altes_echo` läuft weiter | Die Datei kehrt nach dem Löschen zurück. Prozess über `USER`, `PID` und `COMMAND` erneut eindeutig prüfen. |
| Eine unpassende Prozesszeile wird gewählt | Die Spalten `USER`, `PID` und `COMMAND` lesen. Nur eine Zeile mit `COMMAND=altes_echo` gehört zum erzeugenden Prozess. |
| Falsche PID ausgewählt | `kill` nicht ausführen. Prozessliste und `pgrep -a altes_echo` erneut vergleichen; niemals nur anhand einer Zahl handeln. |
| Schlüssel kopiert statt verschoben | Mehrere `archivschluessel.txt` erzeugen eine Mehrdeutigkeitsdiagnose. Inhalte vergleichen und genau die unbeabsichtigte Kopie gezielt entfernen. |
| Mehrere Schlüsselkopien vorhanden | Die Stabilisierung nennt alle Fundorte. Genau ein unveränderter Schlüssel muss unter `steuerung` verbleiben. |
| Nachricht wegen `final`, `backup` oder `alt` ausgewählt | Dateiname verwerfen und Besitzer über `ls -l` mit der Ausgabe von `whoami` vergleichen. |
| Besitzer nicht geprüft | Keine Konfigurationsanweisung übernehmen, bevor das dokumentierte Metadatenkriterium kontrolliert wurde. |
| Falscher Konfigurationswert | `archiv-pruefen` verweist auf die widersprüchlichen Quellen. Nachrichtenauswahl erneut begründen. |
| Sicherung vergessen | Vor einer weiteren Änderung den aktuellen Zustand nicht als vermeintlichen Ausgangszustand überschreiben. Wenn die ursprüngliche Fassung benötigt wird, Workshop zurücksetzen. |
| Nano nicht gespeichert | `cat steuerung/archiv.conf` zeigt weiterhin den alten Wert. Nano erneut öffnen, speichern, Dateinamen bestätigen und schließen. |
| Stabilisierung nicht erneut ausgeführt | Der aktuelle Gesamtzustand und die Flag bleiben unbeobachtet. Nach jeder Korrektur erneut diagnostizieren. |
| Flag mit zusätzlichen Zeichen | `flag-einreichen` vergleicht exakt. Wert ohne führende oder nachgestellte Leerzeichen aus der Erfolgsausgabe übernehmen. |

## Wiederherstellung

### Konfiguration aus der Sicherung wiederherstellen

Wenn nur die aktive Konfiguration fehlerhaft bearbeitet wurde und die
Sicherung noch die gewünschte Ausgangsfassung enthält:

```bash
cp steuerung/archiv.conf.bak steuerung/archiv.conf
cat steuerung/archiv.conf
./steuerung/archiv-pruefen
```

Die vorbereitete Sicherung enthält den instabilen Ausgangswert. Die
Wiederherstellung repariert daher eine beschädigte Datei, schließt die Mission
aber nicht ab. Anschließend muss der sichere Bearbeitungsablauf erneut
durchgeführt werden.

### Vollständiger Workshopreset

Bei einem unklaren oder umfassend beschädigten Zustand wird die
Killercoda-Sitzung über die Plattform neu gestartet. Das idempotente Setup:

- beendet ausschließlich eindeutig identifizierte alte Workshopinstanzen von
  `altes_echo`;
- erzeugt den gesamten Teilnehmerbaum im Ausgangszustand neu;
- entfernt alte Sicherungen, Status- und Abgabemarker;
- startet genau eine neue Workshopinstanz von `altes_echo`;
- lässt fremde Prozesse und Dateien außerhalb der Workshoppfade unverändert.

`setup.sh` wird im normalen Lernweg nicht manuell mit erhöhten Rechten
gestartet.

## Trainer-/Testabschnitt: priorisierter Speedrun

Dieser Abschnitt gehört nicht in sichtbare Lerntexte oder Dropdowns. Der
Speedrun ist ausschließlich ein absichtlicher technischer Regressionstest und
kein Produktionsmuster.

Aus einem frischen Ausgangszustand wird eine formal exakte Konfigurationsdatei
mit genau einem bekannten Schlüssel und einem abschließenden Zeilenumbruch
erzeugt:

```bash
printf '%s\n' 'ERINNERUNG=klar' > steuerung/archiv.conf
./leuchtturm-stabilisieren
```

Der zweite Befehl muss unmittelbar erfolgreich sein und die Flag ausgeben,
obwohl Fragmente, Echo, wiederkehrende Datei und falscher Schlüsselort noch
vorhanden sind. So werden Parser und Erfolgspfad schnell getestet. In einem
realen Stabilisierungssystem wäre das Überspringen unabhängiger Fehler wegen
eines einzelnen Konfigurationswerts fachlich nicht angemessen.

Für einen vollständigen Speedrun-Test wird die ausgegebene Flag anschließend
exakt eingereicht und der CHECK gestartet. Falsche Eingaben sowie führende
oder nachgestellte Leerzeichen müssen weiterhin abgelehnt werden.
