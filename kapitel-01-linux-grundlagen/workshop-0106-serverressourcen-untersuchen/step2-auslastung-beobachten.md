# Was arbeitet gerade im Turm?

Die bisherigen Befehle zeigen, was dem System zur Verfügung steht. Sie zeigen
aber nicht ausreichend, was gerade Rechenzeit verbraucht.

Ein laufendes Programm erscheint unter Linux als Prozess. Prozesse nutzen CPU
und RAM. Um Veränderungen live zu beobachten, verwenden wir `top`.

> **Hinweis:** Für diesen Untersuchungsschritt wurde im Hintergrund eine
> auffällige Systemlast vorbereitet. Das Terminal kann geringfügig verzögert
> reagieren. Warte nach einer Eingabe kurz, statt denselben Befehl mehrfach
> abzusenden.

```bash
top
```{{exec}}

Die Anzeige aktualisiert sich regelmäßig. Du musst heute nicht jede Zahl
verstehen.

| Bereich | Heute relevant |
|---|---|
| `%CPU` | Wie viel CPU beansprucht ein Prozess ungefähr? |
| `COMMAND` | Welcher Prozess beziehungsweise Befehl ist es? |
| `q` | `top` verlassen |

`%CPU` ist ein Prozentwert: `0.6` bedeutet 0,6 Prozent, `15.0` ungefähr
15 Prozent und `60.0` ungefähr 60 Prozent. In der zusammenfassenden CPU-Zeile
steht `id` für *idle*, also unbeschäftigt. `99.7 id` bedeutet, dass die CPU
ungefähr zu 99,7 Prozent untätig ist.

```text
0.6   → geringe CPU-Nutzung
15.0  → deutlich auffällige CPU-Nutzung
60.0  → sehr hohe CPU-Nutzung
```

Bei Programmen mit mehreren Threads können Werte über 100 Prozent auftreten.
Für diese Aufgabe reicht die einfache Einordnung.

## Beobachtungsauftrag

Beobachte mehrere Aktualisierungen.

Suche noch nicht nach einer fertigen Lösung. Prüfe nur:

1. Gibt es einen Prozess mit deutlich höherer CPU-Nutzung?
2. Bleibt dieser Wert über mehrere Aktualisierungen auffällig?
3. Welcher Name steht in derselben Zeile?

## Sicher beobachten

In der Liste stehen auch Shells, Systemprozesse und Werkzeuge der
Laborumgebung. Ein unbekannter Name allein ist kein Grund, einen Prozess zu
beenden.

<details>
<summary>Hinweis 1 – Wo hinschauen?</summary>

Vergleiche in der Prozessliste die Spalte `%CPU`. Lies anschließend in
derselben Zeile den Eintrag unter `COMMAND`.

</details>

<details>
<summary>Hinweis 2 – top verlassen</summary>

Drücke `q`.

</details>

## Beobachtung einordnen

Die Live-Anzeige zeigt, dass laufende Prozesse sehr unterschiedlich viel
Rechenzeit beanspruchen können. Für eine genaue Auswahl brauchen wir jetzt
eine ruhigere, sortierte Momentaufnahme.
