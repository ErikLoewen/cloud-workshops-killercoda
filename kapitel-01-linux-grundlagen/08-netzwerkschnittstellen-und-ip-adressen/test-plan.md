# Testplan

## Grundsatz

Statische Prüfungen ersetzen keinen realen Killercoda-Test. Ergebnisse werden ausschließlich nach tatsächlicher Ausführung in `test-results.md` eingetragen.

## A. Szenariostart und Setup

1. Frischen Szenariostart durchführen.
2. `setup.sh` einmal ausführen.
3. `setup.sh` ein zweites Mal auf Idempotenz ausführen.
4. Prüfen, dass `/root/netzwerklabor` vorhanden ist.
5. Prüfen, dass `netzwerkstatus.txt` nach jedem Setup nicht vorhanden ist.
6. Netzwerkzustand vor und nach Setup vergleichen; Setup darf ihn nicht verändern.
7. Prüfen, dass `ip` vorhanden ist.

## B. Reale Netzwerkumgebung

8. Reale Ausgabe von `ip -brief addr` dokumentieren.
9. Reale Ausgabe von `ip route` dokumentieren.
10. Vorhandensein einer Loopback-Schnittstelle prüfen.
11. Vorhandensein von `127.0.0.1/8` auf einer Loopback-Schnittstelle prüfen.
12. Sichtbare Adressen mit Doppelpunkten dokumentieren und Teilnehmerbelastung bewerten.
13. Prüfen, dass genau eine verwendbare IPv4-Standardroute vorhanden ist.
14. Schnittstellenname hinter `dev` dokumentieren.
15. Mindestens eine Nicht-Loopback-IPv4-Adresse auf dieser Schnittstelle prüfen.
16. Prüfen, ob die Adressdarstellung einen technischen Zusatz nach `@` enthält.
17. Prüfen, ob der Name hinter `dev` und der erste Bereich der Adresszeile exakt übereinstimmen oder nur durch `@` ergänzt werden.

## C. Positive Verify-Fälle

18. Korrekte Bestandsdatei in empfohlener Reihenfolge.
19. Korrekte Datei mit anderer Schlüsselreihenfolge.
20. Mehrere Leerzeichen zwischen Schlüssel-Wert-Paaren.
21. Korrekte Datei mit jeder gültigen primären IPv4-Adresse bei mehreren Adressen.
22. Zusätzliche fachlich irrelevante Datei im Verzeichnis.
23. CHECK unmittelbar zweimal ausführen.
24. Hash der Bestandsdatei vor und nach CHECK vergleichen.
25. Netzwerkzustand vor und nach CHECK vergleichen.

## D. Negative Verify-Fälle

26. Bestandsdatei fehlt.
27. Zielpfad ist ein Verzeichnis statt einer Datei.
28. Datei ist leer.
29. Datei enthält nur Leerzeilen.
30. Datei enthält eine zusätzliche nicht leere Datenzeile.
31. Ein vorgeschriebener Schlüssel fehlt.
32. Ein Schlüssel kommt doppelt vor.
33. Ein unbekannter zusätzlicher Schlüssel ist vorhanden.
34. Ein Wert ist leer.
35. Ein Feld besitzt kein Gleichheitszeichen.
36. IPv4-Format ist ungültig.
37. Ein IPv4-Oktett ist größer als 255.
38. Präfixlänge fehlt.
39. Präfixlänge ist größer als 32.
40. Loopback-Schnittstelle ist falsch.
41. Loopback-Adresse ist falsch.
42. Primäre Schnittstelle ist falsch.
43. Dokumentierte primäre IPv4-Adresse gehört zu einer anderen Schnittstelle.
44. Simulierter Zustand ohne Standardroute.
45. Simulierter Zustand mit mehreren uneindeutigen Standardrouten.
46. Simulierte primäre Schnittstelle ohne IPv4-Adresse.

## E. Didaktische und Plattformtests

47. Realen Killercoda-Test vollständig durchführen.
48. Zeit geübter Teilnehmender messen.
49. Anfängerpilot durchführen.
50. Prüfen, dass nur der erste vollständige Aufruf von `ip -brief addr` anklickbar ist.
51. Prüfen, dass Challenge-Befehle nicht anklickbar sind.
52. Einführung von `-brief` vor der ersten Verwendung beobachten.
53. Einordnung von `addr` und `route` als Informationsbereiche beobachten.
54. Einführung doppelter Anführungszeichen vor ihrer ersten Verwendung beobachten.
55. Vorhersage zur Sichtbarkeit der Anführungszeichen stellen.
56. Prüfen, dass die Statuszeile Leerzeichen enthält.
57. Prüfen, dass die Anführungszeichen nicht im Dateiinhalt erscheinen.
58. Prüfen, dass keine alternative unkommentierte Teilnehmerform ohne Anführungszeichen gezeigt wird.
59. Prüfen, dass der CHECK nicht als vollständiger Verständnisnachweis dargestellt wird.

## F. Statische Qualitätsprüfung

60. JSON-Syntax prüfen.
61. Bash-Syntax mit `bash -n` prüfen.
62. Alle Dateireferenzen aus `index.json` prüfen.
63. Groß- und Kleinschreibung der Referenzen prüfen.
64. Ausführungsrechte prüfen.
65. Vollständige Dateiliste prüfen.
66. Ausschließen, dass eine `structure.json` vorhanden ist.
67. Prüfen, dass `setup.sh` genau einmal referenziert wird.
68. Nach internen Citation-Tokens suchen.
69. Nach abgeschnittenen oder doppelten Sätzen suchen.
70. Teilnehmertexte auf nicht eingeführte Diagnosebefehle und Shellsyntax prüfen.
71. Prüfen, dass keine externen Netzwerkziele Bestandteil einer Aufgabe sind.
72. Prüfen, dass `test-results.md` keine Ergebnisse behauptet.
