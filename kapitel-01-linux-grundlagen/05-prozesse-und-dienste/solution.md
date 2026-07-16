# Musterlösung – Prozesse und Dienste kontrollieren

## Prozessablauf

Erster geführter Durchlauf:

```text
lab-worker &
ps
pgrep lab-worker
```

`pgrep lab-worker` gibt eine dynamische PID aus. Angenommen, die aktuelle Ausgabe wäre **beispielsweise** `4281`:

```text
kill 4281
pgrep lab-worker
```

Die Beispiel-PID `4281` darf nur verwendet werden, wenn sie wirklich die gerade angezeigte PID ist. Andernfalls muss die eigene aktuelle Zahl eingesetzt werden. Die letzte Suche soll keine PID mehr ausgeben.

## Dienstablauf

```text
systemctl status lab-demo.service
systemctl stop lab-demo.service
systemctl status lab-demo.service
```

Nach dem Stoppen muss die relevante Zeile `Active: inactive` enthalten.

## Challenge

```text
lab-worker &
pgrep lab-worker
kill AKTUELLE_PID
pgrep lab-worker
systemctl start lab-demo.service
systemctl status lab-demo.service
```

`AKTUELLE_PID` ist ein Platzhalter und wird durch die gerade ausgegebene Zahl ersetzt. Am Ende soll die Prozesssuche leer bleiben und die Dienststatuszeile `Active: active` zeigen.

## Fachlich gültige Reihenfolgen

Innerhalb des Prozessblocks muss die PID vor `kill` aktuell ermittelt werden. Die Kontrolle nach `kill` gehört zum Lernziel.

In der Challenge dürfen Prozessblock und Dienststart grundsätzlich in vertauschter Reihenfolge bearbeitet werden, sofern beide Endzustände erreicht werden. Die Musterlösung verwendet die didaktisch eingeführte Reihenfolge.

## Marker und ihre Grenzen

Der Worker-Startmarker entsteht ausschließlich im tatsächlich gestarteten Lab-Programm. Er weist nach, dass dieses Programm in der aktuellen Sitzung mindestens einmal lief. Er weist nicht nach:

- ob `&` verwendet wurde;
- ob der Start im Hintergrund erfolgte;
- ob `ps` oder `pgrep` verwendet wurden;
- ob die PID eigenständig gelesen wurde;
- ob `kill` verwendet wurde.

Ein Vordergrundstart mit anschließendem Ende könnte denselben technischen Prozessendzustand erzeugen.

Der Dienstnachweis ist stärker: Er verlangt einen initial aktiven Dienst, einen nach Aktivierung des Trackings registrierten geordneten Stop, einen späteren registrierten Start und einen aktuell aktiven eigenen Dienstprozess.

Auch dieser Nachweis bewertet den Endzustand und die Lifecycle-Ereignisse, nicht die exakte sichtbare Teilnehmerbefehlsfolge.
