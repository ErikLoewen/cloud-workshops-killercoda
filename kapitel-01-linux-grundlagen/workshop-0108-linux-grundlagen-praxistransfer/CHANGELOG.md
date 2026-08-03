# CHANGELOG

## Version 1.0.0 – initiale Erstellung

## Version 2.0.0-dev – technische Zielarchitektur

- Vorläufigen Arbeitstitel `01.08 – Das fragmentierte Archiv` gesetzt.
- Verbindliche technische Zielarchitektur für Benutzerstart, Teilnehmerbaum,
  Prozess, Parser, Diagnosefolge, Speedrun, Flag-only-CHECK und Tests
  dokumentiert.
- Bestehende Workshopimplementierung noch nicht migriert.

## Version 2.1.0-dev – technische Grundstruktur

- Idempotentes Setup mit Benutzer `waerter`, Hostname `leuchtturm` und
  Startverzeichnis `/home/waerter/leuchtturm/archiv` implementiert.
- Teilnehmerstruktur, Ausgangskonfiguration, angewendeten Status,
  Archivschlüssel, Nachrichten und Fragmentbereiche ergänzt.
- Internen Starter und eindeutig identifizierbaren Hintergrundprozess
  `altes_echo` ergänzt.
- Reset auf exakt begrenzte Workshoppfade und exakt identifizierte
  Prozessinstanzen beschränkt.
- Ausführbare Platzhalter für Stabilisierung, Konfigurationsprüfung,
  Statusanzeige und CHECK ergänzt; fachliche Diagnose, Parser und Flag-Ablauf
  bleiben Folgearbeiten.
- Zwei Setup-Läufe sowie Fremdprozess- und Sentinel-Schutz erfolgreich in
  einem isolierten Ubuntu-24.04-Container getestet.

## Version 2.2.0-dev – Stabilisierungsplan

- Dokumentierten Sollzustand des Archivs und die vier stabilen Bereiche im
  reproduzierbar erzeugten `stabilisierungsplan.txt` festgelegt.
- Löschentscheidungen ausdrücklich an den Plan statt an auffällige Namen
  gebunden.
- Warnung vor zurückkehrenden Inhalten ergänzt, ohne Prozessname, Zielwert,
  Flag oder fertigen Lösungsweg vorwegzunehmen.

## Version 2.3.0-dev – Fragmentbereiche

- Vier reproduzierbare `fragment_*`-Bereiche mit eigenständigen
  atmosphärischen UTF-8-Texten ausgestattet.
- Den absichtlich ungültigen Farbwert `7G00FF` als erzählerischen Bestandteil
  beibehalten.
- Fragmentdateien bleiben passive Teilnehmerdaten ohne Ausführungsrechte oder
  automatische Löschlogik.

## Version 2.4.0-dev – Wiederkehrende Erinnerung

- Inhalt von `ERINNERUNG_KEHRT_ZURUECK.txt` verbindlich festgelegt.
- `altes_echo` auf ein ressourcenschonendes Prüfintervall von ungefähr drei
  Sekunden eingestellt.
- Wiederherstellung erfolgt nur bei fehlender Datei und atomar über eine
  temporäre Datei; vorhandene Inhalte werden nicht fortlaufend überschrieben.
- Reguläres Prozessende, ausbleibender automatischer Neustart und sauberer
  Neustart beim Workshopreset technisch geprüft.
- Signalbehandlung beendet auch den jeweils wartenden `sleep`-Kindprozess,
  damit normales `kill PID` und Setupreset unmittelbar reagieren.

## Version 2.5.0-dev – Archivschlüsselprüfung

- Archivschlüssel um Dokumenttyp, Zielbereich, Funktion und Prüfung ergänzt.
- Technische Prüfung für Ausgangsort, korrekten Zielort, fehlende Datei,
  unerwarteten Fundort, mehrere Kopien und veränderten Inhalt implementiert.
