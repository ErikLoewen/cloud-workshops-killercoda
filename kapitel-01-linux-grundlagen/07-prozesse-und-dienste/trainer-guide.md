# Dozentenleitfaden – Workshop 7

## Metadaten

- Titel: Prozesse und Dienste kontrollieren
- Slug: `prozesse-und-dienste`
- Ordner: `07-prozesse-und-dienste`
- geübte Teilnehmende: 34–40 Minuten
- absolute Anfänger: 43–49 Minuten
- Mindestpuffer: 11 Minuten

Der Workshop bleibt zunächst kombiniert. Die verbindlichen Teilungskriterien werden erst nach Pilotdaten ausgewertet und dürfen nicht abgeschwächt werden.

## Menschlich zu prüfende Lernziele

Direkt beobachten oder durch kurze Fragen prüfen:

- Prozess als laufende Programminstanz beschreiben;
- Prozessname und PID unterscheiden;
- PID als momentane Kennung erklären;
- `&` tatsächlich beim Hintergrundstart verwenden;
- zurückgekehrten Prompt nicht mit Prozessende verwechseln;
- PID eigenständig aus `pgrep` übernehmen;
- keine Beispiel-PID ungeprüft verwenden;
- leere `pgrep`-Ausgabe als erwartetes Prozessende einordnen;
- Prozess, Dienst und Service-Unit unterscheiden;
- Unit-Name und PID unterscheiden;
- `active` und `inactive` erklären;
- passende Aktion `status`, `stop` oder `start` auswählen.

## Direkte Beobachtung von `&`

Nur der erste vollständige Start ist anklickbar. In der Challenge muss `lab-worker &` selbstständig eingegeben werden.

Der technische CHECK kann die Verwendung von `&` nicht beweisen. Ein Vordergrundstart mit anschließendem Ende kann denselben technischen Endzustand herstellen. Erfolgsmeldung und Abschlussseite nennen diese Grenze ausdrücklich.

## Eigenständige PID-Übernahme

Beobachten:

1. Führt die Person `pgrep lab-worker` aus?
2. Liest sie die aktuelle Zahl?
3. Setzt sie genau diese Zahl als Argument für `kill` ein?
4. Ermittelt sie bei einem neuen Start eine neue PID, statt eine alte Zahl wiederzuverwenden?

## Typische Verwechslungen

- Zahl in eckigen Klammern wird für die gesuchte PID gehalten;
- Prozessname wird als PID verwendet;
- `kill PID` wird wörtlich eingegeben;
- fehlende Ausgabe von `kill` wird als Fehler interpretiert;
- leere `pgrep`-Ausgabe wird als Defekt interpretiert;
- Unit-Name wird mit einer Prozess-PID gleichgesetzt;
- `inactive` wird nach dem beabsichtigten Stop als Szenariofehler bewertet;
- zurückgekehrter Prompt wird mit Prozessende gleichgesetzt.

## Prozess- und Dienstmodell

Prozess:

```text
Programm → laufende Instanz → Prozessname + momentane PID
```

Dienst:

```text
Service-Unit → systemverwalteter Dienst → eigener Prozess mit momentaner PID
```

Der Unit-Name bleibt stabil. Die Prozess-PID kann sich nach einem neuen Start ändern.

## Regeln für Hinweise

Hinweise nur nach einem eigenen Versuch öffnen lassen:

1. Zustände und Konzepte;
2. passende Werkzeuge;
3. fast vollständige Struktur mit Lücken;
4. vollständiger Musterablauf mit ausdrücklich beispielhafter PID.

Die Beispiel-PID darf nie als tatsächlich einzusetzender Wert dargestellt werden.

## Getrennte Zeitmesspunkte

Dokumentieren:

- Beginn des Workshops;
- Abschluss des Prozess-Teilchecks;
- Beginn des Dienstteils;
- Abschluss des Dienst-Inaktiv-Teilchecks;
- Abschluss der Challenge;
- Ende der Reflexion.

Für absolute Anfänger müssen nach dem Prozess-Teilcheck noch mindestens 15 Minuten echte Dienstlernzeit verbleiben. Planerisch sind etwa 20,5–23 Minuten vorgesehen.

## Technische und menschliche Prüfung

Technisch prüfbar:

- Worker-Startmarker der aktuellen Sitzung;
- keine eigene Worker-Instanz läuft;
- initial aktiver Demo-Dienst;
- gültiger geordneter Stop nach Tracking-Aktivierung;
- späterer gültiger Start;
- richtige Ereignisreihenfolge;
- aktuell aktiver eigener Dienstprozess.

