# Musterlösung – Linux-Serverressourcen untersuchen

Diese interne Datei darf nicht vor dem ersten selbstständigen Versuch sichtbar sein.

## 1. CPU

```bash
nproc
```

Schematische Ausgabe:

```text
<positive ganze Zahl>
```

Fachlich korrekt:

> Die Zahl bezeichnet die für die aktuelle Umgebung verfügbaren logischen Prozessoren.

Sie darf nicht automatisch als Zahl physischer Prozessorkerne bezeichnet werden.

## 2. RAM

```bash
free -h
```

Befehlsbestandteile:

```text
free    = Befehl
-h      = Option
```

`-h` ist die erste in diesem Kapitel eingeführte Option. Der Bindestrich gehört dazu. Die Option verändert hier die Darstellung der Größen und ist weder Variable noch Pfadargument.

Schematische Ausgabe:

```text
               total        used        free      shared  buff/cache   available
Mem:           <Wert>       <Wert>      <Wert>     <Wert>      <Wert>       <Wert>
Swap:          <Wert>       <Wert>      <Wert>
```

Aus der RAM-Zeile übernehmen:

- `total` für `RAM_GESAMT`;
- `available` für `RAM_VERFUEGBAR`.

`free` bezeichnet vollständig ungenutzten RAM. `available` schätzt, wie viel RAM für neue Anwendungen noch nutzbar ist. Swap wird nicht ausgewertet.

## 3. Root-Dateisystem

```bash
df -h /
```

Befehlsbestandteile:

```text
df      = Befehl
-h      = Option
/       = Argument
```

`/` ist der Root-Pfad und bezeichnet, auf welches Dateisystem sich die Abfrage bezieht.

Schematische Ausgabe:

```text
Filesystem      Size  Used Avail Use% Mounted on
<Bezeichnung>   <Wert> <Wert> <Wert> <Wert> /
```

Aus der Datenzeile für `/` übernehmen:

- `Used` für `DATEISYSTEM_BELEGT`;
- `Avail` für `DATEISYSTEM_VERFUEGBAR`.

## 4. Statusdatei erzeugen

Alle Platzhalter müssen durch die aktuellen Werte der Umgebung ersetzt werden:

```bash
echo CPU_LOGISCH=CPU_WERT_EINSETZEN RAM_GESAMT=RAM_TOTAL_EINSETZEN RAM_VERFUEGBAR=RAM_AVAILABLE_EINSETZEN DATEISYSTEM_BELEGT=DF_USED_EINSETZEN DATEISYSTEM_VERFUEGBAR=DF_AVAIL_EINSETZEN > /root/ressourcenlabor/serverstatus.txt
```

Kontrolle:

```bash
cat /root/ressourcenlabor/serverstatus.txt
```

## Grenzen des technischen CHECKs

Version 1.0.0 prüft verbindlich:

- Datei, Zeilenzahl, Schlüssel und Format;
- aktuellen `nproc`-Wert;
- Gesamt-RAM mit Rundungsintervallen;
- `RAM_VERFUEGBAR` nicht größer als `RAM_GESAMT`;
- Dateisystemwerte nicht offensichtlich größer als das Root-Dateisystem.

Nicht streng gegen aktuelle Momentwerte geprüft werden:

- `RAM_VERFUEGBAR`;
- `DATEISYSTEM_BELEGT`;
- `DATEISYSTEM_VERFUEGBAR`.

Die richtige Auswahl von `available`, `Used` und `Avail` sowie das Verständnis der Ressourcen bleiben formative Lernziele.
