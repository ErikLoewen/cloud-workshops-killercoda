# Trainerleitfaden – Workshop 2

Diese Datei ist intern und wird nicht in der Teilnehmeroberfläche angezeigt.

## Zielgruppe und Zeit

- Erwachsene absolute Linux-Anfänger
- Geübte Teilnehmende: etwa 31–38 Minuten
- Absolute Anfänger: etwa 42–48 Minuten
- Mindestens 12 Minuten Puffer innerhalb einer 60-Minuten-Sitzung

Zeitangaben bleiben Schätzwerte, bis ein realer Killercoda-Pilot durchgeführt wurde.

## Abgerufenes Vorwissen aus Workshop 1

Beobachte, ob die Teilnehmenden:

- das Terminal selbst fokussieren;
- Befehle selbst eingeben und mit Enter ausführen;
- Prompt, Eingabe und Ausgabe unterscheiden;
- einfache Tippfehler anhand einer Fehlermeldung korrigieren;
- bei Bedarf die Pfeiltaste nach oben nutzen.

Diese Punkte werden nicht erneut als Hauptlerninhalt unterrichtet.

## Menschlich zu prüfende Lernziele

Die technische Prüfung deckt nur den Markerzustand ab. Menschlich oder durch Fragen zu prüfen sind:

1. absolute und relative Pfade unterscheiden;
2. `/` und `~` unterscheiden;
3. `.` als aktuelles Verzeichnis erklären;
4. `..` als übergeordnetes Verzeichnis erklären;
5. die stille Zustandsänderung durch `cd` beschreiben;
6. den Nutzen von Tab begründen;
7. Tab tatsächlich im Terminal verwenden;
8. denselben Zielort über unterschiedliche gültige Pfade erreichen;
9. einen relativen Pfad auf den jeweiligen Ausgangspunkt beziehen.

## Beobachtung der Tab-Vervollständigung

Tab kann der CHECK nicht erkennen. Beobachte deshalb in Schritt 4 oder 5:

- Ist das Terminal fokussiert?
- Tippt die Person nur ein eindeutiges Präfix?
- Ergänzt Tab den Text?
- Wartet die Person mit Enter, bis die Eingabe vollständig ist?
- Kann sie erklären, dass Tab nur ergänzt und Enter ausführt?

Nicht als Tab-Nachweis akzeptieren:

- vollständig eingetippter Name ohne Tab;
- bloße Selbstaussage ohne beobachtete Handlung;
- Browserfokuswechsel statt Terminalvervollständigung.

## Typische Fehlvorstellungen

### „Keine Ausgabe bedeutet, dass `cd` nicht funktioniert hat.“

Rückfrage:

> Mit welchem bekannten Befehl kannst du den veränderten Standort sichtbar prüfen?

### „`/` und `~` sind derselbe Ort.“

Rückfrage:

> Welche zwei unterschiedlichen Ausgaben erhältst du, wenn du beide Orte nacheinander mit `pwd` prüfst?

### „Ein relativer Pfad funktioniert überall.“

Rückfrage:

> Von welchem aktuellen Verzeichnis aus wird dieser Weg gelesen?

### „`.` und `..` bedeuten beide zurück.“

Rückfrage:

> Welche Veränderung erwartest du jeweils vor dem Ausführen?

### „Tab führt den Befehl aus.“

Rückfrage:

> Was hat sich nur in der Eingabezeile verändert, und was geschah erst nach Enter?

## Geeignete Rückfragen

- Welche Ausgabe erwartest du vor dem Ausführen?
- Wo befindest du dich jetzt?
- Welche Namen sind von hier aus mit `ls` sichtbar?
- Beginnt der Pfad am Wurzelverzeichnis oder an deinem aktuellen Standort?
- Welche Ebene bezeichnet das erste `..`?
- Wie kannst du denselben Zielort auf einem anderen Weg erreichen?
- Welche Information kann der technische CHECK nicht aus dem Marker ableiten?

## Kriterien für die Hinweisstufen

### Stufe 1 geben, wenn:

- die Person nach einem ersten Versuch nicht erkennt, dass das Ziel außerhalb von `startpunkt` liegt;
- `pwd` oder `ls` noch nicht selbst als Orientierungshilfe abgerufen wird.

### Stufe 2 geben, wenn:

- die passenden Werkzeuge verwechselt werden;
- `..` trotz Konzeptfrage nicht abgerufen wird;
- Tab als Hilfe vergessen wird.

### Stufe 3 geben, wenn:

- der Wechsel in die Laborwurzel gelingt, aber die anschließende Struktur nicht zusammengesetzt werden kann;
- mehrere Fehlversuche auf derselben Ebene auftreten.

### Stufe 4 erst geben, wenn:

- ein eigener Versuch mit den Stufen 1 bis 3 erfolgt ist;
- die Person sonst den Zeitkorridor deutlich überschreiten würde;
- die Musterlösung anschließend fachlich erklärt wird.

## Zeitmessung

Erfasse mindestens:

- Start der Teilnehmerbearbeitung;
- Zeitpunkt des ersten korrekten `cd`;
- Beginn der Abschlussaufgabe;
- erfolgreicher Aufruf der Prüfaktion;
- erfolgreicher CHECK;
- verwendete höchste Hinweisstufe;
- Zeitverluste durch Browser- oder Backendprobleme getrennt von Lernzeit.

## Abgrenzung zur technischen Prüfung

`verify.sh` prüft nur:

- Marker vorhanden;
- Markerinhalt exakt korrekt.

Der CHECK darf nicht als Nachweis für Tab, Pfadart, Verständnis von `.` oder `..` oder einen bestimmten Navigationsweg interpretiert werden.

## Pilotbeobachtung für `/root`

Der Pfad `/root` ist eine technische Annahme. Im realen Killercoda-Test ausdrücklich dokumentieren:

- tatsächlicher Benutzer;
- tatsächlicher Startpfad;
- Ergebnis von `cd ~` mit anschließendem `pwd`;
- Verfügbarkeit von `/usr/local/bin` im Suchpfad.

Keinen anderen Pfad stillschweigend einsetzen. Eine notwendige Änderung erfordert eine dokumentierte Überarbeitung.
