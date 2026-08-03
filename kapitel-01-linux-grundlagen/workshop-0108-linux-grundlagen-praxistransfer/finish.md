# Der Wärter

Die schwarzen und weißen Schlieren ziehen sich zurück. Die unmöglichen Farben
verlieren ihre Form und verschwinden aus den Wänden. Entfernungen stimmen
wieder überein, Türen führen in jeweils einen Raum und die Teile des Archivs
ordnen sich zu einer eindeutigen Struktur.

Der Regen fällt wieder nur außerhalb des Turms.

Der Leuchtturm steht fest. Nicht alles wirkt deshalb gewöhnlich, aber die
Erinnerung bleibt klar genug für den Identitätsabgleich.

![Der stabilisierte, aber weiterhin unwirkliche Leuchtturm; eine einzelne Figur erkennt sich schemenhaft in der reflektierenden Scheibe des Laternenraums.](./assets/0108-abschluss-identitaet.png)

## Identitätsabgleich

Die Kennung der aktiven Sitzung lautet weiterhin `waerter`. Du hast sie seit
dem ersten Prompt gesehen, bei der Prozessprüfung bestätigt und mit dem
Besitzer der gültigen Nachricht verglichen.

Erst jetzt erhält sie eine andere Bedeutung.

> Du hast den Wärter nicht gesucht.
>
> Du hast versucht, dich zu erinnern.

Der Abgleich beantwortet nicht, ob du tatsächlich dieselbe Person bist, die
den Leuchtturm zuvor bedient hat. Vielleicht bezeichnet `waerter` nur eine
Rolle. Vielleicht überschreibt der Leuchtturm Erinnerungen. Vielleicht ist
dieser Ablauf schon einmal geschehen und beginnt später erneut.

Der stabilisierte Zustand macht diese Möglichkeiten unterscheidbar. Er
entscheidet nicht, welche davon wahr ist.

## Was du technisch getan hast

Du hast:

- einen dokumentierten Sollzustand mit dem beobachteten Istzustand verglichen,
- Fehlermeldungen als schrittweise Diagnose verwendet,
- bestätigte Dateien und Verzeichnisse kontrolliert gelöscht,
- eine wiederkehrende Datei auf einen laufenden Prozess zurückgeführt,
- Prozessausgaben mit einer Pipe und `grep` gefiltert,
- Benutzer, PID und Prozessnamen vor dem Eingriff geprüft,
- den eindeutig identifizierten Prozess kontrolliert beendet,
- eine Datei anhand ihres dokumentierten Zielbereichs verschoben,
- Dateibesitzer als Metadaten verglichen,
- eine Konfiguration gelesen, gesichert und gezielt bearbeitet,
- den Gesamtzustand nach den Änderungen erneut validiert.

Dabei war kein einzelner Befehl die vollständige Lösung. Entscheidend war die
Reihenfolge aus Beobachten, Begründen, Handeln und Kontrollieren.

## Kapitelabschluss

> Du hast nicht nur einzelne Befehle ausgeführt. Du hast Zustände untersucht,
> Ursachen voneinander getrennt und bekannte Werkzeuge passend zum Problem
> ausgewählt.

Damit ist das Kapitel „Linux-Grundlagen“ abgeschlossen. Die verwendeten
Werkzeuge bilden die Grundlage für umfangreichere Aufgaben, bei denen mehrere
Systembereiche gleichzeitig verstanden und sicher verändert werden müssen.

## Ausblick

Auf diesem Arbeitsprinzip können spätere Kapitel aufbauen, zum Beispiel bei:

- systematischer Administration,
- Netzwerken,
- Servern,
- Containern,
- Cloud-Systemen,
- Incident Response.

Welche konkrete Aufgabe als Nächstes wartet, bleibt offen. Der grundlegende
Ablauf bleibt derselbe: erst einen überprüfbaren Zustand herstellen, dann die
Ursache eingrenzen und gezielt handeln.
