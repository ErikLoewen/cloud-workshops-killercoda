# Dozentenleitfaden

## Workshopprofil

- Titel: Dateirechte und Ausführbarkeit verstehen
- Zielgruppe: erwachsene absolute Linux-Anfänger
- Abhängigkeiten: Workshop 2 und Workshop 3
- Zielzeit geübt: 32–38 Minuten
- Zielzeit Anfänger: 42–48 Minuten
- Mindestpuffer: 12 Minuten
- Sicherheitsprinzip: Nur das benötigte Recht im vorgesehenen Rechtebereich ergänzen

## Menschlich zu prüfende Lernziele

Die betreuende Person prüft durch Beobachtung und kurze Fragen, ob die Teilnehmenden:

1. Dateirechte als Regeln für mögliche Handlungen erklären;
2. das erste Zeichen von den neun Rechtepositionen unterscheiden;
3. die neun Rechtepositionen in drei Dreiergruppen teilen;
4. Besitzer, Gruppe und andere korrekt zuordnen;
5. `r`, `w`, `x` und fehlende Rechte erklären;
6. das fehlende `x` im Besitzerbereich erkennen;
7. `./` mit dem aktuellen Verzeichnis verbinden;
8. den kontrollierten Fehler als Berechtigungsproblem einordnen;
9. `chmod`, Rechteargument und Ziel unterscheiden;
10. `u+x` in Besitzer, Hinzufügen und Ausführen zerlegen;
11. `u-x` in Besitzer, Entfernen und Ausführen zerlegen;
12. Dateiinhalt und Dateirecht unterscheiden;
13. erklären, warum `cat` keine Ausführung ist;
14. erklären, warum Gruppe und andere kein neues Recht erhalten;
15. das Prinzip minimaler Rechte begründen;
16. die Grenzen des technischen CHECKs erklären.

## Beobachtung des kontrollierten Fehlers

Der erste Aufruf von `./ohne-ausfuehrungsrecht` soll sichtbar abgelehnt werden. Vorher muss `./` erklärt sein.

Beobachte:

- Wird die Ablehnung erwartet oder als Szenariofehler verstanden?
- Bleibt die Person handlungsfähig?
- Erkennt sie das fehlende Besitzer-`x`?
- Versucht sie, die Datei umzuschreiben?
- Versucht sie, die direkte Ausführung mit einer anderen Shell zu umgehen?

Der genaue Wortlaut der Fehlermeldung wird nicht bewertet.

## Typische Fehlvorstellungen

### Erstes Zeichen als Recht

Den Block als ein Zeichen für den Objekttyp plus neun Rechtezeichen markieren.

### Dreiergruppen falsch getrennt

Die Anzeige mit sichtbaren Abständen neu schreiben:

```text
-   rw-   r--   r--
```

### Bindestriche werden gleichgesetzt

Den Ort unterscheiden:

- erste Position: reguläre Datei;
- innerhalb der Rechteanzeige: Recht fehlt;
- innerhalb von `u-x`: Recht entfernen.

### `cat` wird als Ausführung verstanden

Nachfragen: „Zeigt `cat` Inhalt oder startet es die Datei als vorbereitete Befehlsdatei?“

### `./` wird als Dateiname gelesen

Punkt, Schrägstrich und eigentlichen Dateinamen sichtbar trennen.

### Vorschlag einer pauschalen großzügigen Rechteänderung

Nicht ausführen lassen. Zur Leitfrage zurückführen:

> Welcher Rechtebereich benötigt welches konkrete Recht?

Ein Vorschlag wie `chmod 777` wird nicht vertieft und nicht als alternative Methode gezeigt. Er widerspricht dem Sicherheitsprinzip und vergibt unnötig weitreichende Rechte.

### Umgehung über `bash` oder `sh`

Nicht als gültige Lösung akzeptieren. Erklären:

> Das Lernziel ist die direkte Ausführbarkeit der vorbereiteten Datei. Der fehlende Zustand wird gezielt durch das Besitzer-Ausführungsrecht hergestellt.

Keine neue Teilnehmerhandlung einführen.

## Vier Hinweisstufen

1. **Konzept:** fehlendes Besitzer-Ausführungsrecht, relativer Pfad, Schutzbereich.
2. **Werkzeuge:** nur die erlaubte Befehlsliste.
3. **Struktur:** Befehlsschablone mit Platzhaltern.
4. **Vollständige Methode:** einzelne Befehle mit konkreten Pfaden.

