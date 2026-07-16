# Wurzel, Home und absolute Pfade

Ein Pfad beschreibt einen Weg zu einem Verzeichnis. Jetzt vergleichst du zwei wichtige Ausgangspunkte und verwendest einen vollständigen absoluten Pfad.

## Das Wurzelverzeichnis `/`

`/` allein bezeichnet das oberste Verzeichnis des Baums.

Gib ein:

```text
cd /
```

Prüfe anschließend:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/
```

Beginnt ein ausgeschriebener Pfad mit `/`, wird er vom Wurzelverzeichnis aus gelesen.

## Das Home-Verzeichnis `~`

`~` ist eine Kurzform für dein Home-Verzeichnis. In diesem Lab ist dafür `/root` vorgesehen.

Gib ein:

```text
cd ~
```

Prüfe anschließend:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root
```

`/` und `~` sind nicht dasselbe:

- `/` bezeichnet das oberste Verzeichnis;
- `~` führt zum Home-Verzeichnis des aktuellen Benutzers.

## Ein absoluter Pfad

Ein ausgeschriebener absoluter Pfad beginnt mit `/` und beschreibt den Weg vom Wurzelverzeichnis aus.

Wechsle direkt zum vorbereiteten Zielraum:

```text
cd /root/navigation-labor/lernstrecke/zielraum
```

Prüfe anschließend:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/lernstrecke/zielraum
```

Lies den Pfad von links nach rechts:

1. `/` – Start am Wurzelverzeichnis;
2. `root`;
3. `navigation-labor`;
4. `lernstrecke`;
5. `zielraum`.

## Erklärungsfrage

Warum kann dieser absolute Pfad unabhängig davon funktionieren, in welchem Verzeichnis du vorher warst?

## Kurzer Vergleich

Wechsle zurück zum vorbereiteten Startpunkt:

```text
cd ~/navigation-labor/startpunkt
```

Prüfe den Standort:

```text
pwd
```

**Erwartete Ausgabe:**

```text
/root/navigation-labor/startpunkt
```
