# Mission abgeschlossen? Licht durch den Nebel

Prüfe den Endzustand des Systems:

- Der auffällige Ressourcenfresser läuft nicht mehr.
- Der Prozess `leuchtfeuer` ist aktiv.
- Die Steuerung hat eine Flagge ausgegeben.

Reiche die gefundene Flag anschließend nach dem bestehenden Muster ein:

```bash
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch die vollständige Flag aus der Erfolgsausgabe.
Starte nach der erfolgreichen Abgabe den CHECK.

Der CHECK bestätigt ausschließlich die erfolgreiche Flag-Abgabe. Er bewertet
weder eine bestimmte Befehlsreihenfolge noch weitere Prozesszustände oder
PIDs.

<details>
<summary>Hinweis 1 – Störprozess prüfen</summary>

Mit `pgrep -a NAME` kannst du allgemein kontrollieren, ob ein Prozess mit
einem bestimmten Namen noch läuft. Bleibt die Ausgabe leer, wurde kein
passender laufender Prozess gefunden.

</details>

<details>
<summary>Hinweis 2 – Leuchtfeuer prüfen</summary>

Kontrolliere mit `pgrep -a`, ob der erwartete Prozess `leuchtfeuer` aktiv ist.

</details>

<details>
<summary>Vollständiger Walkthrough</summary>

Prüfe zuerst den Endzustand:

```bash
pgrep -a beschwoerung
pgrep -a leuchtfeuer
```

Die erste Suche soll keinen Eintrag liefern. Falls `leuchtfeuer` noch nicht
läuft, starte es und kontrolliere erneut:

```bash
./leuchtfeuer-start
pgrep -a leuchtfeuer
```

Reiche anschließend die beim erfolgreichen Start ausgegebene Flag ein:

```bash
flag-einreichen 'FLAG{das_licht_brennt_wieder}'
```

Starte danach den CHECK.

</details>
