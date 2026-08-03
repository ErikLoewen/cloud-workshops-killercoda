Version 1.0.0 – initiale Erstellung

Version 2.0.0 – technische Grundstruktur für den Nano- und Konfigurationsworkshop

- Benutzer `waerter`, Hostname `leuchtturm` und neues Startverzeichnis eingerichtet.
- Alte Prozess-, systemd- und Dienstinfrastruktur aus dem Setup entfernt.
- Konfigurationsdatei, Dokumentation, Log, Laufzeitstatus und drei Hilfsskripte ergänzt.
- Nano wird bei Bedarf still über `apt-get` installiert; dies kann beim ersten Start zusätzliche Setupzeit verursachen.

Version 3.0.0 – vollständige Neuausrichtung von Workshop 7

- Workshop 7 vollständig von Prozessen und Diensten auf die Reparatur einer
  Leuchtfeuerkonfiguration ausgerichtet.
- Suche und Auswertung eines Betriebsprotokolls sowie einer Wartungsanleitung
  als neue Lernschritte ergänzt.
- Einfache Konfigurationsdatei mit Kommentaren und drei
  `SCHLUESSEL=WERT`-Einträgen eingeführt.
- Nano-Einführung mit gefahrloser Orientierung, gezielter Bearbeitung,
  Speicherung und anschließendem Kontrolllesen ergänzt.
- Sicherungsroutine mit `leuchtfeuer.conf.bak` vor der ersten Änderung
  eingeführt.
- Gemeinsamen sicheren Parser ohne `source` und `eval` für Prüfung und
  Neuladen implementiert.
- Verständliche Validierung für fehlende, doppelte und unbekannte Schlüssel,
  ungültige Werte sowie Formatfehler ergänzt.
- Gespeicherte Konfiguration und atomar übernommener Laufzeitstatus technisch
  voneinander getrennt.
- Abschlussmission zur selbstständigen Übertragung der Änderung auf den
  Küstenbereich ergänzt.
- Neue Flag `FLAG{die_spur_fuehrt_vom_turm_fort}` mit Sicherungs-, Zustands-,
  Sitzungs- und Flag-Abgabeprüfung eingeführt.
- Alte Prozess-, `lab-worker`-, systemd-, Dienst- und Markerlogik entfernt.
- Technischen End-to-End-, Fehlerpfad-, Reset- und CHECK-Test in einem
  isolierten Ubuntu-24.04-Container erfolgreich durchgeführt; interaktive
  Killercoda-Browser- und Nano-Prüfungen bleiben als Veröffentlichungsgate
  dokumentiert.
- Vollständigen Abschlussreview zu Story, Fachlichkeit, Didaktik, Technik,
  Scope und Dateikonsistenz durchgeführt.
- Übergang zu Workshop 8 präzisiert: Die Fußspuren führen landeinwärts zu den
  alten Gebäuden am Deich und weiter zum Deichserver.
- Technischen Teilnehmerweg nach dem Review erneut erfolgreich ausgeführt.
