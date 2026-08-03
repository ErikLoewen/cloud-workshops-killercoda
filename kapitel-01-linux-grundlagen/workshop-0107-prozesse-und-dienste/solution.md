# Musterlösung – Die Konfiguration des Leuchtfeuers reparieren

Diese Datei ist nicht in `index.json` referenziert. Sie dient Trainern,
Entwicklern, technischen Tests und der Pflege der vollständigen
Dropdown-Walkthroughs.

## 1. Benutzer und Standort prüfen

```bash
whoami
pwd
ls
```

Erwartet werden der Benutzer `waerter` und das Arbeitsverzeichnis:

```text
/home/waerter/leuchtturm/lichtsteuerung
```

Falls `pwd` einen anderen Standort zeigt, erst danach gezielt wechseln:

```bash
cd /home/waerter/leuchtturm/lichtsteuerung
pwd
ls
```

## 2. Betriebsprotokoll lesen

```bash
cd protokolle
ls
cat leuchtfeuer.log
```

Das Protokoll nennt `leuchtfeuer.conf`, den geladenen Zustand
`ROTATION=impuls`, die Abweichung vom normalen Rundlauf und den Verweis auf
die Wartungsdokumentation.

## 3. Dokumentation und Konfiguration vergleichen

```bash
cd ../dokumentation
ls
cat wartungsanleitung.txt
cd ..
cat leuchtfeuer.conf
```

Die Wartungsanleitung beschreibt `kreis` als gleichmäßige Bewegung um den
Turm. `GESCHWINDIGKEIT=langsam` und `BEREICH=meer` können bei der ersten
Reparatur unverändert bleiben.

## 4. Ausgangszustand sichern

```bash
cp leuchtfeuer.conf leuchtfeuer.conf.bak
ls -l leuchtfeuer.conf leuchtfeuer.conf.bak
cat leuchtfeuer.conf.bak
```

Die Sicherung muss den ursprünglichen Zustand enthalten:

```ini
# Konfiguration der Leuchtfeuersteuerung
ROTATION=impuls
GESCHWINDIGKEIT=langsam
BEREICH=meer
```

## 5. Rotation mit Nano korrigieren

```bash
nano leuchtfeuer.conf
```

In Nano ausschließlich diese Zeile ändern:

```text
ROTATION=impuls
```

zu:

```text
ROTATION=kreis
```

Danach:

1. `Strg+O` drücken;
2. den angezeigten Dateinamen `leuchtfeuer.conf` mit `Enter` bestätigen;
3. Nano mit `Strg+X` verlassen.

## 6. Erste Änderung kontrollieren und anwenden

```bash
cat leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
```

Erwarteter angewendeter Zwischenzustand:

```text
LEUCHTFEUER=aktiv
ROTATION=kreis
GESCHWINDIGKEIT=langsam
BEREICH=meer
```

## 7. Lichtbereich auf die Küste übertragen

```bash
nano leuchtfeuer.conf
```

In Nano ausschließlich diese Zeile ändern:

```text
BEREICH=meer
```

zu:

```text
BEREICH=kueste
```

Wieder mit `Strg+O` speichern, den Dateinamen mit `Enter` bestätigen und Nano
mit `Strg+X` verlassen.

## 8. Abschlusszustand kontrollieren und anwenden

```bash
cat leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
```

Erwarteter angewendeter Endzustand:

```text
LEUCHTFEUER=aktiv
ROTATION=kreis
GESCHWINDIGKEIT=langsam
BEREICH=kueste
```

Das erfolgreiche Neuladen gibt diese Flag aus und legt sie zusätzlich in
`status/abschlussflagge` ab:

```text
FLAG{die_spur_fuehrt_vom_turm_fort}
```

## 9. Flag einreichen und CHECK starten

```bash
cat status/abschlussflagge
flag-einreichen 'FLAG{die_spur_fuehrt_vom_turm_fort}'
```

Danach den CHECK starten. Er prüft ausschließlich den erfolgreichen
Flag-Abgabemarker der aktuellen Workshop-Sitzung.

## Vollständige Befehlsfolge

