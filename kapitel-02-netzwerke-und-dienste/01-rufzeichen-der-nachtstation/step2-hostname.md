# Das Rufzeichen anzeigen: `hostname`

Der **Hostname** ist der lokale Name eines Hosts. In dieser Station ist er das technische Rufzeichen des Systems.

## Neuer Befehl

`hostname` beantwortet vier Fragen:

1. **Was macht der Befehl?**  
   Er zeigt den aktuell verwendeten Hostnamen an.
2. **Warum brauchen wir ihn?**  
   Das beschädigte Protokoll benötigt den wirklichen Namen dieser Sitzung.
3. **Welche Ausgabe erwarten wir?**  
   Eine kurze Textzeile mit dem Hostnamen.
4. **Welche Fehlinterpretation ist typisch?**  
   Der Prompt enthält ebenfalls einen Namen. Für das Protokoll zählt die Ausgabe des Befehls, nicht die gesamte Promptzeile.

## Vormachen und beobachten

`hostname`{{exec}}

Lies ausschließlich die neue Ausgabezeile unter dem Befehl.

## Gemeinsam ins Protokoll übertragen

Öffne das Protokoll:

`nano stationsprotokoll.txt`{{exec}}

Trage die Ausgabe hinter `Hostname:` ein. Speichere und beende Nano.

<details>
<summary>Hilfe: Welcher Text gehört in das Feld?</summary>

Führe `hostname` erneut aus. Übernimm genau die einzelne Ausgabezeile. Prompt, `$` und den Befehl selbst trägst du nicht ein.

</details>

## Kurze Abruffrage

Welcher Befehl zeigt den lokalen Namen der aktuellen Station?
