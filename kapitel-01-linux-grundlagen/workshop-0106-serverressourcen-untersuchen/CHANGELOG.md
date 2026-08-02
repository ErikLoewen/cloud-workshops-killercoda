# Changelog

## Version 2.0.0-dev – Leuchtfeuerdatei garantiert im globalen Setup

- `leuchtfeuer-start`, Leuchtfeuer-Binärdatei, Flag-Werkzeug und
  Wartungsnotiz direkt im globalen Setup erzeugt;
- Abhängigkeit dieser Teilnehmerdateien von der Step-2-Background-Ausführung
  entfernt;
- nicht mehr benötigtes technisches Vorbereitungs-Asset entfernt.

## Version 2.0.0-dev – eigenständiger Step-2-Background-Prozess

- Abhängigkeit des Background-Skripts vom extern erzeugten Prozessstarter und
  Lastregler entfernt;
- `beschwoerung` direkt im Step-2-Background mit integriertem moderatem
  Rechen-/Schlaf-Duty-Cycle gestartet;
- Background-Skript auf erfolgreichen, stillen Abschluss ausgelegt und
  technische Diagnose in `/tmp/workshop-0106-step2-background.log` abgelegt.

## Version 2.0.0-dev – Background-Ausführung als Teilnehmer

- rootpflichtige Installation der Hilfsprogramme vor den Benutzerwechsel
  verlagert;
- Step-2-Background-Skript auf den reinen Prozessstart reduziert;
- Prozessstarter für eine direkte Ausführung als `waerter` erweitert, ohne in
  diesem Kontext erneut `runuser` aufzurufen;
- Benutzerwechsel bleibt auch bei einem technischen Vorbereitungsfehler
  erhalten; Diagnoseausgabe wird intern protokolliert.

## Version 2.0.0-dev – entkoppelter Benutzerstart

- `setup.sh` auf den bewährten Benutzer- und Verzeichnisstart der vorherigen
  Workshops reduziert;
- Benutzerwechsel vollständig von der technischen Prozessvorbereitung
  entkoppelt;
- Hilfsprogramme und `beschwoerung` erst durch den Background-Start von Step 2
  vorbereitet beziehungsweise gestartet;
- technische `usermod`-Ausgabe im Teilnehmerterminal unterdrückt.

## Version 2.0.0-dev – vereinfachter Workshopstart

- zusätzlichen Setup-Wrapper und das Setup-Asset wieder entfernt;
- Workshopstart exakt wie in Workshops 4 und 5 direkt in `setup.sh`
  vorbereitet und mit `exec su - waerter` abgeschlossen;
- Step-2-Background-Aktivierung als einzige Startstelle für `beschwoerung`
  beibehalten.

## Version 2.0.0-dev – Killercoda-Hotfix für Benutzerstart

- Hostnamenwechsel als Best-effort behandelt, damit eine eingeschränkte
  Killercoda-Umgebung das Setup nicht vorzeitig beendet;
- Benutzerwechsel exakt auf das bewährte `exec su - waerter`-Muster der
  Workshops 4 und 5 zurückgestellt;
- dadurch sichergestellt, dass die technischen Hilfsprogramme vor Step 2
  installiert werden und das Background-Skript nicht wegen eines abgebrochenen
  Setups fehlt.

## Version 2.0.0-dev – Step-spezifische Lastaktivierung

- sichtbare Ready-Warteschleife mit bis zu 45 Sekunden Wartezeit vollständig
  entfernt;
- sichtbares Foreground-Skript auf einen kurzen, ausgabenlosen Setup-Aufruf
  und den direkten Benutzerwechsel reduziert;
- Benutzerstart wieder am bewährten Setup-Muster der Workshops 4 und 5
  ausgerichtet;
- globales Setup und Ressourcenfresser getrennt: Intro und Step 1 starten ohne
  künstliche Last;
- `beschwoerung` ausschließlich beim ersten Eintritt in Step 2 über ein
  Background-Skript und einen sitzungsgebundenen Marker aktiviert;