```bash
whoami
pwd
ls
cd /home/waerter/leuchtturm/lichtsteuerung
pwd
ls
cd protokolle
cat leuchtfeuer.log
cd ../dokumentation
cat wartungsanleitung.txt
cd ..
cat leuchtfeuer.conf
cp leuchtfeuer.conf leuchtfeuer.conf.bak
ls -l leuchtfeuer.conf leuchtfeuer.conf.bak
cat leuchtfeuer.conf.bak
nano leuchtfeuer.conf
cat leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
nano leuchtfeuer.conf
cat leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
cat status/abschlussflagge
flag-einreichen 'FLAG{die_spur_fuehrt_vom_turm_fort}'
```

Die absolute `cd`-Zeile ist im vollständigen Block absichtlich enthalten,
wird aber erst nach `pwd` verwendet. Die beiden Nano-Änderungen entsprechen
den Abschnitten 5 und 7.

## Schneller technischer Testweg

Dieser Weg ist ausschließlich für Trainer und automatisierte technische
Kontrollen gedacht. Er ersetzt nicht die Nano-Lernhandlung.

```bash
cd /home/waerter/leuchtturm/lichtsteuerung
cp leuchtfeuer.conf leuchtfeuer.conf.bak
sed -i 's/^ROTATION=impuls$/ROTATION=kreis/' leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
sed -i 's/^BEREICH=meer$/BEREICH=kueste/' leuchtfeuer.conf
./konfiguration-pruefen
./leuchtfeuer-neu-laden
./leuchtfeuer-status
cat status/abschlussflagge
flag-einreichen 'FLAG{die_spur_fuehrt_vom_turm_fort}'
```

## Wiederherstellung aus der Sicherung

Falls die Arbeitsdatei nicht mehr sinnvoll korrigiert werden kann:

```bash
cp leuchtfeuer.conf.bak leuchtfeuer.conf
cat leuchtfeuer.conf
./konfiguration-pruefen
```

Das Zurückkopieren verändert zunächst nur die Datei. Soll der gesicherte
Zustand auch wieder angewendet werden, muss er danach bewusst neu geladen und
kontrolliert werden.

## Typische Fehler

| Fehler | Einordnung und nächster Schritt |
|---|---|
| Nano ist nicht installiert | Das Setup muss Nano bereitstellen. `command -v nano` dient der technischen Diagnose; Lernende sollen keine Pakete selbst installieren. |
| Falsches Arbeitsverzeichnis | Zuerst `pwd` prüfen und anschließend nach `/home/waerter/leuchtturm/lichtsteuerung` wechseln. |
| Sicherung im falschen Verzeichnis | `leuchtfeuer.conf.bak` muss neben `leuchtfeuer.conf` liegen. |
| `leuchtfeuer.conf.bak` überschrieben | Workshop neu starten, um den definierten Ausgangszustand wiederherzustellen, und die Sicherung vor der Bearbeitung neu anlegen. |
| `kries` statt `kreis` | Fehlermeldung lesen und den Wert in Nano auf `kreis` korrigieren. |
| `kuste` statt `kueste` | Den dokumentierten Wert `kueste` ohne Umlaut verwenden. |
| Leerzeichen um `=` | Das Workshopformat verlangt exakt `SCHLUESSEL=WERT`. |
| Schlüssel gelöscht | Den fehlenden Schlüssel anhand der Sicherung wiederherstellen. |
| Falschen Dateinamen bei `Strg+O` bestätigt | Prüfen, welche Datei gespeichert wurde, und `leuchtfeuer.conf` erneut korrekt öffnen und speichern. |
| Nano ohne Speichern verlassen | Datei erneut öffnen, Änderung wiederholen und mit `Strg+O`, `Enter`, `Strg+X` abschließen. |
| Datei gespeichert, aber nicht validiert | `./konfiguration-pruefen` ausführen und mögliche Fehler korrigieren. |
| Datei validiert, aber nicht neu geladen | `./leuchtfeuer-neu-laden` ausführen. |
| Status mit Konfigurationsdatei verwechselt | `cat leuchtfeuer.conf` zeigt gespeicherten Text; `./leuchtfeuer-status` zeigt den angewendeten Zustand. |
| Flag nicht notiert | `cat status/abschlussflagge` ausführen, solange der vollständige Missionszustand angewendet ist. |
| Falsche Flag eingereicht | Den vollständigen Text ohne zusätzliche Leerzeichen aus `status/abschlussflagge` übernehmen. |
