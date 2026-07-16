# Ein leeres Verzeichnis entfernen

`rmdir` entfernt ausschließlich ein leeres Verzeichnis.

```text
rmdir        leerer-ordner
Befehl       Zielverzeichnis
```

`rmdir` entfernt keine Datei und kein Verzeichnis, das noch Inhalte besitzt.

## Erfolgreicher Fall

Prüfe im Demo-Verzeichnis zunächst den vorhandenen Eintrag:

```bash
pwd
ls
ls leerer-ordner
```

Sage voraus, welches Objekt danach fehlen soll.

Gib den Befehl selbst ein:

`rmdir leerer-ordner`{{}}

Die leere Code-Aktion verhindert eine automatische Ausführung. Tippe den Befehl selbst.

Kontrolliere anschließend selbst:

```bash
ls
```

Wenn keine ausführliche Erfolgsmeldung erscheint, ist das normal. `ls` zeigt, ob das leere Verzeichnis entfernt wurde.

## Kurze Erklärung

- Warum passt `rmdir` zu diesem Ziel?
- Weshalb wäre `rm` auf eine einzelne Datei eine andere Handlung?
