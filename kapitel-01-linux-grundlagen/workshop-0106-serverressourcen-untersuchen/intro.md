# 01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?

Die schwere Eingangstür gibt nach. Draußen ist der Sturm noch stärker
geworden. Regen zieht fast waagerecht über den Deich, und über dem Meer liegt
dichter Nebel.

Erst jetzt siehst du den Leuchtturm von außen. Das Leuchtfeuer ist dunkel.

Weit draußen tauchen zwischen den Wellen die Positionslichter eines Schiffes
auf. Es hält auf die Küste zu.

Im Turm läuft noch Technik, doch das Leuchtfeuer reagiert nicht wie erwartet.
Aus dem Inneren dringt ein gleichmäßiges Brummen. Bevor du das Licht wieder
starten kannst, musst du herausfinden, was das System blockiert.

> Besitzt der Rechner zu wenig Ressourcen – oder verbraucht ein laufender
> Prozess mehr, als er sollte?

![Dunkler Leuchtturm im schweren Sturm; am Horizont nähert sich ein Schiff.](./assets/0106-einstieg-leuchtturm-dunkel.png)

### Am Ende kannst du

- CPU, RAM und Speicher grob voneinander unterscheiden,
- aktuelle Auslastung von vorhandener Kapazität unterscheiden,
- auffällige Prozesse in `top` und `ps` erkennen,
- Benutzer, Prozessname und PID prüfen,
- einen einzelnen Prozess kontrolliert beenden,
- das Leuchtfeuer wieder starten.

## Sicher arbeiten

> Beende niemals einen Prozess nur deshalb, weil sein Name unbekannt aussieht.
> Prüfe zuerst Benutzer, Namen und PID und kontrolliere danach das Ergebnis.
