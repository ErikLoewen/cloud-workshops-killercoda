# Cloud-Workshops mit Killercoda

Dieses Repository enthält praxisnahe, browserbasierte Workshops für den
Einstieg in Linux und Cloud-Technologien. Die Übungen laufen als
Killercoda-Szenarien und führen schrittweise von grundlegenden Befehlen bis
zu Server-, Netzwerk- und Dienstkonzepten.

## Kapitel 01 – Moin Linux!

Terminal bedienen, Pfade lesen, Dateien verwalten und Prozesse im Blick behalten.

Kapitel 01 besteht aus acht aufeinander aufbauenden Workshops. Alle acht
Szenarien sind im Repository enthalten und in der Kapitelstruktur verlinkt:

1. [**01.01 – Moin Terminal**](kapitel-01-linux-grundlagen/workshop-0101-terminal-sicher-bedienen/) – Befehle ausführen, Ausgaben und
   Fehlermeldungen lesen sowie Vordergrundprozesse beenden
2. [**01.02 – Wo bin ich hier?**](kapitel-01-linux-grundlagen/workshop-0102-navigation-und-pfade/) – mit `pwd`, `ls` und `cd` arbeiten sowie
   absolute und relative Pfade unterscheiden
3. [**01.03 – Dateien, Ordner und die erste Spur**](kapitel-01-linux-grundlagen/workshop-0103-dateien-und-verzeichnisse/) – Verzeichnisse und Textdateien
   anlegen, Inhalte prüfen und Objekte umbenennen oder verschieben
4. [**01.04 – Kopieren, aufräumen, nichts versenken**](kapitel-01-linux-grundlagen/workshop-0104-dateien-kopieren-und-sicher-loeschen/) – mit `cp`, `rm`,
   `rmdir` und kontrolliertem `rm -r` arbeiten; `rm -rf` wird ausschließlich
   als Gefahrenkombination analysiert
5. [**01.05 – Wer darf das ausführen?**](kapitel-01-linux-grundlagen/workshop-0105-dateirechte-und-ausfuehrbarkeit/) – Rechte mit
   `ls -l` lesen, die Ausführbarkeit mit `chmod u+x` und `chmod u-x` ändern
   und eine vorbereitete Datei über `./dateiname` ausführen
6. [**01.06 – Was macht der Server eigentlich?**](kapitel-01-linux-grundlagen/workshop-0106-serverressourcen-untersuchen/) – CPU, Arbeitsspeicher und
   Dateisystemspeicher analysieren
7. [**01.07 – Prozesse und Dienste unter Kontrolle**](kapitel-01-linux-grundlagen/workshop-0107-prozesse-und-dienste/) – Hintergrundprozesse verwalten
   und einen Demo-Dienst stoppen und starten
8. [**01.08 – Abschlussmission: Ordnung auf dem Deichserver**](kapitel-01-linux-grundlagen/workshop-0108-linux-grundlagen-praxistransfer/) – die Linux-Grundlagen
   in einer integrativen Abschlussmission anwenden

Die [Wurzelstruktur](structure.json) bindet das Kapitel ein. Die Reihenfolge
der acht Szenarien wird in der
[Kapitelstruktur](kapitel-01-linux-grundlagen/structure.json) festgelegt.

## Repository-Struktur

Jedes Szenario besitzt eine `index.json` mit den Killercoda-Metadaten sowie
Markdown-Dateien für Einführung, Lernschritte, Aufgabe, Lösung und Abschluss.
Die zugehörigen Setup- und Prüfskripte bereiten die Übungsumgebung vor und
validieren die Ergebnisse.

```text
.
├── structure.json
├── README.md
└── kapitel-01-linux-grundlagen/
    ├── structure.json
    ├── workshop-0101-terminal-sicher-bedienen/
    ├── workshop-0102-navigation-und-pfade/
    ├── workshop-0103-dateien-und-verzeichnisse/
    ├── workshop-0104-dateien-kopieren-und-sicher-loeschen/
    ├── workshop-0105-dateirechte-und-ausfuehrbarkeit/
    ├── workshop-0106-serverressourcen-untersuchen/
    ├── workshop-0107-prozesse-und-dienste/
    └── workshop-0108-linux-grundlagen-praxistransfer/
```

> **Status: Work in Progress**
>
> Alle acht Workshops des ersten Kapitels sind angelegt und verlinkt. Die
> Inhalte und ihre technischen Annahmen werden weiterhin praktisch getestet
> und können sich daher noch ändern.
