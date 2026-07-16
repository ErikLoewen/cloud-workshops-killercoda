# Musterlösung: mögliche vollständige Methode

Diese Datei ist eine interne Qualitäts- und Trainerreferenz. Sie wird nicht
durch `index.json` als Teilnehmerschritt veröffentlicht.

## Begründete Reihenfolge

1. Zuerst werden Standort, Quelle, Arbeitsbereiche und Schutzbereich geprüft.
2. Die Vorlage wird kopiert, bevor Altobjekte entfernt werden.
3. Vor jeder Löschhandlung wird der Zielpfad erneut gelesen.
4. Die Prüfdatei erhält nur das Besitzer-Ausführungsrecht.
5. Der Systemcheck wird aus seinem Verzeichnis über den relativen Pfad
   ausgeführt.
6. Dynamische Werte werden beobachtet, bevor die Statusdatei geschrieben
   wird.
7. Der Schutzbereich wird vor dem Serverstart erneut kontrolliert.
8. Der Serverstart ist der letzte verändernde Kernschritt.
9. Listener und HTTP-Inhalt werden getrennt geprüft.

## Vollständige mögliche Methode

```bash
cd /root/abschlusslabor
pwd
ls
ls vorlage
ls web
ls pruefung
ls dokumentation
ls schutzbereich
cat vorlage/startseite.txt
cat schutzbereich/wichtig.txt

cp vorlage/startseite.txt web/index.html
cat web/index.html

pwd
ls web
rm web/alt.txt
ls web
rmdir web/leeres-archiv
ls web
rm -r web/temp-build
ls web
ls schutzbereich
cat schutzbereich/wichtig.txt

ls -l pruefung/systemcheck
chmod u+x pruefung/systemcheck
ls -l pruefung/systemcheck
cd pruefung
./systemcheck
cd ..

nproc
ip route

echo "CPU: <ANZAHL>, Schnittstelle: <NAME>" > dokumentation/status.txt
cat dokumentation/status.txt

ls schutzbereich
cat schutzbereich/wichtig.txt

cd web
python3 -m http.server --bind 127.0.0.1 9090 &
ss -ltn
curl http://localhost:9090/
```

Vor dem `echo` müssen `nproc` und `ip route` ausgeführt worden sein.
`<ANZAHL>` und `<NAME>` werden durch die beobachteten Werte ersetzt. Die
spitzen Klammern werden nicht eingegeben.

## Sicherheitsroutine

Vor `rm`, `rmdir` und `rm -r`:

1. Standort prüfen.
2. Zielpfad lesen.
3. Zielobjekt bestätigen.
4. erwartete Wirkung vorhersagen.
5. Befehl ausführen.
6. Ergebnis und Schutzbereich kontrollieren.

Einziges rekursives Ziel ist
`/root/abschlusslabor/web/temp-build`.

## Sicherer Umgang mit einem eigenen Fehlstart

Nur bei eindeutig bekannter PID aus dem unmittelbar vorherigen
Hintergrundstart:

```bash
ps
```

Die bekannte PID muss sichtbar zum eigenen Python-Server gehören. Danach darf
ausschließlich diese PID beendet werden:

```bash
kill PID
```

Anschließend:

```bash
ss -ltn
```

Ist die PID nicht eindeutig, wird kein Prozess geraten oder pauschal
beendet. Der sichere Weg ist ein vollständiger Szenarioneustart.

## Wirkungskette

```text
Vorlagendatei
      ↓
eigenständige Kopie als index.html
      ↓
bereinigter Webarbeitsbereich
      ↓
gezielt ausführbar gemachte Prüfdatei
      ↓
ausgeführter Systemcheck
      ↓
dokumentierte CPU- und Netzwerkinformation
      ↓
Python-HTTP-Serverprozess
      ↓
Arbeitsverzeichnis /root/abschlusslabor/web
      ↓
Bind-Adresse 127.0.0.1 und TCP-Port 9090
      ↓
lokale HTTP-Anfrage
      ↓
HTTP-Antwort mit dem Inhalt von index.html
```

Parallel bleibt der Schutzbereich vollständig unverändert.

## Grenzen des CHECKs

Der technische CHECK beweist nicht die verwendeten Befehle, die Reihenfolge,
die bewusste Sicherheitsroutine, selbstständige Planung oder vollständiges
Verständnis. Diese Aspekte werden formativ beobachtet und erklärt.
