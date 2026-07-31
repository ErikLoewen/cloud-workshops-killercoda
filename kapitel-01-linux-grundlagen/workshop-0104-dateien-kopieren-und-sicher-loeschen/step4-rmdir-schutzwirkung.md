# Die volle Kiste schützt ihren Inhalt

Untersuche zuerst die volle Kiste:

```bash
ls arbeitstisch/volle-kiste
cat arbeitstisch/volle-kiste/inhalt.txt
```

Wird `rmdir` sie entfernen? Probiere den kontrollierten Fehlversuch selbst:

`rmdir arbeitstisch/volle-kiste`{{}}

Die genaue Meldung kann variieren. Entscheidend ist die Schutzwirkung:
`rmdir` lehnt ein nicht leeres Verzeichnis ab. Prüfe erneut mit `ls` und
`cat`, dass Kiste und Inhalt unverändert vorhanden sind.

Erkläre in eigenen Worten: Warum ist dieser Fehler kein Defekt?
