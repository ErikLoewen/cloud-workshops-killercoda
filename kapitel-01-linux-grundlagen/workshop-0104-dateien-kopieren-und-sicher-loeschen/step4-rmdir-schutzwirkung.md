# Kontrolliertes Scheitern mit `rmdir`

Jetzt wendest du `rmdir` absichtlich auf ein nicht leeres Verzeichnis an. Dieser Fehlversuch ist ein geplanter Teil des Lernwegs.

Ein von Hand ausgeführter Befehl darf mit einem Fehlerstatus enden. Die Shell bleibt danach verwendbar und du kannst weitere Befehle eingeben.

## Vorher prüfen

Gib selbst ein:

```bash
ls nicht-leer
cat nicht-leer/inhalt.txt
```

Du erwartest den Inhalt:

```text
Das Verzeichnis ist nicht leer
```

Sage voraus:

- Wird `rmdir` das Verzeichnis entfernen?
- Was geschieht mit `inhalt.txt`?
- Woran erkennst du, dass die Handlung abgelehnt wurde?

Gib den kontrollierten Fehlversuch selbst ein:

`rmdir nicht-leer`{{}}

Die leere Code-Aktion verhindert eine automatische Ausführung. Tippe den Befehl selbst.

Der genaue Wortlaut der Meldung kann je nach Umgebung unterschiedlich sein. Relevant ist, dass die Handlung abgelehnt wird.

## Nachher kontrollieren

Gib selbst ein:

```bash
ls
ls nicht-leer
cat nicht-leer/inhalt.txt
```

Der erwartete Zustand:

- `nicht-leer` ist weiterhin vorhanden.
- `inhalt.txt` ist weiterhin vorhanden.
- Der Inhalt ist unverändert.
- Der Laborzustand ist nicht beschädigt.

## Erkläre

Warum ist das kontrollierte Scheitern hier eine Schutzwirkung und kein Systemdefekt?
