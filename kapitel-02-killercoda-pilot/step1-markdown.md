# Interaktive Markdown-Demonstrationen

Dieser Schritt prüft, ob Live-Demonstrationen direkt im Markdown funktionieren. Die Terminalausgabe ersetzt dabei ein statisches Bild.

## 1. In das Arbeitskonto wechseln

`su - telegrafist`{{exec}}

`cd ~/nachtstation`{{exec}}

## 2. Einzelnen Befehl anklicken

`./pilot-werkzeuge/markdown-inline-demo`{{exec}}

Erwartet wird eine kurze Ausgabe mit Benutzer und Hostname.

## 3. Mehrzeilige Live-Demonstration

```bash
hostname
pwd
./pilot-werkzeuge/demo-architektur
printf 'ok\n' > status/markdown-multiline.ok
```{{exec}}

Die Live-Karte liest den aktuellen Prozess-, Socket-, Namens- und HTTP-Zustand aus der Umgebung. Sie ist absichtlich keine Bilddatei.

## 4. Kopierbaren Block prüfen

Kopiere den folgenden Block über die Killercoda-Kopieraktion. Füge ihn anschließend in das Terminal ein und bestätige mit Enter.

```bash
printf 'copy-ok\n' > status/markdown-copy.ok
cat status/markdown-copy.ok
```{{copy}}

## 5. Ausklappbare interaktive Demonstration

<details><summary>Live-Demonstration ausklappen</summary>

Der Befehl innerhalb dieses Bereichs muss weiterhin anklickbar sein.

```bash
./pilot-werkzeuge/markdown-details-demo
```{{exec}}

</details>

## 6. Unterbrechungsaktion prüfen

Starte zuerst den blockierenden Test:

`sleep 60`{{exec}}

Beende ihn über die folgende Aktion und erzeuge dabei den Abschlussmarker:

`./pilot-werkzeuge/markdown-interrupt-demo`{{exec interrupt}}

## CHECK

Der CHECK bestätigt die ausgeführten Aktionen. Er kann nicht automatisch beweisen, dass die UI optisch korrekt gerendert wurde; das wird zusätzlich in der manuellen Checkliste dokumentiert.