- CPU-Last auf einen moderaten 15/85-Millisekunden-Duty-Cycle reduziert;
- sichtbare Erklärung der Prozentwerte um `15.0` ergänzt und Hinweis zur
  höchstens geringfügigen Verzögerung nach Step 2 verschoben;
- Lösungsweg, Trainerleitfaden und Testdokumentation aktualisiert.

## Version 2.0.0-dev – Reparatur des realen Killercoda-Laufs

- technisches Setup als unsichtbaren Background-Prozess ausgeführt und die
  sichtbare `waerter`-Shell über ein Ready-Signal synchronisiert;
- Hostname und Startverzeichnis vor dem Öffnen der Teilnehmer-Shell geprüft;
- bisherigen Volllastprozess durch eine eigenständig benannte Binärdatei mit
  kontrolliertem 60/40-Millisekunden-Duty-Cycle ersetzt;
- Cleanup auf exakt erkannte Workshopprozesse begrenzt und wiederholtes Setup
  geprüft;
- Prozentwerte, `idle` und erwartbare Terminalverzögerung anfängergerecht im
  sichtbaren Teilnehmertext erklärt;
- Testplan und Testprotokoll an die reale Fehlerkorrektur angepasst.

## Version 2.0.0-dev – Bildassets

- vier gelieferte Workshopgrafiken konsistent benannt und in den Asset-Ordner
  aufgenommen;
- vorbereitete Bildplatzhalter in Intro, Ressourcenerklärung,
  Prozessdiagnose und Abschluss durch echte Bildreferenzen ersetzt.

## Version 2.0.0-dev – abschließender Gesamtcheck

- konkrete Flag aus der offenen Step-6-Beispielausgabe entfernt;
- fehlende Ressourcen- und Diagnosegrafiken als eindeutige Platzhalter
  gekennzeichnet, damit keine defekten Bilder gerendert werden;
- fachliche, didaktische und technische Konsistenz erneut geprüft;
- vollständigen Teilnehmerweg einschließlich Reset erneut getestet.

## Version 2.0.0-dev – Trainer- und Testunterlagen

- vollständigen PID-freien Schnellpfad ergänzt;
- typische Bedien- und Diagnosefehler dokumentiert;
- Trainerleitfaden an die abnehmende Unterstützungsprogression angepasst;
- Testplan auf Setup, Lastprozess, Übungsprozess, Leuchtfeuer, Texte und
  Syntax erweitert;
- Testprotokoll mit ausgeführten Prüfungen und offenen Befunden aktualisiert.

## Version 2.0.0-dev – Struktur und Metadaten

- neuen Missionstitel und neue Kurzbeschreibung eingetragen;
- Workshop auf sechs Diagnose- und Prozessschritte umgestellt;
- alte Ressourcenbericht-Schritte entfernt;
- Unterstützungsprogression und Bildplatzhalter vorbereitet;
- Challenge auf Zustandskontrolle und Flag-Abgabe begrenzt;
- Teilnehmertexte zunächst als knappe Gerüste für folgende Einzelprompts
  angelegt.

## Version 2.0.0-dev – technische Diagnoseumgebung

- konsistente Umgebung mit `waerter@leuchtturm` und Außenstation vorbereitet;
- kontrollierten CPU-Prozess `beschwoerung` und ruhenden Prozess
  `leuchtfeuer` implementiert;
- sicheren, idempotenten Prozess-Reset und Werkzeug-Fallbacks ergänzt;
- `leuchtfeuer-start`, atomare Statusmarker, Flag-Abgabe und CHECK
  implementiert;
- technische Testdokumentation auf die neue Diagnosemission umgestellt;
- Teilnehmertexte bewusst noch nicht auf die neue Mission umgeschrieben.

## Version 1.0.0 – initiale Erstellung

- vollständige erste Szenarioversion des Workshops erstellt;
- Teilnehmertexte, Setup, Verify, Musterlösung, Dozentenleitfaden und Testdokumentation angelegt.
