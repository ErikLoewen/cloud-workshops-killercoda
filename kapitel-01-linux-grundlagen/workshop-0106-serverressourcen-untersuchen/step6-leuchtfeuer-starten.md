# Das Leuchtfeuer wieder starten

Die hohe Last ist verschwunden. Damit ist die Ursache beseitigt – das Licht
läuft dadurch aber noch nicht automatisch.

Im Arbeitsbereich liegt eine vorbereitete Steuerung. Untersuche die
vorhandenen Dateien und finde heraus, womit das Leuchtfeuer gestartet wird.

## Auftrag

1. Prüfe, in welchem Verzeichnis du dich befindest.
2. Untersuche die vorhandenen Dateien und ihre Rechte.
3. Starte die vorbereitete Leuchtfeuersteuerung.
4. Kontrolliere danach, ob ein Prozess namens `leuchtfeuer` läuft.
5. Notiere die ausgegebene Flagge.

## Startdatei und Prozess unterscheiden

Ein laufender Prozess und seine Startdatei sind nicht dasselbe:

- Die Datei enthält beziehungsweise startet das Programm.
- Durch die Ausführung entsteht ein laufender Prozess.

<details>
<summary>Hinweis 1 – Datei finden</summary>

Prüfe deinen Standort mit `pwd`. Verschaffe dir mit `ls` einen Überblick und
verwende anschließend `ls -l`, um auch die Ausführungsrechte zu untersuchen.

</details>

<details>
<summary>Hinweis 2 – Datei starten</summary>

Eine ausführbare Datei im aktuellen Verzeichnis startest du nach dem bereits
bekannten Muster:

```text
./DATEINAME
```

Ersetze `DATEINAME` durch den Namen der vorbereiteten Steuerung.

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
ls
ls -l
./leuchtfeuer-start
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
