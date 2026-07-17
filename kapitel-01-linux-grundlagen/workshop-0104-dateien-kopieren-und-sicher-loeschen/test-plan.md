# Testplan

## Status

Plan erstellt. Ergebnisse werden ausschließlich in einem tatsächlichen Testlauf dokumentiert.

## A. Setup, Pfadwächter und Ausgangslage

1. **Frischer Szenariostart:** Szenario in einer neuen Umgebung starten.
2. **Setup einmal:** `setup.sh` ausführen; Exit-Code 0 erwarten.
3. **Setup zweimal:** unmittelbar erneut ausführen; identischen Ausgangszustand erwarten.
4. **Statische Pfadwächter:** Guard-Funktion isoliert mit gültigem Pfad prüfen.
5. **Leerer Bereinigungspfad:** Guard-Funktion mit leerem Wert aufrufen; verständlichen Abbruch erwarten.
6. **Falscher Bereinigungspfad:** einen ungefährlichen abweichenden Wert übergeben; Abbruch erwarten.
7. **Bereinigungspfad Wurzel:** `/` übergeben; Abbruch erwarten.
8. **Bereinigungspfad Root-Verzeichnis:** `/root` übergeben; Abbruch erwarten.
9. **Symbolischer Link als Laborstamm:** `/root/dateilabor` als Link auf ein ungefährliches Testziel vorbereiten; Setup muss abbrechen und darf dem Link nicht folgen.
10. **Vollständige Ausgangsstruktur:** alle verbindlichen Verzeichnisse und Dateien prüfen.
11. **Bytegenaue Inhalte:** alle neun Textdateien gegen die verbindlichen Inhalte vergleichen.
12. **Genau ein abschließender Zeilenumbruch:** jede Textdatei binär prüfen.
13. **Demo-Kopie fehlt:** `/root/dateilabor/demo/kopie.txt` darf nicht existieren.
14. **Auftragskopie fehlt:** `bericht-kopie.txt` darf nicht existieren.
15. **Löschziele vorhanden:** `einzeldatei.txt`, `leerer-ordner`, `alt.txt`, `leeres-archiv` und `temp-projekt` müssen vorhanden sein.
16. **Externer Technikzustand:** Referenzdateien müssen ausschließlich unter `/var/lib/labforge/dateien-kopieren-und-sicher-loeschen` liegen.
17. **Kein interner Teilnehmerordner:** unter `/root/dateilabor` darf kein technisches Zustandsverzeichnis existieren.

## B. Positiver Lernweg

18. **Erfolgreicher `cp`:** Demo-Quelle nach `kopie.txt` kopieren.
19. **Quelle bleibt erhalten:** Quellpfad und Inhalt nach dem Kopieren prüfen.
20. **Kopie besitzt korrekten Inhalt:** bytegenauer Vergleich.
21. **Kopie anderer Inode:** Gerät-und-Inode-Paar von Quelle und Kopie vergleichen.
22. **Erfolgreicher `rm`:** ausschließlich `demo/einzeldatei.txt` entfernen.
23. **Erfolgreiches `rmdir`:** ausschließlich `demo/leerer-ordner` entfernen.
24. **Kontrollierter `rmdir`-Fehlversuch:** nicht leeres Demo-Verzeichnis verwenden; Fehlerstatus erwarten.
25. **Nicht leeres Verzeichnis bleibt erhalten:** Verzeichnis und `inhalt.txt` nach dem Fehler prüfen.
26. **Erfolgreicher `rm -r`:** ausschließlich `auftrag/arbeitsbereich/temp-projekt` entfernen.
27. **Korrekter Endzustand:** Kopie erzeugen, drei Auftragsziele entfernen, Schutzbereich erhalten.
28. **Positiver Verify-Fall:** Exit-Code 0 und sachliche Erfolgsmeldung erwarten.

## C. Negative Verify-Fälle

