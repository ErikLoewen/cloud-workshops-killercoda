# Cloud-Workshops mit Killercoda

Dieses Repository enthält praxisnahe, browserbasierte Workshops für den
Einstieg in Linux und Cloud-Technologien. Die Übungen laufen als
Killercoda-Szenarien und führen schrittweise von grundlegenden Befehlen bis
zu Server-, Netzwerk- und Dienstkonzepten.

## Kapitel 1 – Linux-Grundlagen

Kapitel 1 besteht aus zehn aufeinander aufbauenden Workshops. Alle zehn
Szenarien sind im Repository enthalten und in der Kapitelstruktur verlinkt:

1. [**Das Terminal sicher bedienen**](kapitel-01-linux-grundlagen/01-terminal-sicher-bedienen/) – Befehle ausführen, Ausgaben und
   Fehlermeldungen lesen sowie Vordergrundprozesse beenden
2. [**Navigieren und Pfade lesen**](kapitel-01-linux-grundlagen/02-navigation-und-pfade/) – mit `pwd`, `ls` und `cd` arbeiten sowie
   absolute und relative Pfade unterscheiden
3. [**Dateien und Verzeichnisse erstellen**](kapitel-01-linux-grundlagen/03-dateien-und-verzeichnisse/) – Verzeichnisse und Textdateien
   anlegen, Inhalte prüfen und Objekte umbenennen oder verschieben
4. [**Dateien kopieren und sicher löschen**](kapitel-01-linux-grundlagen/04-dateien-kopieren-und-sicher-loeschen/) – mit `cp`, `rm`,
   `rmdir` und kontrolliertem `rm -r` arbeiten; `rm -rf` wird ausschließlich
   als Gefahrenkombination analysiert
5. [**Dateirechte und Ausführbarkeit verstehen**](kapitel-01-linux-grundlagen/05-dateirechte-und-ausfuehrbarkeit/) – Rechte mit
   `ls -l` lesen, die Ausführbarkeit mit `chmod u+x` und `chmod u-x` ändern
   und eine vorbereitete Datei über `./dateiname` ausführen
6. [**Linux-Serverressourcen untersuchen**](kapitel-01-linux-grundlagen/06-serverressourcen-untersuchen/) – CPU, Arbeitsspeicher und
   Dateisystemspeicher analysieren
7. [**Prozesse und Dienste kontrollieren**](kapitel-01-linux-grundlagen/07-prozesse-und-dienste/) – Hintergrundprozesse verwalten
   und einen Demo-Dienst stoppen und starten
8. [**Netzwerkschnittstellen und IP-Adressen untersuchen**](kapitel-01-linux-grundlagen/08-netzwerkschnittstellen-und-ip-adressen/) – Loopback,
   IPv4-Adressen, Schnittstellen und Standardroute einordnen
9. [**Ports prüfen und einen HTTP-Server bereitstellen**](kapitel-01-linux-grundlagen/09-ports-und-http-server/) – TCP-Ports und
   HTTP-Antworten untersuchen sowie einen lokalen Python-HTTP-Server starten
10. [**Linux-Grundlagen praktisch anwenden**](kapitel-01-linux-grundlagen/10-linux-grundlagen-praxistransfer/) – Dateiarbeit,
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
    ├── 01-terminal-sicher-bedienen/
    ├── 02-navigation-und-pfade/
    ├── 03-dateien-und-verzeichnisse/
    ├── 04-dateien-kopieren-und-sicher-loeschen/
    ├── 05-dateirechte-und-ausfuehrbarkeit/
    ├── 06-serverressourcen-untersuchen/
    ├── 07-prozesse-und-dienste/
    ├── 08-netzwerkschnittstellen-und-ip-adressen/
    ├── 09-ports-und-http-server/
    └── 10-linux-grundlagen-praxistransfer/
```

> **Status: Work in Progress**
>
> Alle zehn Workshops des ersten Kapitels sind angelegt und verlinkt. Die
> Inhalte und ihre technischen Annahmen werden weiterhin praktisch getestet
> und können sich daher noch ändern.
