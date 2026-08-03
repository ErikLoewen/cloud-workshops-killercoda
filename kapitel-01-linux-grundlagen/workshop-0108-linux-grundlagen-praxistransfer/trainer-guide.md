# Trainerleitfaden – Workshop 8

## Rolle des Workshops

„Das fragmentierte Archiv“ ist die Abschlussmission des Kapitels
„Linux-Grundlagen“. Sie ist eine Abschlussprüfung mit Hilfesystem und keine
völlig offene Prüfung.

Die Lernenden sollen bekannte Werkzeuge nicht nur wiedererkennen, sondern
passend zu einem beobachteten Zustand auswählen und kombinieren. Bewertet wird
deshalb nicht eine auswendig gelernte Befehlsfolge, sondern die Fähigkeit,
eine Diagnose zu lesen, eine Ursache einzugrenzen, sicher zu handeln und den
Zustand anschließend erneut zu kontrollieren.

Die Hauptunterstützung stammt aus:

- `stabilisierungsplan.txt` als dokumentiertem Sollzustand;
- den priorisierten Fehlermeldungen von `./leuchtturm-stabilisieren`;
- den gestuften Dropdowns der einzelnen Lernschritte;
- bereits bekannten Arbeitsroutinen für Navigation, Dateiarbeit, Prozesse und
  Konfigurationen.

Der technische CHECK bestätigt ausschließlich die korrekte Flag-Abgabe. Er
beweist weder selbstständige Werkzeugwahl noch eine bestimmte
Befehlsreihenfolge.

## Didaktische Progression

### Beginn – moderate Führung

In den ersten Schritten ist die Arbeitsrichtung noch klar erkennbar:

- Plan vollständig lesen;
- Diagnose starten;
- dokumentierten Sollzustand und beobachteten Istzustand vergleichen;
- Fehlermeldung als nächsten Untersuchungsauftrag verstehen.

Trainer dürfen hier auf die Existenz des Plans und auf die vollständige
Diagnoseausgabe hinweisen. Eine fertige Löschfolge wird noch nicht genannt.

### Mitte – abnehmende Führung

Die Lernenden müssen zunehmend selbst entscheiden:

- welche `fragment_`-Bereiche durch den Plan ausgeschlossen sind;
- welche Inhalte vor einer Löschung kontrolliert werden;
- ob eine entfernte Datei dauerhaft fehlt oder zurückkehrt;
- welcher Prozess für die Rückkehr verantwortlich ist;
- wie Pipe und `grep` die Prozessliste eingrenzen;
- welche Prozesszeile anhand von Benutzer, PID und Prozessname sicher
  ausgewählt werden darf.

Trainer lenken hier auf Beobachtungen und Identitätsmerkmale, nicht direkt auf
den nächsten verändernden Befehl.

### Ende – hohe Selbstständigkeit

Im letzten Drittel wählen und verbinden die Lernenden die bekannten Routinen
weitgehend selbstständig:

- Archivschlüssel anhand seines Inhalts verschieben;
- Besitzer der fünf Nachrichten vergleichen;
- die richtige Nachricht über das dokumentierte Metadatenkriterium auswählen;
- Konfiguration lesen, sichern, bearbeiten und prüfen;
- Gesamtzustand erneut stabilisieren;
- Flag exakt einreichen und CHECK starten.

Hilfen sollten nun erst nach einem eigenen begründeten Versuch freigegeben
werden.

## Pipe und `grep`

Pipe und `grep` sind das einzige neue kleine Syntaxkonzept dieses Workshops.
`grep` zeigt nur Zeilen mit einem Suchtext; `|` leitet die Ausgabe des linken
Befehls an den rechten Befehl weiter.

Verwenden Sie für die Erklärung die Grafik
`assets/0108-pipe-und-grep.png`. Sie visualisiert ausschließlich:

```bash
ps -eo user,pid,comm | grep altes_echo
```

Die Lernenden prüfen an der gefilterten Zeile weiterhin `USER`, dynamische
`PID` und `COMMAND=altes_echo`, bevor sie den Prozess beenden.

Reguläre Ausdrücke, grep-Optionen, mehrere Pipes und weitere Textwerkzeuge
gehören nicht zu diesem Workshop.

## Beobachtung und Trainerfragen

Fragen Sie möglichst nach einer Beobachtung oder Begründung, bevor Sie einen
Befehlshinweis geben:

1. Was meldet der Stabilisierungsprozess konkret?
2. Welcher Sollzustand steht im Plan?
3. Ist die Datei wirklich gelöscht oder kehrt sie zurück?
4. Welcher Vorgang nennt sich in der Datei selbst?
5. Welche drei Angaben identifizieren `altes_echo` eindeutig?
6. Hast du Benutzer, PID und Prozessname geprüft?
7. Nennt das Dokument einen Zielbereich?
8. Beweist „final“ die Echtheit?
9. Welche Metadaten zeigt `ls -l`?
10. Ist die Konfiguration nur gespeichert oder auch geprüft?

Geeignete Anschlussfragen sind:

- Welche Ausgabe belegt deine Aussage?
- Was erwartest du nach diesem Befehl?
- Welchen vollständigen Pfad willst du verändern?
- Wie kontrollierst du anschließend die Wirkung?

## Fehlermanagement

### Grundregel

Lassen Sie die Lernenden die aktuelle Fehlermeldung zuerst vollständig laut
lesen. Fragen Sie anschließend nach beobachtetem Zustand, erwartetem Zustand
und betroffenem Bereich. Nennen Sie nicht sofort den nächsten Befehl.

### Nach Problemtyp

