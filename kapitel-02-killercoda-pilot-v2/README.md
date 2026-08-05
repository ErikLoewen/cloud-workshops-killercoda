# Kapitel 02 – Killercoda-Technikpilot V2

## Behobener Startfehler

Killercoda führt `foreground`- und `background`-Dateien als
Shellfragmente aus. Die alte Version nahm fälschlich an, `setup.sh`
liege dabei als echte Datei neben `dienst/` und `interne-skripte/`.

V2 verwendet stattdessen `details.assets.host01`:

1. Das Runtime-Archiv wird nach `/tmp` hochgeladen.
2. Ein absolut aufgerufenes Einstiegsskript entpackt es.
3. Das echte `runtime/setup.sh` läuft anschließend aus einem realen
   Quellverzeichnis unter `/opt/labforge`.
4. Das Foreground zeigt nur einen kurzen Bereitschaftsstatus.

## Interaktive Netzwerkarchitektur

Der erste Schritt prüft zwei Varianten:

- Inline-HTML/CSS/JavaScript direkt im Markdown;
- eine interaktive HTML/CSS/JavaScript-Seite vom lokalen
  `/architektur`-Endpunkt, versuchsweise per `iframe` eingebettet.

Ein Link-Fallback öffnet dieselbe interaktive Seite über
`{{TRAFFIC_HOST1_8080}}/architektur`.

Ein blockiertes Inline-Skript oder `iframe` ist kein Setupfehler,
sondern ein zu dokumentierender Plattformbefund.

## Lokale Prüfung

```bash
./validate-package.sh
./test-local.sh
```

Die lokale Prüfung kann die Sanitizing- und CSP-Regeln des echten
Killercoda-Frontends nicht simulieren.
