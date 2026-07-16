# Testplan: Das Terminal sicher bedienen

## Teststatus

- Statische Prüfungen: bei Dateierstellung auszuführen.
- Lokale technische Tests: soweit ohne Killercoda möglich auszuführen und getrennt dokumentieren.
- Reale Killercoda-Tests: vor Veröffentlichung erforderlich.
- Anfängerpilot: vor Veröffentlichung erforderlich.

## Technische Prüflogik

`setup.sh` startet einen externen Beobachter. Der Beobachter bevorzugt die Zuordnung über das ermittelte interaktive Bash-Terminal. In technischen Testumgebungen ohne sichtbare TTY-Zuordnung verwendet er als begrenzten Rückfall den direkten Kindprozess der ermittelten interaktiven Bash-Shell. In beiden Fällen werden nur Prozesse mit exakt zwei Befehlsbestandteilen berücksichtigt: `sleep` und `30`.

Er speichert Prozess-ID und Linux-Startzeit. `verify.sh` liest diese Daten und prüft nur, ob genau dieser Prozess noch existiert.

Die Skripte überschreiben weder `echo` noch `sleep`. Der CHECK beendet keinen Prozess und stellt keinen Lernzustand her.

## 1. Frischer Szenariostart

### Vorgehen

1. Szenario in einer frischen Killercoda-Sitzung starten.
2. Prüfen, dass Intro und Terminal erscheinen.
3. Prüfen, dass keine Erfolgsmeldung oder sichtbare Musterlösung vorab erzeugt wurde.
4. Prüfen, dass `echo` und `sleep` normales Shell-Verhalten zeigen.

### Erwartung

- definierte Ausgangslage,
- Beobachter läuft im Hintergrund,
- kein Startmarker für die Übung,
- kein Übungsprozess.

## 2. Setup erneut ausführen

### Vorgehen

`setup.sh` in der Testumgebung erneut starten.

### Erwartung

- ein früherer eigener Beobachter wird beendet;
- kein fremder Prozess wird verändert;
- alte Prüfdaten werden entfernt;
- genau ein neuer Beobachter wird gestartet;
- erneuter Aufruf bleibt fehlerfrei.

## 3. CHECK direkt nach Start

### Vorgehen

Ohne `sleep 30` den CHECK auslösen.

### Erwartung

- Exit-Code ungleich 0;
- verständlicher Hinweis, dass die Übung noch nicht erkannt wurde;
- kein Marker wird erzeugt;
- kein Prozess wird gestartet oder beendet.

## 4. Übungsprozess läuft noch

### Vorgehen

1. In der Abschlussaufgabe `sleep 30` starten.
2. Während der Prozess noch läuft den CHECK über die Oberfläche auslösen.

### Erwartung

- Start wurde registriert;
- CHECK liefert Exit-Code ungleich 0;
- Rückmeldung nennt den noch laufenden Übungsprozess;
- CHECK beendet ihn nicht.

## 5. Übungsprozess wurde beendet

### Vorgehen

1. `sleep 30` starten.
2. Mit Ctrl+C beenden.
3. CHECK auslösen.

### Erwartung

- Exit-Code 0;
- Erfolgsmeldung bezeichnet das Ergebnis als technische Teilprüfung;
- keine Behauptung, Ctrl+C sei technisch erkannt worden.

## 6. `sleep 30` endet regulär

### Vorgehen

1. `sleep 30` starten.
2. 30 Sekunden abwarten.
3. CHECK auslösen.

### Erwartung

- Exit-Code 0 ist technisch möglich und zulässig;
- Erfolgsmeldung behauptet keine vorzeitige Unterbrechung;
- Trainerleitfaden verlangt weiterhin menschliche Prüfung von Ctrl+C.

## 7. Fremder `sleep`-Prozess läuft

### Vorgehen

Vor der Abschlussübung einen nicht zugeordneten `sleep`-Prozess ohne Vordergrundbindung oder an einem anderen Terminal starten.

### Erwartung

