# Rechte an der Schalttafel lesen

An der Schalttafel liegen mehrere Dateien. Eine normale `ls`-Ausgabe zeigt
nur ihre Namen; mit der Option `-l` werden zusätzliche Eigenschaften sichtbar.

Kontrolliere zuerst deine Identität und führe dann die neue Listenform aus:

`whoami`{{exec}}

`ls -l`{{exec}}

Eine Zeile lässt sich von links nach rechts so lesen:

```text
-rw-r-----  1  waerter  waerter  ...  beispiel
│└────────┘     └─────┘ └─────┘       └──────┘
│ Rechte         Besitzer Gruppe       Dateiname
└ Dateityp
```

Nach dem Dateityp folgen je drei Zeichen für Besitzer, Gruppe und andere.
Besitzer- und Gruppenname stehen danach in eigenen Spalten.

![Grafische Zerlegung eines Linux-Rechteblocks in Dateityp sowie Rechte für Besitzer, Gruppe und andere.](./assets/0105-dateirechte-erklaert.png)

| Kürzel | Bedeutung |
|---|---|
| `u` | Besitzer |
| `g` | Gruppe |
| `o` | andere |
| `r` | lesen |
| `w` | schreiben |
| `x` | ausführen |
| `+x` | Ausführungsrecht hinzufügen |
| `-x` | Ausführungsrecht entfernen |

Wichtig: `u` meint den eingetragenen Besitzer der jeweiligen Datei. Das ist
nicht automatisch der Benutzer, der gerade am Terminal sitzt.

Lies die Zeile von `signaltest` gemeinsam nach diesem Muster. Deute danach die
Zeile einer zweiten Datei selbst: Wem gehört sie, welcher Gruppe ist sie
zugeordnet und welche Handlungen erlauben die drei Rechteblöcke?

<details>
<summary>Hinweis 1: Wie teile ich den Rechteblock?</summary>

Trenne nach dem ersten Zeichen immer in drei Dreiergruppen:
`Dateityp | Besitzer | Gruppe | andere`.

</details>

<details>
<summary>Hinweis 2: Welche Spalten sind Namen?</summary>

Bei der vorbereiteten Ausgabe stehen Besitzer- und Gruppenname zwischen der
Link-Anzahl und Dateigröße. Vergleiche die Namen mit `whoami`.

</details>
