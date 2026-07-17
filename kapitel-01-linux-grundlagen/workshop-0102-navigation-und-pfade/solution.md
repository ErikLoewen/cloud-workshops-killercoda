# Musterlösung – Workshop 2

Diese Datei ist eine interne Referenz und wird nicht in `index.json` angezeigt.

## Ausgangspunkt

Für die Abschlussaufgabe wird folgender Ausgangspunkt erwartet:

```text
/root/navigation-labor/startpunkt
```

Prüfung:

```text
pwd
```

Erwartete Ausgabe:

```text
/root/navigation-labor/startpunkt
```

## Gültiger relativer Navigationsweg

```text
cd ../abschlussgebiet/kontrollzentrum/freigaberaum
pwd
ziel-bestaetigen
```

Erwartete `pwd`-Ausgabe:

```text
/root/navigation-labor/abschlussgebiet/kontrollzentrum/freigaberaum
```

## Alternative schrittweise Route

```text
cd ..
pwd
ls
cd abschlussgebiet
pwd
ls
cd kontrollzentrum
pwd
ls
cd freigaberaum
pwd
ziel-bestaetigen
```

Erwartete `pwd`-Ausgaben in Reihenfolge:

```text
/root/navigation-labor
/root/navigation-labor/abschlussgebiet
/root/navigation-labor/abschlussgebiet/kontrollzentrum
/root/navigation-labor/abschlussgebiet/kontrollzentrum/freigaberaum
```

## Alternative absolute Route

Vom beliebigen Ausgangsort:

```text
cd /root/navigation-labor/abschlussgebiet/kontrollzentrum/freigaberaum
pwd
ziel-bestaetigen
```

## Fachliche Erklärung

### Absoluter Pfad

Ein ausgeschriebener absoluter Pfad beginnt mit `/` und wird vom Wurzelverzeichnis aus gelesen. Deshalb hängt er nicht vom aktuellen Verzeichnis ab.

### Relativer Pfad

Ein relativer Pfad wird vom aktuellen Verzeichnis aus gelesen. Der Weg `../abschlussgebiet/...` funktioniert in dieser Form nur, wenn der Ausgangsort `startpunkt` ist.

### `/`

`/` allein bezeichnet das Wurzelverzeichnis, also die oberste Ebene des Baums.

### `~`

`~` ist eine Kurzform für das Home-Verzeichnis. Im geplanten Killercoda-Backend wird `/root` erwartet. Diese Annahme muss im realen Pilot bestätigt werden.

### `.`

`.` bezeichnet das aktuelle Verzeichnis. Ein Wechsel mit `cd .` lässt den Standort unverändert.

### `..`

`..` bezeichnet das übergeordnete Verzeichnis. Vom `startpunkt` führt `cd ..` nach `/root/navigation-labor`.

## Grenzen des technischen CHECKs

Der CHECK weist nur nach, dass die bereitgestellte technische Lab-Aktion mindestens einmal aus dem exakten Zielverzeichnis erfolgreich ausgeführt wurde und der Marker den erwarteten Inhalt besitzt.

Er weist nicht nach:

- welchen Navigationsweg die Person verwendet hat;
- ob Tab verwendet wurde;
- ob tatsächlich ein absoluter und ein relativer Pfad genutzt wurden;
- ob `.` oder `..` verstanden wurden;
- ob die Begriffe fachlich erklärt werden können;
- ob die Teilnehmer-Shell beim späteren CHECK noch im Zielverzeichnis steht.
