# Schritt 4: Ressourcen vergleichen

## Welches Werkzeug passt?

Ordne jede Frage zu:

| Frage | Passender Befehl | Relevanter Wert |
|---|---|---|
| Wie viele logische Prozessoren sind für die Umgebung verfügbar? | `nproc` | einzelne Ausgabezahl |
| Wie viel RAM ist insgesamt sichtbar? | `free -h` | RAM-Zeile, `total` |
| Wie viel RAM ist für neue Anwendungen voraussichtlich nutzbar? | `free -h` | RAM-Zeile, `available` |
| Wie viel Speicherplatz des Root-Dateisystems ist belegt? | `df -h /` | Zeile für `/`, `Used` |
| Wie viel Speicherplatz des Root-Dateisystems ist verfügbar? | `df -h /` | Zeile für `/`, `Avail` |

## Direkter Vergleich

| Ressource | Bedeutung |
|---|---|
| logische Prozessoren | führen Rechenarbeit aus |
| RAM | kurzfristiger Arbeitsbereich laufender Programme |
| Dateisystemspeicher | Speicherplatz für Dateien |

Beantworte:

1. Ein neues Programm benötigt Arbeitsspeicher. Welcher Befehl passt zuerst?
2. Eine Anwendung kann keine Datei mehr auf dem Root-Dateisystem speichern. Welcher Befehl passt zuerst?
3. Warum sind RAM und Dateisystemspeicher nicht austauschbar?

## Stabile und dynamische Werte

Während einer kurzen Sitzung sind manche Angaben weitgehend stabil:

- die Ausgabe von `nproc`;
- der gesamte sichtbare RAM;
- die Größe des betrachteten Dateisystems.

Andere Werte können sich verändern:

- verfügbarer RAM;
- belegter Dateisystemspeicher;
- verfügbarer Dateisystemspeicher.

Du sollst deshalb keine Werte vorhersagen oder auswendig lernen. Lies die aktuellen Werte deiner Umgebung ab.

## Die spätere Statuszeile

Die Statusdatei enthält genau eine nicht leere Datenzeile in dieser Reihenfolge:

```text
CPU_LOGISCH=<WERT> RAM_GESAMT=<WERT> RAM_VERFUEGBAR=<WERT> DATEISYSTEM_BELEGT=<WERT> DATEISYSTEM_VERFUEGBAR=<WERT>
```

Die Platzhalter `<WERT>` sind keine echten Sollwerte. In der Abschlussaufgabe setzt du dort die tatsächlich angezeigten Werte mit ihren Einheiten ein.

Noch wird kein vollständiger Erzeugungsbefehl gezeigt.
