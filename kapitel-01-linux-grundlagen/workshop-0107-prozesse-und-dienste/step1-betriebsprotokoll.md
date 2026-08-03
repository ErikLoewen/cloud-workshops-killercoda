# Was meldet die Lichtsteuerung?

Programme halten wichtige Ereignisse häufig in **Protokoll-** oder
**Logdateien** fest. Darin können Starts, geladene Einstellungen, Warnungen
und Fehler stehen.

Eine Logdatei ist zunächst nur eine Textdatei. Wenn du sie liest, veränderst
du das System nicht. Die Einträge zeigen nacheinander, was zu verschiedenen
Zeitpunkten geschehen ist.

In einer schmalen Nische neben der Lichtsteuerung wurden alte
Betriebsprotokolle abgelegt. Vielleicht erklärt eines davon das falsche
Signal.

## Auftrag

Verschaffe dir einen Überblick über die Lichtsteuerung.

Finde das Verzeichnis mit den Betriebsprotokollen und lies die vorhandene
Logdatei. Beantworte anschließend:

1. Welche Konfigurationsdatei wurde geladen?
2. Welche Rotation ist aktuell eingestellt?
3. Welche Warnung wurde protokolliert?
4. Wo sollen gültige Einstellungen beschrieben sein?

Für eine Textdatei kennst du bereits das Muster `cat DATEI`.

## Erkenntnis

Das Protokoll zeigt, welche Werte geladen wurden und dass der Rundlauf nicht
dem normalen Betrieb entspricht. Es nennt jedoch nicht direkt den korrekten
Ersatzwert.

Dafür verweist es auf die Wartungsdokumentation.

<details>
<summary>Hinweis 1 – Standort und Übersicht</summary>

Prüfe mit `pwd`, wo du dich befindest. Verschaffe dir danach mit `ls` einen
Überblick über die vorhandenen Einträge.

</details>

<details>
<summary>Hinweis 2 – Protokollverzeichnis</summary>

Suche nach einem Verzeichnisnamen, der auf Betriebsaufzeichnungen oder
protokollierte Ereignisse hindeutet. Wechsle anschließend mit `cd` hinein.

</details>

<details>
<summary>Hinweis 3 – Textdatei lesen</summary>

Eine gefundene Textdatei liest du nach diesem Muster:

```bash
cat DATEINAME
```

Ersetze `DATEINAME` durch den tatsächlich angezeigten Namen.

</details>

<details>
<summary>Vollständiger Weg</summary>

```bash
pwd
ls
cd protokolle
ls
cat leuchtfeuer.log
```

</details>
