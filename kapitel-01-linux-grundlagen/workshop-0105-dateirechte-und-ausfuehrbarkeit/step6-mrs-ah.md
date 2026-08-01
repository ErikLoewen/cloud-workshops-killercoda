# Weitere Spuren unter neuer Identität

Unter dem neuen Konto sind andere Inhalte erreichbar. Untersuche das
Startverzeichnis, vergleiche Besitz und Rechte und lies zugängliche
Protokolle. Kläre, ob sich daraus der Zugang zu einem weiteren Namen von der
Schalttafel ableiten lässt.

Die entscheidenden Informationen liegen in der Laborumgebung. Verbinde Funde,
die in getrennten Nachrichten stehen, selbst miteinander. Kontrolliere nach
jedem erfolgreichen Benutzerwechsel erneut Identität und Standort.

<details>
<summary>Hinweis 1: Woran sollte ich zuerst denken?</summary>

Welche Dateien sind erst unter der Identität der Nachtwache erreichbar?
Untersuche alle lesbaren Logs, ohne sie zu verändern.

</details>

<details>
<summary>Hinweis 2: Wo könnte ich suchen?</summary>

Im Home der Nachtwache liegen zwei relevante Protokolle. Eines enthält eine
persönliche Anrede, das andere eine Sicherheitskritik des Wärters.

</details>

<details>
<summary>Hinweis 3: Konkreter Lösungsansatz</summary>

Lies `dienst-chat.log` und `sicherheitsnotiz.log`. Verbinde den genannten
Vornamen mit der kritisierten Passwortgewohnheit und bilde den Kontonamen aus
dem Schild „Mrs. A. H.“.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
whoami
pwd
ls -l
cat dienst-chat.log
cat sicherheitsnotiz.log
su - mrs_ah
# Passwort: tabitha
whoami
pwd
```

Erwartet werden anschließend `mrs_ah` und `/home/mrs_ah`.

</details>