- Prüfung meldet tatsächliche Fundorte innerhalb des Archivbereichs und nimmt
  selbst keine Verschiebung oder andere Korrektur vor.
- Einbindung nach Fragment- und Echoprüfung sowie Speedrun-Priorisierung
  bleiben Teil der folgenden Gesamtdiagnose.

## Version 2.6.0-dev – Widersprüchliche Nachrichten

- Fünf exakt benannte, ähnlich strukturierte letzte Nachrichten mit fünf
  unterschiedlichen Konfigurationswerten implementiert.
- Eigentümer auf `olmstead`, `root`, `waerter`, `nobody` und `daemon`
  verteilt; alle Dateien bleiben für `waerter` lesbar.
- Fehlendes Konto `olmstead` wird kontrolliert als Systemkonto ohne Login mit
  eigener Gruppe angelegt; vorhandene Systemkonten werden wiederverwendet.
- Eigentümer werden nach dem allgemeinen Teilnehmerbaum-Setup gezielt gesetzt
  und bei jedem Reset reproduziert.

## Version 2.7.0-dev – sicherer Archivparser

- Root-kontrollierten Parser für genau einen `ERINNERUNG=WERT`-Eintrag mit
  Kommentaren und Leerzeilen implementiert.
- `klar` als einzigen stabilen Wert und fünf bekannte, syntaktisch lesbare,
  aber instabile Werte unterschieden.
- Fehlende, unlesbare und nicht reguläre Dateien, Symlinks, fehlende,
  doppelte oder unbekannte Schlüssel, leere Werte, Formatfehler,
  Sonderzeichen und Injectionversuche werden ohne Codeausführung abgelehnt.
- `steuerung/archiv-pruefen` als nicht verändernden Teilnehmer-Wrapper
  implementiert; Exit-Code 0 ausschließlich für `ERINNERUNG=klar`.

## Version 2.8.0-dev – vollständige Stabilisierungsdiagnose

- `leuchtturm-stabilisieren` mit verbindlicher Priorität für Speedrun,
  Fragmentbereiche, Echozustand, Archivschlüssel und Konfiguration
  implementiert.
- Alle vorhandenen direkten `fragment_*`-Verzeichnisse werden konkret und
  deterministisch aufgelistet.
- Die vier Kombinationen aus Workshopprozess und wiederkehrender Datei werden
  getrennt diagnostiziert; die Prozessprüfung validiert Name, Besitzer und
  installierte Executable.
- Schlüsselprüfungen für Ausgangsort, fehlende Datei, mehrere Kopien,
  unerwarteten Ort und veränderten Inhalt in die Diagnosefolge eingebunden.
- Regulärer Zielzustand und priorisierter Speedrun verwenden dieselbe
  wiederholbare Erfolgsdarstellung mit der festgelegten Flag.
- Das Diagnosewerkzeug nimmt keine Reparaturen oder Statusänderungen vor.
  Eine Konfigurationssicherung bleibt didaktisch sinnvoll, ist aber bewusst
  keine technische Erfolgsbedingung.

## Version 2.9.0-dev – Metadaten und Step-Struktur

- Titel und Kurzbeschreibung auf die Abschlussmission im fragmentierten
  Archiv ausgerichtet.
- Sechs neue Lernschritte und die finale Challenge in verbindlicher
  Reihenfolge in `index.json` eingetragen.
- Drei alte Step-Dateien entfernt und durch die neuen sprechenden Dateinamen
  ohne Umlaute ersetzt.
- Alte sichtbare Szenarioinhalte aus Intro, Challenge, Finish und internen
  Begleittexten entfernt; bis zur Ausformulierung schlanke Strukturfassungen
  eingesetzt.
- Drei verbindliche und ein optionales Bildasset geplant, jedoch noch nicht
  referenziert, damit keine kaputten Bilder entstehen.

## Version 2.10.0-dev – vollständiges Intro

