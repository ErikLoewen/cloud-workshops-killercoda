# Was steht dem System zur Verfügung?

Bevor du nach einem Fehler suchst, brauchst du ein grobes Bild des Systems.
Drei Ressourcen spielen dabei eine zentrale Rolle:

- Die CPU verarbeitet Aufgaben.
- Der RAM hält Daten bereit, die laufende Programme gerade benötigen.
- Der Dateisystemspeicher bewahrt Dateien dauerhaft auf.

Ein Rechner kann grundsätzlich ausreichend ausgestattet sein und trotzdem
langsam reagieren. Zuerst prüfen wir deshalb, ob eine Ressource offensichtlich
fehlt oder knapp geworden ist.

![CPU, RAM und Dateisystemspeicher als drei getrennte Ressourcenbereiche.](./assets/0106-ressourcenmodell.png)

| Bereich | Leitfrage |
|---|---|
| CPU | Wie viele logische Recheneinheiten stehen der Umgebung zur Verfügung? |
| RAM | Wie viel kurzfristiger Arbeitsraum ist insgesamt und ungefähr verfügbar? |
| Speicher | Wie viel Platz ist auf dem untersuchten Dateisystem noch frei? |

Als **Lernmetapher** kannst du dir den Leuchtturm so vorstellen:

- Der Maschinenraum steht für die CPU.
- Der Kartentisch steht für den RAM.
- Das Archiv steht für den Speicher.

Diese Zuordnung ist nur eine Merkhilfe und keine technische Architektur des
Rechners.

## CPU-Kapazität mit `nproc`

```bash
nproc
```{{exec}}

`nproc` zeigt, wie viele logische Prozessoren der aktuellen Umgebung zur
Verfügung stehen. Das ist keine Live-Anzeige der Auslastung.

Überlege kurz:

> Zeigt die Ausgabe, wie viele Prozessoren vorhanden sind oder wie stark sie
> gerade arbeiten?

Der Befehl zeigt die vorhandene Kapazität, nicht die momentane Last.

## RAM mit `free -h`

```bash
free -h
```{{exec}}

Die Option `-h` zeigt Größen in leichter lesbaren Einheiten an. Für eine erste
Einschätzung reicht heute die Zeile `Mem:`:

- `total` zeigt die Gesamtmenge.
- `available` schätzt, wie viel RAM neuen Programmen ungefähr noch zur
  Verfügung stehen kann.

## Dateisystemspeicher mit `df -h /`

```bash
df -h /
```{{exec}}

Auch hier sorgt `-h` für leichter lesbare Einheiten. Der Pfad `/` legt fest,
welchen Bereich du untersuchst:

- `Use%` zeigt den belegten Anteil in Prozent.
- `Avail` zeigt den noch verfügbaren Platz.

## Untersuchungsauftrag

Prüfe RAM und Speicherplatz. Entscheide jeweils nur:

- Wirkt der Bereich akut knapp?
- Oder wirkt er zunächst unauffällig?

Du musst keine Werte abschreiben oder in eine Datei übertragen.

<details>
<summary>Hinweis 1 – RAM</summary>

Betrachte in der Zeile `Mem:` vor allem den Wert unter `available`.

</details>

<details>
<summary>Hinweis 2 – Speicher</summary>

Betrachte die Zeile mit dem Einhängepunkt `/`. Relevant sind die Spalten
`Use%` und `Avail`.

</details>

## Ergebnis einordnen

RAM und Dateisystem wirken nicht kritisch knapp. Der Rechner besitzt also
grundsätzlich Arbeitsraum und freien Speicher. Das erklärt noch nicht, warum
er träge reagiert.

Als Nächstes untersuchen wir nicht mehr nur, was das System besitzt, sondern
was gerade darauf arbeitet.
