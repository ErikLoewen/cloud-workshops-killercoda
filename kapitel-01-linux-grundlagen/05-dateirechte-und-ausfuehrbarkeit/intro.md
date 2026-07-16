# Dateirechte und Ausführbarkeit verstehen

In diesem Workshop untersuchst du vorbereitete Dateien. Du schreibst und veränderst ihre technischen Anweisungen nicht. Im Mittelpunkt stehen ausschließlich ihre Rechte und ihre direkte Ausführbarkeit.

## Ziel

Am Ende kannst du:

- eine Rechteanzeige lesen;
- Lesen, Schreiben und Ausführen unterscheiden;
- Besitzer, Gruppe und andere als drei Rechtebereiche erkennen;
- nur das benötigte Ausführungsrecht des Besitzers ergänzen;
- eine vorbereitete Datei über einen relativen Pfad ausführen;
- dieses Besitzer-Ausführungsrecht wieder entfernen;
- Arbeitsbereich und Schutzbereich sicher auseinanderhalten.

## Das Wirkungsmodell

```text
Dateiinhalt
    +
Dateirechte
    ↓
bestimmen gemeinsam, welche Handlung mit der Datei möglich ist
```

Eine Datei kann Inhalt besitzen, ohne direkt ausführbar zu sein. Dateiinhalt und Dateirechte sind unterschiedliche Eigenschaften.

## Laborbereiche

```text
/root/rechtelabor/
├── demo/
│   ├── ohne-ausfuehrungsrecht
│   └── bereits-ausfuehrbar
│
└── auftrag/
    ├── arbeitsbereich/
    │   └── pruefdatei
    │
    └── schutzbereich/
        └── wichtig.txt
```

Im Demo-Bereich beobachtest du die Wirkung von Rechten. In der Abschlussaufgabe darfst du nur die Rechte der freigegebenen Datei im Arbeitsbereich ändern.

> **Sicherheitsprinzip:** Ergänze nur das Recht, das für die konkrete Aufgabe benötigt wird, und nur für den vorgesehenen Rechtebereich.

Der Schutzbereich muss vollständig unverändert bleiben.

## Vorwissen

Du verwendest bereits bekannte Befehle für Standort, Navigation und Dateianzeige. Neu sind eine ausführliche Listenansicht, eine gezielte symbolische Rechteänderung und die direkte Ausführung einer Datei aus dem aktuellen Verzeichnis.

Die vorbereiteten Dateien erzeugen bei ihrer Ausführung eine sichtbare Ausgabe. Die Auftragsdatei erzeugt zusätzlich einen internen technischen Nachweis. Dieser Nachweis ist kein eigener Lerninhalt.

**Planzeit:** etwa 32–38 Minuten für geübte Teilnehmende und 42–48 Minuten für absolute Anfänger.
