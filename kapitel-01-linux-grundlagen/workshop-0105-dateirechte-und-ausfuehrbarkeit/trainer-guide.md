# Trainerleitfaden

## Lernziel

Teilnehmende lesen Rechte und Besitznamen, diagnostizieren fehlendes
Besitzer-`x`, setzen zweimal gezielt `chmod u+x` und kontrollieren zwei
Benutzerwechsel mit `whoami` und `pwd`.

## Beobachten

- Rechteblock korrekt in Dateityp, Besitzer, Gruppe und andere zerlegen.
- Den erwarteten Ausführungsfehler nicht als Defekt missverstehen.
- `u` als Dateibesitzer und nicht als „aktuellen Menschen“ erklären.
- Nach beiden Benutzerwechseln Identität und Home kontrollieren.
- Offen abgelegte sowie erratbare Passwörter als Sicherheitsfehler benennen.
- Keine numerischen Rechte, `chown`, `chgrp` oder zusätzliche
  Administrationsbefehle einführen.

## CHECK-Grenze

Der CHECK bestätigt nur die Flag-Abgabe; auch `flag-einreichen` prüft keine
früheren Lernhandlungen. Rechteänderungen, Ausführungen, Begriffsverständnis
und bewusste Benutzerkontrolle bleiben Beobachtungsziele.
