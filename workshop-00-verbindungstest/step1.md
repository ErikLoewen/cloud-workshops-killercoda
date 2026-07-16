# Umgebung und Prüfung testen

## 1. Linux-Umgebung untersuchen

Führe zunächst die folgenden Befehle aus:

`whoami`{{exec}}

`hostname`{{exec}}

`cat /etc/os-release`{{exec}}

## 2. Testdatei erzeugen

Der folgende Befehl erzeugt eine Datei, anhand derer Killercoda prüfen kann, ob du die Aufgabe abgeschlossen hast:

`printf 'killercoda-ok\n' > /tmp/killercoda-verbindungstest.txt`{{exec}}

Kontrolliere anschließend den Inhalt:

`cat /tmp/killercoda-verbindungstest.txt`{{exec}}

Erwartete Ausgabe:

```text
killercoda-ok
```

## 3. Aufgabe prüfen

Klicke anschließend auf **CHECK**.

Die Prüfung ist erfolgreich, wenn die Datei existiert und exakt den erwarteten Inhalt enthält.
