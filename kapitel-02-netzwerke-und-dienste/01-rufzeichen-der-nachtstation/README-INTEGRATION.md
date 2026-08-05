# Integration: Workshop 02.01

## Vorgesehener Zielpfad

```text
kapitel-02-netzwerke-und-dienste/
└── 01-rufzeichen-der-nachtstation/
```

## Repository-Integration

1. Den Ordner `01-rufzeichen-der-nachtstation` in das Kapitelverzeichnis kopieren.
2. Falls das Kapitel bereits eine `structure.json` besitzt, einen Eintrag ergänzen:

```json
{
  "path": "01-rufzeichen-der-nachtstation"
}
```

3. Falls das Kapitel neu ist, eine Kapitel-`structure.json` mit diesem ersten Eintrag erstellen.
4. In der Root-`structure.json` das Kapitel `kapitel-02-netzwerke-und-dienste` nur dann aufnehmen, wenn der Workshop veröffentlicht werden soll.
5. Kapitel 1 unverändert lassen.
6. `validate-package.sh` erneut im integrierten Ordner ausführen.
7. Repository-weite Prüfungen gemäß `AGENTS.md` und den lokalen Skills ausführen.
8. Erst danach in Killercoda testen.

## Technische Grundlage

Der Workshop verwendet das im technischen Pilot erfolgreich bestätigte Muster:

- selbstständiges `setup.sh` direkt als Intro-Foreground;
- keine Runtime-Assets und kein `/tmp`-Warter;
- Abschluss des Setups im Arbeitskonto `telegrafist`;
- keine externe Netzwerkabhängigkeit;
- keine feste dynamische Schnittstelle oder IPv4-Adresse.

## Dynamische Auswahlregel

Setup und Verify verwenden dieselbe deterministische Regel:

1. Geeignet sind Nicht-Loopback-Schnittstellen mit mindestens einer IPv4-Adresse.
2. Eine geeignete Schnittstelle einer IPv4-Standardroute wird bevorzugt.
3. Bei mehreren passenden Standardrouten entscheidet kleinste Metrik, danach alphabetischer Schnittstellenname.
4. Ohne passende Standardroute wird die alphabetisch erste geeignete Schnittstelle verwendet.
5. Bei mehreren IPv4-Adressen wird eine globale Adresse bevorzugt; danach folgt eine stabile Auswahl nach Bereich und numerischem Wert.

Die Standardroute ist interne Auswahltechnik. Sie wird im Teilnehmertext nicht als Lernziel eingeführt. Bei mehreren Kandidaten nennt `stationsauftrag.txt` die ausgewählte Schnittstelle.

## CHECK

Der CHECK vergleicht `stationsprotokoll.txt` mit dem aktuellen Laufzeitzustand:

- Hostname;
- Loopback-Schnittstelle;
- Loopback-Adresse;
- dynamisch ausgewählte weitere Schnittstelle;
- ihre dynamisch ausgewählte IPv4-Adresse.

Nicht geprüft werden Editor, Befehlsreihenfolge, IPv6, MAC-Adresse oder narrative Elemente.

## Offene Tests nach Integration

### Ubuntu

- Benutzer- und Hostname-Setup;
- Auswahlregel mit mehreren Schnittstellen;
- Idempotenz;
- Dateirechte;
- alle Verify-Negativfälle.

### Killercoda

- Intro-Foreground;
- Übergang zu `telegrafist`;
- tatsächliche Schnittstellenausgabe;
- Nano und Codeaktionen;
- CHECK-Rückmeldungen;
- Neustart;
- Anfängerzeit.

## Empfohlene Commit-Nachricht

```text
feat(networking): add workshop 02.01 station identity and IPv4 interfaces
```
