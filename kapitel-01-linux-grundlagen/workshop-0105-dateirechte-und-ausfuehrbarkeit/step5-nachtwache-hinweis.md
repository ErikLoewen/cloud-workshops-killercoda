# Zugang der Nachtwache

Ein Benutzerwechsel mit `su - BENUTZER` startet eine Login-Shell des
Zielkontos. Das System fragt dabei nach dessen Passwort. Während der Eingabe
werden keine Zeichen angezeigt.

Finde heraus, ob an der Schalttafel genügend Informationen zurückgelassen
wurden, um das Konto der Nachtwache zu erreichen. Prüfe nach einem
erfolgreichen Wechsel immer:

- Wer bin ich jetzt?
- In welchem Verzeichnis starte ich?

`whoami` und `pwd` beantworten diese Fragen.

<details>
<summary>Hinweis 1: Woran sollte ich zuerst denken?</summary>

Unterscheide Benutzername und Kennwort. Der Kontoname ist an der Schalttafel
sichtbar; das Kennwort muss aus einer hinterlassenen Nachricht abgeleitet
werden.

</details>

<details>
<summary>Hinweis 2: Wo könnte ich suchen?</summary>

Lies den zugänglichen Übergabe-Chat im Schalttafelverzeichnis. Achte auf zwei
aufeinanderfolgende Begriffe.

</details>

<details>
<summary>Hinweis 3: Konkreter Lösungsansatz</summary>

Setze „Sturm“ und „Licht“ klein und ohne Leerzeichen zusammen. Verwende den
abgeleiteten Wert beim Wechsel mit `su - nachtwache`.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
cat uebergabe-chat.log
su - nachtwache
# Passwort: sturmlicht
whoami
pwd
```

Erwartet werden `nachtwache` und `/home/nachtwache`.

</details>
