# Eine einzelne Datei sicher entfernen

`rm` entfernt in diesem Workshop eine einzelne Datei.

```text
rm        einzeldatei.txt
Befehl    Ziel
```

Für diese Aufgabe wird kein Papierkorb verwendet. Der CHECK kann eine entfernte Datei nicht wiederherstellen. Ein neuer Szenariostart kann das Labor neu erzeugen, ist aber keine Rückgängig-Funktion von `rm`.

Deshalb wird vor dem Befehl geprüft und nicht erst danach überlegt.

## Sicherheitsroutine

Wende vor der ersten Verwendung von `rm` diese sechs Schritte sichtbar an:

1. Standort mit `pwd` prüfen.
2. Zielpfad lesen.
3. Zielobjekt mit `ls` bestätigen.
4. Erwartete Wirkung vorhersagen.
5. Löschbefehl selbst eingeben.
6. Ergebnis und Schutzbereich kontrollieren.

## Ziel prüfen

Du befindest dich weiterhin in `/root/dateilabor/demo`.

Gib selbst ein:

```bash
pwd
ls einzeldatei.txt
```

Lies den Zielpfad vollständig:

```text
/root/dateilabor/demo/einzeldatei.txt
```

Sage vor der Ausführung voraus:

- `einzeldatei.txt` soll verschwinden.
- `quelle.txt`, `kopie.txt` und `nicht-leer` sollen erhalten bleiben.
- `/root/dateilabor/auftrag/schutzbereich` soll unverändert bleiben.

Gib den Löschbefehl nun selbst ein:

`rm einzeldatei.txt`{{}}

Die leere Code-Aktion verhindert eine automatische Ausführung. Tippe den Befehl selbst.

Kontrolliere danach selbst mit:

```bash
ls
ls /root/dateilabor/auftrag/schutzbereich
cat /root/dateilabor/auftrag/schutzbereich/wichtig.txt
```

Der Schutzinhalt muss weiterhin lauten:

```text
Dieser Inhalt muss erhalten bleiben
```

Eine fehlende Erfolgsmeldung ist normal. Entscheidend ist der kontrollierte Zustand.
