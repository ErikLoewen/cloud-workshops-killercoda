# Kapitel 02 – Killercoda-Technikpilot V2

Diese Version korrigiert den Startmechanismus des ersten Piloten.

Die Runtime-Dateien werden über das offizielle Killercoda-Assetmodell
auf Host 1 hochgeladen. Ein Hintergrundskript entpackt und installiert
sie. Im Terminal läuft nur ein kurzer Vordergrund-Warter.

Zusätzlich prüft der erste Schritt vier Darstellungswege:

- Inline-HTML;
- CSS im Markdown;
- JavaScript im Markdown;
- eine eingebettete HTML/CSS/JS-Netzwerkarchitektur per `iframe`.

Da Killercoda beliebiges CSS, JavaScript und `iframe` nicht offiziell
zusichert, werden auch blockierte Ergebnisse als gültiger Pilotbefund
dokumentiert. Der Link-Fallback zur interaktiven Demo bleibt verfügbar.
