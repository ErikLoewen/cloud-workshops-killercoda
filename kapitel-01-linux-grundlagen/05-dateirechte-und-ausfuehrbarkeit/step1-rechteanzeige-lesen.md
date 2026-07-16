# Schritt 1: Eine Rechteanzeige lesen

## Orientierung

Bestimme zuerst deinen aktuellen Standort. Gib selbst ein:

```bash
pwd
```

Wechsle danach in den Demo-Bereich:

```bash
cd /root/rechtelabor/demo
```

## Von `ls` zu `ls -l`

`ls` zeigt vorhandene Objekte. Die Option `-l` fordert eine ausführlichere Listenansicht an.

```text
ls        -l
Befehl    Option
```

Der Bindestrich gehört zur Option. Das Zeichen nach dem Bindestrich ist ein kleines `l`, nicht die Ziffer `1`.

Diese Befehlsform liest nur Informationen. Sie verändert weder Dateiinhalt noch Dateirechte.

Führe jetzt den ersten vollständigen Aufruf aus:

`ls -l`{{exec}}

Konzentriere dich nur auf:

- den ersten Zeichenblock;
- die drei Rechtebereiche;
- den Dateinamen.

Andere sichtbare Spalten werden in diesem Workshop nicht ausgewertet.

## Zwei vorbereitete Dateien vergleichen

Die Ausgabe sieht schematisch so aus:

```text
-rw-r--r--  ...  ohne-ausfuehrungsrecht
-rwxr--r--  ...  bereits-ausfuehrbar
```

Die Auslassungspunkte stehen nur für Ausgabebereiche, die wir hier nicht untersuchen. Sie sind keine Terminaleingabe. Reale Abstände und Werte können abweichen.

Wir lesen den Kernblock aus zehn Zeichen:

```text
-   rw-   r--   r--
│    │     │     │
│    │     │     └─ andere
│    │     └─────── Gruppe
│    └───────────── Besitzer
└────────────────── Objekttyp
```

- Das erste Zeichen zeigt hier den Objekttyp.
- `-` an der ersten Position bedeutet hier: reguläre Datei.
- Dieses erste Zeichen gehört nicht zu den neun Rechtepositionen.
- Die nächsten neun Zeichen bilden drei Dreiergruppen.
- Die erste Gruppe gehört zum Besitzer.
- Die zweite Gruppe gehört zur Gruppe.
- Die dritte Gruppe gehört zu anderen Benutzern.
- Ein Bindestrich innerhalb einer Dreiergruppe bedeutet: Das entsprechende Recht fehlt.

Falls hinter den ersten zehn Zeichen ein zusätzliches Zeichen wie `+` oder `.` sichtbar ist, lesen wir für diese Aufgabe trotzdem nur die ersten zehn Zeichen. Ein mögliches Zusatzzeichen gehört nicht zu den neun Grundrechten dieser Aufgabe.

## Lesen, Schreiben und Ausführen

Am konkreten Rechteblock gilt:

```text
r   lesen
w   schreiben
x   ausführen
-   entsprechendes Recht fehlt
```

- **Lesen:** Der Dateiinhalt darf gelesen werden.
- **Schreiben:** Der Dateiinhalt darf verändert werden.
- **Ausführen:** Die Datei darf als vorbereitete Programm- oder Befehlsdatei gestartet werden.

Rechte an Verzeichnissen werden in diesem Workshop nicht behandelt.

## Beobachte

Beantworte anhand deiner echten Ausgabe:

1. Welcher Rechteblock gehört zu `ohne-ausfuehrungsrecht`?
2. In welcher Dreiergruppe unterscheiden sich die beiden Dateien?
3. Welche Datei besitzt im Besitzerbereich ein `x`?
4. Welche Datei besitzt dort einen Bindestrich?
5. Haben Gruppe oder andere durch diesen Unterschied ein Ausführungsrecht?
6. Welcher Teil der Ausgabe ist nur der Dateiname?
