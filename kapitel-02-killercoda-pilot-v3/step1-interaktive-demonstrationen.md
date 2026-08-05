# Interaktive Netzwerkarchitektur

Der Killercoda-Test hat gezeigt:

- einfache HTML-Elemente wie `<details>` bleiben im Text erhalten;
- `<style>` wird entfernt;
- `<script>` wird nicht ausgeführt;
- ein eingebettetes `iframe` ist nicht zuverlässig verfügbar.

Deshalb verwendet dieser Schritt zwei robuste Ebenen:

1. **interaktive Aufklapp-Demonstrationen direkt im Text**;
2. **eine echte HTML/CSS/JavaScript-Web-App über den Traffic-Pfad**.

Wechsle zuerst in das vorbereitete Arbeitskonto:

`su - telegrafist`{{exec}}

`cd ~/nachtstation`{{exec}}

## Diagnoseebenen direkt im Text

<details>
<summary><strong>1 · Name und Adresse untersuchen</strong></summary>

Diese Demonstration fragt die aktuelle Systemauflösung ab und erzeugt
die Ausgabe live statt als Bild.

`./pilot-werkzeuge/textdemo-name`{{exec}}

</details>

<details>
<summary><strong>2 · Prozess und TCP-Port untersuchen</strong></summary>

Diese Demonstration verbindet den laufenden Prozess mit dem bekannten
Sollport.

`./pilot-werkzeuge/textdemo-dienst`{{exec}}

</details>

<details>
<summary><strong>3 · Listener und Bind-Adresse untersuchen</strong></summary>

Die aktuelle `ss`-Zeile wird live aus dem Systemzustand gelesen.

`./pilot-werkzeuge/textdemo-bindung`{{exec}}

</details>

<details>
<summary><strong>4 · HTTP-Antwort untersuchen</strong></summary>

Statuszeile und Xebico-Header werden getrennt dargestellt.

`./pilot-werkzeuge/textdemo-http`{{exec}}

</details>

## Echte HTML/CSS/JavaScript-Demonstration

Die vollständige interaktive Architektur läuft als lokale Web-App.
Sie verwendet keine externen Bibliotheken und keine Bilddateien.

[Interaktive Netzwerkarchitektur öffnen]({{TRAFFIC_HOST1_8080}}/architektur)

Prüfe dort:

- die vier Architekturkarten;
- die Schaltfläche **Nächste Diagnoseebene**;
- den wechselnden Statustext;
- die Zurücksetzen-Schaltfläche.

Der CHECK prüft die vier ausgeführten Textdemonstrationen sowie den
HTML/CSS/JavaScript-Endpunkt. Die sichtbare Browserbedienung bleibt ein
manueller Plattformnachweis.
