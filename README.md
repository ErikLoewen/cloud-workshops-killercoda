# Cloud-Workshops mit Killercoda

Dieses Repository enthält praxisnahe, browserbasierte Workshops für den
Einstieg in Linux und Cloud-Technologien. Die Übungen laufen als
Killercoda-Szenarien und führen schrittweise von grundlegenden Befehlen bis
zu Server-, Netzwerk- und Dienstkonzepten.

## Kapitel 1 – Linux-Grundlagen

Kapitel 1 umfasst sieben aufeinander aufbauende Workshops:

1. **Das Terminal sicher bedienen** – Befehle ausführen, Ausgaben und
   Fehlermeldungen lesen sowie Vordergrundprozesse beenden
2. **Navigieren und Pfade lesen** – mit `pwd`, `ls` und `cd` arbeiten sowie
   absolute und relative Pfade unterscheiden
3. **Dateien und Verzeichnisse erstellen** – Verzeichnisse und Textdateien
   anlegen, Inhalte prüfen und Objekte umbenennen oder verschieben
4. **Linux-Serverressourcen untersuchen** – CPU, Arbeitsspeicher und
   Dateisystemspeicher analysieren
5. **Prozesse und Dienste kontrollieren** – Hintergrundprozesse verwalten
   und einen Demo-Dienst stoppen und starten
6. **Netzwerkschnittstellen und IP-Adressen untersuchen** – Loopback,
   IPv4-Adressen, Schnittstellen und Standardroute einordnen
7. **Ports prüfen und einen HTTP-Server bereitstellen** – TCP-Ports und
   HTTP-Antworten untersuchen sowie einen lokalen Python-HTTP-Server starten

Die Reihenfolge der Szenarien wird in
[`kapitel-01-linux-grundlagen/structure.json`](kapitel-01-linux-grundlagen/structure.json)
festgelegt.

## Repository-Struktur

Jedes Szenario besitzt eine `index.json` mit den Killercoda-Metadaten sowie
Markdown-Dateien für Einführung, Lernschritte, Aufgabe, Lösung und Abschluss.
Die zugehörigen Setup- und Prüfskripte bereiten die Übungsumgebung vor und
validieren die Ergebnisse.

> **Status: Work in Progress**
>
> Die Workshops und ihre Dokumentation werden fortlaufend weiterentwickelt
> und praktisch getestet. Inhalte und technische Annahmen können sich daher
> noch ändern.
