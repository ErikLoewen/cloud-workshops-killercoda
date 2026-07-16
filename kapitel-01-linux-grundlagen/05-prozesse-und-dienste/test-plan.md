# Testplan – Workshop 5

## Grundregeln

- Jede ausgeführte Prüfung wird erst danach in `test-results.md` dokumentiert.
- Lokale Tests werden nicht als Killercoda-Tests bezeichnet.
- Ein statischer Test ersetzt keinen realen Laufzeittest.
- Ein Killercoda-Test ersetzt keinen Anfängerpilot.
- Fremde Prozesse und Dienste dürfen nicht verändert werden.

## A. Statische Prüfung

1. Vollständige Dateiliste prüfen.
2. Bestätigen, dass keine `structure.json` existiert.
3. `index.json` syntaktisch prüfen.
4. Alle referenzierten Dateien und Assets prüfen.
5. Groß- und Kleinschreibung aller Pfade prüfen.
6. Bash-Syntax aller Shell-Dateien prüfen.
7. Python-Syntax aller Python-Dateien prüfen.
8. Ausführungsrechte prüfen.
9. Bestätigen, dass `setup.sh` nur einmal in `index.json` referenziert ist.
10. Bestätigen, dass nur `lab-worker &` anklickbar ist.
11. Teilnehmertexte auf nicht eingeführte Befehle, Aktionen, Optionen und Operatoren prüfen.
12. Nach internen Citation-Tokens, abgeschnittenen Sätzen und doppelten Nummerierungen suchen.
13. Prüfen, dass interne Qualitätsdateien nicht in `index.json` referenziert sind.
14. Prüfen, dass `test-results.md` ausschließlich eine leere Vorlage mit dem Status „noch nicht getestet“ enthält.
15. Prüfen, dass `CHANGELOG.md` nur den initialen Eintrag enthält.

## B. Lokaler technischer Test ohne systemd-Integration

1. Worker mit temporärem Zustandsverzeichnis starten.
2. Sichtbaren kurzen Prozessnamen `lab-worker` über `/proc` prüfen.
3. Ein einfaches `ps` aus demselben Terminalkontext prüfen.
4. Gezielte Prozesssuche prüfen.
5. Zweiten Worker-Start versuchen und die Sperre prüfen.
6. Worker normal beenden.
7. Startmarker, Sitzungskennung und Start-PID prüfen.
8. Prozess-Teilcheck mit angepasster Testumgebung oder äquivalenter lesender Prüfung ausführen.
9. Runner direkt starten.
10. Lifecycle-Helfer für einen geordneten Stop ausführen.
11. Stopmarker und Ereignisnummer prüfen.
12. Neuen Runner starten.
13. Start-Lifecycle-Ereignis ausführen.
14. Start-nach-Stop-Marker und Reihenfolge prüfen.
15. Unerwarteten Runner-Ausfall ohne Lifecycle-Stop simulieren; er darf keinen gültigen Stopmarker erzeugen.
16. Pager-Wrapper gegen `/usr/bin/systemctl --no-pager` vergleichen.
17. Argumentweitergabe, Standardausgabe, Standardfehler und Exit-Code des Wrappers vergleichen.

## C. Reale Killercoda-Tests

1. Frischen Szenariostart öffnen.
2. Bestätigen, dass Setup genau einmal vor der ersten Teilnehmerhandlung läuft.
3. Zu späteren Schritten und zur Challenge wechseln; Setup darf nicht erneut starten.
4. Setup manuell ein zweites Mal ausschließlich als Idempotenztest ausführen. Der zweite Aufruf muss als No-op enden und darf Sitzung, Marker, Zähler oder Dienstzustand nicht zurücksetzen. Anschließend einen neuen frischen Szenariostart für den Lernablauf verwenden.
5. Initial prüfen: `lab-demo.service` ist aktiv.
6. Initial prüfen: kein Worker-Startmarker vorhanden.
7. Initial prüfen: kein Stopmarker vorhanden.
8. Initial prüfen: kein Start-nach-Stop-Marker vorhanden.
9. `lab-worker &` ausführen.
10. Bestätigen, dass das einfache `ps` den Prozess zuverlässig zeigt.
11. Bestätigen, dass `pgrep lab-worker` genau eine PID liefert.
12. Zweiten Worker-Start versuchen; zweite laufende Instanz muss verhindert werden.
13. Worker mit normalem `kill PID` beenden.
14. Prozess-Teilcheck erfolgreich ausführen.
15. Negativtest: Worker nie gestartet.
16. Negativtest: Worker läuft noch.
17. `systemctl status lab-demo.service` ausführen; kein Pager darf erscheinen.
18. Dienst stoppen.
19. Inaktiven Teilcheck erfolgreich ausführen.
20. Negativtest: Dienst nicht gestoppt.
21. Negativtest: Dienst gestoppt, aber nicht erneut gestartet.
22. Dienst nach gültigem Stop starten.
23. Stop- und Startmarker auf richtige Ereignisreihenfolge prüfen.
24. Negativtest: aktiver Dienst ohne Stopmarker.
25. Negativtest: Startmarker vorhanden, Dienst aktuell inaktiv.
26. Unerwarteten Runner-Ausfall testen; er darf nicht ungeprüft als gültiger Teilnehmer-Stop gelten. Zusätzlich `SERVICE_RESULT`, `EXIT_CODE` und `EXIT_STATUS` für einen sauberen Stop sowie für einen Fehlerfall dokumentieren.
27. Abschluss-CHECK erfolgreich ausführen.
28. Abschluss-CHECK wiederholt ausführen.
29. Hashes aller Marker und Ereigniszähler vor und nach Verify vergleichen; keine Veränderung zulässig.
30. Fremden ähnlich benannten Prozess starten; Setup und Verify dürfen ihn nicht verändern oder bewerten.
31. Einen fremden Dienst kontrolliert bereitstellen; Workshopskripte dürfen ihn nicht verändern.
32. Vollständigen Szenarioneustart prüfen.
33. Reale Killercoda-Ausgabe des einfachen `ps` dokumentieren.
34. Reales Killercoda-systemd-Verhalten dokumentieren.
35. Pagerverhalten bei aktiver und inaktiver Unit sowie kleiner Terminalhöhe dokumentieren.
36. Mindestens 40 frische technische Starts durchführen; mindestens 38 müssen vollständig reproduzierbar sein.

## D. Zeit- und Anfängerpilot

37. Geübte Teilnehmende: Gesamtzeit und Teilzeiten messen.
38. Absolute Anfänger: Gesamtzeit, Hinweise, Fehler und Erklärungen messen.
39. Alle kritischen und regulären Teilungskriterien auswerten.

## E. Erwartete Veröffentlichungsentscheidung

Veröffentlichung blockieren, wenn:

- das einfache `ps` den Worker nicht zuverlässig zeigt;
- ein Pager erscheint;
- systemd oder die Unit nicht reproduzierbar funktionieren;
- Setup im regulären Ablauf erneut ausgeführt wird;
- Verify den Lernzustand verändert;
- ein technischer Ausfall als gültiger Stop gezählt wird;
- die Schwelle von 95 Prozent erfolgreichen technischen Frischstarts unterschritten wird.

Eine Workshopteilung wird ausschließlich nach den verbindlichen Pilotkriterien entschieden.
