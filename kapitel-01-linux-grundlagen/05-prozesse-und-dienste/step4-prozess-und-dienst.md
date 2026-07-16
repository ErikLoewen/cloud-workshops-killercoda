# Prozess und Dienst unterscheiden

Der Prozessteil ist abgeschlossen. Nun folgt ein anderes Verwaltungsmodell.

## Prozess

Ein **Prozess** ist eine aktuell laufende Instanz eines Programms.

- Er besitzt einen sichtbaren Prozessnamen.
- Eine PID kennzeichnet genau diese laufende Instanz.
- Nach einem neuen Start kann eine andere PID vergeben werden.

## Dienst und Service-Unit

Ein **Dienst** ist eine vom System verwaltete Funktion oder Anwendung. Ein Dienst kann einen Prozess starten und überwachen.

Eine **Service-Unit** beschreibt, wie dieser Dienst verwaltet wird. In diesem Workshop betrachtest du ausschließlich diese isolierte Service-Unit:

`lab-demo.service`

Der Unit-Name ist keine PID.

Nach einem neuen Start des Dienstes kann sein zugehöriger Prozess eine andere PID besitzen. Der Unit-Name `lab-demo.service` bleibt trotzdem gleich.

## Einfaches Modell

```text
Programm lab-worker
        └── laufender Prozess
            ├── Name: lab-worker
            └── momentane PID

Service-Unit lab-demo.service
        └── von systemd verwalteter Dienst
            └── zugehöriger Prozess mit momentaner PID
```

## Ordne zu

Welche Kennung ist stabil, und welche kann sich nach einem neuen Start ändern?

- `lab-demo.service`
- die PID des zugehörigen Prozesses

## Erkläre

Warum steuern wir den Dienst über seinen Unit-Namen und nicht über eine ungeprüft wiederverwendete alte PID?
