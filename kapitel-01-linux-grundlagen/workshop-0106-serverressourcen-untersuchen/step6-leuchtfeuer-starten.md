# Das Leuchtfeuer wieder starten

Die hohe Last ist verschwunden. Damit ist die Ursache beseitigt – das Licht
läuft dadurch aber noch nicht automatisch.

Für die Außenstation steht ein vorbereiteter Systembefehl bereit. Finde ihn
und starte damit das Leuchtfeuer.

## Auftrag

1. Prüfe, in welchem Verzeichnis du dich befindest.
2. Prüfe, ob der Befehl `leuchtfeuer-start` verfügbar ist.
3. Starte die vorbereitete Leuchtfeuersteuerung.
4. Kontrolliere danach, ob ein Prozess namens `leuchtfeuer` läuft.
5. Notiere die ausgegebene Flagge.

## Startbefehl und Prozess unterscheiden

Ein laufender Prozess und seine Startdatei sind nicht dasselbe:

- Der Systembefehl startet das Programm.
- Durch die Ausführung entsteht ein laufender Prozess.

<details>
<summary>Hinweis 1 – Befehl finden</summary>

Prüfe deinen Standort mit `pwd`. Mit `command -v leuchtfeuer-start` findest du
heraus, ob und wo der vorbereitete Systembefehl installiert ist.

</details>

<details>
<summary>Hinweis 2 – Leuchtfeuer starten</summary>

Einen installierten Systembefehl startest du direkt mit seinem Namen:

```text
leuchtfeuer-start
```

</details>

<details>
<summary>Hinweis 3 – Prozess kontrollieren</summary>

```bash
pgrep -a leuchtfeuer
```

Die Ausgabe soll genau eine laufende Instanz des Leuchtfeuers zeigen.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

```bash
pwd
command -v leuchtfeuer-start
leuchtfeuer-start
pgrep -a leuchtfeuer
```

</details>

## Erwartete Erfolgsausgabe

Bei erfolgreichem Start erscheint sinngemäß:

```text
Das Leuchtfeuer fährt hoch. Ein Lichtstrahl schneidet durch den Nebel.
Danach erscheint deine persönliche Abschlussflagge.
```

Die Flagge wird nur ausgegeben, wenn die störende Last beseitigt wurde und das
Leuchtfeuer erfolgreich gestartet ist. Bewahre sie für die Abschlusskontrolle
auf.
