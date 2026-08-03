# Ist die Konfiguration wirklich gültig?

Nano konnte die Datei speichern. Das beweist aber nur, dass Text geschrieben
wurde.

Eine Konfiguration kann gespeichert und trotzdem ungültig sein – zum Beispiel
durch einen Tippfehler oder eine fehlende Einstellung.

```text
gespeichert ≠ gültig ≠ angewendet
```

## Phase 1 – Sichtkontrolle

Lies zuerst den gespeicherten Inhalt:

`cat leuchtfeuer.conf`{{exec}}

Prüfe:

- Steht `ROTATION` auf dem erwarteten Wert?
- Sind Geschwindigkeit und Bereich unverändert?
- Enthält die Datei keine versehentlichen zusätzlichen Zeichen?

## Phase 2 – Validierung

Führe anschließend das vorbereitete Prüfwerkzeug aus:

`./konfiguration-pruefen`{{exec}}

Das Werkzeug liest die Konfiguration und kontrolliert Schlüssel, Werte und
Format. Es verändert weder die Datei noch den angewendeten Zustand.

Bei einer gültigen Datei erscheint zuerst:

```text
Konfiguration ist gültig.
```

## Drei verschiedene Zustände

> **Gespeichert:** Der Text steht in der Datei.
>
> **Gültig:** Alle erwarteten Einstellungen und Werte werden akzeptiert.
>
> **Angewendet:** Die laufende Steuerung verwendet die neuen Werte.

## Reparaturschleife

```text
Fehlermeldung lesen
→ Nano erneut öffnen
→ betroffene Zeile korrigieren
→ speichern
→ erneut prüfen
```

<details>
<summary>Hinweis 1 – Sichtkontrolle</summary>

Nutze `cat leuchtfeuer.conf`, um den tatsächlich gespeicherten Text noch
einmal vollständig zu lesen.

</details>

<details>
<summary>Hinweis 2 – Prüfung starten</summary>

Das vorbereitete Werkzeug startest du im aktuellen Verzeichnis mit:

```bash
./konfiguration-pruefen
```

</details>

<details>
<summary>Hinweis 3 – Prüfung meldet einen Fehler</summary>

Lies die konkrete Meldung vollständig. Sie nennt entweder einen betroffenen
Schlüssel, einen nicht zulässigen Wert oder eine fehlerhafte Zeile im Format
`SCHLUESSEL=WERT`.

Öffne danach nur die betroffene Stelle erneut mit Nano, korrigiere sie und
wiederhole Sichtkontrolle und Prüfung.

</details>

<details>
<summary>Vollständiger Ablauf</summary>

```bash
cat leuchtfeuer.conf
./konfiguration-pruefen
```

Falls die Prüfung einen Fehler meldet:

```bash
nano leuchtfeuer.conf
cat leuchtfeuer.conf
./konfiguration-pruefen
```

</details>

## Abschluss

Die Datei ist nun gespeichert und gültig. Die laufende Lichtsteuerung
verwendet jedoch möglicherweise noch den alten Zustand.
