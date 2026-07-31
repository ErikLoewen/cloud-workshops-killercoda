# Testplan

## Setup und Umgebung

1. Bash-Syntax und JSON prüfen.
2. Setup in frischer Ubuntu-Umgebung zweimal ausführen.
3. Echten Benutzer `waerter`, Home `/home/waerter`, Hostnamen `leuchtturm`
   und Startort im Kartenraum prüfen.
4. Eigentümer und Modi prüfen: `original/` Root `0555`, Original Root `0444`,
   übrige Arbeitsbereiche `waerter`-beschreibbar.
5. Als `waerter` Lesen und Kopieren erlauben, Überschreiben und Entfernen des
   Originals ablehnen.

## Positiver Weg

6. Vorlagenkopie erstellen und beide Dateien erhalten.
7. Einzeldatei mit `rm`, leere Mappe mit `rmdir` entfernen.
8. `rmdir` auf voller Kiste muss scheitern; Kiste und Inhalt bleiben erhalten.
9. Baum der eingestürzten Ecke vollständig prüfen und nur diesen mit `rm -r`
   entfernen; `notiz-aus-der-wand.txt` muss innerhalb eines kurzen
   Polling-Intervalls erscheinen.
10. Flag aus der neuen Notiz lesen und korrekt einreichen.
11. Abschlusskopie erstellen; CHECK muss erfolgreich sein und wiederholt
    read-only erfolgreich bleiben.

## Negative CHECK-Fälle

12. Fehlendes, verändertes oder verlinktes Original ablehnen.
13. Fehlende, falsche, symbolisch verlinkte oder hardverlinkte Kopie ablehnen.
14. Jedes noch vorhandene Löschziel getrennt melden.
15. Fehlende, veränderte, verlinkte oder ergänzte volle Kiste ablehnen.
16. Fehlende, veränderte oder verlinkte Wandnotiz sowie eine fehlende oder
    falsche Flag-Abgabe ablehnen.
17. Veränderte Eigentümer oder Rechte des Originals ablehnen.
18. Fehlende oder manipulierte Referenzdaten als technischen Fehler melden.

## Teilnehmertexte und Plattform

19. Keine alten Laborpfade oder Root-/Ubuntu-Prompts.
20. Kein Löschbefehl mit ausführbarer Code-Aktion.
21. Meme-Zeile nur in nicht kopierbarem `<pre><code>` und klarer Warnung.
22. Alle `index.json`-Referenzen und lokalen Bildlinks prüfen.
23. Intro- und Outrobild-Platzhalter eindeutig finden.
24. Flagge erst nach Entfernung der eingestürzten Ecke sichtbar machen und als
    Voraussetzung des CHECKs prüfen.
25. Vollständigen Killercoda-Lauf und Anfängerpilot manuell durchführen.
