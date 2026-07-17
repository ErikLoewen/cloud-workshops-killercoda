# Kopieren und Verschieben unterscheiden

## Was macht `cp`?

`cp` kopiert eine Datei. Wir benötigen den Befehl, um am Ziel eine zusätzliche Datei zu erzeugen.

```text
cp        quelle.txt        kopie.txt
Befehl    Quelle             Ziel
```

- `quelle.txt` ist der vorhandene Quellpfad.
- `kopie.txt` ist der neue Zielpfad.
- Die Quelldatei bleibt erhalten.
- Quelle und Ziel sind zwei unterschiedliche Pfade.

Das bekannte `mv` verschiebt oder benennt ein vorhandenes Objekt um. `cp` erzeugt dagegen eine weitere Datei.

Vorher:

```text
quelle.txt
```

Nach dem Kopieren:

```text
quelle.txt
kopie.txt
```

Eine erfolgreiche Befehlsausführung muss keine ausführliche Bestätigung anzeigen. Deshalb kontrollierst du anschließend Quelle, Ziel und Inhalt.

## Gemeinsam ausführen

Du musst dich in `/root/dateilabor/demo` befinden. Prüfe das bei Bedarf mit `pwd`.

Nur dieser erste vollständige neue Befehl ist anklickbar:

`cp quelle.txt kopie.txt`{{exec}}

Gib die folgenden bekannten Befehle selbst ein:

```bash
ls
cat quelle.txt
cat kopie.txt
```

## Beobachte und erkläre

- Welche beiden Dateien sind jetzt vorhanden?
- Welche Datei war die Quelle?
- Welche Datei wurde neu erzeugt?
- Ist der Inhalt beider Dateien gleich?
- Was wäre bei einem entsprechenden `mv` anders gewesen?
- Weshalb ist die fehlende Erfolgsmeldung kein Beweis für einen Fehler?

Falls `cp` die Quelle nicht findet, prüfe zuerst mit `pwd` deinen Standort und mit `ls` den genauen Dateinamen.
