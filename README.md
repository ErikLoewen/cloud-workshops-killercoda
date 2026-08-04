# Interaktive IT-Workshops mit Killercoda

Dieses Repository enthält praxisnahe, browserbasierte IT-Workshops. Die
Übungen laufen als Killercoda-Szenarien und vermitteln technische Grundlagen
in aufeinander aufbauenden Kapiteln. Den Anfang macht Linux; weitere Themen
aus Serverbetrieb, Netzwerken, Containern und Cloud-Technologien sollen folgen.

## Kapitel 01 – Der Ruf des Leuchtturms

**Kapitel 01 ist vollständig:** Acht aufeinander aufbauende Workshops führen
praktisch in die Linux-Grundlagen ein. Im alten Leuchtturm bedienst du das
Terminal, navigierst durch das Dateisystem, verwaltest Dateien und Rechte,
untersuchst Prozesse und reparierst die Konfiguration des Leuchtfeuers.

Alle acht Szenarien sind im Repository enthalten und in der Kapitelstruktur
verlinkt:

1. [**01.01 – Moin Terminal: Nachtschicht im Leuchtturm**](kapitel-01-linux-grundlagen/workshop-0101-terminal-sicher-bedienen/) – Befehle ausführen, Ausgaben und
   Fehlermeldungen lesen sowie Vordergrundprozesse beenden
2. [**01.02 – Navigation im Nebel: Wo bin ich hier?**](kapitel-01-linux-grundlagen/workshop-0102-navigation-und-pfade/) – mit `pwd`, `ls` und `cd` durch den
   Leuchtturm navigieren sowie absolute und relative Pfade unterscheiden
3. [**01.03 – Dateien, Ordner und die erste Spur**](kapitel-01-linux-grundlagen/workshop-0103-dateien-und-verzeichnisse/) – Im Leuchtturm Ordner und Textdateien erstellen und das Logbuch in den Kartenraum verschieben
4. [**01.04 – Kopieren, aufräumen, nichts versenken**](kapitel-01-linux-grundlagen/workshop-0104-dateien-kopieren-und-sicher-loeschen/) – mit `cp`, `rm`,
   `rmdir` und kontrolliertem `rm -r` arbeiten; `rm -rf` wird ausschließlich
   als Gefahrenkombination analysiert
5. [**01.05 – Gesperrtes Signal: Wer darf das ausführen?**](kapitel-01-linux-grundlagen/workshop-0105-dateirechte-und-ausfuehrbarkeit/) – Rechte mit
   `ls -l` lesen, die Ausführbarkeit mit `chmod u+x` und `chmod u-x` ändern
   und eine vorbereitete Datei über `./dateiname` ausführen
6. [**01.06 – Licht aus im Sturm: Was blockiert den Leuchtturm?**](kapitel-01-linux-grundlagen/workshop-0106-serverressourcen-untersuchen/) – Ressourcen und
   Prozesse untersuchen, einen CPU-Verursacher finden und kontrolliert beenden
7. [**01.07 – Falsches Signal: Die Konfiguration des Leuchtfeuers reparieren**](kapitel-01-linux-grundlagen/workshop-0107-prozesse-und-dienste/) – Betriebsprotokoll und
   Konfiguration prüfen, bearbeiten und sicher anwenden
8. [**01.08 – Das fragmentierte Archiv**](kapitel-01-linux-grundlagen/workshop-0108-linux-grundlagen-praxistransfer/) – die Linux-Grundlagen
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

> **Status: Kapitel 01 abgeschlossen**
>
> Alle acht Workshops sind ausgearbeitet, technisch geprüft und in der
> vorgesehenen Reihenfolge veröffentlicht. Weitere Kapitel sind geplant.
