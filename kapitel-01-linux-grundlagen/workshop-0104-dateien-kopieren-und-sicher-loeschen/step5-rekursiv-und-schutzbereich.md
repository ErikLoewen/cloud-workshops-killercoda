# Rekursives Löschen vorbereiten

Ein nicht leeres Verzeichnis enthält weitere Objekte. Für das ausdrücklich freigegebene Ziel wird später die konkrete Form `rm -r` verwendet.

```text
rm        -r        verzeichnis
Befehl    Option    Ziel
```

- `-r` ist eine konkrete Option von `rm`.
- `-r` bedeutet hier rekursiv.
- Rekursiv umfasst das Zielverzeichnis, seine Dateien und seine Unterverzeichnisse.
- `rm -r` ist deshalb folgenstärker als `rm` auf einer einzelnen Datei.
- Wildcards werden nicht verwendet.
- Allgemeinere oder übergeordnete Pfade sind nicht freigegeben.

Die erste und einzige tatsächliche Ausführung erfolgt in der Abschlussaufgabe. Sie wird immer selbst eingegeben.

## Das einzige freigegebene rekursive Ziel

```text
/root/dateilabor/auftrag/arbeitsbereich/temp-projekt
```

Untersuche den Zielbaum, ohne ihn jetzt zu entfernen:

```bash
cd /root/dateilabor/auftrag/arbeitsbereich
pwd
ls
ls temp-projekt
cat temp-projekt/notiz.txt
ls temp-projekt/unterordner
cat temp-projekt/unterordner/rest.txt
```

Kontrolliere den Schutzbereich:

```bash
ls /root/dateilabor/auftrag/schutzbereich
cat /root/dateilabor/auftrag/schutzbereich/wichtig.txt
```

## Sicherheitsroutine verkürzt abrufen

Beantworte vor der späteren Ausführung:

1. Wo befinde ich mich?
2. Welcher konkrete Zielpfad ist freigegeben?
3. Welche enthaltenen Objekte werden mitbetroffen?
4. Liegt der Zielpfad vollständig im Arbeitsbereich?
5. Welcher Bereich muss unverändert bleiben?

## Gefahrenanalyse: nicht ausführen

Die Kombination `rm -rf` wird in diesem Workshop nur theoretisch analysiert:

```text
rm     entfernt
-r     arbeitet rekursiv
-f     erzwingt die Handlung und unterdrückt bestimmte Rückmeldungen
```

`-r` erweitert den betroffenen Bereich. `-f` kann Rückmeldungen oder Schutzwirkungen reduzieren. Ein falsch gelesener Pfad kann dadurch erhebliche Folgen haben.

`-f` ist für kein Lernziel erforderlich und keine normale Reaktion auf eine Fehlermeldung. Prüfe zuerst Pfad, Objektart und Fehlerursache.