Nur menschlich beziehungsweise formativ prüfbar:

- Verwendung von `&`;
- Verwendung von `ps`, `pgrep` und `kill`;
- eigenständiges Ablesen der PID;
- Verständnis der Begriffe;
- fachliche Erklärung der Zustandsänderungen.

## Eingriffskriterien

Eingreifen, wenn:

- ein Teilnehmer einen nicht isolierten Systemdienst verändern möchte;
- wiederholt eine alte oder beispielhafte PID verwendet wird;
- ein fremder Prozess betroffen sein könnte;
- das Terminal in einem Pager hängen bleibt;
- einfaches `ps` den Worker im Killercoda-Pilot nicht zeigt;
- systemd oder die Service-Unit nicht reproduzierbar funktionieren;
- nach dem Prozessteil weniger als zehn Minuten verbleiben.

Ein auftretender Pager ist ein technischer Szenariofehler. Keine Pagerbedienung lehren.

## Verbindliche Teilungskriterien

Kritisch – Teilung bei mindestens einem Kriterium:

- weniger als 70 Prozent erreichen beide Endzustände innerhalb von 50 Minuten;
- mehr als 30 Prozent unterscheiden Prozess und Dienst nicht;
- mehr als 30 Prozent verwechseln PID, Prozessname und Dienstname;
- mehr als 30 Prozent erklären `&` falsch oder starten wiederholt im Vordergrund;
- für mindestens 25 Prozent bleiben weniger als zehn Minuten echte Dienstübungszeit;
- der Demo-Dienst ist in weniger als 95 Prozent frischer Starts reproduzierbar;
- das Budget verhindert selbstständigen Transfer.

Regulär – Teilung bei mindestens zwei Kriterien:

- Prozess-Teilcheck unter 80 Prozent ohne Hinweisstufe 4;
- Dienst-Teilcheck unter 80 Prozent ohne Hinweisstufe 4;
- mehr als 30 Prozent benötigen in beiden Teilen Hinweisstufe 3 oder 4;
- Anfänger-Median über 49 Minuten;
- mehr als 20 Prozent benötigen ohne technische Störung über 50 Minuten;
- Mehrheit führt Befehle aus, kann Zustandsänderungen aber nicht erklären;
- Übergang zum Dienstmodell erzeugt anhaltende Fehlannahmen;
- `&` verdrängt die Lernzeit für den Prozess-Dienst-Unterschied.

## Pagerlösung

Ein transparentes `/usr/local/bin/systemctl`-Wrapperprogramm ergänzt intern ausschließlich `--no-pager` und delegiert mit `exec` an `/usr/bin/systemctl`. Diese Lösung ist nötig, weil ein Setup-Kindprozess die Umgebung einer bereits laufenden Teilnehmer-Shell nicht nachträglich ändern kann. Der Wrapper verändert weder Aktion noch Unit und gibt Ausgabe, Fehlerausgabe und Exit-Code des echten Werkzeugs unverändert weiter.

Setup und Verify rufen ausdrücklich `/usr/bin/systemctl` auf. Erscheint im Killercoda-Pilot dennoch ein Pager, ist die Veröffentlichung blockiert.

## Dienstmarker und systemd-Ergebnis

Der Stop wird zweistufig bewertet:

1. `ExecStop` fordert ausschließlich den eigenen Runner normal zum Beenden auf und erzeugt nur einen vorläufigen Nachweis.
2. `ExecStopPost` wertet `SERVICE_RESULT`, `EXIT_CODE` und `EXIT_STATUS` aus.

Ein gültiger Stopmarker entsteht nur bei bestätigtem `success`, `exited` und Status `0`. Ein unerwarteter Prozessabsturz oder ein fehlgeschlagener Stop darf dadurch nicht als erfolgreicher Teilnehmer-Stop gelten. Das reale Verhalten dieser Ergebniswerte muss im Killercoda-Pilot bestätigt werden.

## Veröffentlichungsblocker

- systemd in der realen Killercoda-Umgebung unzuverlässig;
- einfacher `ps` zeigt `lab-worker` nicht zuverlässig;
- Pager erscheint trotz transparenter Deaktivierung;
- Lifecycle-Marker akzeptieren einen technischen Absturz als gültigen Stop;
- Verify verändert Marker, Zähler, Prozesse oder Dienstzustand;
- weniger als 95 Prozent erfolgreiche technische Frischstarts.
