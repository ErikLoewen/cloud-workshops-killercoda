# Die Nachtwache finden

`uebergabe-chat.log` gehört laut `ls -l` der `nachtwache`, ist für dich
aber lesbar:

`cat uebergabe-chat.log`{{exec}}

Die Nachricht schreibt das Kennwort nicht direkt aus, hinterlässt aber einen
leicht erratbaren Hinweis. Auch das ist schlechtes Sicherheitsverhalten.
Leite das Kennwort ab und wechsle mit `su - nachtwache`.

Kontrolliere danach bewusst:

```bash
whoami
pwd
```

<details>
<summary>Hinweis 1 – Wörter zusammensetzen</summary>

Die Nachricht nennt zuerst den Sturm und danach das Licht. Setze beide Wörter
ohne Leerzeichen zusammen.

</details>

<details>
<summary>Hinweis 2 – Kennwort</summary>

Das Kennwort lautet `sturmlicht`. Verwende:

```bash
su - nachtwache
```

Während der Passworteingabe erscheinen keine Zeichen.

</details>
