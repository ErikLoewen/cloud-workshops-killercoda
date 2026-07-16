# Dozentenleitfaden: Das Terminal sicher bedienen

Diese Datei ist nicht in `index.json` referenziert.

## Zielgruppe

Erwachsene absolute Linux-Anfänger ohne Terminalerfahrung.

## Zielzeit

- geübte Teilnehmende: etwa 30 bis 35 Minuten,
- absolute Anfänger: ungefähr 40 bis 46 Minuten,
- vorgesehener Puffer: mindestens 14 Minuten.

Der Workshop soll nicht künstlich verlängert werden.

## Menschlich zu prüfende Lernziele

Beobachte beziehungsweise erfrage, ob die lernende Person:

1. Terminal, Shell und Prompt am konkreten Bildschirm unterscheiden kann;
2. Eingabe, Ausgabe und Fehlermeldung korrekt zuordnet;
3. einen Befehl mit Enter ausführt;
4. in `echo "Hallo Welt"` Befehl und Argument unterscheidet;
5. `whoam` mit der Pfeiltaste nach oben zurückholt und korrigiert;
6. `sleep 30` als Vordergrundprozess erkennt;
7. den Vordergrundprozess mit Strg+C beendet;
8. die Rückkehr des Prompts als Bereitschaftssignal erklärt;
9. `command not found` als Hinweis und nicht als Systemschaden einordnet.

## Beobachtungskriterien

### Enter

Erfüllt, wenn die Person:

- eine fertige Eingabe im fokussierten Terminal ausführt;
- die folgende Ausgabe oder Veränderung der Prompt-Situation beobachtet;
- Enter nicht mit dem bloßen Tippen der Zeichenfolge verwechselt.

Der technische CHECK erkennt Enter nicht zuverlässig.

### Pfeiltaste nach oben

Erfüllt, wenn die Person:

- nach `whoam` die vorherige Eingabe sichtbar zurückholt;
- das fehlende `i` ergänzt;
- in der Abschlussaufgabe den vorherigen `echo`-Befehl zurückholt, statt ihn vollständig neu zu tippen.

Der technische CHECK erkennt die Pfeiltaste nicht zuverlässig.

### Strg+C

Erfüllt, wenn die Person:

- bei laufendem `sleep 30` Strg gedrückt hält und C drückt;
- nicht die Zeichenfolge `Strg+C` eintippt;
- anschließend die Rückkehr des Prompts beobachtet.

Das Ende des Prozesses beweist nicht, dass Strg+C verwendet wurde. Direkte Beobachtung ist erforderlich.

## Typische Anfängerfehler

- Das Terminal ist nicht fokussiert.
- Promptzeichen werden als Teil des Befehls mitgetippt.
- Nach dem Tippen wird Enter vergessen.
- Das Leerzeichen zwischen `echo` und Argument fehlt.
- Die Fehlermeldung wird übersprungen oder als Schaden interpretiert.
- Die Pfeiltaste wird gedrückt, während der Browser statt des Terminals fokussiert ist.
- `Strg` und `C` werden nacheinander statt gleichzeitig verwendet.
- Die Zeichenfolge `Strg+C` wird eingetippt.
- Die fehlende Ausgabe bei `sleep` wird als Absturz interpretiert.
- Der CHECK wird gestartet, bevor der Prompt zurückgekehrt ist.

## Geeignete Rückfragen

- Wo beginnt deine Eingabe?
- Woran erkennst du, dass die Shell bereit ist?
- Welche Zeile ist Eingabe und welche ist Ausgabe?
- Welcher Teil von `echo "Hallo Welt"` legt die Handlung fest?
- Welcher Teil liefert den auszugebenden Text?
- Welchen Namen nennt die Fehlermeldung?
- Was unterscheidet `whoam` von `whoami`?
- Was fehlt während `sleep 30`?
- Was kehrt nach der Unterbrechung zurück?
- Was kann der technische CHECK nicht beurteilen?

## Kriterien für direkte Hilfe

Direkte Bedienhilfe ist angemessen, wenn:

- die Person den Terminalfokus nach zwei Hinweisen nicht herstellen kann;
- die Tastenkombination Strg+C trotz Erklärung und Hinweisstufe 2 nicht gelingt;
- ein blockierender Prozess den weiteren Ablauf verhindert;
- motorische oder technische Einschränkungen die geforderte Bedienhandlung verhindern;
- eine Plattformstörung statt eines Lernfehlers vorliegt.

Vorgehen bei direkter Hilfe:

1. Zuerst auf das relevante Bildschirmmerkmal oder Konzept hinweisen.
2. Danach die benötigte Taste oder den Befehlsnamen nennen.
3. Erst anschließend die nahezu vollständige Handlung vormachen.
4. Die Person führt die Handlung danach noch einmal selbst aus.

## Hinweise zur Zeitmessung

Erfasse getrennt:

- Start bis Ende der Orientierung,
- Dauer bis zur ersten selbst eingegebenen erfolgreichen Ausgabe,
- Dauer der Fehlerkorrektur,
- Dauer der ersten erfolgreichen Strg+C-Handlung,
- Dauer der Abschlussaufgabe,
- Gesamtzeit bis zum Ende der Abruffragen.

Pilotkriterium:

Mindestens vier von fünf absoluten Anfängern schließen den Kernpfad innerhalb von 46 Minuten ab. Ein einzelner Ausreißer führt nicht automatisch zur Ablehnung. Ursache und benötigte Hilfe werden qualitativ dokumentiert.

Geübte Vergleichspersonen sollten den Kernpfad überwiegend in 30 bis 35 Minuten abschließen.