Regeln:

- nicht vorschnell auf Stufe 4 wechseln;
- nach jeder Stufe einen eigenen Versuch ermöglichen;
- Eingriffe und benötigte Stufe im Pilotprotokoll erfassen;
- die Musterlösung nie vor dem ersten selbstständigen Versuch zeigen.

## Eingriffskriterien

Unmittelbar eingreifen, wenn:

- ein Ziel außerhalb von `/root/rechtelabor` genannt wird;
- der Schutzbereich Ziel einer Rechteänderung wird;
- eine rekursive oder pauschale Rechteänderung vorbereitet wird;
- eine nicht eingeführte Umgehung als Lösung genutzt werden soll;
- die Person die vorbereiteten technischen Dateien bearbeiten möchte.

Nicht sofort eingreifen bei:

- Tippfehlern;
- dem erwarteten Ausführungsfehler;
- einer zunächst falschen Vorhersage;
- einer falschen Zuordnung, die durch Beobachtungsfragen korrigierbar ist.

## Zeitmessung

Getrennt erfassen:

- Start bis erste korrekte Rechteblockzerlegung;
- Zeit für den kontrollierten Fehler;
- Zeit für `u+x`, Kontrolle und erfolgreiche Ausführung;
- Zeit für `u-x` und Rückkontrolle;
- Zeit für die Abschlussaufgabe;
- Zeit für CHECK und Reflexion;
- verwendete Hinweisstufe;
- Gesamtzeit.

Überarbeitung ist erforderlich, wenn absolute Anfänger regelmäßig mehr als 48 Minuten benötigen oder weniger als 12 Minuten Puffer verbleiben. Bei deutlicher Unterschreitung wird kein Zusatzstoff eingeführt.

## Pilotbeobachtungen

Besonders beobachten:

- Verwechslung von kleinem `l` und Ziffer `1`;
- mögliche Zusatzzeichen hinter dem Rechteblock;
- UID/GID der Setup-Ausführung;
- UID/GID der Teilnehmer-Shell;
- Möglichkeit von `chmod u+x` ohne zusätzliche Rechte;
- Mount-Option `noexec`;
- Verfügbarkeit von `/usr/bin/env bash`;
- benötigte Hinweisstufe;
- Vorschläge zu pauschalen Rechten;
- Verständnis der Trennung von Inhalt und Recht.

## Eigentümer, Gruppe und technische Identität

Setup ermittelt seine effektive numerische UID und GID und setzt die kritischen Dateien auf diese Werte. Verify vergleicht numerisch.

Im realen Killercoda-Pilot muss bestätigt werden:

- Setup und Teilnehmer-Shell besitzen kompatible Identitäten;
- die Teilnehmeridentität ist tatsächlich Besitzer der Auftragsdatei;
- `chmod u+x` funktioniert ohne zusätzliche Teilnehmerhandlung.

Bei abweichenden Identitäten ist die Veröffentlichung blockiert. Es wird nicht mit `sudo`, Eigentümeränderungen oder anderen neuen Teilnehmerbefehlen umgangen.

## Interne Modi

Numerische Modi sind ausschließlich technische Details:

- Ausgangsdateien und Schutzdatei: `0644`;
- bereits ausführbare Demo und finaler Auftrag: `0744`;
- Verzeichnisse: `0755`;
- Technikstamm: `0750`;
- Referenzverzeichnis: `0700`;
- Referenzdateien: `0400`.

Sie werden nicht als Teilnehmerlösung erklärt.

## Referenzschutz

Die Referenzen liegen außerhalb des Teilnehmerbereichs und sind restriktiv gesetzt. In einer Root-Shell kann lokaler Dateizugriff technisch nicht vollständig vor einer absichtlichen Untersuchung verborgen werden. Deshalb sind die Referenzen kein Geheimnis, sondern ein nicht sichtbarer technischer Prüfzustand. Teilnehmertexte nennen den Pfad nicht.

## Technische und menschliche Prüfung trennen

Der CHECK prüft nur:

- Dateityp und Symlinkfreiheit;
- bytegenauen Inhalt;
- numerische UID/GID;
- exakten Zielmodus;
- technischen Marker;
- unveränderten Schutzbereich.

Der CHECK beweist nicht den Lösungsweg oder das Verständnis. Die menschlichen Lernziele werden mit den Fragen in `finish.md` und den Beobachtungen dieses Leitfadens geprüft.
