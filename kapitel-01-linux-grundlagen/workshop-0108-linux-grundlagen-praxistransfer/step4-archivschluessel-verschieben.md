# Wo gehört der Schlüssel hin?

Nachdem der erzeugende Vorgang beendet und seine Datei entfernt wurde, prüfst
du den Gesamtzustand erneut:

`./leuchtturm-stabilisieren`{{exec}}

Die neue Diagnose nennt den aktuellen Ort des Archivschlüssels und den
erwarteten Steuerungsbereich. Eine automatische Korrektur nimmt sie nicht
vor.

## Dokument statt Dateiname

Lies `archivschluessel.txt` an seinem aktuellen Ort vollständig. Achte dabei
besonders auf diese beiden Angaben:

- `DOKUMENTTYP` beschreibt die Funktion der Datei;
- `ZIELBEREICH` nennt den vorgesehenen Bereich im Archiv.

Der Inhalt ist damit die Begründung für die Zuordnung. Der Dateiname allein
reicht auch hier nicht als Entscheidung.

## Auftrag

> Ordne den Archivschlüssel dem im Dokument genannten Zielbereich zu.

Gehe dabei in dieser Reihenfolge vor:

1. Bestätige den aktuellen Fundort aus der Diagnose.
2. Lies den Schlüssel und ermittle seinen `ZIELBEREICH`.
3. Wähle den bekannten Befehl, der eine vorhandene Datei an einen anderen Ort
   verschiebt.
4. Verschiebe genau diese Datei in den begründeten Zielbereich.
5. Kontrolliere anschließend das Zielverzeichnis und prüfe, dass der
   Schlüssel dort genau einmal vorhanden ist.
6. Starte die Stabilisierung erneut und lies die nächste Diagnose vollständig.

<details>
<summary>Hinweis 1 – aktuellen Ort finden</summary>

Die Stabilisierung nennt unter „Aktueller Ort“ den relativen Pfad von
`archivschluessel.txt`. Du kannst denselben Ort mit den bekannten
Verzeichnisbefehlen kontrollieren.

</details>

<details>
<summary>Hinweis 2 – Zielbereich ermitteln</summary>

Lies die Datei am aktuellen Ort. Welche Angabe steht hinter
`ZIELBEREICH:`? Vergleiche sie mit den vorhandenen Archivverzeichnissen.

</details>

<details>
<summary>Hinweis 3 – passendes Werkzeug wählen</summary>

Du möchtest keine zweite Kopie erzeugen. Welcher bekannte Befehl verschiebt
eine Datei von ihrem bisherigen Ort an ein Ziel?

</details>

<details>
<summary>Hinweis 4 – vollständiger Ablauf</summary>

```bash
cat erinnerungen/archivschluessel.txt
mv erinnerungen/archivschluessel.txt steuerung/
ls steuerung
./leuchtturm-stabilisieren
```

Die Verzeichnisanzeige kontrolliert den neuen Ort. Die anschließende
Stabilisierung prüft die Zuordnung unabhängig davon erneut.

</details>

## Erkenntnis

Eine Datei ist nicht nur durch ihren Inhalt bestimmt. Auch ihr Ort kann Teil
der Systemkonfiguration sein.
