# Schritt 3: Dateisystemspeicher untersuchen

RAM ist nicht der Speicherplatz für Dateien.

- RAM dient laufenden Programmen als kurzfristiger Arbeitsspeicher.
- Dateien liegen auf einem Dateisystem beziehungsweise persistenten Speicher.
- Ein voller Datenträger ist daher nicht dasselbe wie knapper RAM.

## Das Befehlsmodell wird erweitert

Bei `free -h` hast du erstmals diese Form verwendet:

```text
Befehl + Option
```

Jetzt kommt ein Argument hinzu:

```text
Befehl + Option + Argument
```

Am konkreten Beispiel gilt:

```text
df      = Befehl
-h      = Option
/       = Argument
```

`df` zeigt Speicherplatzangaben für Dateisysteme.

Die bereits bekannte Option `-h` sorgt wieder für leichter lesbare Größen mit Einheiten.

`/` ist der bekannte Root-Pfad. Er ist hier ein Argument, weil er bezeichnet, worauf sich `df` beziehen soll. Der Bindestrich fehlt, und `/` ist keine Option.

Das Argument `/` begrenzt die Betrachtung auf das Dateisystem, das diesen Pfad enthält.

## Vervollständige und führe selbst aus

```text
df -h ___
```

Ergänze den Root-Pfad und gib den vollständigen Befehl selbst im Terminal ein.

## Relevante Ausgabe

Die Ausgabe ist schematisch so aufgebaut. Deine Werte und die technische Dateisystembezeichnung können anders aussehen:

```text
Filesystem      Size  Used Avail Use% Mounted on
<Bezeichnung>   <Wert> <Wert> <Wert> <Wert> /
```

Suche die Datenzeile, in der unter `Mounted on` der Pfad `/` steht.

Für die Statusdatei benötigst du nur:

- `Used`: belegter Dateisystemspeicher;
- `Avail`: verfügbarer Dateisystemspeicher.

Nicht übernehmen:

- `Filesystem`;
- `Size`;
- `Use%`;
- `Mounted on`.

Eine Bezeichnung wie `overlay` kann technisch aussehen. Sie ist kein eigener Lerngegenstand.

## Beobachtungs- und Abruffragen

1. Welcher zusätzliche Teil kommt bei `df -h /` gegenüber `free -h` hinzu?
2. Warum ist `/` ein Argument und keine Option?
3. Was ist bei `df -h /` der Befehl?
4. Was ist die Option?
5. Was ist das Argument?
6. Welche Spalte beantwortet „Wie viel ist belegt?“
7. Welche Spalte beantwortet „Wie viel ist verfügbar?“
8. Warum können viel Dateisystemspeicher und wenig RAM gleichzeitig vorkommen?
