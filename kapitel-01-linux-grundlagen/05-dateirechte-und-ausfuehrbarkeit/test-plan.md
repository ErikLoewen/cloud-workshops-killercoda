# Testplan

Dieser Plan unterscheidet statische Prüfung, lokalen technischen Test, realen Killercoda-Test und Pilotierung. Ein statischer oder lokal umgebogener Test ersetzt keinen realen Plattformtest.

## Technische Sollwerte

- Teilnehmerstamm: `/root/rechtelabor`
- Technikstamm: `/var/lib/labforge/dateirechte-und-ausfuehrbarkeit`
- Ausgangsmodi: intern `0644`, `0744`, `0644`, `0644`
- Verzeichnismodus: bevorzugt `0755`
- Finaler Auftragsmodus: intern `0744`
- Referenzdateien: regulär, keine Symlinks, intern `0400`
- Markerinhalt: `ausgefuehrt` mit genau einem abschließenden Zeilenumbruch

## Testfälle

| Nr. | Testfall | Vorgehen und erwartetes Ergebnis | Status |
|---:|---|---|---|
| 1 | Frischer Szenariostart | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 2 | Setup einmal ausführen | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 3 | Setup zweimal auf Idempotenz testen | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 4 | Statische Pfadwächter testen | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 5 | Leerer Bereinigungspfad | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 6 | Falscher Bereinigungspfad | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 7 | Bereinigungspfad `/` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 8 | Bereinigungspfad `/root` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 9 | Bereinigungspfad `/var` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 10 | Symbolischer Link als Teilnehmerstamm | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 11 | Symbolischer Link als Technikstamm | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 12 | Vollständige Ausgangsstruktur | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 13 | Alle Dateiinhalte bytegenau | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 14 | Genau ein abschließender Zeilenumbruch | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 15 | Ausgangsmodi | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 16 | Ausgangs-UIDs und -GIDs | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 17 | Marker anfangs nicht vorhanden | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 18 | Reale `ls -l`-Ausgabe | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 19 | Kleines `l` visuell verständlich | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 20 | Rechteblock ohne Besitzer-`x` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 21 | Rechteblock mit Besitzer-`x` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 22 | Kontrollierter Ausführungsfehler | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 23 | Inhalt und Modus nach Fehlversuch unverändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 24 | `chmod u+x` erfolgreich | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 25 | Zielmodus nach `u+x` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 26 | Direkte Ausführung erfolgreich | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 27 | Erwartete Terminalausgabe | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 28 | `chmod u-x` erfolgreich | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 29 | Demo-Ausgangsmodus wiederhergestellt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 30 | Vollständiger positiver Challengepfad | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 31 | Auftragsdatei fehlt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 32 | Auftragsdatei falscher Typ | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 33 | Auftragsdatei als Symlink | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 34 | Inhalt verändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 35 | Besitzer verändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 36 | Gruppe verändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 37 | Besitzer-`x` fehlt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 38 | Besitzer-Lese- oder Schreibrecht fehlt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 39 | Gruppe besitzt `x` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 40 | Gruppe besitzt unerwartetes `w` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 41 | Andere besitzen `x` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 42 | Andere besitzen unerwartetes `w` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 43 | Modus `0755` statt `0744` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 44 | Modus `0777` | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 45 | Marker fehlt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 46 | Marker falscher Inhalt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 47 | Marker als Symlink | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 48 | Rechte korrekt, Datei aber nicht ausgeführt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 49 | Marker korrekt, Rechte aber falsch | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 50 | Schutzbereich fehlt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 51 | Schutzbereich als Symlink | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 52 | Schutzdatei fehlt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 53 | Schutzdatei verändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 54 | Schutzrechte verändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 55 | Schutz-UID oder -GID verändert | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 56 | Schutzdatei als Symlink | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 57 | Zusätzlicher Eintrag im Schutzbereich | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 58 | Referenzdaten fehlen | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 59 | Referenzdaten beschädigt | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 60 | Wiederholter CHECK | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 61 | Inhalt-, Modus-, UID-, GID- und Strukturvergleich vor und nach CHECK | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 62 | Verify führt die Auftragsdatei nicht aus | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 63 | Verify erzeugt keinen Marker | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 64 | Verify verändert keine Rechte | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 65 | Vollständiger Szenarioneustart | Durchführen, beobachteten Zustand dokumentieren und mit Spezifikation vergleichen. | offen |
| 66 | Test auf `noexec` | Mount-Optionen im realen Backend prüfen; direkte Ausführung unter dem Teilnehmerpfad muss möglich sein. | offen |
| 67 | Test auf `/usr/bin/env bash` | Existenz und erfolgreiche Verwendung von `/usr/bin/env bash` prüfen. | offen |
| 68 | Realer Killercoda-Test | Erst in der realen Zielumgebung beziehungsweise mit echten Teilnehmenden durchführen; keine lokale Ersatzbehauptung. | offen |
| 69 | Zeitmessung mit geübten Teilnehmenden | Erst in der realen Zielumgebung beziehungsweise mit echten Teilnehmenden durchführen; keine lokale Ersatzbehauptung. | offen |
| 70 | Anfängerpilot | Erst in der realen Zielumgebung beziehungsweise mit echten Teilnehmenden durchführen; keine lokale Ersatzbehauptung. | offen |

## Pfadwächter

Die Tests 4 bis 11 müssen nachweisen, dass eine Bereinigung nur bei bytegenau passenden statischen Laborpfaden erfolgt. Leere, falsche, übergeordnete und symbolisch verlinkte Wurzeln müssen vor einer rekursiven Entfernung verständlich abgelehnt werden. Der Elternpfad `/var/lib/labforge` darf nie rekursiv entfernt werden.

## Verify-Negativtests

Jeder Negativfall wird aus einem frisch erzeugten Ausgangszustand aufgebaut. Erwartet werden ein von null verschiedener Exit-Code, eine passende Diagnoseklasse, der erwartete Zustand und ein sinnvoller nächster Prüfschritt. Verify darf den Fehler nicht reparieren.

## Zustandsneutralität

Vor und nach Verify werden mindestens Inhaltshashes, Modi, numerische UID/GID, Symlinkstatus, Eintragszahl und Markerzustand verglichen. Zugriffszeiten sind kein bewerteter Zustand.

## Veröffentlichungsblocker

- Setup- und Teilnehmeridentität passen nicht zusammen.
- Der Teilnehmerpfad ist mit `noexec` eingebunden.
- `/usr/bin/env bash` ist nicht verfügbar.
- `ls -l` zeigt eine nicht didaktisch beherrschte Darstellung.
- Verify verändert einen Lernzustand.
- Absolute Anfänger überschreiten regelmäßig 48 Minuten.
- Der Puffer fällt unter 12 Minuten.
