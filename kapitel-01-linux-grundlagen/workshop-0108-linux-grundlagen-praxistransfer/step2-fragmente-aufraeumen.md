# Was gehört nicht zur Ordnung?

Die erste Diagnose hat mehrere Bereiche mit dem Präfix `fragment_` gemeldet.
Vergleiche diese Namen erneut mit `stabilisierungsplan.txt`. Nur der
dokumentierte Sollzustand entscheidet, ob ein Bereich entfernt werden darf.

> Ein ungewöhnlicher Name allein ist kein Löschgrund. In dieser Mission
> bestätigt der Stabilisierungsplan ausdrücklich, welche Verzeichnisse nicht
> zur stabilen Struktur gehören.

## Einen Bereich vollständig prüfen

Beginne mit genau einem gemeldeten Ordner. Zeige seinen Inhalt an, lies die
darin liegende Datei und kontrolliere den vollständigen Zielnamen unmittelbar
vor der Löschung:

```bash
ls fragment_FFD700
cat fragment_FFD700/das_gelbe_zeichen.txt
rm -r fragment_FFD700
```

`rm -r` entfernt den angegebenen Ordner samt Inhalt. Prüfe den vollständigen
Namen vor dem Absenden.

Das Sternchen ist hier kein geeignetes Löschziel. Verwende insbesondere
niemals eine pauschale Befehlsfolge wie `rm -rf *`. Untersuche und benenne
jeden bestätigten Fragmentbereich gezielt.

## Auftrag

1. Vergleiche alle von der Diagnose genannten `fragment_`-Verzeichnisse mit
   dem Stabilisierungsplan.
2. Untersuche mindestens einen weiteren Inhalt, bevor du den zugehörigen
   Bereich entfernst.
3. Entferne ausschließlich die bestätigten Fragmentbereiche. Andere
   Archivverzeichnisse und Dateien bleiben unverändert.
4. Kontrolliere die Struktur erneut.
5. Führe anschließend die Stabilisierung erneut aus:

`./leuchtturm-stabilisieren`{{exec}}

Die nächste Diagnose führt dich zu einer Datei im Bereich `erinnerungen`.
Finde sie, lies ihren Inhalt und merke dir ihren exakten Namen.

## Die Datei kehrt zurück

Entferne ausschließlich die von der Diagnose bezeichnete Datei. Kontrolliere
den Bereich `erinnerungen` direkt danach und nach einem kurzen Moment erneut.

Erscheint die Datei wieder, lösche sie nicht einfach wiederholt. Beobachte
stattdessen, was dieses Verhalten über die Ursache aussagt.

<details>
<summary>Hinweis 1 – erlaubte Bereiche bestimmen</summary>

Vergleiche die Aufzählung unter „Zur stabilen Ordnung gehören“ mit den
Verzeichnissen, die das Diagnosewerkzeug als fremde Bereiche meldet.

</details>

<details>
<summary>Hinweis 2 – einen Fragmentinhalt untersuchen</summary>

Verwende zuerst `ls` für einen konkreten Fragmentordner und anschließend
`cat` für genau die darin gefundene Textdatei.

</details>

<details>
<summary>Hinweis 3 – zurückkehrende Datei beobachten</summary>

Mit `ls erinnerungen` findest du den Namen. Lies die Datei vor dem Entfernen.
Entferne nur diese einzelne Datei und wiederhole die Verzeichnisanzeige nach
einem kurzen Moment.

</details>

<details>
<summary>Hinweis 4 – vollständiger möglicher Weg</summary>

Öffne diesen Hinweis erst nach einem eigenen Versuch. Jeder Löschbefehl nennt
ein einzelnes, zuvor bestätigtes Ziel.

```bash
ls fragment_FFD700
cat fragment_FFD700/das_gelbe_zeichen.txt
rm -r fragment_FFD700

ls fragment_8B0000
cat fragment_8B0000/der_letzte_raum.txt
rm -r fragment_8B0000

ls fragment_D6C84B
cat fragment_D6C84B/muster_hinter_der_wand.txt
rm -r fragment_D6C84B

ls fragment_7G00FF
cat fragment_7G00FF/farbe_ohne_wert.txt
rm -r fragment_7G00FF

ls
./leuchtturm-stabilisieren
ls erinnerungen
cat erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
rm erinnerungen/ERINNERUNG_KEHRT_ZURUECK.txt
ls erinnerungen
```

Kontrolliere den Bereich nach einem kurzen Moment nochmals mit:

```bash
ls erinnerungen
```

</details>

## Erkenntnis

Die Datei wurde entfernt. Trotzdem kehrt sie zurück. Das Problem liegt
offenbar nicht nur im Dateisystem.
