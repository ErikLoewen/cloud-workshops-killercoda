# Testprotokoll – Navigation im Nebel

## Allgemeine Angaben

- Datum: 2026-07-30
- Umgebung: lokales Repository und isolierter Container `ubuntu:24.04`
- Nicht getestet: reale Killercoda-Browseroberfläche und Anfängerpilot

## Statische Prüfung

| Prüfung | Ergebnis | Befund |
|---|---|---|
| Bash-Syntax | bestanden | `setup.sh`, `verify.sh` und `assets/eintrag-bestaetigen` sind syntaktisch gültig. |
| JSON | bestanden | `index.json` ist gültig. |
| Referenzen | bestanden | Alle referenzierten Texte und Skripte existieren. |
| Bild | bestanden | PNG vorhanden, `./assets/...` verwendet und nicht als VM-Asset eingetragen. |
| Altbegriffe | bestanden | Keine Treffer für die vorgegebenen alten Pfade, Namen oder Markerbezeichnungen. |
| Diff-Prüfung | bestanden | `git diff --check` meldet keine Fehler. |
| Shellcheck | nicht ausgeführt | `shellcheck` ist lokal nicht installiert. |

## Ubuntu-Integrationstest

| Prüfung | Ergebnis | Befund |
|---|---|---|
| Foreground-Setup | bestanden | Aktuelles Setup endet mit einer echten Login-Shell von `waerter`; Benutzer, Hostname und Home wurden danach bestätigt. |
| Setup zweimal | bestanden | Beide Aufrufe endeten erfolgreich. |
| Benutzer und Host | bestanden | `whoami` als Teilnehmer liefert `waerter`, UID ist ungleich 0, Hostname ist `leuchtturm`. |
| Home und Shell | bestanden | Home ist `/home/waerter`, Start mit `cd ~` führt dorthin, Login-Shell ist `/bin/bash`. |
| Baum und Eigentümer | bestanden | Sollbereiche vorhanden; Einträge unter dem Leuchtturm gehören `waerter`. |
| Eindeutige Präfixe | bestanden | `t`, `k`, `u` und `v` besitzen an den beschriebenen Stellen jeweils genau ein Verzeichnisziel. |
| Falscher Ort | bestanden | Prüfaktion scheitert ohne Marker. |
| Fehlende Zieldatei | bestanden | Prüfaktion scheitert ohne Marker. |
| Unerlaubtes Argument | bestanden | Prüfaktion scheitert ohne Marker. |
| Korrekter Fundort | bestanden | Prüfaktion erzeugt den erwarteten neutralen Marker. |
| Datei unverändert | bestanden | Hash sowie Eigentümer, Gruppe, Modus, Größe und Änderungszeit blieben unverändert. |
| CHECK ohne Marker | bestanden | `verify.sh` scheitert mit handlungsfähiger Rückmeldung. |
| CHECK mit Marker | bestanden | `verify.sh` ist erfolgreich. |

## Offene Tests

- tatsächlicher Foreground-Ablauf mit abschließendem Benutzerwechsel im
  Killercoda-Browser,
- sichtbarer Prompt und vollständig geleertes Browserterminal,
- echte Tab-Taste und Terminalfokus im Browser,
- vollständiger Szenariodurchlauf einschließlich CHECK-Schaltfläche,
- Zeitmessung und Anfängerpilot.
