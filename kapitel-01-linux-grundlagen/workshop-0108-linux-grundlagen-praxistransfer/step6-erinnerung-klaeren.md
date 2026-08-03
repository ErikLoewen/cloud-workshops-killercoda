# Wie wird die Erinnerung klar?

Du hast die Nachricht aus der dokumentierten Quelle identifiziert. Sie nennt
den Pfad der Steuerungsdatei und den stabilen Zielwert:

```text
ERINNERUNG=klar
```

Wende jetzt den sicheren Konfigurationsablauf aus Workshop 7 selbstständig
an. Die einzelnen Werkzeuge sind bekannt; entscheidend ist ihre begründete
Reihenfolge:

```text
lesen
→ sichern
→ ändern
→ prüfen
→ anwenden beziehungsweise stabilisieren
→ kontrollieren
```

Die finale Stabilisierung erfolgt erst in der anschließenden Challenge. In
diesem Schritt bearbeitest und prüfst du ausschließlich die Konfiguration.

## Lesen und sichern

Lies zuerst den aktuellen Inhalt von `steuerung/archiv.conf`. Lege danach
eine Sicherung des beobachteten Ausgangszustands an:

```bash
cp steuerung/archiv.conf steuerung/archiv.conf.bak
```

Kontrolliere, dass Original und Sicherung vorhanden sind, bevor du das
Original bearbeitest.

## Gezielt bearbeiten

Öffne die aktive Konfiguration mit Nano:

```bash
nano steuerung/archiv.conf
```

Ändere ausschließlich den Wert der vorhandenen Zeile `ERINNERUNG`. Übernimm
den Zielwert exakt aus der zuvor geprüften Nachricht. Kommentare und die
Schreibweise des Schlüssels bleiben erhalten.

Speichere die Datei und schließe Nano. Die Bedienung wird hier nicht erneut
ausführlich eingeführt; eine Kurzerinnerung findest du bei Bedarf im letzten
Dropdown.

## Kontrollieren und prüfen

Zeige zuerst den tatsächlich gespeicherten Inhalt an:

```bash
cat steuerung/archiv.conf
```

Prüfe die Datei danach mit dem vorgesehenen Werkzeug:

```bash
./steuerung/archiv-pruefen
```

Nur eine syntaktisch gültige und fachlich stabile Konfiguration besteht diese
Prüfung. Bei einem anderen bekannten Wert verweist das Werkzeug zurück auf
die widersprüchlichen Nachrichten und ihre Quellen. Korrigiere dann nicht
nach Vermutung, sondern überprüfe erneut deine Auswahl aus Step 5.

<details>
<summary>Hinweis 1 – sichere Reihenfolge</summary>

Lies zuerst das Original. Erzeuge danach eine Sicherung, kontrolliere beide
Dateien und öffne erst dann die aktive Konfiguration zur Bearbeitung. Nach dem
Speichern folgen Inhaltskontrolle und technische Prüfung.

</details>

<details>
<summary>Hinweis 2 – Änderungsumfang</summary>

Bearbeitet wird `steuerung/archiv.conf`, nicht die Sicherung. Es gibt genau
einen erlaubten Schlüssel. Ändere nur dessen Wert und füge keine weitere
Konfigurationszeile hinzu.

</details>

<details>
<summary>Hinweis 3 – vollständiger Ablauf</summary>

```bash
cat steuerung/archiv.conf
cp steuerung/archiv.conf steuerung/archiv.conf.bak
ls -l steuerung/archiv.conf steuerung/archiv.conf.bak
nano steuerung/archiv.conf
cat steuerung/archiv.conf
./steuerung/archiv-pruefen
```

Im Editor setzt du den Wert ein, den du aus der Nachricht mit der geprüften
Quelle notiert hast.

</details>

<details>
<summary>Hinweis 4 – Nano-Kurzhilfe</summary>

Nach der gezielten Änderung:

1. `Strg+O` speichert.
2. `Enter` bestätigt den angezeigten Dateinamen.
3. `Strg+X` beendet Nano.

Kontrolliere anschließend mit `cat`, was tatsächlich gespeichert wurde, und
führe danach `./steuerung/archiv-pruefen` aus.

</details>

## Erkenntnis

Eine Konfigurationsänderung ist erst belastbar, wenn der alte Zustand
gesichert, der neue Inhalt sichtbar kontrolliert und durch das vorgesehene
Prüfwerkzeug bestätigt wurde.

Die Konfiguration ist jetzt für die finale Stabilisierung vorbereitet. Führe
diese erst in der Challenge aus.