29. **Quelle fehlt:** getrennte Diagnose.
30. **Quelle verändert:** getrennte Diagnose.
31. **Quelle als Symlink:** ablehnen.
32. **Quelle ist kein regulärer Dateityp:** getrennte Diagnose.
33. **Kopie fehlt:** getrennte Diagnose.
34. **Kopie falscher Inhalt:** getrennte Diagnose.
35. **Kopie als Symlink:** ablehnen.
36. **Kopie als Verzeichnis oder anderer Typ:** getrennte Diagnose.
37. **Kopie als Hardlink derselben Quelle:** gleicher Inode muss abgelehnt werden.
38. **`alt.txt` vorhanden:** getrennte Diagnose.
39. **`leeres-archiv` vorhanden:** getrennte Diagnose.
40. **`temp-projekt` vorhanden:** getrennte Diagnose.
41. **Schutzbereich fehlt:** getrennte Diagnose.
42. **Schutzbereich als Symlink:** ablehnen.
43. **Schutzbereich falscher Objekttyp:** getrennte Diagnose.
44. **Schutzdatei fehlt:** getrennte Diagnose.
45. **Schutzdatei verändert:** getrennte Diagnose.
46. **Schutzdatei als Symlink:** ablehnen.
47. **Schutzdatei falscher Objekttyp:** getrennte Diagnose.
48. **Zusätzlicher Eintrag im Schutzbereich:** ablehnen.
49. **Zusätzliche irrelevante Datei im Arbeitsbereich:** bei sonst korrektem Zustand akzeptieren.
50. **Technische Referenz fehlt:** als technischer Fehler, nicht Teilnehmerfehler, melden.
51. **Technische Referenz beschädigt:** als technischer Fehler, nicht Teilnehmerfehler, melden.
52. **Laborstamm fehlt oder technisch nicht auswertbar:** getrennte Diagnose.

## D. Read-only- und Wiederholungstests

53. **Wiederholter CHECK:** erfolgreichen CHECK zweimal ausführen.
54. **Hashvergleich:** Inhalte aller erhaltenen Teilnehmerdateien vor und nach beiden CHECKs vergleichen.
55. **Strukturvergleich:** Pfade und Objekttypen vor und nach beiden CHECKs vergleichen.
56. **Keine Teilnehmerdatei erzeugt:** vollständige Liste vergleichen.
57. **Keine Datei entfernt:** vollständige Liste vergleichen.
58. **Kein Verzeichnis verändert:** Struktur- und Metadatenvergleich durchführen.
59. **Keine persistenten temporären Dateien:** Teilnehmerbereich und Technikzustand prüfen.

## E. Statische Teilnehmertextprüfung

60. **Nur erster `cp`-Befehl anklickbar:** genau ein `{{exec}}`, ausschließlich bei `cp quelle.txt kopie.txt`.
61. **Kein Löschbefehl anklickbar:** keine ausführbare Code-Aktion an `rm`, `rmdir` oder `rm -r`.
62. **Keine ausführbare Gefahrenzeile:** `rm -rf` darf nur in klar theoretischem Text oder dieser statischen Prüfung erscheinen und nie ein Zielargument besitzen.
63. **Keine Wildcards in Teilnehmerbefehlen:** Codeblöcke und Code-Aktionen prüfen.
64. **Keine ausgeschlossenen Optionen:** Teilnehmerdateien prüfen.
65. **Keine nicht eingeführten Teilnehmerbefehle:** sichtbare Befehlsblöcke prüfen.
66. **Keine Verkettung:** keine Pipes, Variablen, Befehlsersetzung, `&&`, `;` oder mehrere Befehle in einer Zeile.
67. **Keine gefährlichen Löschziele:** keine ausführbare Löschzeile mit einem höheren oder nicht freigegebenen Pfad.
68. **Setup genau einmal:** `index.json` enthält genau eine Referenz auf `setup.sh`.
69. **Verify nur an Challenge:** `verify.sh` ist ausschließlich am Abschlussauftrag referenziert.
70. **Interne Dateien unsichtbar:** `solution.md`, Trainer- und Testdateien sowie Changelog fehlen in `index.json`.

## F. Plattform- und Pilotprüfung

71. **Realer Killercoda-Test:** vollständiger Ablauf in frischer Killercoda-Umgebung.
72. **Setup-Reihenfolge:** bestätigen, dass Intro-`foreground` vor der ersten Teilnehmerhandlung abgeschlossen ist.
73. **Anklickbare Demo:** einziges `cp`-`exec` tatsächlich testen.
74. **Fehlermeldung:** kontrollierten `rmdir`-Fehler in der Plattformumgebung lesen.
75. **CHECK-Integration:** Erfolg und mehrere Fehlerfälle über die Killercoda-Schaltfläche prüfen.
76. **Zeitmessung geübte Teilnehmende:** Zielkorridor 32–38 Minuten.
77. **Anfängerpilot:** Zielkorridor 41–48 Minuten.
78. **Nachahmungsversuche:** Verhalten nach der Gefahrenanalyse beobachten.
79. **Schutzbereich ohne zusätzliche Erinnerung:** beobachten und dokumentieren.
80. **Hinweisstufen:** höchste benötigte Stufe dokumentieren.

## Abnahmeregel

Statische und lokale Tests ersetzen keinen realen Killercoda-Test und keinen Anfängerpilot. Eine Freigabe zur Veröffentlichung erfolgt erst nach dokumentiertem Plattformtest und didaktischem Pilot.