- fremder Prozess wird nicht registriert;
- fremder Prozess wird nicht beendet;
- CHECK bewertet ausschließlich den registrierten Übungsprozess.

## 8. Mehrere fremde `sleep`-Prozesse laufen

### Vorgehen

Mehrere Prozesse mit anderen Zeitargumenten sowie ohne Vordergrundbindung starten.

### Erwartung

- keiner wird als Übung registriert;
- keiner wird verändert;
- CHECK bleibt ohne Übungsregistrierung erfolglos.

## 9. CHECK wird wiederholt

### Vorgehen

Nach einem erfolgreichen CHECK den CHECK mehrfach erneut auslösen.

### Erwartung

- jeder Aufruf liefert denselben technischen Zustand;
- keine Prüfdaten werden verändert;
- kein Prozess wird gestartet oder beendet.

## 10. Szenario vollständig neu starten

### Vorgehen

Sitzung beenden und das Szenario frisch starten.

### Erwartung

- keine Prüfdaten aus der vorherigen Sitzung;
- kein vorheriger Erfolg;
- neuer Beobachter und definierte Ausgangslage.

## 11. Erfolgsmeldung und Tastendrücke

### Vorgehen

Erfolgstext von `verify.sh` prüfen.

### Erwartung

Der Text behauptet nicht, Enter, Pfeiltaste nach oben oder Ctrl+C erkannt zu haben. Er behauptet auch nicht, `echo terminal-bereit` oder Begriffsverständnis geprüft zu haben.

## 12. Realer Ablauf in Killercoda

### Vorgehen

1. Repository mit genau diesem Szenario verbinden.
2. Szenario frisch starten.
3. Jeden Schritt in Reihenfolge bearbeiten.
4. Anklickbarkeit ausschließlich bei `whoami` prüfen.
5. Eingabe, Ausgabe und Fehlermeldung visuell prüfen.
6. Pfeiltaste nach oben und Ctrl+C im Browserterminal testen.
7. CHECK bewusst fehlschlagen lassen.
8. Aufgabe korrekt durchführen.
9. CHECK erneut auslösen.
10. Browser und Sitzung vollständig neu starten.

### Erwartung

- alle Markdown-Dateien werden korrekt dargestellt;
- `setup.sh` startet zuverlässig über `background`;
- der Beobachter erkennt das tatsächliche Teilnehmerterminal;
- `sleep 30` bleibt ein normaler Vordergrundprozess;
- alle CHECK-Rückmeldungen sind sichtbar und handlungsfähig;
- keine Plattformfunktion wurde nur aufgrund statischer Annahmen als getestet bezeichnet.

## 13. Zeitmessung

### Geübte Vergleichspersonen

Mindestens zwei Durchläufe messen. Der Kernpfad sollte überwiegend 30 bis 35 Minuten benötigen.

### Absolute Anfänger

Mindestens fünf Durchläufe messen. Mindestens vier von fünf Personen sollen den Kernpfad innerhalb von 46 Minuten abschließen.

Zusätzlich erfassen:

- benötigte Hinweisstufe,
- Fokusprobleme,
- Fehler bei Enter,
- Erfolg der Pfeiltasten-Korrektur,
- Erfolg von Ctrl+C,
- Verständnis der Abschlussfragen,
- technische Verzögerungen.

Ein einzelner zeitlicher Ausreißer führt nicht automatisch zur Ablehnung. Wiederkehrende Verzögerungen an derselben Stelle erfordern eine Überarbeitung.

## Freigabekriterien

Vor Veröffentlichung müssen erfüllt sein:

- alle statischen Prüfungen bestanden;
- reale Killercoda-Tests für Start, Darstellung, Setup, Prozessbeobachtung und CHECK bestanden;
- keine fremden Prozesse erfasst oder verändert;
- mindestens vier von fünf Anfängern innerhalb von 46 Minuten;
- mindestens vier von fünf mit höchstens Hinweisstufe 2 bei Pfeiltaste und Ctrl+C;
- Grenzen des CHECKs in Challenge, Finish, Lösung und Trainerleitfaden konsistent.
