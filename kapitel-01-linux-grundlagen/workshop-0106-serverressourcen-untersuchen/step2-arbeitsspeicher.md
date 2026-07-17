# Schritt 2: Arbeitsspeicher untersuchen

## Das bisherige Befehlsmodell

Bisher hast du vor allem zwei Formen verwendet:

```text
Befehl
```

Beispiele: `pwd`, `ls`, `nproc`

```text
Befehl + Argument
```

Beispiele: `echo Hallo`, `cd projekt`, `cat notiz.txt`

Ein **Befehl** legt fest, was ausgeführt wird.  
Ein **Argument** bezeichnet häufig, worauf sich ein Befehl bezieht.

Jetzt kommt erstmals ein weiterer Bestandteil hinzu: eine **Option**.

Eine Option verändert, wie ein Befehl arbeitet oder wie er seine Ausgabe darstellt. In diesem Workshop geht es nur um die konkrete Option `-h`. Eine allgemeine Optionenlehre folgt nicht.

## Der Befehl `free -h`

```text
free    = Befehl
-h      = Option
```

Der Bindestrich gehört zur Option.

`-h` sorgt bei diesem Befehl für leichter lesbare Größenangaben mit Einheiten. `-h` ist:

- keine Variable,
- kein Pfad,
- kein frei einsetzbarer Wert,
- kein Argument wie ein Dateiname oder Pfad.

**Was macht `free -h`?**  
Der Befehl zeigt eine Übersicht über den Arbeitsspeicher. Durch `-h` erscheinen Größen beispielsweise mit Einheiten wie `Mi` oder `Gi`.

**Welche Ausgabe wird erwartet?**  
Eine Kopfzeile und eine Zeile für den eigentlichen Arbeitsspeicher. Zusätzlich kann eine Swap-Zeile erscheinen. Swap wird in diesem Workshop nicht ausgewertet.

Gib den folgenden Befehl selbst ein und führe ihn mit Enter aus:

```bash
free -h
```

## Finde die RAM-Zeile

Die Ausgabe ist schematisch so aufgebaut. Deine Werte sind anders:

```text
               total        used        free      shared  buff/cache   available
Mem:           <Wert>       <Wert>      <Wert>     <Wert>      <Wert>       <Wert>
Swap:          <Wert>       <Wert>      <Wert>
```

Für die Aufgabe ist die RAM-Zeile relevant, gewöhnlich mit `Mem:` beschriftet.

Lies in dieser Zeile:

- `total`: insgesamt sichtbarer RAM;
- `free`: vollständig ungenutzter RAM;
- `available`: Schätzung, wie viel RAM für neue Anwendungen noch nutzbar ist.

`free` und `available` sind deshalb nicht dasselbe.

Für die spätere Statusdatei benötigst du:

- den Wert unter `total`;
- den Wert unter `available`.

## Beobachtungsfragen

1. Welcher Teil von `free -h` ist der Befehl?
2. Welcher Teil ist die Option?
3. Was verändert `-h` in diesem konkreten Befehl?
4. Sind `free` und `available` in deiner Ausgabe gleich?
5. Warum ist `available` für die einfache Frage nach noch nutzbarem RAM geeigneter als nur `free`?
6. Welche Zeile wird heute nicht ausgewertet?
