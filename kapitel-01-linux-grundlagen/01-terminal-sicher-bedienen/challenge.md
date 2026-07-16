# Abschlussaufgabe

Bearbeite die Aufgabe ohne anklickbare Befehle.

## Ziel

1. Gib den Text `terminal-bereit` mit dem bekannten Ausgabebefehl aus.
2. Hole dieselbe Eingabe mit der **Pfeiltaste nach oben** zurück und führe sie erneut aus.
3. Starte die bereits eingeführte Warteübung für 30 Sekunden.
4. Beende den Vordergrundprozess vorzeitig.
5. Starte den CHECK erst, wenn der Prompt wieder sichtbar ist.

## Sichtbare Erfolgskriterien

- `terminal-bereit` erscheint zweimal als Ausgabe.
- Du hast die zweite Eingabe aus dem Befehlsverlauf zurückgeholt.
- Während der Warteübung fehlt vorübergehend der neue Prompt.
- Nach deiner Unterbrechung erscheint der Prompt wieder.

## Technische Teilprüfung

Der CHECK beobachtet nur einen begrenzten technischen Zustand der `sleep 30`-Übung. Er erkennt nicht zuverlässig, ob du Enter, die Pfeiltaste nach oben oder `Strg+C` verwendet hast. Er prüft auch nicht die `echo`-Ausgabe oder dein Begriffsverständnis.

Nutze Hinweise erst nach einem eigenen Versuch.

<details>
<summary>Hinweis 1 – Konzept</summary>

Für den Text benötigst du den bereits verwendeten Ausgabebefehl. Eine frühere Eingabe holst du aus dem Befehlsverlauf zurück. Ein laufender Vordergrundprozess wird mit der eingeführten Tastenkombination unterbrochen.

</details>

<details>
<summary>Hinweis 2 – Passendes Werkzeug</summary>

Der Ausgabebefehl heißt `echo`. Die Pfeiltaste nach oben holt die vorherige Eingabe zurück. Die Warteübung verwendet `sleep`. Die Unterbrechung erfolgt mit `Strg+C`.

</details>

<details>
<summary>Hinweis 3 – Nahezu vollständige Lösung</summary>

Die erste Eingabe beginnt mit `echo` und erhält `terminal-bereit` als Argument. Danach verwendest du die Pfeiltaste nach oben und Enter. Die Warteübung besteht aus `sleep` und dem Argument `30`.

</details>

<details>
<summary>Hinweis 4 – Musterlösung mit Erklärung</summary>

Gib zuerst `echo terminal-bereit` ein und drücke Enter. `echo` ist der Befehl; `terminal-bereit` ist das auszugebende Argument.

Drücke danach die Pfeiltaste nach oben und Enter. So führst du dieselbe Eingabe erneut aus, ohne sie vollständig neu zu tippen.

Gib anschließend `sleep 30` ein und drücke Enter. Halte dann Strg gedrückt und drücke C. Der zurückkehrende Prompt zeigt, dass die Shell wieder bereit ist.

</details>
