# Schritt 3: Eigene Prüfreihenfolge

Plane deine Sichtkontrolle, bevor du den technischen CHECK verwendest.

## 1. Vorlage und Webkopie

Kontrolliere:

- Die Vorlage ist weiterhin vorhanden.
- Die neue Datei heißt `index.html`.
- Beide Dateien zeigen denselben Inhalt.
- Die Quelle wurde nicht verschoben oder ersetzt.

## 2. Entfernte Altobjekte

Kontrolliere getrennt:

- `alt.txt` fehlt.
- `leeres-archiv` fehlt.
- `temp-build` fehlt vollständig.

## 3. Prüfdatei

Kontrolliere:

- Der Besitzer besitzt Lesen, Schreiben und Ausführen.
- Gruppe und andere besitzen nur Lesen.
- Die Datei hat bei der Ausführung genau diese sichtbare Meldung erzeugt:

```text
Systemcheck erfolgreich ausgeführt
```

## 4. Statusdatei

Kontrolliere:

- Die Datei enthält genau eine Zeile.
- Die CPU-Anzahl stammt aus der aktuellen Ausgabe.
- Der Schnittstellenname steht in der Standardroute direkt hinter `dev`.
- Keine Platzhalter oder spitzen Klammern sind übrig.
- Die Datei wurde mit **cat** sichtbar geprüft.

## 5. Schutzbereich

Kontrolliere:

- Der Ordner ist weiterhin vorhanden.
- Er enthält ausschließlich `wichtig.txt`.
- Der Inhalt ist unverändert.
- Es wurden keine Rechte geändert.

## 6. Server und HTTP

Kontrolliere getrennt:

- Der Server wurde aus dem Webverzeichnis gestartet.
- Der Listener zeigt IPv4-Adresse `127.0.0.1` und Port `9090`.
- Es gibt keine Bindung an alle IPv4- oder IPv6-Adressen.
- Die lokale HTTP-Anfrage zeigt:

```text
Linux-Grundlagen erfolgreich angewendet
```

## Vor dem CHECK

Beantworte kurz:

- Welche Kontrolle weist nur einen Listener nach?
- Welche Kontrolle weist den ausgelieferten Inhalt nach?
- Warum können diese beiden Nachweise nicht durch eine einzige Beobachtung
  ersetzt werden?
