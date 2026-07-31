# Trainerleitfaden

## Lernziel und Zeit

Teilnehmende sichern eine wichtige Datei mit `cp`, unterscheiden `cp` von
`mv` und entfernen ausschließlich geprüfte Ziele mit `rm`, `rmdir` und
`rm -r`. Zielzeit: 35–48 Minuten mit mindestens 12 Minuten Puffer.

## Beobachten

- Quelle und Ziel werden vor `cp` benannt.
- Vor jeder Löschung folgen `pwd`, Zielprüfung, Vorhersage und Kontrolle.
- Der `rmdir`-Fehler wird als Schutzwirkung erklärt.
- Vor `rm -r` wird der gesamte Baum gelesen.
- Nach `rm -r` wird die neu erschienene Notiz entdeckt, gelesen und ihre Flag
  eingereicht.
- Die Meme-Zeile wird nur analysiert, nie kopiert oder ausgeführt.
- Die volle Kiste sowie das Root-geschützte Original bleiben unverändert.

Sofort eingreifen, wenn das Ziel außerhalb des Kartenraums liegt, ein höherer
Pfad, eine Wildcard, `sudo` oder `-f` für eine praktische Löschung verwendet
werden soll.

## Typische Fehlvorstellungen

| Fehlvorstellung | Rückführung |
|---|---|
| `cp` verschiebt | Quelle und Kopie gemeinsam mit `ls` prüfen. |
| Keine Ausgabe bedeutet Fehler | Den Zustand kontrollieren. |
| `rmdir` ist defekt | Inhalt zeigen und Schutzwirkung erklären lassen. |
| `-f` repariert | Pfad, Objektart und eigentliche Fehlerursache prüfen. |
| CHECK beweist den Ablauf | Der CHECK bestätigt nur die Flag-Abgabe; Lernweg und Sicherheitsleistung beobachten. |

Hinweise gestuft öffnen: Konzept → Werkzeuge → Muster → vollständige Methode.
