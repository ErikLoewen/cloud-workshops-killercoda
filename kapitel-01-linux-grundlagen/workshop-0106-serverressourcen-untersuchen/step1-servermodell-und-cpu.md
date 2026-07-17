# Schritt 1: Servermodell und CPU

## Drei verschiedene Ressourcen

Ein einfaches Servermodell unterscheidet:

| Ressource | Aufgabe |
|---|---|
| CPU beziehungsweise logische Prozessoren | Rechenarbeit ausführen |
| RAM beziehungsweise Arbeitsspeicher | Arbeitsdaten laufender Programme kurzfristig bereithalten |
| persistenter Dateisystemspeicher | Dateien speichern |

Eine Werkstatt kann als begrenzte Analogie helfen:

- logische Prozessoren ähneln verfügbaren Arbeitsplätzen für Rechenarbeit;
- RAM ähnelt einer Arbeitsfläche für aktuell bearbeitete Dinge;
- Dateisystemspeicher ähnelt einem Regal für abgelegte Dateien.

Die Analogie erklärt nur die unterschiedlichen Aufgaben. Sie beschreibt nicht den technischen Aufbau der Hardware.

## Vorhersage

Welcher Bereich würde eher knapp, wenn viele laufende Anwendungen gleichzeitig Arbeitsdaten bereithalten: RAM oder Dateisystemspeicher?

## Der erste Diagnosebefehl: `nproc`

**Was macht der Befehl?**  
`nproc` zeigt die Zahl der **für die aktuelle Umgebung verfügbaren logischen Prozessoren**.

**Warum wird er benötigt?**  
Der Befehl beantwortet eine einfache Frage zur verfügbaren CPU-Verarbeitungskapazität dieser Umgebung.

**Welche Ausgabe wird erwartet?**  
Eine einzelne positive ganze Zahl.

**Warum sind das nicht automatisch physische Prozessorkerne?**  
Eine virtuelle oder begrenzte Umgebung kann Rechenressourcen anders darstellen als die zugrunde liegende Hardware. Der Befehl belegt daher nur die Zahl der für die aktuelle Umgebung verfügbaren logischen Prozessoren.

`nproc` besteht nur aus dem Befehl. Es folgt kein weiterer Bestandteil.

Führe den Befehl aus:

`nproc`{{exec}}

## Beobachte

1. Ist die Ausgabe eine einzelne Zahl oder eine Tabelle?
2. Formuliere das Ergebnis korrekt:

> Für die aktuelle Umgebung sind ___ logische Prozessoren verfügbar.

3. Warum wäre diese Aussage zu stark?

> Der Server besitzt genau so viele physische Prozessorkerne.

Für eine Antwort brauchst du keine Details zu Sockeln, Threads oder CPU-Architektur.
