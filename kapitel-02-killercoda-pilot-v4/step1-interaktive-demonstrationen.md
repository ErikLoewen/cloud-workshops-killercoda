# Interaktive Netzwerkarchitektur

Das Setup hat dich direkt als `telegrafist` in den Arbeitsordner versetzt.

Prüfe den aktuellen Ort:

`pwd`{{exec}}

## Live-Demonstrationen im Text

<details>
<summary><strong>1 · Name und Adresse</strong></summary>

`./pilot-werkzeuge/textdemo-name`{{exec}}

Die Ausgabe wird bei jedem Klick neu aus dem Systemzustand erzeugt.

</details>

<details>
<summary><strong>2 · Prozess und TCP-Port</strong></summary>

`./pilot-werkzeuge/textdemo-dienst`{{exec}}

</details>

<details>
<summary><strong>3 · Listener und Bind-Adresse</strong></summary>

`./pilot-werkzeuge/textdemo-bindung`{{exec}}

</details>

<details>
<summary><strong>4 · HTTP-Antwort</strong></summary>

`./pilot-werkzeuge/textdemo-http`{{exec}}

</details>

## Interaktive HTML/CSS/JavaScript-Anwendung

Killercoda entfernt JavaScript aus dem Markdown-Text. Die echte interaktive
Netzwerkarchitektur läuft deshalb im lokalen Dienst:

[Interaktive Netzwerkarchitektur öffnen]({{TRAFFIC_HOST1_8080}}/architektur)

Dort müssen funktionieren:

- die vier Diagnosekarten;
- **Nächste Diagnoseebene**;
- der wechselnde Statustext;
- **Zurücksetzen**.

Der CHECK prüft die vier Live-Demonstrationen und den HTML-Endpunkt. Die
sichtbare Browserbedienung bleibt ein manueller Plattformnachweis.
