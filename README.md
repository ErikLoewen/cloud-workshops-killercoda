# Cloud-Workshops mit Killercoda

Dieses Repository enthält praxisnahe, browserbasierte Workshops für den
Einstieg in Linux und Cloud-Technologien. Die Übungen laufen als
Killercoda-Szenarien und führen schrittweise von grundlegenden Befehlen bis
zu Server-, Netzwerk- und Dienstkonzepten.

## Kapitel 01 – Linux-Grundlagen

Kapitel 01 besteht aus zehn aufeinander aufbauenden Workshops. Alle zehn
Szenarien sind im Repository enthalten und in der Kapitelstruktur verlinkt:

1. [**Workshop 01.01 – Das Terminal sicher bedienen**](kapitel-01-linux-grundlagen/workshop-0101-terminal-sicher-bedienen/) – Befehle ausführen, Ausgaben und
   Fehlermeldungen lesen sowie Vordergrundprozesse beenden
2. [**Workshop 01.02 – Navigieren und Pfade lesen**](kapitel-01-linux-grundlagen/workshop-0102-navigation-und-pfade/) – mit `pwd`, `ls` und `cd` arbeiten sowie
   absolute und relative Pfade unterscheiden
3. [**Workshop 01.03 – Dateien und Verzeichnisse erstellen**](kapitel-01-linux-grundlagen/workshop-0103-dateien-und-verzeichnisse/) – Verzeichnisse und Textdateien
   anlegen, Inhalte prüfen und Objekte umbenennen oder verschieben
4. [**Workshop 01.04 – Dateien kopieren und sicher löschen**](kapitel-01-linux-grundlagen/workshop-0104-dateien-kopieren-und-sicher-loeschen/) – mit `cp`, `rm`,
   `rmdir` und kontrolliertem `rm -r` arbeiten; `rm -rf` wird ausschließlich
   als Gefahrenkombination analysiert
5. [**Workshop 01.05 – Dateirechte und Ausführbarkeit verstehen**](kapitel-01-linux-grundlagen/workshop-0105-dateirechte-und-ausfuehrbarkeit/) – Rechte mit
   `ls -l` lesen, die Ausführbarkeit mit `chmod u+x` und `chmod u-x` ändern
   und eine vorbereitete Datei über `./dateiname` ausführen
6. [**Workshop 01.06 – Linux-Serverressourcen untersuchen**](kapitel-01-linux-grundlagen/workshop-0106-serverressourcen-untersuchen/) – CPU, Arbeitsspeicher und
   Dateisystemspeicher analysieren
7. [**Workshop 01.07 – Prozesse und Dienste kontrollieren**](kapitel-01-linux-grundlagen/workshop-0107-prozesse-und-dienste/) – Hintergrundprozesse verwalten
   und einen Demo-Dienst stoppen und starten
8. [**Workshop 01.08 – Netzwerkschnittstellen und IP-Adressen untersuchen**](kapitel-01-linux-grundlagen/workshop-0108-netzwerkschnittstellen-und-ip-adressen/) – Loopback,
   IPv4-Adressen, Schnittstellen und Standardroute einordnen
9. [**Workshop 01.09 – Ports prüfen und einen HTTP-Server bereitstellen**](kapitel-01-linux-grundlagen/workshop-0109-ports-und-http-server/) – TCP-Ports und
   HTTP-Antworten untersuchen sowie einen lokalen Python-HTTP-Server starten
10. [**Workshop 01.10 – Linux-Grundlagen praktisch anwenden**](kapitel-01-linux-grundlagen/workshop-0110-linux-grundlagen-praxistransfer/) – Dateiarbeit,
    sicheres Löschen, Berechtigungen, Systembeobachtung,
    Netzwerkinformationen und einen lokalen HTTP-Server in einer
    integrativen Abschlussübung verbinden, ohne neue Befehle einzuführen

Die [Wurzelstruktur](structure.json) bindet das Kapitel ein. Die Reihenfolge
der zehn Szenarien wird in der
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
    ├── workshop-0108-netzwerkschnittstellen-und-ip-adressen/
    ├── workshop-0109-ports-und-http-server/
    └── workshop-0110-linux-grundlagen-praxistransfer/
```

> **Status: Work in Progress**
>
> Alle zehn Workshops des ersten Kapitels sind angelegt und verlinkt. Die
> Inhalte und ihre technischen Annahmen werden weiterhin praktisch getestet
> und können sich daher noch ändern.
