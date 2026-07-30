# Testplan – Navigation im Nebel

Diese Datei beschreibt geplante Prüfungen. Tatsächliche Ergebnisse stehen
ausschließlich in `test-results.md`.

## T01 – Frischer Szenariostart

- Das Foreground-Setup stellt die Umgebung vollständig her und wechselt
  anschließend mit `exec su - waerter` in die Teilnehmer-Shell.
- Der sichtbare Prompt lautet `waerter@leuchtturm:~$`.
- Das Terminal enthält keine sichtbaren Setup-Zeilen.

Erwartete Kommandowerte:

```text
whoami   → waerter
hostname → leuchtturm
pwd      → /home/waerter
```

`id` muss eine UID ungleich 0 zeigen.

## T02 – Idempotentes Setup

- `setup.sh` zweimal als Root ausführen.
- Beide Läufe enden mit Exit-Code 0.
- Benutzer, Gruppe, Home, Bash-Shell und Hostname bleiben korrekt.
- Der Verzeichnisbaum wird reproduzierbar hergestellt.
- Ein alter Erfolgsmarker wird entfernt.

## T03 – Verzeichnisbaum und Rechte

Sollstruktur und Iststruktur vollständig vergleichen:

```text
/home/waerter/leuchtturm
├── eingang
├── obergeschoss
│   ├── funkraum
│   └── kartenraum
├── technik
│   ├── kontrollraum
│   └── maschinenraum
└── untergeschoss
    ├── lagerraum
    │   └── archiv
    │       └── letzter_eintrag.txt
    └── vorratsraum
```

Alle vorbereiteten Einträge müssen `waerter` gehören. Navigation und Lesen
der Namen müssen ohne Root-Rechte funktionieren.

## T04 – Tab-Vervollständigung

Im realen Browserterminal prüfen:

- `t` ergänzt eindeutig `technik/`,
- dort ergänzt `k` eindeutig `kontrollraum/`,
- `u` ergänzt eindeutig `untergeschoss/`,
- dort ergänzt `v` eindeutig `vorratsraum/`,
- Tab führt keinen Befehl aus.

## T05 – Prüfaktion: Argument

`eintrag-bestaetigen test` muss mit Exit-Code ungleich 0 enden und darf
keinen Marker erzeugen.

## T06 – Prüfaktion am falschen Ort

Aus dem `eingang` ohne Argument aufrufen. Erwartet:

- Exit-Code ungleich 0,
- kein Marker,
- kein vollständiger Lösungspfad in der Rückmeldung.

## T07 – Prüfaktion ohne letzten Eintrag

In einer isolierten Testumgebung die Zieldatei vorübergehend entfernen und
die Aktion am korrekten Ort aufrufen. Erwartet:

- Exit-Code ungleich 0,
- kein Marker.

Danach den definierten Ausgangszustand wiederherstellen.

## T08 – Erfolgreiche Prüfaktion

Im Archiv vor und nach dem Aufruf Hash, Inhalt und Metadaten von
`letzter_eintrag.txt` vergleichen. Erwartet:

- Aufruf ohne Argument endet mit Exit-Code 0,
- neutraler Marker enthält exakt `navigation-im-nebel:v1`,
- die gefundene Datei bleibt unverändert.

## T09 – CHECK

- Ohne Marker schlägt `verify.sh` mit einem handlungsfähigen Hinweis fehl.
- Mit falschem Markerinhalt schlägt es fehl und verändert nichts.
- Nach T08 ist der CHECK erfolgreich.
- Wiederholte CHECKs verändern weder Marker noch Zieldatei.

## T10 – Statische Qualität

- `index.json` ist gültig.
- Alle Text-, Foreground-, Verify- und VM-Asset-Referenzen existieren.
- Das PNG liegt unter `assets/`, wird mit `./assets/...` eingebunden und
  steht nicht in `details.assets`.
- Bash-Syntax aller Skripte ist gültig; Skripte sind ausführbar.
- Teilnehmertexte führen nur `pwd`, `ls` und `cd` als Linux-Lernbefehle ein.
- Alte Pfade und Begriffe sind vollständig entfernt.

## T11 – Zeit und Didaktik

- mindestens zwei geübte Durchläufe,
- mindestens fünf Durchläufe mit absoluten Anfängern,
- Zielkorridor ungefähr 30 Minuten,
- benötigte Hinweisstufe und technische Verzögerungen getrennt erfassen.
