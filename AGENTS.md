# LabForge Killercoda Repository

Dieses Repository enthält interaktive Killercoda-Workshops.

## Verbindliche Referenzen

Lies vor jeder inhaltlichen oder technischen Änderung vollständig:

1. `skills/01-workshopdidaktik-evidenzbasiert.md`
2. `skills/02-killercoda-authoring-standards.md`
3. `skills/03-workshop-aenderungen.md`

Diese Dateien sind verbindliche Arbeitsgrundlagen. Bei Widersprüchen gilt:

1. Sicherheit und ausdrückliche Benutzeranforderungen,
2. aktuell verifizierte offizielle Killercoda-Dokumentation,
3. Killercoda-Authoring-Standard,
4. Workshopdidaktik,
5. lokale Konventionen des betroffenen Kapitels.

## Hauptaufgabe

Der erste vollständige Workshopentwurf wird normalerweise außerhalb dieses Repositorys erstellt.

Deine Hauptaufgabe ist die gezielte Pflege bestehender Workshops:

- Fehler korrigieren,
- Erklärungen verbessern,
- Aufgaben ergänzen oder vereinfachen,
- Challenges anpassen,
- Setup- und Verify-Skripte überarbeiten,
- technische Änderungen konsistent übertragen,
- Workshops didaktisch und technisch prüfen.

Erstelle keinen vollständigen neuen Workshop und führe kein grundlegendes Redesign durch, außer der Benutzer verlangt dies ausdrücklich.

## Vorgehen bei Änderungen

1. Lies den gesamten betroffenen Szenarioordner.
2. Ermittle Lernziel, Zielgruppe, Voraussetzungen und vorgesehenen Endzustand.
3. Prüfe alle Dateien, die durch die Änderung beeinflusst werden können.
4. Vergleiche die geplante Änderung mit den verbindlichen Referenzen.
5. Recherchiere aktuelle Primärquellen, wenn Killercoda-Syntax, Softwareversionen, CLI-Syntax, Sicherheit oder Plattformfunktionen betroffen sind.
6. Nimm die kleinste sinnvolle zusammenhängende Änderung vor.
7. Prüfe danach alle betroffenen Dateien erneut auf inhaltliche und technische Konsistenz.

## Zusammengehörige Dateien

Betrachte insbesondere gemeinsam:

- `index.json`
- `structure.json`
- `intro.md`
- alle Schrittdateien
- `challenge.md`
- `finish.md`
- `setup.sh`
- `foreground.sh`
- `background.sh`
- `verify.sh`
- `solution.md`
- `trainer-guide.md`
- `test-plan.md`

Ändert sich ein Port, Pfad, Dateiname, Containername, Service, Benutzername, Passwort, URL, Traffic-Platzhalter oder Lernziel, suche nach allen dazugehörigen Vorkommen und passe nur echte Abhängigkeiten an.

## Didaktische Mindestprüfung

Änderungen dürfen nicht:

- neue notwendige Konzepte erst in der Abschlusschallenge einführen,
- ausschließlich Copy-and-paste verlangen,
- Anfänger ohne Vorbereitung in freie Problemlösung schicken,
- Lernziel, Aufgabe und Verify voneinander entkoppeln,
- unnötig viele neue Begriffe oder Befehle gleichzeitig einführen,
- die vorgesehene Bearbeitungszeit ohne ausdrücklichen Hinweis überschreiten,
- Hilfen entfernen, ohne den Kenntnisstand der Zielgruppe zu berücksichtigen.

Prüfe insbesondere:

- beobachtbare Lernhandlung,
- Vorhersage oder Diagnose,
- eigene Erklärung,
- gestützte Anwendung,
- selbstständige Challenge,
- technische Prüfung,
- Abruf oder Transfer,
- realistisches Zeitbudget mit Puffer.

## Killercoda-Regeln

Erfinde keine Killercoda-Felder, Backend-IDs, Markdown-Aktionen oder Platzhalter.

Bei Unsicherheit prüfe zuerst:

1. offizielle Killercoda-Creator-Dokumentation,
2. offizielles Repository `killercoda/scenario-examples`,
3. offizielles Repository `killercoda/scenario-examples-groups`.

Behandle jede Killercoda-Sitzung als unabhängig. Verwende keine echten Zugangsdaten und keine externen Angriffsziele.

## Änderungsbericht

Nenne nach jeder Bearbeitung:

- geänderte Dateien,
- fachliche Änderung,
- didaktische Begründung,
- technische Konsistenzprüfung,
- verwendete Recherchequellen,
- nicht lokal überprüfbare Punkte.
