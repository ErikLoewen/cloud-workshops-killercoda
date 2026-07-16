# Abschlussaufgabe: Serverstatus dokumentieren

Ein Administrator benötigt einen kurzen Status der aktuellen Lernumgebung.

## Dein Ziel

Ermittle selbstständig:

- die Zahl der für die aktuelle Umgebung verfügbaren logischen Prozessoren;
- den gesamten sichtbaren RAM;
- den verfügbaren RAM;
- den belegten Speicherplatz des Root-Dateisystems;
- den verfügbaren Speicherplatz des Root-Dateisystems.

Du darfst die drei Diagnosebefehle in einer beliebigen fachlich sinnvollen Reihenfolge verwenden.

Erzeuge danach diese Datei:

```text
/root/ressourcenlabor/serverstatus.txt
```

Die Datei muss genau eine nicht leere Datenzeile enthalten:

```text
CPU_LOGISCH=<WERT> RAM_GESAMT=<WERT> RAM_VERFUEGBAR=<WERT> DATEISYSTEM_BELEGT=<WERT> DATEISYSTEM_VERFUEGBAR=<WERT>
```

Übernimm die tatsächlich angezeigten Werte deiner Umgebung. Bei RAM und Dateisystemspeicher gehört die angezeigte Einheit zum Wert.

## Erlaubte Werkzeuge

- `nproc`
- `free -h`
- `df -h /`
- `echo`
- ein einzelnes `>`
- `cat`

Verwende keine automatische Filterung, keine Berechnung, keine Variablen und keine Befehlsersetzung.

Kontrolliere die fertige Datei mit `cat`. Starte danach den CHECK.

## Hinweise

Öffne einen Hinweis erst nach einem eigenen Versuch.

<details>
<summary>Hinweis 1 – Ressourcen und Kategorien</summary>

Du benötigst je einen Wert für CPU sowie je zwei Werte für RAM und Dateisystemspeicher:

- logische Prozessoren;
- RAM gesamt und verfügbar;
- Dateisystem belegt und verfügbar.

</details>

<details>
<summary>Hinweis 2 – Befehle und Felder</summary>

Verwende:

- `nproc`;
- bei `free -h` die RAM-Felder `total` und `available`;
- bei `df -h /` die Felder `Used` und `Avail`.

Für die Datei verwendest du die bekannten Werkzeuge `echo`, ein einzelnes `>` und `cat`.

</details>

<details>
<summary>Hinweis 3 – Vollständiges Zeilenformat</summary>

Setze deine fünf aktuellen Werte in dieses Format ein:

```text
CPU_LOGISCH=<WERT> RAM_GESAMT=<WERT> RAM_VERFUEGBAR=<WERT> DATEISYSTEM_BELEGT=<WERT> DATEISYSTEM_VERFUEGBAR=<WERT>
```

Schreibe genau diese eine Zeile nach:

```text
/root/ressourcenlabor/serverstatus.txt
```

</details>

<details>
<summary>Hinweis 4 – Vollständiger Musterablauf</summary>

1. Führe `nproc` aus und merke dir die einzelne Zahl.
2. Führe `free -h` aus. Lies in der RAM-Zeile `total` und `available`.
3. Führe `df -h /` aus. Lies in der Zeile für `/` `Used` und `Avail`.
4. Ersetze in diesem Muster alle Wörter mit `_EINSETZEN` durch deine aktuellen Werte:

```bash
echo CPU_LOGISCH=CPU_WERT_EINSETZEN RAM_GESAMT=RAM_TOTAL_EINSETZEN RAM_VERFUEGBAR=RAM_AVAILABLE_EINSETZEN DATEISYSTEM_BELEGT=DF_USED_EINSETZEN DATEISYSTEM_VERFUEGBAR=DF_AVAIL_EINSETZEN > /root/ressourcenlabor/serverstatus.txt
```

5. Kontrolliere den Inhalt:

```bash
cat /root/ressourcenlabor/serverstatus.txt
```

Die Platzhalter sind keine Systemwerte und dürfen nicht unverändert bleiben.

</details>

## Was der CHECK bewertet

Der CHECK prüft den kleinen technischen Endzustand: Pfad, Zeilenformat, Schlüssel, Werteformate, CPU-Wert, Gesamt-RAM und robuste Plausibilitätsbeziehungen.

Die genaue Auswahl der dynamischen Felder `available`, `Used` und `Avail` wird in dieser ersten Version nicht mit ungeprüften Momentwerttoleranzen abgelehnt. Beantworte deshalb auch die Verständnisfragen im Abschluss.