- Storyanschluss an Laterne und Fußspuren aus Workshop 7 hergestellt.
- Verzerrte Archivwelt reduziert beschrieben, ohne die technische Mission zu
  überlagern.
- Abschlussmissionscharakter, überprüfbarer Zustand, selbstständige
  Werkzeugwahl und vollständige Lernziele sichtbar gemacht.
- Fehlendes Einstiegsbild als nicht rendernder Platzhalter mit vorbereitetem
  Pfad und Alt-Text aufgenommen.
- Das erste anklickbare `./leuchtturm-stabilisieren` als letzte Handlung des
  Intros gesetzt; Flag, Speedrun und Auflösung bleiben verborgen.

## Version 2.11.0-dev – erster Diagnoseschritt

- Step 1 als Soll-Ist-Vergleich zwischen Stabilisierungsplan, Archivstruktur
  und erster vollständiger Diagnose ausgearbeitet.
- Bekannte Navigations- und Lesewerkzeuge nur knapp aktiviert, ohne sie erneut
  ausführlich zu erklären.
- Vier geschlossene Hilfestufen ergänzt; der vollständige Beobachtungsweg
  erscheint ausschließlich im letzten Dropdown.
- Noch keine Löschfolge oder Lösung der Fragmentbereiche vorweggenommen.

## Version 2.12.0-dev – kontrollierte Fragmentbereinigung

- Step 2 mit planbasierter Löschentscheidung und sichtbarer
  Sicherheitsbotschaft ausgearbeitet.
- Einen Fragmentbereich geführt untersuchen lassen; rekursive Löschung bleibt
  auf einzeln ausgeschriebene und bestätigte Ziele begrenzt.
- Pauschale Wildcard-Löschung ausdrücklich ausgeschlossen und die vollständige
  Befehlsfolge ausschließlich im letzten Dropdown untergebracht.
- Wiederkehrende Erinnerungsdatei nach erneuter Stabilisierung beobachten
  lassen, ohne den Prozessnamen im Haupttext vorwegzunehmen.

## Version 2.13.0-dev – Prozessursache mit Pipe und grep

- Step 3 vom Herkunftshinweis in der wiederkehrenden Datei bis zur sicheren
  Prozessbeendigung ausgearbeitet.
- `ps -eo user,pid,comm | grep altes_echo` als verbindlichen neuen
  Syntaxbaustein mit minimaler Erklärung von `grep` und Pipe eingeführt.
- Zusätzliche `grep`-Zeile konkret erklärt und Auswahl ausschließlich über
  `USER`, eindeutige `PID` und `COMMAND=altes_echo` abgesichert.
- Nachkontrolle über denselben Filter beziehungsweise `pgrep` und endgültige
  Dateientfernung ergänzt.
- Grafikpfad und Alt-Text als nicht rendernden Platzhalter vorbereitet.

## Version 2.14.0-dev – Archivschlüssel zuordnen

- Step 4 als offene Zuordnungsaufgabe aus Diagnose, Dokumentinhalt und
  Zielkontrolle ausgearbeitet.
- Dokumenttyp und Zielbereich als fachliche Begründung für den Dateiort
  hervorgehoben, ohne die Lösung aus dem Dateinamen abzuleiten.
- `mv` über vier gestufte Hinweise aktiviert; vollständiger Befehl nur im
  letzten Dropdown.
- Dateiort als Teil des Systemzustands festgehalten, ohne zusätzliche
  Dateisystemtheorie einzuführen.

## Version 2.15.0-dev – Nachrichtenquelle über Metadaten

- Step 5 als Vergleich von fünf widersprüchlichen Nachrichten ausgearbeitet.
- Dateinamen und Inhalte ausdrücklich als unzureichende Auswahlkriterien
  behandelt und den Besitzer über `ls -l` als kontrolliertes
  Szenariokriterium eingeführt.
