# Welche Nachricht stammt aus der richtigen Quelle?

Der Archivschlüssel liegt jetzt im vorgesehenen Bereich. Starte die Diagnose
erneut:

`./leuchtturm-stabilisieren`{{exec}}

Die Stabilisierung meldet fünf letzte Nachrichten, deren Anweisungen sich
widersprechen. Jede nennt einen Konfigurationspfad und einen möglichen Wert.
Dateiname und Inhalt allein reichen deshalb nicht aus, um die verlässliche
Quelle auszuwählen.

## Metadaten vergleichen

Verschaffe dir zunächst einen Überblick über alle fünf Dateien im Verzeichnis
`nachrichten`. Zeige sie danach in der ausführlichen Listenansicht an und
vergleiche insbesondere ihre Besitzer.

Prüfe, welche Nachricht aus der dokumentierten Benutzerquelle stammt. Stelle
dazu fest, unter welcher Benutzerkennung du im Leuchtturm arbeitest, und
vergleiche diese Kennung mit den Dateimetadaten.

> In realen Untersuchungen beweist ein Dateibesitzer allein nicht die
> Echtheit. In diesem kontrollierten Archiv ist er das dokumentierte
> Vergleichskriterium.

## Auftrag

1. Liste die fünf Nachrichtendateien gemeinsam auf.
2. Verwende die ausführliche Listenansicht, um Rechte und Besitzer sichtbar
   zu machen.
3. Bestimme die Benutzerkennung deiner aktuellen Sitzung.
4. Vergleiche diese Kennung mit den fünf Besitzern.
5. Lies ausschließlich die Nachricht, die das dokumentierte Kriterium erfüllt.
6. Notiere aus dieser Nachricht:
   - den Pfad der zu bearbeitenden Konfiguration;
   - den dort geforderten Zielwert.

Verändere die Konfiguration in diesem Schritt noch nicht. Zuerst sicherst du
die ermittelte Anweisung durch Beobachtung und Notiz.

<details>
<summary>Hinweis 1 – Dateinamen bewerten</summary>

Bezeichnungen wie `final`, `backup` oder `alt` beweisen keine Echtheit. Sie
sind Namen, keine verlässlichen Angaben über die Quelle.

</details>

<details>
<summary>Hinweis 2 – Besitzer anzeigen</summary>

`ls -l` zeigt neben Dateityp und Rechten auch den Besitzer jeder Datei. Führe
die ausführliche Listenansicht für das Verzeichnis `nachrichten` aus.

</details>

<details>
<summary>Hinweis 3 – eigene Benutzerkennung prüfen</summary>

Mit `whoami` prüfst du, unter welchem Benutzer du gerade arbeitest. Suche in
der ausführlichen Dateiliste nach derselben Besitzerkennung.

</details>

<details>
<summary>Hinweis 4 – vollständiger Weg</summary>

```bash
whoami
ls -l nachrichten
cat nachrichten/letzte_nachricht_alt.txt
```

Notiere den Konfigurationspfad und den Wert aus der gelesenen Nachricht. Führe
noch keine Änderung an der Konfigurationsdatei aus.

</details>

## Erkenntnis

Du kennst jetzt den Pfad der Konfiguration und den Zielwert aus der
dokumentierten Quelle. Im nächsten Schritt sicherst, bearbeitest und prüfst du
die Konfiguration kontrolliert.
