# Die Nachtwache finden

`uebergabe-chat.log` gehört laut `ls -l` der `nachtwache`, ist für dich
aber lesbar:

`cat uebergabe-chat.log`{{exec}}

Ein Kennwort wurde dort offen hinterlassen. Das ist schlechtes
Sicherheitsverhalten: Passwörter gehören weder in Logs noch in
Chatnachrichten.

Wechsle nun:

```bash
su - nachtwache
```

Gib bei der Passwortabfrage `sturmlicht` ein. Während der Eingabe erscheinen
keine Zeichen. Kontrolliere danach bewusst:

```bash
whoami
pwd
```

Erwartet werden `nachtwache` und `/home/nachtwache`.
