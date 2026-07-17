# Trainerleitfaden

## Zweck

Der Workshop prüft nicht möglichst schnelles Löschen. Erfolgreiches Verhalten bedeutet:

> Nur ausdrücklich freigegebene Ziele entfernen und den Schutzbereich vollständig unverändert lassen.

Zielzeiten:

- geübte Teilnehmende: 32–38 Minuten;
- absolute Anfänger: 41–48 Minuten;
- mindestens 12 Minuten Puffer.

Nicht künstlich auf 60 Minuten verlängern.

## Menschlich zu prüfende Lernziele

Beobachten und erfragen:

- Unterschied zwischen `cp` und `mv`;
- richtige Zuordnung von Quelle und Ziel;
- Erklärung, weshalb die Quelle nach `cp` erhalten bleibt;
- Einordnung erfolgreicher Befehle ohne Ausgabe;
- Löschen ohne verwendeten Papierkorb;
- Datei und Verzeichnis als unterschiedliche Ziele;
- Bedingung für `rmdir`;
- kontrollierter Fehler als Schutzwirkung;
- Bedeutung von `-r`;
- Vorhersage betroffener Unterobjekte;
- bewusstes Lesen des Zielpfads;
- Trennung von Arbeitsbereich und Schutzbereich;
- Gefahr von `rm -rf`;
- Begründung, weshalb `-f` keine normale Fehlerbehebung ist;
- Grenzen des technischen CHECKs.

Der technische CHECK ersetzt diese Beobachtungen nicht.

## Sicherheitsbeobachtungen

Vor dem ersten `rm` muss die vollständige Routine sichtbar sein:

1. `pwd`;
2. Zielpfad lesen;
3. Zielobjekt mit `ls` bestätigen;
4. Wirkung vorhersagen;
5. Löschbefehl selbst eingeben;
6. Ergebnis und Schutzbereich kontrollieren.

Vor `rm -r` muss die verkürzte Routine erkennbar sein:

- Standort;
- konkreter freigegebener Zielpfad;
- betroffene Unterobjekte;
- vollständige Lage im Arbeitsbereich;
- unveränderter Schutzbereich.

## Eingriffskriterien

Sofort eingreifen, bevor ein destruktiver Befehl ausgeführt wird, wenn:

- der Zielpfad nicht eindeutig gelesen wurde;
- das Ziel außerhalb von `/root/dateilabor/demo` oder `/root/dateilabor/auftrag/arbeitsbereich` liegt;
- das rekursive Ziel nicht exakt `temp-projekt` im Arbeitsbereich ist;
- der Schutzbereich als Ziel erscheint;
- ein allgemeinerer Pfad gewählt wird;
- eine Wildcard vorgeschlagen wird;
- eine nicht eingeführte Option ergänzt wird;
- `-f` als spontane Fehlerbehebung vorgeschlagen wird.

Nicht erst nach der Eingabe korrigieren. Zur Routine zurückführen.

## Erwarteter `rmdir`-Fehler

Der Fehlversuch ist didaktisch beabsichtigt.

- Nicht als beschädigten Laborzustand bezeichnen.
- Nicht als Workshopfehler werten.
- Keine automatische Reparatur auslösen.
- Den exakten Wortlaut der Meldung nicht voraussetzen.
- Sofort mit `ls` und `cat` den erhaltenen Zustand kontrollieren.
- Erfragen: „Was blieb durch die Ablehnung geschützt?“
- Darauf hinweisen, dass die Shell nach dem Fehler weiterverwendet werden kann.

## Umgang mit einem vorgeschlagenen `-f`

Nicht diskutieren, wie die Option praktisch verwendet werden könnte. Fragen:

1. Welches Ziel wurde angegeben?
2. Ist es Datei oder Verzeichnis?
3. Welche Bedingung meldet der Fehler?
4. Welcher bereits eingeführte Befehl passt zur Objektart?
5. Warum wäre weniger Rückmeldung hier riskant?

Kernaussage: `-f` ist keine normale Fehlerbehebung.

## Nachahmungsversuche

Nach der theoretischen Gefahrenanalyse beobachten, ob Teilnehmende:

- eine vollständige Zielzeile formulieren;
- die Kombination kopieren möchten;
- sie als vermeintliche Standardlösung einsetzen;
- einen höheren Pfad wählen.

Bei einem Versuch die Eingabe stoppen und auf Ziel, Objektart und freigegebenen Bereich zurückführen. Keine gefährliche Zielzeile vormachen.

## Vier Hinweisstufen

Hinweise nur schrittweise öffnen:

1. Konzept: Unterschiede und Schutzregel.
2. Werkzeuge: nur erlaubte Befehlsnamen.
3. Struktur: Platzhalter ohne konkrete Pfade.
4. Vollständige Methode: erst nach eigenem Versuch.

Dokumentieren, welche höchste Stufe benötigt wurde. Die Musterlösung nicht vor dem Lösungsversuch zeigen.

## Typische Fehlvorstellungen

| Fehlvorstellung | Reaktion |
|---|---|
| `cp` verschiebt die Quelle | Quelle und Kopie mit `ls` kontrollieren lassen; mit `mv` kontrastieren. |
| Quelle und Ziel sind vertauscht | Befehl von links nach rechts lesen lassen. |
| Keine Ausgabe bedeutet Fehler | Zuerst den Zustand prüfen. |
| `rm` nutzt einen Papierkorb | An direkten Endzustand und fehlende CHECK-Wiederherstellung erinnern. |
| `rmdir` ist defekt | Bedingung „leer“ und erhaltenen Inhalt beobachten lassen. |
| `rm -r` ist normal für beliebige Ordner | Ausschließlich den freigegebenen Zielpfad lesen lassen. |
| `-f` repariert Fehler | Ursache, Objektart und Pfad prüfen lassen. |
| Erfolgreicher CHECK beweist sicheren Ablauf | Technischen Endzustand und menschliche Sicherheitsleistung trennen. |

## Zeitmessung

Für jeden Piloten erfassen:

- Start der Orientierung;
- Ende der `cp`-Kontrolle;
- Ende der Einzeldatei;
- Ende des erfolgreichen und fehlgeschlagenen `rmdir`;
- Beginn und Ende der Challenge;
- Zeitpunkt des erfolgreichen CHECKs;
- höchste Hinweisstufe;
- Eingriffe vor destruktiven Befehlen;
- Nachahmungsversuche;
- Gesamtzeit.

## Freigabegrenze

Überarbeiten, wenn:

- geübte Teilnehmende regelmäßig mehr als 38 Minuten benötigen;
- Anfänger regelmäßig mehr als 48 Minuten benötigen;
- weniger als 12 Minuten Puffer bleiben;
- Zielpfade häufig ohne Prüfung ausgeführt werden;
- der Schutzbereich nicht zuverlässig beachtet wird;
- die Gefahrenanalyse Nachahmung begünstigt;
- der CHECK gültige Endzustände ablehnt oder Schutzverletzungen akzeptiert.
