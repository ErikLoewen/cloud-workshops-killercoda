# Testplan – Workshop 2

Diese Datei ist intern. Sie beschreibt geplante Prüfungen und enthält keine Testergebnisse.

## Voraussetzungen

- Test in einer isolierten Umgebung mit ausreichenden Rechten für `/root`, `/usr/local/bin` und `/tmp`
- Für den Realtest: frische Killercoda-Umgebung mit Backend `ubuntu`
- Ergebnisse werden ausschließlich in `test-results.md` protokolliert

## Testfälle

### T01 – Frischer Szenariostart

**Ziel:** Setup läuft vor der ersten Teilnehmerhandlung.

**Prüfung:**

- Szenario frisch starten.
- Kontrollieren, dass der Baum vorhanden ist.
- Kontrollieren, dass kein Erfolgsmarker vorhanden ist.
- Kontrollieren, dass die Lab-Aktion ausführbar installiert wurde.

### T02 – Setup zweimal ausführen

**Ziel:** `setup.sh` ist reproduzierbar und möglichst idempotent.

**Prüfung:**

- `setup.sh` zweimal nacheinander ausführen.
- Beide Ausführungen müssen mit Exit-Code 0 enden.
- Danach muss die definierte Ausgangslage bestehen.
- Ein zuvor angelegter Erfolgsmarker muss entfernt sein.

### T03 – Vollständiger Verzeichnisbaum

**Ziel:** Alle geforderten Verzeichnisse existieren und keine ungeplanten Einträge liegen im Laborbaum.

**Prüfung:** Sollstruktur und Iststruktur vollständig vergleichen.

### T04 – Ausführungsrechte der Lab-Aktion

**Ziel:** Die installierte Aktion ist unter dem vorgesehenen Namen ausführbar.

**Prüfung:**

- Asset besitzt Ausführungsrecht.
- Installierte Datei besitzt Ausführungsrecht.
- Aufruf ohne Argument ist möglich.

### T05 – Lab-Aktion aus falschem Verzeichnis

**Ziel:** Kein falscher positiver Marker.

**Prüfung:**

- Aus `/root/navigation-labor/startpunkt` aufrufen.
- Exit-Code muss ungleich 0 sein.
- Marker darf nicht existieren.
- Rückmeldung darf den vollständigen Lösungspfad nicht verraten.

### T06 – Lab-Aktion aus richtigem Verzeichnis

**Ziel:** Korrekter Endzustand.

**Prüfung:**

- In den exakten Zielpfad wechseln.
- Aktion ohne Argument ausführen.
- Exit-Code muss 0 sein.
- Marker muss reguläre Datei sein.
- Inhalt muss exakt `navigation-und-pfade:v1` ohne zusätzliche Bytes sein.

### T07 – CHECK vor der Lab-Aktion

**Ziel:** Fehlender Marker wird erkannt.

**Prüfung:**

- Setup frisch ausführen.
- `verify.sh` starten.
- Exit-Code muss ungleich 0 sein.
- Rückmeldung muss auf `pwd`, `ls`, `freigaberaum` und die bereitgestellte technische Lab-Aktion verweisen.

### T08 – CHECK nach erfolgreicher Lab-Aktion

**Ziel:** Korrekter Marker wird akzeptiert.

**Prüfung:**

- T06 durchführen.
- `verify.sh` starten.
- Exit-Code muss 0 sein.

### T09 – CHECK wiederholt ausführen

**Ziel:** Verify verändert den Lernzustand nicht.

**Prüfung:**

- Hash und Metadaten des Markers vor dem ersten CHECK erfassen.
- CHECK zweimal ausführen.
- Hash und Inhalt müssen unverändert sein.

### T10 – Marker mit falschem Inhalt

**Ziel:** Falscher Inhalt wird erkannt.

**Prüfung:**

- Marker mit abweichendem Inhalt vorbereiten.
- `verify.sh` starten.
- Exit-Code muss ungleich 0 sein.
- Marker darf durch Verify nicht verändert werden.

### T11 – CHECK aus unterschiedlichen Arbeitsverzeichnissen

**Ziel:** Verify ist unabhängig vom Arbeitsverzeichnis seiner eigenen Shell.

**Prüfung:**

- Korrekten Marker herstellen.
- `verify.sh` aus mindestens drei unterschiedlichen Verzeichnissen starten.
- Ergebnis muss jeweils erfolgreich sein.

### T12 – Szenario vollständig neu starten

**Ziel:** Neustart stellt eine frische definierte Ausgangslage her.

**Prüfung:**

- Workshop erfolgreich abschließen.
- Szenario neu starten.
- Marker muss fehlen.
- Baum und installierte Aktion müssen erneut korrekt vorhanden sein.

### T13 – Tab im realen Killercoda-Browserterminal

**Ziel:** Neue Bedienhandlung funktioniert in der tatsächlichen Oberfläche.

**Prüfung:**

- Terminal fokussieren.
- Die in Schritt 4 beschriebenen Präfixe eingeben.
- Tab muss jeweils den erwarteten eindeutigen Namen ergänzen.
- Enter darf erst danach ausführen.
- Browserfokus darf nicht unerwartet wechseln.

### T14 – Zeitmessung geübter Teilnehmender

**Zielkorridor:** ungefähr 31–38 Minuten.

**Erfassung:**

- reine Bearbeitungszeit;
- technische Verzögerungen getrennt;
- höchste Hinweisstufe;
- Erfolg der Abschlussaufgabe.

### T15 – Zeitmessung absoluter Anfänger

**Zielkorridor:** ungefähr 42–48 Minuten; spätestens etwa 50 Minuten.

**Erfassung:**

- reine Bearbeitungszeit;
- Fehlerarten;
- höchste Hinweisstufe;
- beobachtete Tab-Nutzung;
- Antworten zu absolut/relativ sowie `.` und `..`.

## Zusätzliche statische Prüfungen

- JSON syntaktisch gültig;
- alle `index.json`-Referenzen vorhanden;
- Bash-Syntax aller Shell-Dateien gültig;
- Ausführungsrechte gesetzt;
- keine `structure.json`;
- keine internen Citation-Tokens;
- nur der erste `pwd`-Aufruf besitzt `{{exec}}`;
- Teilnehmertexte verlangen keine anderen Lernbefehle;
- keine Dateioperation wird als Teilnehmerhandlung verlangt;
- `test-results.md` enthält keine Resultate.
