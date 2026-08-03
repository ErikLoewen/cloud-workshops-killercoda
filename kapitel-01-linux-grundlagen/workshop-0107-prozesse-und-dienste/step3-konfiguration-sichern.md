# Wie kehrst du zum alten Zustand zurück?

Eine fehlerhafte Konfigurationsänderung kann ein Programm unbrauchbar machen.
Deshalb sicherst du den bekannten Ausgangszustand, bevor du die Datei
bearbeitest.

## Sichere Wartungsroutine

```text
lesen → sichern → ändern → prüfen → anwenden → kontrollieren
```

![Sicherer Ablauf für Konfigurationsänderungen: lesen, sichern, ändern, prüfen, anwenden und kontrollieren.](./assets/0107-konfigurationsablauf.png)

## Eine Sicherungskopie erstellen

Führe aus:

`cp leuchtfeuer.conf leuchtfeuer.conf.bak`{{exec}}

Der Befehl enthält zwei Pfade:

- `leuchtfeuer.conf` ist die **Quelle**,
- `leuchtfeuer.conf.bak` ist die neu erzeugte **Kopie**.

Das Original bleibt erhalten. Die Endung `.bak` ist lediglich eine gut
erkennbare Benennungskonvention für eine Sicherungskopie. Linux verlangt
diese Endung nicht.

Diese einzelne Kopie ersetzt kein vollständiges Backup-System. Für die
kontrollierte Änderung in diesem Workshop bietet sie jedoch einen schnellen
Rückweg.

## Auftrag

Erstelle die Sicherung und prüfe anschließend mit bereits bekannten
Werkzeugen, ob Original und Kopie vorhanden sind.

Kontrolliere außerdem den Inhalt der Sicherung. Sie muss noch den bekannten
Ausgangszustand enthalten.

## Erkläre

1. Welche Datei wird später bearbeitet?
2. Welche Datei bleibt unverändert?
3. Warum wird die Sicherung vor der Änderung erstellt?

<details>
<summary>Hinweis – Sicherungsname</summary>

Die neue Kopie soll `leuchtfeuer.conf.bak` heißen. Achte darauf, Original und
Sicherung nicht zu vertauschen.

</details>

<details>
<summary>Vollständiger Ablauf</summary>

```bash
cp leuchtfeuer.conf leuchtfeuer.conf.bak
ls -l
cat leuchtfeuer.conf.bak
```

`ls -l` soll beide Dateien zeigen. `cat` zeigt anschließend den gesicherten
Inhalt.

</details>

## Abschluss

Der bisherige Zustand ist gesichert. Jetzt kannst du Nano zunächst
kennenlernen, ohne sofort eine wichtige Änderung speichern zu müssen.
