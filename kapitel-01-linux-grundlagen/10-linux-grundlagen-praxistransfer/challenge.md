# Challenge: Mini-Serverauftrag

Bearbeite den vollständigen Auftrag möglichst selbstständig. Verwende die
Hinweise erst, wenn dein eigener Plan nicht weiterführt.

## Vollständiger Auftrag

1. Wechsle nach `/root/abschlusslabor`.
2. Untersuche die vorbereitete Struktur.
3. Ordne Vorlage, Arbeitsbereiche und Schutzbereich zu.
4. Kopiere `vorlage/startseite.txt` als eigenständige Datei
   `web/index.html`.
5. Kontrolliere Quelle und Kopie.
6. Entferne `web/alt.txt` als einzelne Datei.
7. Entferne `web/leeres-archiv` als leeres Verzeichnis.
8. Entferne ausschließlich `web/temp-build` rekursiv.
9. Kontrolliere Vorlage und Schutzbereich.
10. Untersuche die Rechte von `pruefung/systemcheck`.
11. Ergänze ausschließlich das Besitzer-Ausführungsrecht.
12. Kontrolliere die neue Rechteanzeige.
13. Wechsle in das Verzeichnis `pruefung`.
14. Führe die Datei mit folgender relativer Form aus:

```bash
./systemcheck
```

15. Beobachte die festgelegte Erfolgsmeldung.
16. Kehre nach `/root/abschlusslabor` zurück.
17. Bestimme die aktuelle Anzahl logischer Prozessoren:

```bash
nproc
```

18. Zeige die aktuellen Routen:

```bash
ip route
```

19. Finde die eindeutig verwendbare Zeile mit `default` und übernimm den
    Schnittstellennamen direkt hinter `dev`.
20. Erzeuge `dokumentation/status.txt` in dieser Form:

```bash
echo "CPU: <ANZAHL>, Schnittstelle: <NAME>" > dokumentation/status.txt
```

`<ANZAHL>` und `<NAME>` sind Platzhalter. Die spitzen Klammern werden
nicht eingegeben. Setze die tatsächlich beobachteten Werte ein. Die gesamte
Zeile steht in doppelten Anführungszeichen. Verwende genau ein
Größer-als-Zeichen. Eine Ergänzung an eine bestehende Datei ist nicht nötig.

21. Kontrolliere die Statusdatei mit **cat**.
22. Kontrolliere den Schutzbereich erneut.
23. Wechsle nach `/root/abschlusslabor/web`.
24. Starte den Server als letzten verändernden Kernschritt:

```bash
python3 -m http.server --bind 127.0.0.1 9090 &
```

25. Prüfe den Listener:

```bash
ss -ltn
```

26. Prüfe den ausgelieferten Inhalt:

```bash
curl http://localhost:9090/
```

27. Löse anschließend den technischen CHECK aus.
28. Erkläre nach erfolgreichem CHECK die Wirkungskette.

Der technische CHECK akzeptiert fachlich gültige alternative Reihenfolgen,
sofern alle Voraussetzungen erfüllt sind, nur freigegebene Ziele verändert
werden und der vollständige Endzustand erreicht wird.

## Erfolgskriterien

- Vorlage und Schutzbereich sind unverändert.
- `index.html` ist eine eigenständige Kopie und kein Link.
- Alle drei freigegebenen Altobjekte fehlen.
- Die Prüfdatei besitzt nur das zusätzlich geforderte Besitzerrecht.
- Der Systemcheck wurde ausgeführt.
- Die Statusdatei enthält genau die aktuellen dynamischen Werte.
- Der Serverprozess läuft aus dem richtigen Webverzeichnis.
- Er lauscht ausschließlich an `127.0.0.1:9090`.
- Beide lokalen HTTP-Prüfungen des CHECKs liefern den Inhalt von
  `index.html`.

<details>
<summary>Hinweis 1 – Teilziele anzeigen</summary>

- Vorlage kopieren
- drei Altobjekte passend zur Objektart entfernen
- Prüfdatei minimal ausführbar machen und ausführen
- CPU und primäre Schnittstelle dokumentieren
- lokalen Server starten
- Listener und Antwort prüfen
- Schutzbereich unverändert lassen

</details>

<details>
<summary>Hinweis 2 – Befehlspool anzeigen</summary>

**Dateien**

- cp
- rm
- rmdir
- rm -r

**Rechte**

- ls -l
- chmod u+x
- ./dateiname

**System und Netzwerk**

- nproc
- ip route

**Dokumentation**

- echo
- ein einzelnes Größer-als-Zeichen
- cat

**Server**

- python3 -m http.server
- --bind
- 127.0.0.1
- 9090
- Hintergrundoperator
- ss -ltn
- curl

Die vollständigen Pfade und Befehlszeilen musst du weiterhin selbst
zusammensetzen.

</details>

<details>
<summary>Hinweis 3 – Befehlsstrukturen anzeigen</summary>

```text
cp <QUELLE> <ZIEL>

rm <EINZELDATEI>

rmdir <LEERES_VERZEICHNIS>

rm -r <FREIGEGEBENES_NICHT_LEERES_VERZEICHNIS>

chmod u+x <DATEI>

./<DATEI>

echo "CPU: <ANZAHL>, Schnittstelle: <NAME>" > <STATUSDATEI>

python3 -m http.server --bind 127.0.0.1 <PORT> &

ss -ltn

curl http://localhost:<PORT>/
```

Platzhalter werden nicht wörtlich eingegeben. Werte stammen aus dem Auftrag
oder aus den beobachteten Ausgaben. Spitze Klammern werden nicht eingegeben.
Der Schutzbereich gehört in keinen verändernden Befehl. Jeder Befehl steht
einzeln.

</details>

<details>
<summary>Hinweis 4 – vollständige mögliche Methode anzeigen</summary>

Öffne diese Methode erst nach einem eigenen Versuch. Sie zeigt nur eine
fachlich gültige Reihenfolge.

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

Vor der Statuszeile müssen **nproc** und **ip route** ausgeführt worden sein.
Ersetze `<ANZAHL>` und `<NAME>` durch die beobachteten Werte und gib keine
spitzen Klammern ein.

</details>

## Troubleshooting: eigener Server wurde falsch gestartet

Dieser Abschnitt gehört nicht zum normalen Lösungsweg.

Verwende die Prozessbeendigung nur, wenn die beim unmittelbar vorherigen
Hintergrundstart angezeigte PID eindeutig bekannt ist.

1. Führe **ps** ohne zusätzliche Option aus.
2. Prüfe, ob die bekannte PID zu deinem gerade gestarteten Python-Server
   gehört.
3. Beende ausschließlich diese eindeutige PID:

```bash
kill PID
```

4. Prüfe mit **ss -ltn**, dass Port `9090` nicht mehr lauscht.
5. Wechsle in das richtige Webverzeichnis.
6. Starte den verbindlichen Server erneut.
7. Prüfe Listener und HTTP-Inhalt erneut.

Ist die PID nicht eindeutig bekannt oder lassen sich mehrere Prozesse nicht
sicher unterscheiden, beende keinen Prozess auf Verdacht. Starte stattdessen
das vollständige Szenario neu.
