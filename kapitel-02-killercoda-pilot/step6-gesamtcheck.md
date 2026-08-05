# Vollständiger Endzustand

## Interaktive Gesamtkette

`./pilot-werkzeuge/demo-gesamtkette`{{exec}}

Die Live-Ausgabe muss folgende Kette bestätigen:

```text
xebico
→ lokale Stationsadresse
→ xebico-dienst
→ TCP-Port 8080
→ Bind-Adresse 0.0.0.0
→ HTTP 200
→ X-Xebico-Status: EMPFANGEN
→ vollständiger Body
```

## Sichtbarer Plattformnachweis

[Abschlussmeldung über den Traffic-Pfad öffnen]({{TRAFFIC_HOST1_8080}})

## Finaler CHECK

Der CHECK prüft den technischen Endzustand direkt. Route und Browserlink sind keine automatischen Erfolgsbedingungen.
