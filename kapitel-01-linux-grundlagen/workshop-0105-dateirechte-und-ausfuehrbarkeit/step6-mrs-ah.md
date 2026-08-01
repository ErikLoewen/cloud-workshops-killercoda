# Weitere Spuren unter neuer Identität

Unter dem neuen Konto sind andere Inhalte erreichbar. Untersuche das
Startverzeichnis, vergleiche Besitz und Rechte und lies zugängliche
Protokolle. Kläre, ob sich daraus der Zugang zu einem weiteren Namen von der
Schalttafel ableiten lässt.

Mit `getent passwd` kannst du die Kontodatenbank des Systems abfragen. Jede
Zeile beginnt mit einem Kontonamen. Die folgende Variante zeigt nur diese
erste Spalte an. Neben den persönlichen Konten erscheinen dabei auch System-
und Dienstkonten:

```bash
getent passwd | cut -d: -f1
```

Die entscheidenden Informationen liegen in der Laborumgebung. Verbinde Funde,
die in getrennten Nachrichten stehen, selbst miteinander. Kontrolliere nach
jedem erfolgreichen Benutzerwechsel erneut Identität und Standort.

<details>
<summary>Hinweis 1: Woran sollte ich zuerst denken?</summary>

Welche Dateien sind erst unter der Identität der Nachtwache erreichbar?
Untersuche mit `ls -l`, wem die Dateien gehören, und lies alle zugänglichen
Logs, ohne sie zu verändern.

</details>

<details>
<summary>Hinweis 2: Wo könnte ich suchen?</summary>

Im Home der Nachtwache liegen zwei relevante Protokolle. Ihre Besitzernamen
bestätigen die genaue Schreibweise der beteiligten Konten. Eines enthält eine
persönliche Anrede, das andere eine Sicherheitskritik des Waerters.

</details>

<details>
<summary>Hinweis 3: Konkreter Lösungsansatz</summary>

Lies `dienst-chat.log` und `sicherheitsnotiz.log`. Der Besitzer von
`dienst-chat.log` zeigt dir den genauen Kontonamen. Verbinde den im Chat
genannten Vornamen mit der kritisierten Passwortgewohnheit.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
whoami
pwd
ls -l
getent passwd | cut -d: -f1
cat dienst-chat.log
cat sicherheitsnotiz.log
su - mrs_ah
# Passwort: tabitha
whoami
pwd
```

Erwartet werden anschließend `mrs_ah` und `/home/mrs_ah`.

</details>
