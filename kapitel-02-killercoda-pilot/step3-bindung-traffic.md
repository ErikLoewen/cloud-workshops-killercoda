# Bind-Adresse und Traffic-Pfad

## Loopback-Zustand herstellen

`./pilot-werkzeuge/bindung-loopback-testen`{{exec}}

`ss -ltnp | grep xebico-dienst`{{exec}}

Öffne nun den Traffic-Link. Bei reiner Loopback-Bindung soll die Xebico-Seite **nicht** erscheinen:

[Traffic-Test auf Port 8080]({{TRAFFIC_HOST1_8080}})

Der konkrete Browserfehler ist kein Prüfkriterium.

## Wildcard-Bindung herstellen

`./pilot-werkzeuge/bindung-alle-testen`{{exec}}

`ss -ltnp | grep xebico-dienst`{{exec}}

Lade denselben Link erneut:

[Traffic-Test auf Port 8080 erneut öffnen]({{TRAFFIC_HOST1_8080}})

Jetzt soll der Klartext des Dienstes erscheinen.

Der automatische CHECK prüft Bindung und lokale Stationsadresse. Die Browserinteraktion bleibt ein zusätzlicher manueller Plattformnachweis.
