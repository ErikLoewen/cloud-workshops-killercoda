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
    Der Abgabemarker muss ohne Schreibzugriff auf den geschützten technischen
    Statusordner angelegt und atomar ersetzt werden können.
11. Alle übrigen Kontrollen vor der Flag-Abgabe abschließen; nach erfolgreicher
    Abgabe muss der CHECK sofort und wiederholt erfolgreich sein.

## Negative CHECK-Fälle

12. CHECK ohne oder mit ungültigem Abgabemarker ablehnen.
13. Nach erfolgreicher Flag-Abgabe keine weiteren Dateisystemkriterien prüfen.

## Teilnehmertexte und Plattform

14. Keine alten Laborpfade oder Root-/Ubuntu-Prompts.
15. Kein Löschbefehl mit ausführbarer Code-Aktion.
16. Meme-Zeile nur in nicht kopierbarem `<pre><code>` und klarer Warnung.
17. Alle `index.json`-Referenzen und lokalen Bildlinks prüfen.
18. Intro- und Outrobild-Platzhalter eindeutig finden.
19. Flagge erst nach Entfernung der eingestürzten Ecke sichtbar machen und als
    Voraussetzung des CHECKs prüfen.
20. Vollständigen Killercoda-Lauf und Anfängerpilot manuell durchführen.
