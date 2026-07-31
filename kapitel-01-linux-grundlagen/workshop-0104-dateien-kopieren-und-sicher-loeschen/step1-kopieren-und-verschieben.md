# Die Kopie bleibt

`cp QUELLE ZIEL` erzeugt am Ziel eine zusätzliche Datei. Anders als bei
`mv` bleibt die Quelle an ihrem bisherigen Ort.

> `cp` → Quelle bleibt, Kopie entsteht
>
> `mv` → Objekt wechselt Namen oder Ort

Probiere es zunächst mit der Vorlage. Dieser erste neue Befehl ist anklickbar:

`cp arbeitstisch/vorlage.txt arbeitstisch/vorlage-kopie.txt`{{exec}}

Prüfe anschließend selbst:

```bash
ls arbeitstisch/vorlage.txt arbeitstisch/vorlage-kopie.txt
cat arbeitstisch/vorlage.txt
cat arbeitstisch/vorlage-kopie.txt
```

Welche zwei Pfade existieren jetzt? Was wäre nach einem entsprechenden `mv`
anders? Eine fehlende Erfolgsmeldung ist normal; der kontrollierte Zustand
entscheidet.

Die wichtige `erste-spur.txt` kopierst du erst in der Abschlussaufgabe.
