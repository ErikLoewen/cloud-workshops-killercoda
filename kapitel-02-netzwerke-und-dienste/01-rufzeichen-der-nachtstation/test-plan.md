# Testplan: 02.01 – Das Rufzeichen der Nachtstation

## Ziel

Der Test weist nach, dass Setup, dynamische Auswahl und CHECK in einer frischen Ubuntu-/Killercoda-Umgebung reproduzierbar funktionieren. Statische Prüfung ersetzt keinen Plattformtest.

## Dynamische Auswahlregel

Zu prüfen ist exakt diese Reihenfolge:

1. Nicht-Loopback-Schnittstellen ohne IPv4-Adresse sind ungeeignet.
2. Eine geeignete Schnittstelle einer IPv4-Standardroute wird bevorzugt.
3. Bei mehreren passenden Standardrouten entscheidet zuerst die kleinste Metrik und danach der Schnittstellenname alphabetisch.
4. Ohne passende Standardroute wird die alphabetisch erste geeignete Schnittstelle gewählt.
5. Bei mehreren IPv4-Adressen der ausgewählten Schnittstelle wird eine globale Adresse bevorzugt; danach erfolgt eine stabile Auswahl nach Bereich und numerischem Adresswert.
6. Setup und Verify müssen denselben Wert bestimmen.

Die Routentabelle darf im Teilnehmertext weder als Aufgabe noch als CHECK-Bedingung erscheinen.

## Statische Paketprüfung

```bash
./validate-package.sh
```

Erwartet:

- gültiges JSON;
- gültige Bash-Syntax;
- alle Referenzen vorhanden;
- Skripte ausführbar;
- keine feste Nicht-Loopback-Schnittstelle;
- keine feste dynamische IPv4-Adresse;
- kein `ip a` im Teilnehmertext;
- kein `ip route` im Teilnehmertext;
- keine nicht bestätigten Killercoda-Felder;
- keine leeren Dateien.

## Ubuntu-Systemtests

Nur in einer frischen, entbehrlichen Test-VM als root:

1. `./setup.sh`
2. Prompt endet im Konto `telegrafist`.
3. `hostname` liefert `nachtstation`.
4. Startordner ist `/home/telegrafist/nachtstation`.
5. Teilnehmerdateien gehören `telegrafist`.
6. Das Protokoll ist leer vorbereitet.
7. `stationsauftrag.txt` passt zur Kandidatenzahl.
8. Erneuter Szenariostart erzeugt denselben Ausgangszustand.
9. Keine fremden Dateien außerhalb der kontrollierten Pfade werden gelöscht.

## Auswahlmatrix

### Fall A – eine weitere Schnittstelle

- genau ein Nicht-Loopback-Kandidat mit IPv4;
- Stationsauftrag nennt keine unnötige Routingentscheidung;
- Verify erwartet diesen Kandidaten.

### Fall B – mehrere Kandidaten, passende Standardroute

- mehrere Nicht-Loopback-Kandidaten;
- mindestens eine passende Standardroute;
- ausgewählte Schnittstelle wird im Stationsauftrag genannt;
- Verify erwartet denselben Kandidaten.

### Fall C – mehrere Standardrouten

- niedrigste Metrik gewinnt;
- bei gleicher Metrik alphabetische Reihenfolge;
- wiederholte Ausführung liefert denselben Wert.

### Fall D – keine passende Standardroute

- alphabetisch erster geeigneter Kandidat gewinnt.

### Fall E – mehrere IPv4-Adressen auf der ausgewählten Schnittstelle

- globale Adresse wird bevorzugt;
- die Auswahl bleibt bei Wiederholung stabil.

### Fall F – IPv6 zusätzlich sichtbar

- Lerntext bleibt verständlich;
- Verify ignoriert IPv6 vollständig.

### Fall G – Schnittstellenanzeige mit `@...`

- Lerntext erklärt den sichtbaren Zusatz;
- Verify akzeptiert den Basisnamen vor `@`.

### Fall H – nur Loopback oder keine geeignete IPv4-Adresse

- Setup bricht verständlich ab;
- Szenario wird nicht als lernbereit dargestellt.

## Verify-Negativtests

Für jeden Test frischen Ausgangszustand herstellen.

- Datei fehlt
- Datei ist ein Symlink
- Feld `Hostname` fehlt
- Feld `Hostname` leer
- falscher Hostname
- Loopback-Schnittstelle fehlt
- falsche Loopback-Schnittstelle
- Loopback-Adresse mit `/8`
- falsche Loopback-Adresse
- weitere Schnittstelle fehlt
- falsche weitere Schnittstelle
- IPv4-Adresse fehlt
- IPv4-Adresse mit Präfixteil
- falsche IPv4-Adresse
- Pflichtfeld doppelt
- ungewöhnlich große Datei

Erwartung: Exit-Code ungleich 0, konkretes Feld, aktueller Fehler und nächster Untersuchungsschritt.

## Verify-Positivtests

- vollständige korrekte Datei;
- zusätzliche Vorhersage und Selbst-Erklärung;
- andere Leerzeichen nach dem Doppelpunkt;
- Schnittstellenname mit zulässigem sichtbaren `@...`-Zusatz.

Erwartung: Exit-Code 0.

## Zustandsneutralität

Vor und nach jedem Verify-Lauf vergleichen:

- Prüfsumme von `stationsprotokoll.txt`;
- Besitzer und Rechte;
- Hostname;
- Ausgabe von `ip address`.

Verify darf keinen dieser Zustände verändern.

## Killercoda-Tests

- Intro-Foreground startet ohne Root-Prompt für die Lernarbeit.
- Setup endet als `telegrafist`.
- `hostname` und `ip address` sind vorhanden.
- anklickbare Befehle funktionieren;
- Nano ist bedienbar;
- CHECK scheitert zunächst verständlich;
- CHECK besteht mit aktuellen Werten;
- Back/Next-Navigation verändert den Zustand nicht;
- Neustart des Szenarios ist unabhängig;
- reale Anfängerzeit bleibt unter 50 Minuten;
- mindestens 10 Minuten Puffer bleiben.

## Freigabekriterium

Freigabe erst nach:

- bestandener statischer Prüfung;
- bestandenem Ubuntu-Systemtest;
- bestandenem Killercoda-Durchlauf;
- bewusstem Negativ- und Positivtest des CHECKs;
- dokumentierter Anfängerzeit.
