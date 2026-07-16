# Prozess finden und kontrolliert beenden

## 1. Eine einfache Prozessübersicht mit `ps`

`ps` zeigt eine einfache Übersicht laufender Prozesse.

Wir benötigen den Befehl, um den vorbereiteten Prozess `lab-worker` in der Ausgabe zu beobachten. Für diese Aufgabe sind nur relevant:

- `PID`: die momentane numerische Prozesskennung;
- der sichtbare Prozessname;
- die Zeile mit `lab-worker`.

TTY, Laufzeit und weitere Angaben werden nicht systematisch ausgewertet.

Gib selbst ein:

`ps`{{}}

Erwartet wird eine Zeile ähnlich dieser:

```text
  PID TTY          TIME CMD
 4281 pts/0    00:00:00 lab-worker
```

Die Zahl `4281` ist nur ein Beispiel. Deine PID kann anders sein.

**Beobachtungsfrage:** Welche PID und welcher Prozessname stehen in deiner `lab-worker`-Zeile?

> Veröffentlichungshinweis für die technische Erprobung: Das einfache `ps` muss in einer realen Killercoda-Umgebung zuverlässig genau diesen Hintergrundprozess zeigen. Eine Option darf nicht stillschweigend ergänzt werden.

## 2. Den Prozess gezielt mit `pgrep` finden

`pgrep` sucht gezielt nach einem Prozessnamen.

- `pgrep` ist der Befehl.
- `lab-worker` ist das Suchargument.
- Als Ausgabe erwartest du die momentane PID des passenden Prozesses.

Gib selbst ein:

`pgrep lab-worker`{{}}

Erwartete Form:

```text
4281
```

Eine PID kennzeichnet genau diese laufende Instanz in diesem Moment. Nach einem neuen Start kann `lab-worker` eine andere PID erhalten.

## 3. Die tatsächliche PID in `kill` einsetzen

`kill` sendet dem angegebenen Prozess in dieser Übung die normale Aufforderung, sich zu beenden.

Die Befehlsform lautet:

`kill PID`{{}}

Dabei ist `PID` nur ein erklärter Platzhalter. Tippe nicht das Wort `PID`. Setze stattdessen die Zahl ein, die `pgrep lab-worker` gerade bei dir ausgegeben hat.

Beispiel: Nur falls deine aktuelle Ausgabe tatsächlich `4281` lautet, wäre die Eingabe `kill 4281`.

Bei Erfolg erscheint häufig keine Ausgabe.

## 4. Das Prozessende kontrollieren

Gib danach erneut selbst ein:

`pgrep lab-worker`{{}}

Wenn keine PID mehr erscheint, ist das hier das erwartete Ergebnis:

> Der gesuchte Prozess läuft nicht mehr.

Falls unmittelbar noch eine PID erscheint, rufe denselben Suchbefehl mit der Pfeiltaste nach oben erneut auf und führe ihn noch einmal aus.

## Prozess-Teilcheck

Starte jetzt den CHECK dieses Schritts.

Der technische Teilcheck prüft ausschließlich:

- `lab-worker` wurde in dieser Szenariositzung mindestens einmal gestartet;
- keine eigene `lab-worker`-Instanz läuft mehr.

Er kann nicht nachweisen, dass du `&`, `ps`, `pgrep` oder `kill` verwendet oder die PID selbstständig abgelesen hast. Diese Handlungen werden durch deine Ausführung und Erklärung gelernt und beobachtet.
