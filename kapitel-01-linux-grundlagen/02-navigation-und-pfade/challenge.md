# Abschlussaufgabe: den Freigaberaum finden

Du befindest dich zu Beginn der Aufgabe im vorbereiteten `startpunkt`.

## Dein Ziel

Finde selbstständig den vorbereiteten `freigaberaum`.

Der vollständige Lösungspfad wird vor deinem ersten Versuch nicht angezeigt.

## Erlaubte Lernwerkzeuge

Du benötigst ausschließlich:

- `pwd` für deinen aktuellen Standort;
- `ls` für sichtbare Ziele;
- `cd` für den Verzeichniswechsel;
- Tab zur Vervollständigung eindeutiger Namen.

Erstelle oder verändere keine Dateien und Verzeichnisse.

## Vorgehen

1. Prüfe deinen Ausgangsort.
2. Untersuche die sichtbaren Verzeichnisse.
3. Entscheide, ob das gesuchte Gebiet innerhalb oder außerhalb des aktuellen Verzeichnisses liegt.
4. Navigiere schrittweise zum `freigaberaum`.
5. Prüfe dort deinen Standort mit `pwd`.

## Bereitgestellte technische Prüfaktion

Erst wenn du glaubst, den `freigaberaum` erreicht zu haben, führe diese bereitgestellte technische Lab-Aktion aus:

```text
ziel-bestaetigen
```

`ziel-bestaetigen` ist **kein neuer Linux-Lernbefehl**. Die Aktion prüft nur, ob sie aus dem richtigen Zielverzeichnis gestartet wurde. Nur dann bereitet sie den technischen CHECK vor.

Erwartete Erfolgsmeldung:

```text
Zielort bestätigt. Du kannst jetzt den CHECK ausführen.
```

Starte danach den CHECK.

## Hinweise

Öffne eine weitere Stufe erst, nachdem du mit der vorherigen Hilfe noch einmal selbst versucht hast, das Ziel zu erreichen.

<details>
<summary>Hinweis 1 – Konzept</summary>

Der gesuchte Bereich liegt nicht innerhalb von `startpunkt`. Bestimme zuerst deinen aktuellen Standort und untersuche, wie du eine Ebene höher gelangst.

</details>

<details>
<summary>Hinweis 2 – passende Werkzeuge</summary>

Nutze `pwd` für deinen Standort, `ls` für sichtbare Ziele und `cd ..`, um vom `startpunkt` in das übergeordnete Verzeichnis zu wechseln. Tab kann eindeutige Namen ergänzen.

</details>

<details>
<summary>Hinweis 3 – Struktur des Weges</summary>

Vom `startpunkt` führt der Weg zunächst über `..` in die Laborwurzel. Danach beginnt der relative Weg mit:

```text
../abschlussgebiet/kontrollzentrum/…
```

Der letzte Zielname fehlt noch.

</details>

<details>
<summary>Hinweis 4 – Musterlösung mit Erklärung</summary>

Eine vollständige gültige Lösung ist:

```text
cd ../abschlussgebiet/kontrollzentrum/freigaberaum
pwd
ziel-bestaetigen
```

`..` führt vom `startpunkt` zur Laborwurzel. Danach werden `abschlussgebiet`, `kontrollzentrum` und `freigaberaum` nacheinander betreten. `pwd` bestätigt den Zielort. Die bereitgestellte technische Prüfaktion erzeugt nur dort den neutralen Erfolgsmarker.

</details>