- Eigene Benutzerkennung erst über die dritte Hilfestufe aktiviert;
  tatsächlicher Dateipfad ausschließlich im letzten Dropdown.
- Konfigurationspfad und Zielwert werden nur notiert; die Datei bleibt in
  diesem Schritt unverändert.
- Begrenzte Aussagekraft von Dateibesitzern in realen Untersuchungen fachlich
  klargestellt.

## Version 2.16.0-dev – Erinnerungskonfiguration klären

- Step 6 als selbstständige Wiederholung des sicheren Ablaufs aus Lesen,
  Sichern, Ändern, Prüfen, Stabilisieren und Kontrollieren ausgearbeitet.
- Sicherung, Nano-Bearbeitung, sichtbare Inhaltskontrolle und
  `archiv-pruefen` in klarer Reihenfolge verankert.
- Nano-Tasten ausschließlich als Kurzhilfe im letzten Dropdown wiederholt.
- Finale Stabilisierung bewusst in die Challenge verschoben und keinen
  internen Schnelltestpfad im Lerntext offengelegt.
- Standardpfad von `archiv-pruefen` korrigiert, sodass der dokumentierte
  Aufruf aus dem Archivstamm die Konfiguration im Steuerungsbereich prüft.

## Version 2.17.0-dev – finale Challenge und Flag-only-CHECK

- Challenge als offenen finalen Stabilisierungslauf ohne sichtbare Flag oder
  vorweggenommene Auflösung ausgearbeitet.
- Vier Diagnosehilfen für Konfiguration, Schlüssel, Prozess und vollständigen
  regulären Lernweg ergänzt; technischer Schnelltestpfad bleibt unsichtbar.
- Root-kontrolliertes `flag-einreichen` mit exaktem Ein-Argument-Vergleich,
  sitzungsgebundenem atomarem Marker und wiederholbarer korrekter Abgabe
  implementiert.
- `verify.sh` auf die ausschließliche Prüfung des aktuellen Flag-Abgabemarkers
  umgestellt; Missionsdateien und Prozesse bleiben unbeachtet und unverändert.
- Falsche Flag, zusätzliche Leerzeichen, regulärer Erfolg, technischer
  Schnelltest und Wiederholung im isolierten Container geprüft.

## Version 2.18.0-dev – Outro und Kapitelabschluss

- Finish als weiterhin unwirkliche, aber wieder konsistente Stabilisierung
  des Leuchtturms ausgearbeitet.
- Benutzerkennung `waerter` rückwirkend mit dem Identitätsabgleich und dem
  offenen Plot-Twist verbunden.
- Identität, Rolle, Erinnerungsüberschreibung und mögliche Wiederholung
  ausdrücklich als offene Deutungen erhalten.
- Vollständigen fachlichen Rückblick auf Diagnose, Dateiarbeit, Prozess,
  Metadaten und Konfiguration ergänzt.
- Kapitelabschluss und offenen Ausblick auf Administration, Netzwerke,
  Server, Container, Cloud und Incident Response formuliert.
- Abschlussbild als nicht rendernden Platzhalter mit vorbereitetem Alt-Text
  aufgenommen; keine Flag im sichtbaren Finish genannt.

## Version 2.19.0-dev – Pipe-und-grep-Grafik

- Deterministische PNG-Grafik für den Pflichtbefehl
  `ps -eo user,pid,comm | grep altes_echo` erstellt.
- Prozessliste, Pipe, Filter und Vorher-/Nachher-Ausgabe mit exakt
  kontrollierten Beschriftungen visualisiert.
- Erklärenden Markdownabschnitt auf die zwei vorgegebenen Sätze reduziert und
  den bisherigen Platzhalter erst nach erfolgreicher Assetprüfung durch die
  reale Bildreferenz ersetzt.
- Weiterführende grep- und Shelltheorie weiterhin ausgeschlossen.

## Version 2.20.0-dev – vollständige Musterlösung

