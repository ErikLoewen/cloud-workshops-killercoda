# Abschlussaufgabe

## Ausgangslage

- `lab-worker` läuft nicht mehr.
- Das Lab-Programm wurde im geführten Teil bereits einmal gestartet.
- `lab-demo.service` ist inaktiv.
- Ein gültiger Stop wurde registriert.

## Ziel

Stelle selbstständig diesen Endzustand her:

1. Starte `lab-worker` erneut mit `&` im Hintergrund.
2. Ermittle die aktuelle PID mit `pgrep`.
3. Beende den Prozess mit `kill` und deiner tatsächlich angezeigten PID.
4. Prüfe, dass `pgrep` keinen Treffer mehr liefert.
5. Starte `lab-demo.service`.
6. Prüfe mit `systemctl status`, dass die Unit wieder `active` ist.
7. Löse danach den Abschluss-CHECK aus.

Es gibt in dieser Aufgabe keine anklickbaren Lösungsbefehle. Verwende nur die bereits eingeführten Befehle, Aktionen und die bekannte Syntax.

## Erfolgskriterien

- Das Lab-Programm wurde in dieser Sitzung gestartet.
- Keine eigene `lab-worker`-Instanz läuft mehr.
- Der Demo-Dienst wurde nach dem gültigen Stop erneut gestartet.
- Das Startereignis liegt nach dem Stopereignis.
- `lab-demo.service` ist aktuell aktiv.
- Der zugehörige Prozess gehört zum isolierten Demo-Dienst.

<details>
<summary>Hinweis 1 – Zustände und Konzepte</summary>

Du brauchst zuerst einen kurzzeitig laufenden Hintergrundprozess und am Ende keinen laufenden `lab-worker`. Der aktuell inaktive Dienst muss am Ende wieder aktiv sein.

</details>

<details>
<summary>Hinweis 2 – Passende Werkzeuge</summary>

Nutze `&` für den Hintergrundstart, `pgrep` für die aktuelle PID, `kill` zum Beenden und die bekannte `systemctl`-Aktion zum Starten der Unit. Kontrolliere beide Endzustände.

</details>

<details>
<summary>Hinweis 3 – Struktur mit Lücken</summary>

```text
lab-worker __

pgrep lab-worker

kill [hier deine aktuelle Zahl einsetzen]

pgrep lab-worker

systemctl _____ lab-demo.service

systemctl status lab-demo.service
```

</details>

<details>
<summary>Hinweis 4 – Vollständiger Musterablauf</summary>

```text
lab-worker &
pgrep lab-worker
```

Angenommen, deine aktuelle Ausgabe wäre **beispielsweise** `4281`. Nur dann würde der nächste Befehl `kill 4281` lauten. Verwende immer deine eigene aktuelle PID.

```text
kill 4281
pgrep lab-worker
systemctl start lab-demo.service
systemctl status lab-demo.service
```

Die zweite Suche nach `lab-worker` soll keine PID mehr ausgeben. In der Dienststatusausgabe soll `Active: active` stehen.

</details>

## Abschluss-CHECK

Der technische CHECK prüft den beschriebenen Endzustand. Er liest nur und verändert weder Prozesse, Dienstzustand noch Marker.
