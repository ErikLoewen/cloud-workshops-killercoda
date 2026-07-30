# Abschluss: den letzten Eintrag finden

Im Untergeschoss könnte eine erste Spur liegen. Wechsle mit diesem
anklickbaren Befehl zum Ausgangsort:

`cd ~/leuchtturm/eingang`{{exec}}

## Dein Ziel

Finde selbstständig den Lagerraum. Entdecke dort das Archiv und darin mit
`ls` die Datei `letzter_eintrag.txt`.

Öffne, lies, verändere, kopiere oder benenne die Datei noch nicht um. Darum
geht es erst im nächsten Workshop.

## Erlaubte Lernwerkzeuge

Nutze ausschließlich:

- `pwd` für deinen Standort,
- `ls` für sichtbare Einträge,
- `cd` für den Verzeichniswechsel,
- Tab für eindeutige Namen.

## Vorgehen

1. Prüfe deinen Ausgangsort.
2. Untersuche sichtbare Wege.
3. Navigiere zum Lagerraum und suche dort das Archiv.
4. Wechsle in das Archiv.
5. Entdecke mit `ls` den letzten Eintrag.

## Technische Prüfaktion

Wenn `letzter_eintrag.txt` in deiner `ls`-Ausgabe erscheint, führe ohne
Argument aus:

```text
eintrag-bestaetigen
```

Die bereitgestellte Aktion ist kein neuer Linux-Lernbefehl. Sie prüft nur den
Fundort und die Existenz der Datei. Bei Erfolg erscheint:

```text
Der letzte Eintrag wurde gefunden. Du kannst jetzt den CHECK ausführen.
```

Starte danach den Killercoda-CHECK.

## Hinweise

Öffne eine weitere Stufe erst nach einem neuen eigenen Versuch.

<details>
<summary>Hinweis 1 – Navigationsprinzip</summary>

Der Lagerraum liegt nicht im Eingang. Ermittle deinen Standort und gehe
zunächst in den übergeordneten Hauptbereich des Leuchtturms.

</details>

<details>
<summary>Hinweis 2 – passende Werkzeuge</summary>

Nutze `pwd` zur Orientierung, `ls` für sichtbare Namen und `cd ..` für eine
Ebene nach oben. Tab kann eindeutige Namen vervollständigen.

</details>

<details>
<summary>Hinweis 3 – grobe Wegstruktur</summary>

Vom Hauptbereich führt der Weg zuerst ins Untergeschoss, dann in den
Lagerraum und schließlich ins Archiv. Prüfe auf jeder Ebene mit `ls`, welche
Namen tatsächlich sichtbar sind.

</details>

<details>
<summary>Hinweis 4 – Musterlösung mit Erklärung</summary>

Eine schrittweise Lösung ist:

```text
cd ..
ls
cd untergeschoss
ls
cd lagerraum
ls
cd archiv
pwd
ls
eintrag-bestaetigen
```

`cd ..` führt vom Eingang zurück in den Hauptbereich. Danach folgst du den
mit `ls` sichtbaren Namen. Im Archiv zeigt `ls` die Datei
`letzter_eintrag.txt`; die Prüfaktion bestätigt anschließend Fundort und
Datei, ohne den Eintrag zu verändern.

</details>