- Regulären Lernweg mit allen 29 geforderten Diagnose-, Datei-, Prozess-,
  Metadaten-, Konfigurations- und Flag-Schritten vollständig dokumentiert.
- Robuste Prozessbeendigung ohne feste PID und mit verbindlicher Prüfung von
  `USER`, `PID` und `COMMAND` beschrieben.
- Kompakte vollständige Befehlsfolge, Pipe-Erklärung und gefilterte
  Prozessidentität ergänzt.
- Typische Fehler mit konkreter Diagnose und sicherer Korrekturrichtung
  tabellarisch aufgenommen.
- Konfigurationswiederherstellung und vollständigen Plattformreset getrennt
  dokumentiert.
- Speedrun ausschließlich in einem klar markierten internen Trainer- und
  Testabschnitt mit formal exakter Konfigurationsdatei festgehalten.

## Version 2.21.0-dev – Trainerleitfaden

- Workshoprolle als gestützte Abschlussprüfung und Auswahlaufgabe für bekannte
  Werkzeuge eingeordnet.
- Didaktische Progression von moderater Führung über abnehmende Hilfe bis zu
  hoher Selbstständigkeit konkretisiert.
- Pipe und `grep` als einziges neues Syntaxkonzept auf zwei Erklärungssätze,
  Grafik und sichere Prozessidentitätsprüfung begrenzt.
- Zehn Trainerfragen, problembezogenes Fehlermanagement, vier Hilfestufen und
  Sicherheitsinterventionen dokumentiert.
- Sechs Arbeitsphasen auf ungefähr 60 Minuten geplant, ohne
  Sicherheitskontrollen bei Zeitdruck zu kürzen.
- Speedrun getrennt für Dozenten, Entwicklung, Browsertests und schnelle
  CHECK-Prüfungen beschrieben.

## Version 2.22.0-dev – umfassender Testplan

- Testmatrix mit stabilen IDs für Setup, Fragmente, Echo, Pipe und grep,
  Schlüssel, Nachrichten, Parser, regulären Weg, Speedrun, CHECK, Reset und
  Repositoryqualität vollständig neu erstellt.
- Statische, isolierte, reale Killercoda- und manuelle Tests klar getrennt.
- Dynamische Werte und Prozessausgaben als Beobachtungen statt feste
  Erwartungen behandelt.
- Positive, negative und Wiederholungsfälle mit konkretem Vorgehen und
  eindeutigem Sollbefund dokumentiert.
- Verbindliches Ergebnisschema ergänzt und nicht ausgeführte Browser- oder
  TTY-Tests ausdrücklich von bestandenen Tests getrennt.

## Version 3.0.0-dev – vollständige Neufassung von Workshop 8

- Workshop 8 vollständig von der alten Aufgabe zur Abschlussmission
  „Das fragmentierte Archiv“ für das Kapitel „Linux-Grundlagen“ migriert.
- Wiederholbares Diagnosewerkzeug `leuchtturm-stabilisieren` mit priorisierten
  Zustandsmeldungen und neuer Abschlussflagge umgesetzt.
- Vier kontrollierte Fragmentordner mit eigenständigen Horrorliteratur-
  Anklängen und planbasierter Löschdidaktik ergänzt.
- Ressourcenschonenden, sicher identifizierbaren Hintergrundprozess
  `altes_echo` und die wiederkehrende Erinnerungsdatei implementiert.
- Pipe und `grep` als einziges neues kleines Syntaxkonzept sowie eine eigene
  Prozessfilter-Grafik eingeführt.
- Archivschlüssel als begründete `mv`-Aufgabe mit eindeutiger Ortsprüfung
  umgesetzt.
- Fünf widersprüchliche Nachrichten mit verschiedenen Besitzern und Auswahl
  der echten Quelle über `ls -l` gestaltet.
- Sicheren, nicht ausführenden Parser für `archiv.conf`, Teilnehmerprüfung und
  negative Syntax- sowie Injectiondiagnosen implementiert.
