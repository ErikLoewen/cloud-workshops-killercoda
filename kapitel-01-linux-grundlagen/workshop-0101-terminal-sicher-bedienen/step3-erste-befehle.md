# Schritt 3: Erste Meldung vom System – `whoami` und `echo`

## Der Befehl `whoami`

Der Name kommt von der englischen Frage **„Who am I?“** – auf Deutsch:
**„Wer bin ich?“**

### Was macht er?

`whoami` zeigt den Namen des Benutzers, als der die Shell gerade arbeitet.

### Warum brauchen wir ihn?

Der Befehl ist kurz und liefert sofort eine gut erkennbare Ausgabe.

### Was erwarten wir?

Eine einzelne Zeile mit einem Benutzernamen. In dieser Umgebung ist das
`waerter`.

## Vorhersage

Erwartest du eine Textausgabe oder eine dauerhafte Veränderung?

## Ersten Befehl ausführen

Dann schauen wir, unter welchem Benutzernamen du am Deichserver arbeitest.
Klicke auf den Befehl:

`whoami`{{exec}}

## Erwartete Ausgabe

```text
waerter
```

Danach erscheint erneut der Prompt. Der Befehl ist beendet und die Shell ist
wieder bereit.

## Der Befehl `echo`

Das englische Wort **„echo“** bedeutet **„Echo“** oder **„Widerhall“**. Der Befehl gibt den Text wieder aus, den du ihm mitgibst.

### Was macht er?

`echo` gibt den Text aus, der nach dem Befehlsnamen steht.

### Warum brauchen wir ihn?

Mit `echo` kannst du Eingabe und Ausgabe besonders leicht vergleichen.

### Was erwarten wir?

Der angegebene Text erscheint in einer neuen Zeile.

## Ein Echo im Leuchtturm

Klicke den neuen Befehl bei diesem ersten Kontakt an:

`echo "Moin Terminal"`{{exec}}

Erwartete Ausgabe:

```text
Moin Terminal
```

## Jetzt selbst eingeben

1. Klicke in das Terminal.
2. Tippe selbst `echo "Hallo Welt"`{{}}.
3. Drücke **Enter**.

Die Anführungszeichen zeigen der Shell, dass die beiden Wörter
zusammengehören. Tippe sie deshalb mit ein.

## Erwartete Ausgabe

```text
Hallo Welt
```

## Beobachtungsfrage

Welche Zeile war deine Eingabe? Welche war die Ausgabe? Woran erkennst du,
dass die Shell für den nächsten Befehl bereit ist?
