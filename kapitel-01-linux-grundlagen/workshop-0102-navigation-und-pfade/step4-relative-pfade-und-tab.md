# Relative Pfade und Tab-Vervollständigung

Ein relativer Pfad wird vom aktuellen Verzeichnis aus gelesen. Deshalb ist dein Ausgangspunkt entscheidend.

## Das aktuelle Verzeichnis `.`

`.` bezeichnet das aktuelle Verzeichnis.

Gib ein:

```text
cd .
```

Prüfe anschließend:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/startpunkt
```

Der Standort bleibt gleich.

## Das übergeordnete Verzeichnis `..`

`..` bezeichnet genau eine Ebene oberhalb des aktuellen Verzeichnisses.

Sage vorher voraus, welchen Pfad du nach dem nächsten Wechsel erwartest. Gib dann ein:

```text
cd ..
```

Prüfe anschließend:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor
```

Wechsle relativ wieder in den Startpunkt:

```text
cd ./startpunkt
```

Prüfe:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/startpunkt
```

## Derselbe Zielort auf einem anderen Weg

Den `zielraum` hast du bereits über einen absoluten Pfad erreicht. Nutze jetzt vom `startpunkt` aus einen relativen Pfad:

```text
cd ../lernstrecke/./zielraum
```

Prüfe:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/lernstrecke/zielraum
```

Dabei bedeutet:

- `..` – eine Ebene nach oben;
- `lernstrecke` – von dort in dieses Verzeichnis;
- `.` – an dieser Stelle das aktuelle Verzeichnis;
- `zielraum` – weiter zum Ziel.

## Tab-Vervollständigung

Tab ergänzt einen begonnenen Namen oder Pfadabschnitt, wenn die Eingabe eindeutig ist.

Tab **führt den Befehl nicht aus**. Erst Enter führt die vervollständigte Eingabe aus.

Wechsle zuerst zur Laborwurzel:

```text
cd ~/navigation-labor
```

Prüfe:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor
```

Stelle nun die nächste Eingabe schrittweise selbst her:

1. Tippe `cd u`.
2. Drücke Tab. Erwartet wird `cd uebungszone/`.
3. Tippe `n`.
4. Drücke Tab. Erwartet wird `cd uebungszone/nordfluegel/`.
5. Tippe `k`.
6. Drücke Tab. Erwartet wird `cd uebungszone/nordfluegel/kartenraum/`.
7. Drücke erst jetzt Enter.

Prüfe anschließend:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/uebungszone/nordfluegel/kartenraum
```

## Beobachtung

- Was hat Tab an der Eingabe verändert?
- Was geschah erst nach Enter?
- Warum kann Tab Tippfehler reduzieren?
