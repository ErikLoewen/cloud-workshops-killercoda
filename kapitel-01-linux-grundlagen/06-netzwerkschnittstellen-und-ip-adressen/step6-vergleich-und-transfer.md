# Vergleichen und die Bestandsdatei vorbereiten

## Loopback und primäre Schnittstelle vergleichen

Fülle den Vergleich mit deinen aktuellen Beobachtungen:

| Merkmal | Loopback | Primäre Schnittstelle |
|---|---|---|
| Zweck in diesem Modell | Bezug auf das eigene System | Schnittstelle der Standardroute |
| Ermittlung | Loopback-Zeile in der Adressausgabe | Name hinter `dev` in der `default`-Zeile |
| IPv4-Adresse | aus der Loopback-Zeile | aus der Zeile derselben primären Schnittstelle |
| Präfixlänge | wird übernommen | wird übernommen |

## Vier benötigte Werte

Für die Bestandsdatei benötigst du:

```text
LOOPBACK_INTERFACE=<WERT>
LOOPBACK_IPV4=<WERT>
PRIMAERE_INTERFACE=<WERT>
PRIMAERE_IPV4=<WERT>
```

Die Platzhalter `<WERT>` werden später nicht wörtlich eingegeben. Du ersetzt sie durch die tatsächlich angezeigten Werte deiner aktuellen Umgebung.

## Neue Shell-Syntax: doppelte Anführungszeichen

Die Statuszeile enthält mehrere Bestandteile und Leerzeichen. Doppelte Anführungszeichen halten diesen gesamten Text für die Shell zusammen.

Der Text zwischen den Anführungszeichen wird als ein zusammengehöriges Textargument an `echo` übergeben. Die Anführungszeichen selbst erscheinen später nicht in der Datei.

### Vorhersage

**Werden die doppelten Anführungszeichen mit in die Datei geschrieben?**

Erwartete Antwort:

> Nein. Sie dienen der Shell dazu, den Text als zusammengehöriges Argument zu erkennen.

## Zerlegung der Dateierzeugung

```text
echo "LOOPBACK_INTERFACE=... LOOPBACK_IPV4=..." > ziel.txt
│    └────────────────────────────────────────┘ │ └──────┘
│            zusammengehöriges Textargument     │ Zielpfad
Befehl                                           bekannte Umleitung
```

Dabei gilt:

- `echo` ist der Befehl;
- die doppelten Anführungszeichen begrenzen das zusammengehörige Textargument;
- `>` ist die bereits bekannte Ausgabeumleitung;
- rechts von `>` steht der Zielpfad.

Die Umleitung schreibt die Ausgabe von `echo` in die Datei. Beim späteren Kontrollieren mit `cat` erwartest du die vollständige Statuszeile mit Leerzeichen, aber ohne die doppelten Anführungszeichen.

## Verbindliche Form

```bash
echo "LOOPBACK_INTERFACE=<WERT> LOOPBACK_IPV4=<WERT> PRIMAERE_INTERFACE=<WERT> PRIMAERE_IPV4=<WERT>" > /root/netzwerklabor/netzwerkstatus.txt
```

Gib diesen Befehl hier noch nicht mit den Platzhaltern ein. In der Abschlussaufgabe ersetzt du alle vier Platzhalter durch deine aktuellen Werte.

## Transferfrage

Eine andere Umgebung zeigt einen anderen Namen hinter `dev`. Welcher Teil deiner Methode bleibt gleich?
