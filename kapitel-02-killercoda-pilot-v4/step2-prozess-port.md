# Prozessname und TCP-Ports

## Live-Karte statt Prozessgrafik

`./pilot-werkzeuge/demo-prozess-socket`{{exec}}

Die Ausgabe verbindet die aktuelle PID mit Prozessname, Bind-Adresse und TCP-Port.

## Kontrollierten Fehlerport testen

`./pilot-werkzeuge/port-8081-testen`{{exec}}

Prüfe anschließend die Listenerzeile:

`ss -ltnp | grep xebico-dienst`{{exec}}

Erwartet wird Port `8081`.

## Sollport wiederherstellen

`./pilot-werkzeuge/port-8080-wiederherstellen`{{exec}}

`ss -ltnp | grep xebico-dienst`{{exec}}

Der CHECK prüft zusätzlich, ob `ss -ltnp` den Prozessnamen und die PID auch für `telegrafist` sichtbar macht.
