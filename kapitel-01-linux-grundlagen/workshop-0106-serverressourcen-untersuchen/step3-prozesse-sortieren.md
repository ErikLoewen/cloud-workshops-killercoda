# Wer verbraucht die Rechenleistung?

`top` eignet sich zum Beobachten. Für eine ruhige Momentaufnahme verwenden wir
`ps`.

Die normale Prozessausgabe kann viele Angaben enthalten. Deshalb wählen wir
nur die Spalten aus, die wir für diese Diagnose benötigen.

| Werkzeug | Funktion |
|---|---|
| `top` | laufend aktualisierte Ansicht |
| `ps` | Momentaufnahme der Prozesse |

## Eine reduzierte Prozessliste erzeugen

```bash
ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu
```{{exec}}

Der Befehl besteht hier aus wenigen relevanten Teilen:

- `ps` zeigt Prozessinformationen an.
- `-e` bezieht alle Prozesse ein.
- `-o` legt die gewünschten Ausgabespalten fest.
- `--sort=-pcpu` stellt hohe CPU-Werte an den Anfang.

| Spalte | Bedeutung |
|---|---|
| `USER` | Benutzer, unter dem der Prozess läuft |
| `PID` | eindeutige Prozessnummer |
| `%CPU` | CPU-Nutzung des Prozesses |
| `%MEM` | ungefährer Anteil am RAM |
| `COMMAND` | Prozessname |

## PID, Benutzer und Name zusammen prüfen

Eine PID ist die eindeutige Nummer einer laufenden Prozessinstanz. Sie allein
reicht für eine sichere Entscheidung noch nicht aus. Prüfe zusätzlich Benutzer
und Prozessname.

Du wirst auch Shells und Prozesse der Laborumgebung sehen. Wir untersuchen sie
heute nicht im Detail und verändern sie nicht.

## Arbeitsauftrag

Untersuche die ersten Zeilen der sortierten Ausgabe.

Finde einen auffälligen Eintrag und beantworte:

1. Unter welchem Benutzer läuft er?
2. Wie lautet sein Prozessname?
3. Welche PID gehört genau zu dieser Instanz?

Beende noch nichts.

<details>
<summary>Hinweis 1 – Sortierung</summary>

Die höchsten Werte aus der Spalte `%CPU` beziehungsweise dem Sortierfeld
`pcpu` stehen oben.

</details>

<details>
<summary>Hinweis 2 – Sichere Identifikation</summary>

Prüfe den Eintrag immer als Kombination aus `USER`, `COMMAND` und `PID`.

</details>

## Nächster Schritt

Du kannst nun einen auffälligen Prozess identifizieren. Bevor du die echte
Störung veränderst, übst du das kontrollierte Beenden an einem harmlosen
Prozess.
