# Schritt 2: Ausführbarkeit beobachten

Die Datei `ohne-ausfuehrungsrecht` besitzt technischen Inhalt. Im Besitzerbereich fehlt jedoch das `x`.

## Eine Datei aus dem aktuellen Verzeichnis angeben

Vor der ersten Ausführung zerlegen wir die Form:

```text
./                         ohne-ausfuehrungsrecht
aktuelles Verzeichnis      Dateiname
```

- `.` bezeichnet das bekannte aktuelle Verzeichnis.
- `/` trennt Pfadbestandteile.
- `./dateiname` ist ein relativer Pfad zur Datei.
- Die Shell versucht, diese Datei auszuführen.
- `./` verändert keine Rechte.
- `./` gehört nicht zum eigentlichen Dateinamen.
- Der Punkt wird hier nicht als anderer Befehl verwendet.

Andere Ausführungsformen und Suchpfade sind nicht Bestandteil dieses Workshops.

## Vorhersage

> Wird die Datei bereits ausgeführt, obwohl im Besitzerbereich kein `x` steht?

Gib den folgenden Befehl selbst ein:

```bash
./ohne-ausfuehrungsrecht
```

## Erwartete Beobachtung

Die Ausführung wird abgelehnt. Der genaue deutsche oder englische Wortlaut der Fehlermeldung ist nicht wichtig.

Wichtig ist:

- Der Fehler ist beabsichtigt.
- Die Datei bleibt vorhanden.
- Dateiinhalt und Rechte bleiben unverändert.
- Die Shell bleibt benutzbar.
- Die Datei ist nicht beschädigt.
- Der fehlende Zustand ist das Ausführungsrecht.

Die Datei muss nicht neu geschrieben werden. Die Ausführung wird auch nicht über eine andere Shell umgangen. Stattdessen wird genau das benötigte Recht ergänzt.

## Wirkungskette

```text
vorbereitete Datei
        ↓
Besitzer-Ausführungsrecht fehlt
        ↓
./dateiname wird abgelehnt
```
