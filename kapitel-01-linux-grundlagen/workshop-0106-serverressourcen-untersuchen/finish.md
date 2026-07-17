# Workshop abgeschlossen

Der technische CHECK bestätigt einen kleinen Endzustand. Er bestätigt nicht automatisch, dass du jede Ausgabe verstanden oder alle Werte manuell abgelesen hast.

## Befehl, Option und Argument abrufen

Beantworte ohne Zurückzublättern:

1. Welcher Teil von `free -h` ist der Befehl?
2. Welcher Teil ist die Option?
3. Was verändert `-h`?
4. Welcher zusätzliche Teil kommt bei `df -h /` hinzu?
5. Warum ist `/` ein Argument und keine Option?
6. Was ist bei `df -h /` Befehl, Option und Argument?

<details>
<summary>Antworten prüfen</summary>

1. `free`
2. `-h`
3. Die Option sorgt hier für leichter lesbare Größenangaben mit Einheiten.
4. Das Argument `/`
5. `/` bezeichnet den Root-Pfad, auf dessen Dateisystem sich `df` beziehen soll. Es verändert nicht als Option die Arbeitsweise.
6. Befehl: `df`; Option: `-h`; Argument: `/`

</details>

## Ressourcenwissen abrufen

1. Was zeigt `nproc` fachlich korrekt?
2. Warum darf die Zahl nicht automatisch als physische Kernzahl bezeichnet werden?
3. Was ist bei `free -h` der Unterschied zwischen `free` und `available`?
4. Welche Zeile gehört zum RAM und welche Zusatzzeile wurde nicht ausgewertet?
5. Was bedeuten bei `df -h /` `Used` und `Avail`?
6. Warum sind RAM und Dateisystemspeicher nicht austauschbar?
7. Welche drei dokumentierten Werte können sich während der Sitzung verändern?

<details>
<summary>Antworten prüfen</summary>

- `nproc` zeigt die Zahl der für die aktuelle Umgebung verfügbaren logischen Prozessoren.
- Die Umgebung kann Rechenressourcen anders darstellen oder begrenzen als die physische Hardware.
- `free` ist vollständig ungenutzter RAM. `available` schätzt, wie viel RAM für neue Anwendungen noch nutzbar ist.
- Die RAM-Zeile ist gewöhnlich `Mem:`. Die Swap-Zeile wurde nicht ausgewertet.
- `Used` ist belegter, `Avail` verfügbarer Dateisystemspeicher.
- RAM ist kurzfristiger Arbeitsbereich laufender Programme; Dateisystemspeicher hält Dateien.
- verfügbarer RAM, belegter Dateisystemspeicher und verfügbarer Dateisystemspeicher.

</details>

## Grenze des CHECKs

Maschinell geprüft wurden Format, stabile Werte und robuste Beziehungen. Nicht maschinell nachgewiesen wurden:

- die manuelle Auswahl von `available`, `Used` und `Avail`;
- die Unterscheidung von logischen und physischen Prozessorkernen;
- das Verständnis von CPU, RAM und Dateisystemspeicher;
- die sichere Unterscheidung von Befehl, Option und Argument.

Diese Ziele werden durch deine Antworten und gegebenenfalls durch eine Trainerin oder einen Trainer geprüft.

## Übergang

Im nächsten Workshop werden Prozesse und verwaltete Dienste untersucht. Die heutige Fähigkeit, gezielt Systemausgaben zu lesen und relevante Werte auszuwählen, wird dort wieder benötigt.
