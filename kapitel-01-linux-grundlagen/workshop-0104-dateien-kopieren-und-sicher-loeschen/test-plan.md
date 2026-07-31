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
   entfernen.
10. Abschlusskopie erstellen; CHECK muss erfolgreich sein und wiederholt
    read-only erfolgreich bleiben.

## Negative CHECK-Fälle

11. Fehlendes, verändertes oder verlinktes Original ablehnen.
12. Fehlende, falsche, symbolisch verlinkte oder hardverlinkte Kopie ablehnen.
13. Jedes noch vorhandene Löschziel getrennt melden.
14. Fehlende, veränderte, verlinkte oder ergänzte volle Kiste ablehnen.
15. Veränderte Eigentümer oder Rechte des Originals ablehnen.
16. Fehlende oder manipulierte Referenzdaten als technischen Fehler melden.

## Teilnehmertexte und Plattform

17. Keine alten Laborpfade oder Root-/Ubuntu-Prompts.
18. Kein Löschbefehl mit ausführbarer Code-Aktion.
19. Meme-Zeile nur in nicht kopierbarem `<pre><code>` und klarer Warnung.
20. Alle `index.json`-Referenzen und lokalen Bildlinks prüfen.
21. Intro- und Outrobild-Platzhalter eindeutig finden.
22. Flagge nur auf der nach erfolgreichem CHECK sichtbaren Finish-Seite.
23. Vollständigen Killercoda-Lauf und Anfängerpilot manuell durchführen.
