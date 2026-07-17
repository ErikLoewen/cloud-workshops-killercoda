# Netzwerkschnittstellen und IP-Adressen untersuchen

## Dein Ziel

Du untersuchst ausschließlich die **lokalen, bereits vorhandenen** Netzwerkinformationen dieses Linux-Systems. Du veränderst keine Netzwerkkonfiguration und sprichst kein externes Ziel an.

Am Ende dokumentierst du vier aktuelle Werte:

- die Loopback-Schnittstelle;
- ihre IPv4-Adresse einschließlich Präfixlänge;
- die primäre Schnittstelle aus der Standardroute;
- eine aktuelle IPv4-Adresse genau dieser Schnittstelle einschließlich Präfixlänge.

Die Bestandsdatei entsteht hier:

`/root/netzwerklabor/netzwerkstatus.txt`

## Zeitrahmen

- geübte Teilnehmende: etwa 31–37 Minuten;
- absolute Anfänger: etwa 40–47 Minuten;
- mindestens 13 Minuten bleiben innerhalb einer 60-Minuten-Sitzung für Fragen, Tippfehler und Wiederholungen.

Der Workshop wird nicht künstlich auf 60 Minuten verlängert.

## Das bringst du bereits mit

Rufe kurz ab:

1. Welcher Befehlsbestandteil verändert die Arbeitsweise oder Darstellung eines Befehls?
2. Musst du jede sichtbare Spalte einer technischen Ausgabe auswerten?
3. Welcher bekannte Operator schreibt die Ausgabe von `echo` in eine Datei?

Erwartet werden: **Option**, **nur relevante Felder auswerten** und **ein einzelnes `>`**.

## Fachliche Grenze

In diesem Workshop geht es um:

- Netzwerkschnittstellen;
- Loopback;
- IPv4-Adressen;
- Präfixlängen;
- Routen;
- Standardroute und primäre Schnittstelle.

Nicht behandelt werden Netzwerkänderungen, externe Verbindungen, Ports, Namensauflösung oder Subnetzberechnungen. Adressen mit Doppelpunkten können sichtbar sein, gehören aber nicht zur Aufgabe.

## Zwei Arten von Prüfung

Der technische CHECK prüft die erzeugte Datei gegen den aktuellen lokalen Netzwerkzustand.

Zusätzliche Fragen prüfen dein Verständnis. Ein erfolgreicher CHECK beweist daher nicht automatisch, dass du jeden Begriff erklären kannst.
