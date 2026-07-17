# Musterlösung und technische Referenz

Diese Datei ist eine interne Qualitäts- und Betreuungshilfe. Sie wird nicht über `index.json` sichtbar gemacht.

## Vollständiger Demoablauf

```bash
pwd
```

Zeigt den aktuellen Standort.

```bash
cd /root/rechtelabor/demo
```

Wechselt in den vorbereiteten Demo-Bereich.

```bash
ls -l
```

Zeigt die ausführliche Listenansicht. Relevant sind der erste Zeichenblock und der Dateiname.

Schematisch:

```text
-rw-r--r--  ...  ohne-ausfuehrungsrecht
-rwxr--r--  ...  bereits-ausfuehrbar
```

Zerlegung:

```text
-   rw-   r--   r--
│    │     │     │
│    │     │     └─ andere
│    │     └─────── Gruppe
│    └───────────── Besitzer
└────────────────── Objekttyp
```

Das erste Zeichen ist hier der Objekttyp. Die folgenden neun Stellen bilden drei Rechtebereiche. `r` bedeutet lesen, `w` schreiben und `x` ausführen.

```bash
./ohne-ausfuehrungsrecht
```

Die Ausführung wird beabsichtigt abgelehnt, weil im Besitzerbereich kein `x` vorhanden ist. Der genaue Wortlaut der Fehlermeldung ist nicht relevant. Inhalt und Rechte bleiben unverändert.

```bash
chmod u+x ohne-ausfuehrungsrecht
```

`chmod` ist der Befehl, `u+x` das zusammengehörige Rechteargument und `ohne-ausfuehrungsrecht` das Ziel. `u` bezeichnet den Besitzer, `+` das Hinzufügen und `x` das Ausführungsrecht.

```bash
ls -l
```

Erwartet wird für die Datei:

```text
-rwxr--r--
```

Nur die Besitzerstelle für Ausführen wurde ergänzt.

```bash
./ohne-ausfuehrungsrecht
```

Erwartete Ausgabe:

```text
Demo-Datei erfolgreich ausgeführt
```

Der Inhalt war bereits vorhanden. Erst das ergänzte Besitzer-Ausführungsrecht ermöglicht die direkte Ausführung.

```bash
chmod u-x ohne-ausfuehrungsrecht
```

`u-x` entfernt nur das Besitzer-Ausführungsrecht.

```bash
ls -l
```

Erwarteter Demo-Endzustand:

```text
-rw-r--r--
```

## Vollständige Abschlusslösung

```bash
cd /root/rechtelabor/auftrag
```

```bash
pwd
```

```bash
ls
```

```bash
cd arbeitsbereich
```

```bash
ls -l
```

Vor der Änderung besitzt `pruefdatei` im Besitzerbereich kein `x`.

```bash
chmod u+x pruefdatei
```

Es wird ausschließlich das Besitzer-Ausführungsrecht ergänzt.

```bash
ls -l
```

Erwarteter Rechteblock:

```text
-rwxr--r--
```

```bash
./pruefdatei
```

Erwartete Ausgabe:

```text
Prüfdatei erfolgreich ausgeführt
```

```bash
cd ../schutzbereich
```

```bash
ls -l
```

```bash
cat wichtig.txt
```

Erwarteter Inhalt:

```text
Dieser Inhalt und diese Rechte bleiben unverändert
```

Danach wird der technische CHECK ausgelöst.

## Prinzip minimaler Rechte

Benötigt wird nur das Ausführungsrecht des Besitzers. Deshalb erhalten Gruppe und andere kein neues Recht. Pauschale oder rekursive Rechteänderungen sind keine Lösung dieses Workshops.

Die direkte Ausführung wird nicht durch eine andere Shell umgangen. Das Lernziel ist die beobachtbare Ausführbarkeit der vorbereiteten Datei über ihren relativen Pfad.

## Technischer Sollzustand

Die folgenden numerischen Angaben sind ausschließlich interne Test- und Verify-Details, keine Teilnehmerlösung:

- Demo ohne Ausführungsrecht: `0644`;
- bereits ausführbare Demo: `0744`;
- Auftragsdatei am Anfang: `0644`;
- Auftragsdatei am Ende: `0744`;
- Schutzdatei: `0644`;
- Laborverzeichnisse: `0755`.

## Grenzen des CHECKs

Der CHECK kann Inhalt, Typ, numerische UID/GID, Rechte, Marker und Schutzstruktur prüfen. Er kann nicht beweisen:

- welcher Befehl verwendet wurde;
- ob die Rechteanzeige bewusst gelesen wurde;
- ob der erwartete Fehler ausgeführt und verstanden wurde;
- ob `u+x` und `u-x` begrifflich zerlegt werden können;
- ob die Aufgabe selbstständig gelöst wurde;
- ob das Prinzip minimaler Rechte bewusst angewendet wurde.

Diese Punkte werden durch Beobachtung und Reflexionsfragen geprüft.
