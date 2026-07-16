# Schritt 1: Im Dateilabor orientieren

## Ziel

Du rufst bekannte Navigationshandlungen ab und untersuchst den vorbereiteten Ausgangszustand.

## Vorhersage

Welche Elemente des Zielbildes sind Verzeichnisse? Welche Elemente sind Dateien?

## Standort prüfen

Tippe den bekannten Befehl selbst ein:

```bash
pwd
```

**Erwartete Ausgabe bei der angenommenen Killercoda-Startlage:**

```text
/root
```

Falls ein anderer Pfad erscheint, ist das zunächst kein Fehler. Der nächste Wechsel verwendet einen absoluten Pfad.

## Vorbereiteten Bereich ansehen

Tippe:

```bash
ls
```

Wechsle danach in den leeren Übungsbereich:

```bash
cd /root/dateilabor/uebung
```

Prüfe deinen neuen Standort:

```bash
pwd
```

**Erwartete Ausgabe:**

```text
/root/dateilabor/uebung
```

Untersuche den Inhalt:

```bash
ls
```

**Erwartete Beobachtung:**

Es werden keine Datei- oder Verzeichnisnamen angezeigt. Das Verzeichnis `uebung` ist zu Beginn leer.

## Pfadfrage

Angenommen, dein aktueller Standort ist `/root/dateilabor/uebung`: An welchem vollständigen Pfad würde ein Objekt mit dem relativen Namen `notiz.txt` liegen?

<details>
<summary>Antwort prüfen</summary>

```text
/root/dateilabor/uebung/notiz.txt
```

Ein relativer Pfad wird vom aktuellen Arbeitsverzeichnis aus ausgewertet.

</details>