- Priorisierten Speedrun für Dozenten-, Entwicklungs-, Browser- und schnelle
  CHECK-Tests ergänzt, ohne ihn in sichtbaren Lerntexten offenzulegen.
- Exakte Flag-Abgabe und wiederholbaren Flag-only-CHECK sitzungsgebunden
  umgesetzt.
- Identitätsauflösung um die Benutzerkennung `waerter` und den offenen
  Plot-Twist im Kapitelabschluss ausgearbeitet.
- Intro, sechs Lernschritte, Challenge, Finish, Musterlösung,
  Trainerleitfaden, Testplan und technische Dokumentation vollständig neu
  erstellt.

## Version 3.0.1-dev – lokale Gesamtabnahme

- Regulären technischen Teilnehmerweg, Speedrun und alle ausdrücklich
  geforderten Fehlerpfade in isolierten Ubuntu-24.04-Containern ausgeführt.
- 79 Prüfgruppen bestanden; 0 Workshopprüfungen fehlgeschlagen.
- Rückkehr der Erinnerung mit 2935 ms sowie `altes_echo` mit 0,0 % CPU und
  3908 KiB RSS gemessen.
- Parsermatrix mit 15 Fällen sowie zusätzliche Symlink-, Rechte-, Schlüssel-,
  Session-, Fremdprozess- und Resettests ausgeführt.
- Nano-Browserprüfung wegen fehlendem Nano im Minimalcontainer offen gelassen.
- Pflichtpipe in 30 aktiven Versuchen geprüft und bestätigt, dass der
  `comm`-basierte Filter keine normale `COMMAND=grep`-Zeile ausgibt.
- Echte Killercoda-Browser-, TTY- und Pilottests ausdrücklich nicht als
  bestanden markiert.

## Version 3.0.2-dev – abschließender Gesamtcheck

- Story, Didaktik, Technik, Sicherheit, Dateireferenzen und Altlasten über den
  gesamten Workshop hinweg überprüft.
- Fachliche Pipe-Darstellung präzisiert: Der `comm`-basierte Pflichtbefehl
  filtert eine normale `COMMAND=grep`-Zeile aus, weil sie den Suchtext
  `altes_echo` nicht enthält.
- Step 3, Challenge, Lösung, Trainerleitfaden, Testplan und Ergebnisbericht an
  das tatsächlich gemessene Filterverhalten angepasst.
- Pipe-und-grep-Grafik neu gerendert: vier konzeptionelle Prozesszeilen vor
  dem Filter und ausschließlich `altes_echo` danach.
- Zuvor offengehaltenen Pipe-Test nach der Korrektur als bestanden bewertet;
  einzig lokale Nano-/Browserprüfung bleibt offen.
- Abschließenden frischen Kernreview mit Setup-Idempotenz, 30 Pipe-Läufen,
  regulärem Erfolg, Injectionabwehr, Flag-only-CHECK und Speedrun bestanden.

## Version 3.0.3-dev – finale Bildassets

- Die hochgeladenen Dateien `intro.png`, `diagram.png` und `outro.png` den
  vorgesehenen Workshoppositionen zugeordnet und ohne Umlaute als
  `0108-einstieg-fragmentiertes-archiv.png`, `0108-pipe-und-grep.png` und
  `0108-abschluss-identitaet.png` benannt.
- Einstiegs- und Abschlussplatzhalter durch echte Markdown-Bildreferenzen mit
  den vorgesehenen Alt-Texten ersetzt.
- Das bisherige Pipe-/grep-Bild durch das hochgeladene Diagramm ersetzt.
- Den offenen Lerntext in Step 3 an den spoilerfreien Platzhalter `UNKNOWN`
  angepasst: Der Prozessname muss nun zuerst aus der wiederkehrenden Datei
  ermittelt werden; die konkrete Befehlsfolge bleibt im letzten Hinweis.
