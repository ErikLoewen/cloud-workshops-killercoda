# Wie änderst du genau eine Einstellung?

Die Sicherung liegt bereit. Die Wartungsanleitung hat gezeigt, welcher Wert
einen normalen Rundlauf erzeugt.

Jetzt änderst du nur die fehlerhafte Rotation. Geschwindigkeit und Bereich
bleiben unverändert.

## Auftrag

Öffne `leuchtfeuer.conf` mit Nano.

Ändere ausschließlich die Einstellung für die Rotation, sodass sich der
Lichtstrahl gleichmäßig um den Turm bewegt.

Speichere die Datei unter demselben Namen und verlasse Nano.

<details>
<summary>Hinweis 1 – Betroffene Einstellung</summary>

Die Bewegung des Lichtstrahls wird durch `ROTATION` gesteuert. Suche diese
Zeile, ohne die beiden anderen Einstellungen zu verändern.

</details>

<details>
<summary>Hinweis 2 – Zulässiger Zielwert</summary>

Die Wartungsanleitung beschreibt `kreis` als gleichmäßigen Rundlauf.

</details>

<details>
<summary>Hinweis 3 – Speichern und schließen</summary>

1. Speichere mit `Strg+O`.
2. Bestätige den angezeigten Dateinamen mit `Enter`.
3. Verlasse Nano mit `Strg+X`.

</details>

<details>
<summary>Vollständiger Ablauf</summary>

Öffne die Datei:

```bash
nano leuchtfeuer.conf
```

Suche die Zeile mit `ROTATION`. Ersetze dort nur den bisherigen Wert durch
`kreis`. Speichere mit `Strg+O`, bestätige den Dateinamen mit `Enter` und
verlasse Nano mit `Strg+X`.

</details>

## Zwischenstand

Die bearbeitete Datei ist gespeichert. Ob ihr Inhalt technisch gültig ist,
wird erst im nächsten Schritt kontrolliert.
