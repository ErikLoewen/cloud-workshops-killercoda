# Schritt 2: Ein Verzeichnis erstellen

## Der neue Befehl `mkdir`

`mkdir` steht für **„make directory“**. Das bedeutet **„Verzeichnis erstellen“**.

`mkdir` erstellt ein Verzeichnis.

Wir benötigen den Befehl, damit zusammengehörige Dateien später in einem eigenen Bereich liegen können. Nach der nächsten Eingabe soll im aktuellen Verzeichnis ein neues Verzeichnis mit dem Namen `sammlung` existieren.

Ein erfolgreicher Aufruf von `mkdir` erzeugt normalerweise keine eigene Ausgabe. Der Prompt erscheint einfach wieder. Prüfe den Erfolg anschließend mit dem bereits bekannten Befehl `ls`.

In diesem Workshop verwendest du `mkdir` ohne Optionen.

## Vorhersage

Was erwartest du direkt nach einem erfolgreichen `mkdir`: einen erklärenden Text oder den nächsten Prompt?

## Einzige anklickbare Demonstration

`mkdir sammlung`{{exec}}

**Erwartete Terminalausgabe:**

Normalerweise erscheint kein eigener Text. Der Prompt kehrt zurück.

**Erwartete Zustandsänderung:**

Das Verzeichnis `/root/dateilabor/uebung/sammlung` existiert jetzt.

## Erfolg selbst kontrollieren

Tippe den Kontrollbefehl selbst ein:

```bash
ls
```

**Erwartete relevante Ausgabe:**

```text
sammlung
```

Wenn `sammlung` angezeigt wird, war die Erstellung erfolgreich.
