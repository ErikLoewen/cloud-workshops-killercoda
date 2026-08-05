# Kapitel 02 – Killercoda-Technikpilot V3

## Behobene Fehler

### Assets

Killercoda sucht die in `details.assets.host01` referenzierten Dateien im
Szenario-Unterordner `assets/`.

V3 enthält daher:

```text
assets/
├── kapitel-02-killercoda-runtime.tar.gz
├── killercoda-entry.sh
└── killercoda-wait.sh
```

Die Dateien werden nach `/tmp` hochgeladen. Background und Foreground
verwenden anschließend ausschließlich absolute Pfade.

### HTML, CSS und JavaScript

Der echte Frontend-Test zeigte:

- HTML-Inhalt wird teilweise dargestellt;
- `<style>` wird entfernt;
- `<script>` wird nicht ausgeführt;
- das `iframe` ist nicht zuverlässig verwendbar.

V3 verwendet deshalb:

- native `<details>`-Interaktionen im Markdown;
- Killercoda-Codeaktionen;
- eine eigenständige lokale HTML/CSS/JavaScript-App unter
  `{{TRAFFIC_HOST1_8080}}/architektur`.

Damit bleiben die Demonstrationen interaktiv und bildfrei, ohne
unsichere Inline-Skriptausführung vorauszusetzen.