- Bei einem Löschproblem zurück zum Stabilisierungsplan führen. Ein
  auffälliger Name allein legitimiert keine Löschung.
- Bei einem Prozessproblem zuerst Benutzer, PID und Prozessname prüfen lassen.
  Kein `kill`, solange die Identität nicht eindeutig begründet wurde.
- Bei einer weiterhin auftauchenden Datei zwischen sichtbarem Symptom und
  erzeugendem Vorgang unterscheiden lassen.
- Bei einem Schlüsselproblem Dateiinhalt, tatsächlichen Ort und genannten
  Zielbereich vergleichen lassen.
- Bei einem Nachrichtenproblem von Dateinamen und Stil weg zu den Metadaten
  lenken.
- Bei einem Konfigurationsproblem zuerst Sicherung und gespeicherten Inhalt
  kontrollieren lassen, danach `archiv-pruefen`.
- Bei Nano nur die Kurzhilfe für Speichern, Bestätigen und Schließen geben;
  die Bedienung nicht erneut vollständig unterrichten.

### Hilfestufen

1. Diagnose oder Plan erneut lesen lassen.
2. Passenden Beobachtungsbereich nennen, aber kein Werkzeug.
3. Auf das bekannte Werkzeug beziehungsweise das passende Dropdown verweisen.
4. Erst nach eigenem Versuch den vollständigen Ablauf im letzten Dropdown
   öffnen lassen.

Dokumentieren Sie bei einer Durchführung die höchste benötigte Hilfestufe.

## Sicherheitsinterventionen

Unterbrechen Sie vor dem Absenden, wenn:

- ein Löschziel nicht vollständig gelesen und mit dem Plan verglichen wurde;
- eine Wildcard oder ein Elternverzeichnis rekursiv gelöscht werden soll;
- ein Nicht-Fragmentbereich in einem Löschbefehl steht;
- eine PID ohne gleichzeitige Prüfung von Benutzer und Prozessname beendet
  werden soll;
- die `grep`-Zeile statt `altes_echo` ausgewählt wurde;
- mehrere Schlüsselkopien absichtlich als Endzustand bestehen bleiben sollen;
- eine Konfiguration ohne vorherige Sicherung verändert werden soll.

Nach der Intervention nur die Sicherheitsprüfung abrufen. Die eigentliche
Lösung soll weiterhin von den Lernenden kommen.

## Zeitplanung – ungefähr 60 Minuten

| Phase | Richtwert | Beobachtungsschwerpunkt |
|---|---:|---|
| Intro, Plan und erste Diagnose | 8 Minuten | Soll-/Istvergleich und vollständiges Lesen |
| Fragmente untersuchen und bereinigen | 10 Minuten | begründete Löschziele und Pfadkontrolle |
| Wiederkehrende Datei und Prozess | 15 Minuten | Pipe, Filterergebnis und sichere PID |
| Schlüssel und Nachrichtenquelle | 10 Minuten | Dateiort, Besitzer und Metadaten |
| Konfiguration bearbeiten und prüfen | 12 Minuten | Sicherung, Nano, Inhalts- und Syntaxkontrolle |
| Finale Stabilisierung, Flag und Reflexion | 5 Minuten | Gesamtzustand und Wirkungskette |

Die Summe von 60 Minuten ist ein Richtwert. Lernende, die Werkzeuge noch nicht
sicher selbst auswählen, benötigen möglicherweise zusätzliche Zeit. Kürzen
Sie dann nicht die Sicherheitskontrollen; verwenden Sie stattdessen die
gestuften Hinweise.

## Trainer-/Testweg: Speedrun

Dieser Abschnitt ist ausschließlich für Dozenten, Entwickler, Browsertests
und schnelle CHECK-Prüfungen bestimmt. Er gehört nicht in normale Lerntexte,
sichtbare Dropdowns oder mündliche Hilfen während des regulären Wegs.

Nach einem frischen Reset im Archivstamm:

```bash
printf '%s\n' 'ERINNERUNG=klar' > steuerung/archiv.conf
./leuchtturm-stabilisieren
```

Die Konfigurationsdatei enthält damit genau einen erlaubten Schlüssel, einen
stabilen Wert und einen abschließenden Zeilenumbruch. Die Stabilisierung muss
unmittelbar erfolgreich sein und die Flag ausgeben, obwohl die vorherigen
Missionszustände noch bestehen.

Für den vollständigen CHECK-Test wird die ausgegebene Flag exakt eingereicht:

```bash
flag-einreichen 'FLAG{du_warst_schon_immer_der_waerter}'
```

Danach muss der CHECK sofort und bei Wiederholung erfolgreich sein. Zusätzlich
werden eine falsche Flag sowie führende und nachgestellte Leerzeichen
abgelehnt.

Dieser priorisierte Testpfad ist absichtlich kein Produktionsmuster. Ein
frischer Workshopreset muss anschließend die normale Ausgangslage samt genau
einer neuen `altes_echo`-Instanz wiederherstellen.

## Abschlussbeobachtung

Nach dem Workshop sollten Lernende erklären können:

- warum die Diagnosefolge immer nur das nächste Problem meldet;
- warum Löschung und Prozessbeendigung unterschiedliche Ursachen behandeln;
- warum eine PID ohne Identitätsprüfung kein ausreichendes Ziel ist;
- warum Ort und Besitzer relevante Dateimetadaten sein können;
- warum eine gespeicherte Konfiguration zusätzlich geprüft werden muss;
- warum der CHECK nur die Flag-Abgabe und nicht die selbstständige
  Transferleistung bestätigt.
