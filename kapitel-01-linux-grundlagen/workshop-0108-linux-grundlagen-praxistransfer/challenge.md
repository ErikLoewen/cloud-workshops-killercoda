# Stabilisiere den Leuchtturm

Alle bekannten Teilzustände sind vorbereitet. Führe jetzt die finale
Stabilisierung aus:

`./leuchtturm-stabilisieren`{{exec}}

Lies die gesamte Ausgabe. Wenn die Stabilisierung erfolgreich ist, notiere
die dort angezeigte Flag vollständig und reiche sie ein:

```bash
flag-einreichen 'GEFUNDENE_FLAG'
```

Ersetze `GEFUNDENE_FLAG` durch den exakten Text aus der Erfolgsausgabe. Die
einfachen Anführungszeichen bleiben stehen. Starte nach der angenommenen
Eingabe den CHECK.

Der CHECK bestätigt ausschließlich, dass du die richtige Flag eingereicht
hast. Er bewertet weder deine Befehlsreihenfolge noch den aktuellen Zustand
einzelner Missionsdateien oder Prozesse.

## Wenn die Stabilisierung noch fehlschlägt

Eine Fehlermeldung ist weiterhin eine Zustandsdiagnose. Lies sie vollständig,
kontrolliere den aktuell genannten Bereich und kehre zu dem vorherigen Step
zurück, der genau diesen Zustand behandelt. Führe die Stabilisierung erst nach
der begründeten Korrektur erneut aus.

<details>
<summary>Hinweis 1 – Konfiguration prüfen</summary>

Kontrolliere den gespeicherten Inhalt und führe das vorgesehene Prüfwerkzeug
aus:

```bash
cat steuerung/archiv.conf
./steuerung/archiv-pruefen
```

Bei einem falschen bekannten Wert kehrst du zur Prüfung der Nachrichtenquelle
zurück.

</details>

<details>
<summary>Hinweis 2 – Archivschlüssel kontrollieren</summary>

Zeige den Steuerungsbereich an. Dort soll genau ein unveränderter
`archivschluessel.txt` liegen. Die Diagnose nennt einen fehlenden, falschen
oder mehrdeutigen Ort getrennt.

```bash
ls -l steuerung
cat steuerung/archivschluessel.txt
```

</details>

<details>
<summary>Hinweis 3 – Prozessstatus kontrollieren</summary>

Prüfe erneut, ob der erzeugende Vorgang noch läuft und ob seine Datei
fortgeblieben ist:

```bash
ps -eo user,pid,comm | grep altes_echo
pgrep -a altes_echo
ls erinnerungen
```

Beide Kontrollen sollen keine Instanz mit dem Namen `altes_echo` mehr zeigen.

</details>

<details>
<summary>Hinweis 4 – vollständiger Lernweg</summary>

Dieser Ablauf fasst die vorherigen Steps zusammen. Ersetze
`<GEPRÜFTE_PID>` und `GEFUNDENE_FLAG` durch die tatsächlich beobachteten
Werte; spitze Klammern werden nicht eingegeben.

```bash
cat stabilisierungsplan.txt
./leuchtturm-stabilisieren

rm -r fragment_FFD700
rm -r fragment_8B0000
rm -r fragment_D6C84B
rm -r fragment_7G00FF
./leuchtturm-stabilisieren

cat erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ps -eo user,pid,comm | grep altes_echo
kill <GEPRÜFTE_PID>
pgrep -a altes_echo
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
./leuchtturm-stabilisieren

cat erinnerungen/archivschluessel.txt
mv erinnerungen/archivschluessel.txt steuerung/
./leuchtturm-stabilisieren

whoami
ls -l nachrichten
cat nachrichten/letzte_nachricht_alt.txt

cat steuerung/archiv.conf
cp steuerung/archiv.conf steuerung/archiv.conf.bak
nano steuerung/archiv.conf
cat steuerung/archiv.conf
./steuerung/archiv-pruefen

./leuchtturm-stabilisieren
flag-einreichen 'GEFUNDENE_FLAG'
```

Starte nach der Meldung „Flag angenommen“ den CHECK.

</details>

## Abschluss

Die Erfolgsausgabe der Stabilisierung enthält alles, was du für die
Flag-Abgabe benötigst. Übernimm den Wert exakt, ohne zusätzliche Zeichen oder
Leerzeichen.
