# Testplan

## Geltungsbereich

Dieser Plan prüft ausschließlich Workshop 7. Statische Prüfung ersetzt keinen realen Killercoda-Test.

## Grundregeln

- Fremde Prozesse niemals allein wegen Prozessname, Modul oder Port beenden.
- Tests mit absichtlich falschen Listenern nur in isolierter Umgebung durchführen.
- Vor und nach Verify Datei-, Prozess- und Socketzustand vergleichen.
- Killercoda-Test, Zeitmessung und Anfängerpilot getrennt protokollieren.
- Nicht ausgeführte Fälle offen als nicht getestet kennzeichnen.

## Testfälle

| Nr. | Testfall | Durchführung | Erwartung |
|---:|---|---|---|
| 1 | Frischer Szenariostart | Szenario in einer frischen Umgebung öffnen. | Setup läuft vor der ersten Teilnehmerhandlung. |
| 2 | Setup einmal ausführen | `setup.sh` einmal ausführen. | Demo-Server ist bereit; Abschlusszustand fehlt. |
| 3 | Setup zweimal auf Idempotenz testen | `setup.sh` erneut ausführen. | Eigene alte Instanz wird sicher bereinigt und neu bereitgestellt. |
| 4 | Vollständige Dateistruktur | Alle verbindlichen Workshopdateien auflisten. | Alle 16 Dateien vorhanden; keine zusätzlichen Szenariodateien. |
| 5 | Demo-Verzeichnis vorhanden | Pfad `/root/httplabor/demo` prüfen. | Verzeichnis vorhanden. |
| 6 | Demo-Datei bytegenau korrekt | Bytes von `demo/index.html` prüfen. | Exakt `Demo-Server erreichbar\n`. |
| 7 | Abschlussverzeichnis vorhanden | Pfad `/root/httplabor/abschluss` prüfen. | Verzeichnis vorhanden. |
| 8 | Abschlussdatei nach Setup nicht vorhanden | Pfad `abschluss/index.html` prüfen. | Nicht vorhanden. |
| 9 | Port 8000 vor Bereinigung prüfen | Ausgangsbelegung erfassen. | Freier Port oder sicher klassifizierbare eigene Altinstanz. |
| 10 | Port 8080 vor Bereinigung prüfen | Ausgangsbelegung erfassen. | Freier Port oder sicher klassifizierbare eigene Altinstanz. |
| 11 | Fremder Listener auf 8000 | Fremden lokalen Listener bereitstellen und Setup starten. | Setup bricht verständlich ab und beendet ihn nicht. |
| 12 | Fremder Listener auf 8080 | Fremden lokalen Listener bereitstellen und Setup starten. | Setup bricht verständlich ab und beendet ihn nicht. |
| 13 | Eigene alte Demo-Instanz bereinigen | Passenden Python-Server mit Demo-CWD auf 8000 vorab starten. | Nur diese eindeutig eigene Instanz wird beendet. |
| 14 | Eigene alte Abschlussinstanz bereinigen | Passenden Python-Server mit Abschluss-CWD auf 8080 vorab starten. | Nur diese eindeutig eigene Instanz wird beendet. |
| 15 | Demo-Server bleibt nach Setup aktiv | Nach Ende von `setup.sh` Prozess und Port erneut prüfen. | Prozess läuft weiter. |
| 16 | Demo-Listener exakt 127.0.0.1:8000 | Lokale Sockettabelle prüfen. | Genau der vorgesehene IPv4-Loopback-Listener. |
| 17 | Demo-Anfrage über 127.0.0.1 | Lokale HTTP-Anfrage ausführen. | Erfolgreiche Antwort. |
| 18 | Demo-Anfrage über localhost | Lokale HTTP-Anfrage ausführen. | Erfolgreiche Antwort. |
| 19 | Demo-Inhalt bytegenau korrekt | Antwortbytes mit Demo-Datei vergleichen. | Bytegleich. |
| 20 | `ss -ltn` reale Teilnehmerausgabe | Befehl im Zielbackend ausführen. | Adresse, Port und `LISTEN` sind verständlich sichtbar. |
| 21 | `curl` reale Teilnehmerausgabe | Demo-Anfrage ohne Option ausführen. | Nutztext ist erkennbar. |
| 22 | Verständlichkeit ohne curl-Option | Mit Anfängern beobachten. | Keine zusätzliche Option erforderlich. |
| 23 | Abschlussdatei fehlt | Verify ohne Datei starten. | Fehlschlag mit Pfad-Hinweis. |
| 24 | Abschlussdatei ist ein Verzeichnis | Verzeichnis namens `index.html` anlegen. | Fehlschlag: keine reguläre Datei. |
| 25 | Abschlussdatei leer | Leere Datei anlegen. | Bytegenauer Inhaltsfehler. |
| 26 | Falscher Inhalt | Abweichenden Text schreiben. | Bytegenauer Inhaltsfehler. |
| 27 | Fehlender abschließender Zeilenumbruch | Solltext ohne `\n` schreiben. | Fehlschlag. |
| 28 | Zusätzlicher Dateiinhalt | Weitere Bytes anhängen. | Fehlschlag. |
| 29 | Server nicht gestartet | Korrekte Datei, kein Listener. | Fehlschlag mit Listener-Hinweis. |
| 30 | Server auf falschem Port | Server auf anderem Port starten. | Port-8080-Prüfung schlägt fehl. |
| 31 | Server an 0.0.0.0 | Server auf allen IPv4-Adressen starten. | Explizite Ablehnung. |
| 32 | Reiner IPv6-Listener | Nur IPv6 auf 8080 lauschen lassen. | Explizite Ablehnung. |
| 33 | Fremder Listener auf 8080 | Nicht passenden Prozess auf 127.0.0.1:8080 verwenden. | Prozesszuordnung oder Kommandoprüfung schlägt fehl. |
| 34 | Python-Server aus falschem Arbeitsverzeichnis | Passenden Befehl aus anderem CWD starten. | Arbeitsverzeichnisprüfung schlägt fehl. |
| 35 | Python-Server mit falscher Bind-Adresse | Abweichende Bindung verwenden. | Socket- oder Argumentprüfung schlägt fehl. |
| 36 | Python-Server mit falschem Portargument | Abweichendes Portargument verwenden. | Portprüfung schlägt fehl. |
| 37 | Richtige Datei, aber falsche HTTP-Antwort | Server liefert abweichende Bytes. | Antwortvergleich schlägt fehl. |
| 38 | Verzeichnisliste statt index.html | `index.html` beim Serverstart fehlen lassen. | Antwortvergleich schlägt fehl. |
| 39 | Abschlussserver korrekt | Verbindliche Musterlösung ausführen. | Verify erfolgreich. |
| 40 | Antwort über 127.0.0.1 korrekt | Numerische Anfrage prüfen. | Bytegleich mit Abschlussdatei. |
| 41 | Antwort über localhost korrekt | Namensbasierte lokale Anfrage prüfen. | Bytegleich mit Abschlussdatei. |
| 42 | Socket-Prozess-Zuordnung | Listener-Inode über `/proc/<PID>/fd` zuordnen. | Genau ein Prozess. |
| 43 | Prozesskommandozeile | `/proc/<PID>/cmdline` auswerten. | Python, `-m http.server`, Bind-Adresse und Port vorhanden. |
| 44 | Prozessarbeitsverzeichnis | `/proc/<PID>/cwd` auswerten. | Exakt `/root/httplabor/abschluss`. |
| 45 | Wiederholter CHECK | Verify mehrfach ausführen. | Gleiches Ergebnis; kein persistenter Zustandswechsel. |
| 46 | Datei-Hash vor und nach CHECK | Hash vergleichen. | Unverändert. |
| 47 | Prozesszustand vor und nach CHECK | PID und Kommando vergleichen. | Unverändert. |
| 48 | Socketzustand vor und nach CHECK | Listener-Inode und Adresse vergleichen. | Unverändert. |
| 49 | Verify startet keinen Prozess | Prozessliste vor und nach negativem Verify vergleichen. | Kein neuer Prozess. |
| 50 | Verify beendet keinen Prozess | Bestehende Testprozesse vor und nach Verify vergleichen. | Kein Signal und kein Prozessverlust. |
| 51 | Verify verändert keine Lab-Datei | Metadaten und Hash relevanter Dateien vergleichen. | Keine Änderung. |
| 52 | Vollständiger Szenarioneustart | Umgebung verwerfen und neu starten. | Reproduzierbarer Ausgangszustand. |
| 53 | Erneuter vollständiger Durchlauf | Alle Teilnehmerhandlungen erneut ausführen. | Gleicher Zielzustand. |
| 54 | Realer Killercoda-Test | Szenario über Creator-Repository starten. | Alle Schritte, Setup und Verify funktionieren. |
| 55 | Zeitmessung geübter Teilnehmender | Bearbeitungszeit messen. | 35–40 Minuten. |
| 56 | Anfängerpilot | Absolute Anfänger beobachten. | 44–50 Minuten und mindestens 10 Minuten Puffer. |

## Freigabeblocker

- `localhost` erreicht den IPv4-Loopback-Server nicht zuverlässig.
- Socket und Prozess können im Zielbackend nicht robust zugeordnet werden, ohne die Prüfaussage anzupassen.
- Setup beendet einen fremden Prozess.
- Verify verändert Datei, Prozess oder Listener.
- Anfängerpfad überschreitet wiederholt 50 Minuten.
- Weniger als 10 Minuten Puffer verbleiben.
