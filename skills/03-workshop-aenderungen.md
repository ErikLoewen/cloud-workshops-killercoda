---
title: LabForge Änderungsworkflow
purpose: Verbindlicher Arbeitsprozess für Änderungen an bestehenden Killercoda-Workshops
language: de
priority: Hoch
---

# LabForge Änderungsworkflow

## 1. Zweck

Diese Datei gilt für Änderungen an bestehenden Killercoda-Workshops.

Der Agent soll vorhandene Inhalte analysieren und gezielt verändern. Er soll keinen vollständigen Workshop neu schreiben, wenn nur eine begrenzte Änderung verlangt wurde.

## 2. Änderungsumfang bestimmen

### Lokale Änderung

Beispiele:

- Tippfehler korrigieren,
- einzelne Erklärung präzisieren,
- Fehlermeldung verständlicher machen,
- einen Befehl austauschen.

Bearbeite nur unmittelbar betroffene Dateien, prüfe aber mögliche Verweise in angrenzenden Dateien.

### Szenarioweite Änderung

Beispiele:

- Port ändern,
- Pfad oder Dateiname ändern,
- Container- oder Servicenamen ändern,
- Challenge verändern,
- Lernziel anpassen,
- Verify-Kriterium verändern.

Lies und prüfe den vollständigen Szenarioordner.

### Kapitelweite Änderung

Beispiele:

- einheitliches Zeitformat,
- einheitliche Begriffsnutzung,
- neue Challenge-Konvention,
- wiederkehrende technische Voraussetzung,
- Anpassung einer Progression über mehrere Workshops.

Prüfe alle betroffenen Szenarien des Kapitels und achte auf die Reihenfolge des Kompetenzaufbaus.

## 3. Vor jeder Bearbeitung

Ermittle:

- das aktuelle Lernziel,
- die Zielgruppe und ihr Vorwissen,
- bereits eingeführte Begriffe und Werkzeuge,
- die selbstständig auszuführende Handlung,
- den erwarteten Endzustand,
- die Erfolgskriterien,
- die zuständigen Setup- und Verify-Dateien,
- Auswirkungen auf Lösung, Trainerleitfaden und Testplan.

## 4. Recherche

Recherchiere aktuelle Informationen, wenn die Änderung betrifft:

- Killercoda-Funktionen,
- Backend-Images,
- Markdown-Code-Aktionen,
- Traffic-Platzhalter,
- Softwareversionen,
- Paketnamen,
- CLI-Syntax,
- Sicherheitsstandards,
- technische Best Practices.

Bevorzuge Primärquellen:

- offizielle Dokumentation,
- offizielle Repositories,
- offizielle Release Notes,
- technische Standards.

Bei rein redaktionellen Änderungen ist keine Webrecherche erforderlich.

Dokumentiere kurz, welche Aussagen durch Recherche bestätigt wurden.

## 5. Didaktische Änderungsprüfung

Prüfe, ob die Änderung:

- unmittelbar zum Lernziel beiträgt,
- zusätzliches Vorwissen voraussetzt,
- neue kognitive Belastung erzeugt,
- eine vorherige Demonstration benötigt,
- Hilfen zu früh entfernt,
- die Challenge wesentlich schwieriger macht,
- das Verify-Skript beeinflusst,
- Transfer oder Selbst-Erklärung entfernt,
- die Bearbeitungszeit verändert.

Eine gewünschte Änderung darf fachlich angepasst oder kritisch markiert werden, wenn ihre wörtliche Umsetzung gegen zentrale didaktische oder sicherheitstechnische Prinzipien verstößt. Die Absicht des Benutzers soll dabei soweit wie möglich erhalten bleiben.

## 6. Technische Konsistenz

Suche bei Änderungen nach allen Vorkommen von:

- Ports,
- Pfaden,
- Dateinamen,
- Containernamen,
- Image-Namen und Tags,
- Services,
- Benutzernamen,
- Demo-Passwörtern,
- URLs,
- Traffic-Platzhaltern,
- erwarteten Ausgaben,
- Verify-Bedingungen.

Passe nur tatsächliche Abhängigkeiten an. Verändere keine angrenzenden Inhalte nur aus stilistischen Gründen.

## 7. Verify-Regeln

Ein Verify-Skript prüft den fachlich relevanten Endzustand.

Es darf nicht:

- die Lösung selbst herstellen,
- eine bestimmte Befehlsreihenfolge voraussetzen,
- einen bestimmten Editor verlangen,
- irrelevante Nebenbedingungen prüfen,
- versteckte Anforderungen enthalten,
- bei Fehlern nur eine pauschale Falschmeldung ausgeben.

Es soll:

- unterschiedliche gültige Lösungswege akzeptieren,
- konkrete Diagnosehinweise geben,
- schnell und nichtinteraktiv laufen,
- den Zustand nicht verändern,
- bei Erfolg Exit-Code 0 liefern.

## 8. Umgang mit Unsicherheit

Bei Unsicherheit:

1. erst lokalen Kontext lesen,
2. dann verbindliche Referenzdateien prüfen,
3. bei technischen Fragen Primärquellen recherchieren,
4. keine Syntax aus dem Gedächtnis erfinden,
5. verbleibende Unsicherheit offen benennen.

## 9. Abschlussbericht

Fasse nach jeder Änderung knapp zusammen:

1. geänderte Dateien,
2. fachliche Änderung,
3. didaktische Prüfung,
4. technische Konsistenzprüfung,
5. Recherchequellen,
6. verbleibende Risiken oder manuelle Tests.
