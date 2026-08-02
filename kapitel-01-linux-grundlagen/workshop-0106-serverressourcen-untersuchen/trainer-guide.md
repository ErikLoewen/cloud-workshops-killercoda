# Trainerleitfaden – 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

## Kurzprofil

- Zielgruppe: Linux-Anfänger nach Workshops 0101 bis 0105;
- Arbeitskonto: `waerter`;
- Arbeitsbereich: `/home/waerter/leuchtturm/aussenstation`;
- Lernhandlung: Ressourcen einordnen, Auslastung beobachten, einen Prozess
  sicher identifizieren, regulär beenden und den Zielzustand herstellen;
- CHECK-Grenze: ausschließlich erfolgreiche Flag-Abgabe.

## Didaktische Progression

| Abschnitt | Unterstützungsgrad | Lernfunktion |
|---|---|---|
| Step 1 | stark geführt | CPU, RAM und Dateisystemspeicher grob einordnen |
| Step 2 | Beobachtung | Störung einmalig im Hintergrund aktivieren und aktuelle Nutzung unterscheiden |
| Step 3 | teilgeführte Auswertung | reduzierte Prozessliste lesen und sortieren |
| Step 4 | Worked Example | sicheres Beenden an `sleep 300` vollständig üben |
| Step 5 | selbstständiger Transfer | bekannte Methode auf die echte Störung übertragen |
| Step 6 | Zielzustand | Startdatei entdecken, ausführen und Prozess kontrollieren |
| Challenge | nur Flag-Abgabe | Endzustand kontrollieren und Flag einreichen |

Die Unterstützung nimmt bewusst ab. Step 4 ist das einzige stark geführte
Beendigungsbeispiel. Step 5 soll nicht zu einer zweiten Demonstration werden.

## Technischer Startzustand

- Intro und Step 1 laufen ohne künstlichen Störprozess.
- Der erste Eintritt in Step 2 aktiviert die Störung unsichtbar.
- Erneutes Öffnen von Step 2 startet keine weitere Instanz – auch dann nicht,
  wenn die erste Instanz bereits von den Lernenden beendet wurde.
- Erwartet werden ungefähr 10 bis 20 Prozent CPU bei kleinem RAM-Verbrauch.
- Das Terminal darf höchstens geringfügig verzögert reagieren. Starke Hänger
  sind ein technischer Fehler und kein gewünschter Lernzustand.

## Betreuung

- Keine Ressourcenwerte abschreiben oder in eine Datei übertragen lassen.
- Den Namen des Störprozesses nicht sofort verraten.
- Vor jedem Beenden Benutzer, Prozessname und PID nennen lassen.
- Bei Problemen zuerst mit einer Frage auf die relevante Beobachtung lenken.
- Dropdowns erst nach einem eigenen Beobachtungs- oder Lösungsversuch öffnen
  lassen.
- `kill -9` nicht als Standard oder Abkürzung empfehlen.
- Unbekannte Shell-, System- und Laborprozesse nicht verändern lassen.
- Nach jedem Eingriff eine erneute Prozess- oder Auslastungskontrolle
  verlangen.

## Geeignete Trainerfragen

- Zeigt dieser Befehl Kapazität oder aktuelle Nutzung?
- Welche Spalte ist gerade relevant?
- Wem gehört der Prozess?
- Woran erkennst du, dass es genau der richtige Prozess ist?
- Wie kontrollierst du die Wirkung?
- Ist der Fehler beseitigt oder der Zielzustand bereits hergestellt?

## Typische Unterstützung

### Bei der Ressourcenprüfung

Auf die Leitfrage zurückführen: Ist eine Ressource offensichtlich knapp, oder
wirkt sie zunächst unauffällig? Keine exakten Werte protokollieren lassen.

### Bei `top`

Nur auf `%CPU`, `COMMAND`, mehrere Aktualisierungen und das Verlassen mit `q`
lenken. Darauf achten, dass `0.6` als 0,6 Prozent gelesen wird. Keine weiteren
Spalten oder Tastenkürzel vertiefen.

### Bei der Prozessauswahl

Nicht sofort den Namen nennen. Zuerst fragen, welcher Eintrag dauerhaft
auffällig ist und welche Kombination aus `USER`, `COMMAND` und `PID` ihn
eindeutig beschreibt.

### Beim Beenden

Darauf bestehen, die PID unmittelbar vorher erneut zu ermitteln. Normales
`kill PID` verwenden und danach mit derselben Suche kontrollieren.

### Beim Zielzustand

Zwischen beseitigtem Fehler und gestartetem Leuchtfeuer unterscheiden lassen.
Die Startdatei und der daraus entstehende Prozess sind nicht dasselbe.

## CHECK-Grenze

Der CHECK bestätigt ausschließlich den atomaren Flag-Abgabemarker. Er prüft
weder Diagnoseweg, Befehlsreihenfolge noch Prozesszustände. Diese bleiben
formative Beobachtungsziele.
