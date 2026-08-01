# Fremde Besitzverhältnisse

Das Signal reagiert, doch an der Schalttafel liegen weitere Dateien. Nicht
alles gehört `waerter`. Untersuche Rechte, Besitzer, Gruppe und lesbare
Inhalte, ohne fremde Dateien zu verändern.

Welche Informationen kannst du mit deiner aktuellen Identität lesen? Gibt es
Hinweise darauf, dass ein anderes Konto an der Schalttafel gearbeitet hat?

<details>
<summary>Hinweis 1: Woran sollte ich zuerst denken?</summary>

Nutze die Besitzer- und Gruppenspalten aus `ls -l`. Ein fremder Besitzer
bedeutet nicht automatisch, dass du den Inhalt nicht lesen darfst; dafür ist
dein zutreffender Rechteblock entscheidend.

</details>

<details>
<summary>Hinweis 2: Wo könnte ich suchen?</summary>

Untersuche die Dateien im aktuellen Schalttafelverzeichnis. Lies reguläre
Textdateien, für die dein Rechteblock ein `r` enthält.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
whoami
pwd
ls -l
cat uebergabe-chat.log
```

Die Nachricht umschreibt das Übergabekennwort mit „erst der Sturm, dann das
Licht“, ohne es direkt auszuschreiben.

</details>
