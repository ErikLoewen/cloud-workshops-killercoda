# Trainerleitfaden

## Lernziel

Teilnehmende lesen Rechte und Besitznamen, diagnostizieren fehlendes
Besitzer-`x`, setzen zweimal gezielt `chmod u+x` und kontrollieren
Benutzerwechsel mit `whoami` und `pwd`.

## Didaktische Ebenen

- Der offene Haupttext erklärt Konzept, Situation und Untersuchungsauftrag.
- Geschlossene Hinweise bieten Unterstützung von Denkrichtung über Fundort bis
  zum konkreten Ansatz.
- Der vollständige Walkthrough ist die letzte Rückfallebene für Betreuung,
  Selbstkorrektur und schnelle technische Tests.

Passwörter dürfen im Setup, in `solution.md` und im geschlossenen vollständigen
Walkthrough stehen. Im offenen Lerntext werden sie weder genannt noch durch
eine fertige Schlussfolgerung ersetzt.

## Vor einem Hinweis fragen

- Wem gehört die Datei?
- Welcher Rechteblock gilt für dich?
- Was kannst du aktuell lesen?
- Welche Information hast du bereits gefunden?
- Unter welchem Konto arbeitest du gerade?
- Welche zwei Beobachtungen lassen sich möglicherweise verbinden?

Erst wenn diese Fragen nicht weiterhelfen, die nächste Hinweisstufe öffnen.

## Beobachten

- Rechteblock korrekt in Dateityp, Besitzer, Gruppe und andere zerlegen.
- Besitzer- und Gruppenname in den eigenen Spalten erkennen.
- Den erwarteten Ausführungsfehler nicht als Defekt missverstehen.
- `u` als Dateibesitzer und nicht als „aktuellen Menschen“ erklären.
- Nach Benutzerwechseln Identität und Home kontrollieren.
- Getrennte Hinweise selbst kombinieren.
- Offen abgelegte oder erratbare Zugangsdaten als Sicherheitsfehler benennen.
- Keine numerischen Rechte, `chown`, `chgrp` oder zusätzliche
  Administrationsbefehle einführen.

## CHECK-Grenze

`flag-einreichen` vergleicht ausschließlich die Flag und schreibt bei Erfolg
atomar den Abgabemarker. Der CHECK liest ausschließlich diesen Marker.
Rechteänderungen, Ausführungen, Benutzerwechsel und Begriffsverständnis bleiben
Beobachtungsziele.

## Schneller Testpfad

Der vollständige Ablauf mit beiden Passwörtern und der Flag steht in
`solution.md`. Die letzten Dropdowns der komplexen Schritte enthalten
denselben Ablauf abschnittsweise.
