# Trainerleitfaden

## Zweck

Workshop 10 ist eine formative Transferaufgabe und keine benotete Prüfung.
Der technische CHECK und die menschliche Beobachtung werden strikt getrennt.

## Beobachtungsskala

### Stufe A – selbstständig

- ohne inhaltlichen Hinweis geplant
- Zielzustand erreicht
- Schutzbereich beachtet
- Wirkungskette erklärt

### Stufe B – geringer Hinweisbedarf

- höchstens Hinweisstufe 1 verwendet
- Sicherheits- und Rechteprinzipien überwiegend selbstständig angewendet

### Stufe C – Werkzeughinweise erforderlich

- Hinweisstufe 2 verwendet
- Endzustand anschließend selbstständig hergestellt

### Stufe D – Strukturhilfe erforderlich

- Hinweisstufe 3 verwendet
- deutliche Strukturierung notwendig

### Stufe E – nahezu vollständige Methode erforderlich

- Hinweisstufe 4 verwendet
- technische Durchführung abgeschlossen
- Transferleistung noch nicht ausreichend selbstständig

Keine Punkte, Noten oder Bestehensgrenzen ableiten.

## Menschlich zu prüfende Transferleistungen

Beobachte, ob die Teilnehmenden:

- Quelle, Arbeitsbereiche und Schutzbereich unterscheiden
- ihre Prüfreihenfolge begründen
- Kopieren und Verschieben fachlich unterscheiden
- Objektarten den drei bekannten Löschhandlungen zuordnen
- vor destruktiven Handlungen Standort und Ziel prüfen
- nur `temp-build` als rekursives Ziel verwenden
- das fehlende Besitzer-Ausführungsrecht erkennen
- die Bedeutung von `u+x` und `./` erklären
- CPU-Anzahl und primäre Schnittstelle korrekt aus Ausgaben auswählen
- Listener und HTTP-Inhalt als unterschiedliche Nachweise erklären
- mindestens vier Glieder der Wirkungskette frei verbinden
- Grenzen des technischen CHECKs benennen

## Freigabe der Hinweisstufen

- Hinweis 1 erst nach einem erkennbaren eigenen Planungsversuch
- Hinweis 2 bei fehlender Werkzeugzuordnung
- Hinweis 3 bei fehlender Befehlsstruktur
- Hinweis 4 erst nach einem eigenen technischen Versuch oder bei
  festgefahrenem Lernprozess

Dokumentiere nur die höchste benötigte Stufe und wichtige Beobachtungen.

## Eingriffskriterien vor destruktiven Handlungen

Sofort stoppen, bevor Enter gedrückt wird, wenn:

- der Zielpfad über `temp-build` hinausgeht
- der Schutzbereich im verändernden Befehl erscheint
- der Teilnehmerstamm, das Webverzeichnis oder ein Elternpfad Ziel der
  rekursiven Löschung ist
- der Zielpfad nicht vollständig gelesen wurde
- die erwartete Wirkung nicht benannt werden kann

Danach nur die bekannte Sicherheitsroutine abrufen. Keine vollständige
Lösung vorsagen.

## Zu hoher Löschpfad

Lass den Zielpfad Segment für Segment lesen und frage:

- Welches einzelne Altobjekt soll verschwinden?
- Welche Bestandteile des Pfads müssen erhalten bleiben?
- Ist das Ziel eine Datei, ein leeres oder ein nicht leeres Verzeichnis?

Das einzige rekursive Ziel ist
`/root/abschlusslabor/web/temp-build`.

## Zu weitreichende Rechte

Lass die drei Rechteblöcke erneut lesen. Frage:

- Welcher Bereich steht für den Besitzer?
- Welches einzelne Recht fehlt?
- Welche Rechte sollen Gruppe und andere behalten?

Keine numerische Berechtigungsform als Teilnehmerlösung nennen.

## Falscher Serverstart

Der normale Kernpfad enthält keine Prozessbeendigung.

Nur bei eindeutig bekannter PID:

1. `ps` ohne neue Option ausführen lassen.
2. PID und eigener Python-Server müssen eindeutig zusammengehören.
3. ausschließlich diese PID mit `kill PID` beenden lassen.
4. Port mit `ss -ltn` erneut prüfen lassen.

Bei unklarer PID oder mehreren nicht sicher unterscheidbaren Prozessen:
keine Beendigung raten, vollständigen Szenarioneustart verwenden.

## Technische Szenariofehler

Nicht als Teilnehmerfehler behandeln:

- technische Referenzen fehlen oder sind beschädigt
- keine genau eine verwendbare Standardroute
- direkte Ausführung durch Dateisystem verhindert
- Eigentümer- oder Markerrechte sind technisch inkompatibel
- Port 9090 ist beim Setup durch einen fremden Prozess belegt
- Socket und Prozess lassen sich nicht eindeutig zuordnen
- plain `localhost` erreicht den IPv4-Loopbackserver nicht zuverlässig

Befund dokumentieren und Veröffentlichung beziehungsweise Pilot anhalten.

## Typische Lernfehler

- Quelle und Ziel beim Kopieren vertauscht
- passende Löschhandlung nicht aus dem Objekttyp abgeleitet
- Schutzkontrolle nach einer Löschung ausgelassen
- Ausführungsrecht auch Gruppe oder anderen gegeben
- Prüfdatei nicht aus ihrem Verzeichnis gestartet
- Platzhalter in der Statusdatei stehen gelassen
- Schnittstellenname nicht direkt hinter `dev` gelesen
- Server aus dem falschen Verzeichnis gestartet
- Listener mit richtigem Inhalt gleichgesetzt
- Servermeldungen als neu einzugebende Befehle interpretiert

Feedback nennt Beobachtung, Ziel und einen bekannten nächsten Prüfschritt.

## Zeitmessung

Erfasse getrennt:

- Orientierung und Schutzgrenzen
- Lösungsplanung
- Dateioperationen
- Rechte und Systemcheck
- Statusdatei
- Server und Sichtkontrolle
- CHECK und Korrektur
- Gesamtzeit
- höchste Hinweisstufe

Zielkorridore:

- geübt 36 bis 40 Minuten
- absolute Anfänger 45 bis 50 Minuten
- mindestens 10 Minuten Puffer

## Schutzverletzungen

Dokumentiere:

- Art der geplanten oder ausgeführten Schutzverletzung
- ob ein Trainerstopp nötig war
- höchster geplanter Löschpfad
- ob die Sicherheitsroutine ohne Erinnerung angewendet wurde

## Wirkungskettenfragen

- Warum reicht die Vorlagendatei allein nicht als HTTP-Antwort?
- Welche Rolle besitzt das Arbeitsverzeichnis des Servers?
- Was weist der Listener nach?
- Was weist die HTTP-Anfrage zusätzlich nach?
- Warum ist `127.0.0.1` eine lokale Bindung?
- Warum müssen Adresse und Port in den drei Beobachtungen übereinstimmen?

## Technikcheck und Verständnis

Ein erfolgreicher CHECK bedeutet nur, dass der technische Endzustand
beobachtet wurde. Selbstständige Planung, Sicherheitsverhalten und Verständnis
werden ausschließlich durch Aufgabenbearbeitung und Erklärung eingeschätzt.
