# Testplan

Jeder Test erhält Datum, Umgebung, erwartetes Ergebnis, tatsächliches Ergebnis und Befund. Statische, lokale, Killercoda- und Pilottests werden getrennt ausgewiesen.

1. **Frischer Szenariostart**
2. **Setup einmal**
3. **Setup zweimal**
4. **Pfadwächter**
5. **Leerer Bereinigungspfad**
6. **Falscher Bereinigungspfad**
7. **Pfad /**
8. **Pfad /root**
9. **Pfad /var**
10. **Pfad /var/lib**
11. **Teilnehmerstamm als Symlink**
12. **Technikstamm als Symlink**
13. **Vollständige Ausgangsstruktur**
14. **Alle Inhalte bytegenau**
15. **Alle Abschlusszeilenumbrüche**
16. **Ausgangsmodi**
17. **Ausgangs-UID und -GID**
18. **Marker anfangs nicht vorhanden**
19. **index.html anfangs nicht vorhanden**
20. **status.txt anfangs nicht vorhanden**
21. **Altobjekte anfangs vorhanden**
22. **Schutzbereich vollständig**
23. **Port 9090 frei**
24. **Fremder Listener wird nicht beendet**
25. **Eindeutig eigener Altserver wird sicher erkannt**
26. **Vorlage kopiert**
27. **Quelle erhalten**
28. **Anderer Inode**
29. **Hardlink abgelehnt**
30. **Symlink abgelehnt**
31. **alt.txt entfernt**
32. **leeres-archiv entfernt**
33. **temp-build entfernt**
34. **Schutzbereich nach Dateiarbeit unverändert**
35. **chmod-Zielzustand mit ausschließlich zusätzlichem Besitzer-Ausführungsrecht**
36. **Gruppe ohne Ausführungsrecht**
37. **Andere ohne Ausführungsrecht**
38. **systemcheck direkt ausgeführt**
39. **Terminalausgabe korrekt**
40. **Marker korrekt**
41. **nproc dynamisch**
42. **Workshop-8-Schnittstellenlogik identisch**
43. **Korrekte Statusdatei**
44. **Falsche CPU abgelehnt**
45. **Falsche Schnittstelle abgelehnt**
46. **Platzhalter abgelehnt**
47. **Falsches Format abgelehnt**
48. **Mehrere Zeilen abgelehnt**
49. **Fehlender Abschlusszeilenumbruch abgelehnt**
50. **Server aus richtigem Verzeichnis**
51. **Listener exakt 127.0.0.1:9090**
52. **0.0.0.0 abgelehnt**
53. **IPv6-Wildcard abgelehnt**
54. **Zusätzlicher Listener abgelehnt**
55. **Fremder Listener abgelehnt**
56. **Prozesskommando geprüft**
57. **Arbeitsverzeichnis geprüft**
58. **HTTP über 127.0.0.1**
59. **HTTP über localhost**
60. **Antwort bytegenau**
61. **Server aus falschem Verzeichnis**
62. **Falscher Port**
63. **Falsche Bind-Adresse**
64. **Falscher Inhalt**
65. **Sichere Wiederherstellung mit bekannter PID**
66. **Neustart bei unklarer PID**
67. **Schutzdatei verändert**
68. **Schutzrechte verändert**
69. **Schutz-UID verändert**
70. **Schutz-GID verändert**
71. **Zusätzlicher Schutzeintrag**
72. **Wiederholter CHECK**
73. **Hashvergleich vor und nach CHECK**
74. **Modusvergleich vor und nach CHECK**
75. **UID-/GID-Vergleich vor und nach CHECK**
76. **Strukturvergleich vor und nach CHECK**
77. **Prozessvergleich vor und nach CHECK**
78. **Verify führt systemcheck nicht aus**
79. **Verify erzeugt keinen Marker**
80. **Verify verändert keine Rechte**
81. **Verify startet keinen dauerhaften Prozess**
82. **Verify beendet keinen Prozess**
83. **Verify repariert keinen Server**
84. **HTTP-CHECK erzeugt höchstens flüchtige Serverausgabe**
85. **Szenarioneustart**
86. **Test auf noexec**
87. **Test von /usr/bin/env bash**
88. **Realer Killercoda-Test**
89. **Zeitmessung geübt**
90. **Anfängerpilot**
91. **Hinweisstufen dokumentieren**
92. **Schutzbereich ohne Erinnerung beachtet**
93. **Wirkungskette erklärt**

## Besondere Abnahmeregeln

- Ein lokaler Pfadsubstitutionstest ist kein realer Killercoda-Test.
- Ein realer Killercoda-Test muss in einer frischen Sitzung erfolgen.
- Ein Anfängerpilot darf nur mit tatsächlichen absoluten Anfängern als durchgeführt gelten.
- Vorher-Nachher-Vergleiche erfassen Pfade, Inhalte, Modi, numerische UID und GID sowie den laufenden Serverprozess.
- HTTP-Anfragen dürfen nur flüchtige Zugriffszeilen erzeugen und keine Teilnehmerdatei verändern.
- Bei fehlender eindeutiger Standardroute wird der Test als technischer Szenariofehler und nicht als Teilnehmerfehler bewertet.
