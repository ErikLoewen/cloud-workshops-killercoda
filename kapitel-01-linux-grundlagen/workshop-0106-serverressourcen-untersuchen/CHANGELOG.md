# Changelog

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
