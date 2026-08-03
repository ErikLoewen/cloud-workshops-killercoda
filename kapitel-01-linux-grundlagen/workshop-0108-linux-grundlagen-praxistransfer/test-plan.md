# Testplan – Workshop 0108: Das fragmentierte Archiv

## 1. Zweck und Testregeln

Dieser Plan prüft Setup, Teilnehmerweg, negative Zustände, Speedrun, CHECK,
Reset und Repositoryqualität getrennt. Jeder ausgeführte Test wird in
`test-results.md` mit Datum, Umgebung, tatsächlichem Ergebnis und Befund
dokumentiert.

Testarten:

- **statisch:** Prüfung der Repositorydateien ohne Szenariostart;
- **isoliert:** reproduzierbarer Lauf in einem frischen Ubuntu-Container;
- **Killercoda:** Prüfung in einer neuen realen Browsersitzung;
- **manuell:** sichtbare oder didaktische Beurteilung durch eine Person.

Ein isolierter Test ersetzt keine reale Killercoda-Prüfung. Dynamische Werte
wie PID, UID, Laufzeit und Zeitpunkt der Dateirückkehr werden beobachtet und
nicht fest vorgegeben.

## A. Setup und Start

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| A01 | isoliert | `setup.sh` in einer frischen Umgebung ausführen. | Exit-Code 0; keine technische Fehlermeldung; vollständiger Ausgangszustand. |
| A02 | isoliert | `setup.sh` unmittelbar ein zweites Mal ausführen. | Exit-Code 0; alter eigene Prozess sicher beendet; genau eine neue Instanz; Ausgangsbaum vollständig zurückgesetzt. |
| A03 | isoliert | `id waerter` und Passworteintrag prüfen. | Benutzer und Primärgruppe `waerter` existieren; Home `/home/waerter`; Shell `/bin/bash`. |
| A04 | Killercoda | Sichtbaren Prompt und `pwd` direkt nach Start prüfen. | Prompt `waerter@leuchtturm`; Pfad `/home/waerter/leuchtturm/archiv`; keine sichtbare Root-Shell. |
| A05 | isoliert | Eigentümer und Modi des Teilnehmerbaums mit `stat` prüfen. | Normale Verzeichnisse `waerter:waerter:755`, normale Dateien `waerter:waerter:644`, Teilnehmerwerkzeuge `0755`; gezielte Nachrichtenbesitzer aus Abschnitt F. |
| A06 | isoliert | `command -v nano` als Teilnehmer ausführen. | Nano ist ohne Installation oder `sudo` verfügbar und startbar. |
| A07 | isoliert | Ausgangsbaum mit der verbindlichen Struktur vergleichen. | Plan, Stabilisierung, Erinnerungen, fünf Nachrichten, Protokolle, Steuerung und vier Fragmente vollständig; keine unerwartete Nachrichtenvariante. |
| A08 | isoliert | Alle Ausgangsinhalte und Abschlusszeilenumbrüche gegen die Vorgaben prüfen. | Dateien sind bytegenau reproduziert und UTF-8-lesbar. |
| A09 | isoliert | Besitzer aller Teilnehmerdateien auflisten. | Ausschließlich die fünf Nachrichten besitzen die vorgesehenen abweichenden Benutzer; alle bleiben für `waerter` lesbar. |
| A10 | isoliert | `pgrep -u waerter -x altes_echo` und `/proc/PID/comm` prüfen. | Genau eine Instanz; Besitzer `waerter`; `comm` exakt `altes_echo`; erwartete installierte Executable. |
| A11 | isoliert | State-Verzeichnis nach Reset auflisten. | Nur aktuelle Session-, Prozess- und Setupdaten; keine alte PID, Sicherung, Flag-Abgabe oder Erfolgsdatei aus der vorigen Session. |
| A12 | Killercoda | Setupausgabe und Startzeit beobachten. | Keine sichtbaren Setupbefehle, Ready-Schleifen oder künstliche Wartezeit. |

## B. Fragmentbereiche

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| B01 | isoliert | Direkte Verzeichnisse `fragment_*` nach frischem Setup auflisten. | Exakt `fragment_FFD700`, `fragment_8B0000`, `fragment_D6C84B`, `fragment_7G00FF`. |
| B02 | statisch | Namen von Fragment 4 prüfen. | `7G00FF` enthält absichtlich `G`; Setup und Lerntexte verändern oder normalisieren den Namen nicht. |
| B03 | isoliert | Je Fragment genau eine erwartete Datei und ihren Inhalt prüfen. | Alle vier Dateinamen und selbst geschriebenen Inhalte stimmen bytegenau. |
| B04 | isoliert | Stabilisierung im Ausgangszustand ausführen. | Exit-Code 1; alle vier vorhandenen Fragmente werden konkret und deterministisch aufgelistet; keine spätere Diagnose erscheint. |
| B05 | isoliert | Einen Fragmentordner gezielt entfernen und erneut stabilisieren. | Exit-Code 1; nur die drei tatsächlich verbleibenden Fragmentnamen werden gemeldet. |
| B06 | isoliert | Weitere Fragmente nacheinander gezielt entfernen. | Nach jeder Teilentfernung enthält die Ausgabe ausschließlich die noch vorhandenen `fragment_*`-Verzeichnisse. |
| B07 | isoliert | Alle vier bestätigten Fragmente entfernen und stabilisieren. | Fragmentdiagnose ist bestanden; nächste Diagnose betrifft die wiederkehrende Erinnerung. |
| B08 | statisch/manuell | Lerntexte nach pauschalen Löschwegen prüfen. | Kein ausführbarer oder empfohlener `rm -rf *`; ausschließlich vollständig benannte, planbestätigte Ziele. |

## C. Wiederkehrende Datei und Prozess

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| C01 | isoliert | Nach Setup Erinnerungsbereich prüfen. | `ERINNERUNG_KEHRT_ZURUECK.txt` ist regulär, lesbar und besitzt den exakten Inhalt. |
| C02 | isoliert | Datei als `waerter` löschen und Zeit bis zur Rückkehr messen. | Datei erscheint innerhalb von 3–5 Sekunden erneut. |
| C03 | isoliert | Wiederhergestellte Datei bytegenau vergleichen. | Inhalt einschließlich `Erstellt durch: altes_echo` stimmt; Modus `0644`; Besitzer `waerter`. |
| C04 | isoliert | Prozessidentität mit `ps`, `pgrep` und `/proc` prüfen. | Name überall exakt `altes_echo`; genau eine Workshopinstanz; kaum CPU- und RAM-Verbrauch. |
| C05 | isoliert | Stabilisierung bei laufendem Prozess und vorhandener Datei ausführen. | Eigene Diagnose für Zustand A; Exit-Code 1. |
| C06 | isoliert | Datei löschen und vor ihrer Rückkehr stabilisieren. | Eigene Diagnose für Zustand B: Datei fehlt, erzeugender Vorgang läuft. |
| C07 | isoliert | Prozess kontrolliert mit `TERM` beenden, Datei bestehen lassen. | Eigene Diagnose für Zustand C: Vorgang beendet, Datei vorhanden. |
| C08 | isoliert | Eindeutig geprüfte PID mit normalem `kill PID` beenden. | Prozess endet ohne `KILL`; wartendes Kind bleibt nicht zurück; kein automatischer Neustart. |
| C09 | isoliert | Nach Prozessende Datei entfernen und mindestens 5 Sekunden kontrollieren. | Datei bleibt dauerhaft weg; keine neue `altes_echo`-Instanz. |
| C10 | isoliert | Prozess und Datei beseitigen, dann stabilisieren. | Zustand D ist bestanden; Diagnose wechselt zum Archivschlüssel. |

## D. Pipe und `grep`

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| D01 | isoliert | `ps -eo user,pid,comm | grep altes_echo` bei laufendem Prozess ausführen. | Mindestens die Zeile `waerter <dynamische PID> altes_echo` ist sichtbar. |
| D02 | isoliert | USER-, PID- und COMMAND-Spalten gegen `/proc` und `pgrep` vergleichen. | Die `altes_echo`-Zeile ist eindeutig identifizierbar; PID wird nicht fest erwartet. |
| D03 | isoliert | Pflichtbefehl wiederholt ausführen und Ausgabe prüfen. | Wegen der `comm`-Spalte bleibt nur die Zeile mit dem Suchtext im Prozessnamen; keine normale `COMMAND=grep`-Zeile. |
| D04 | statisch | Step 3 und Grafik prüfen. | Der offene Text und die Grafik verwenden vor der eigenen Ermittlung nur `SUCHTEXT` beziehungsweise `UNKNOWN`; der technische Hinweis grenzt die schematische grep-Zeile vom konkreten `comm`-Verhalten ab. |
| D05 | manuell | Gefilterte Prozesszeile auswerten lassen. | Lernende prüfen `USER`, dynamische `PID` und `COMMAND=altes_echo` gemeinsam. |
| D06 | isoliert | Speedrun ohne Ausführung eines grep-Befehls durchführen. | Speedrun und CHECK funktionieren; `grep` ist keine technische Speedrun-Voraussetzung. |

## E. Archivschlüssel

Vor den Schlüsseltests werden Fragmente, Prozess und wiederkehrende Datei
beseitigt, sofern nicht ausdrücklich ein isolierter Schlüsselprüfer verwendet
wird.

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| E01 | isoliert | Ausgangsort suchen. | Genau eine Datei unter `erinnerungen/archivschluessel.txt`; Inhalt unverändert. |
| E02 | isoliert | Stabilisierung mit Schlüssel am Ausgangsort. | Aktueller und erwarteter relativer Ort werden getrennt genannt; Exit-Code 1. |
| E03 | isoliert | `mv erinnerungen/archivschluessel.txt steuerung/` ausführen und Ziel kontrollieren. | Quelle fehlt; genau eine unveränderte Datei unter `steuerung`; nächste Diagnose wird erreicht. |
| E04 | isoliert | Schlüssel vollständig entfernen. | Eigene verständliche Fehlermeldung „fehlt“; keine automatische Neuerzeugung. |
| E05 | isoliert | Zwei identische Kopien anlegen. | Mehrdeutigkeitsdiagnose listet beide tatsächlichen Fundorte; Exit-Code 1. |
| E06 | isoliert | Einzige Datei in einen weiteren Archivbereich legen. | Unerwarteter tatsächlicher Ort und erwarteter Zielort werden genannt. |
| E07 | isoliert | Inhalt oder Dateityp am korrekten Ziel verändern. | Schlüsselprüfung schlägt als unverändertheitsbezogener Fehler fehl. |
| E08 | isoliert | Unveränderten Schlüssel eindeutig am Ziel platzieren. | Schlüsselzustand ist bestanden; Stabilisierung meldet anschließend die Konfiguration beziehungsweise Nachrichtenquelle. |

## F. Fünf letzte Nachrichten

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| F01 | isoliert | `nachrichten` nach Setup auflisten. | Genau fünf vorgesehene Dateinamen, keine weiteren Varianten. |
| F02 | isoliert | Eigentümer mit `stat` prüfen. | Reihenfolge nach Datei: `olmstead`, `root`, `waerter`, `nobody`, `daemon`. |
| F03 | isoliert | Alle fünf Dateien als `waerter` lesen. | Jede Datei regulär und lesbar, Modus `0644`. |
| F04 | statisch/manuell | Überschrift, Pfad, Zielwertanzahl, Zeilen- und Textlänge vergleichen. | Ähnliche Struktur und Plausibilität; je genau ein Wert; keine stilistisch eindeutige echte Nachricht. |
| F05 | manuell | Nur Dateinamen betrachten. | `final`, `backup` und `alt` liefern keinen belastbaren Echtheitsbeweis. |
| F06 | isoliert | `ls -l nachrichten` als Teilnehmer ausführen. | Alle fünf Besitzer sind gleichzeitig sichtbar und unterscheidbar. |
| F07 | isoliert | `whoami` mit Besitzern vergleichen und passende Datei lesen. | Kontrolliertes Kriterium führt zur Nachricht im Besitz von `waerter` und zum dokumentierten Zielwert. |
| F08 | isoliert | Besitzer manipulieren und Setup erneut ausführen. | Reset stellt alle fünf vorgesehenen Eigentümer exakt wieder her. |

## G. Sicherer Parser und `archiv-pruefen`

Alle Fälle werden aus dem Archivstamm mit
`./steuerung/archiv-pruefen` ausgeführt. Vorher und nachher werden Hashes von
Konfiguration und angewendetem Status verglichen.

| ID | Eingabe/Zustand | Erwarteter Exit-Code und Befund |
|---|---|---|
| G01 | `ERINNERUNG=fragmentiert` | 1; syntaktisch lesbarer Ausgangszustand. |
| G02 | `ERINNERUNG=strukturiert` | 1; bekannter instabiler Wert, Rückverweis auf Quellen. |
| G03 | `ERINNERUNG=eins` | 1; bekannter instabiler Wert, Rückverweis auf Quellen. |
| G04 | `ERINNERUNG=klar` | 0; stabile Konfiguration. |
| G05 | `ERINNERUNG=ungeteilt` | 1; bekannter instabiler Wert, Rückverweis auf Quellen. |
| G06 | `ERINNERUNG=vereint` | 1; bekannter instabiler Wert, Rückverweis auf Quellen. |
| G07 | `ERINNERUNG=unbekannt` | 1; vollständig unbekannter Wert. |
| G08 | Schlüssel zweimal | 1; doppelter Schlüssel konkret erkannt. |
| G09 | `ANDERER=klar` | 1; unbekannter Schlüssel konkret erkannt. |
| G10 | Leerzeichen vor oder nach `=` | 1; Formatmeldung verlangt Form ohne Leerzeichen. |
| G11 | leerer Wert | 1; leerer Wert konkret erkannt. |
| G12 | ungültige freie Zeile | 1; Zeilennummer und erwartetes Format genannt. |
| G13 | Befehlsersetzung, Semikolon oder Shell-Sonderzeichen | 1; keine Payload ausgeführt und keine Nachweisdatei erzeugt. |
| G14 | Datei fehlt | 1; fehlende Konfigurationsdatei konkret gemeldet. |
| G15 | Datei unlesbar | 1; Lesefehler konkret gemeldet. |
| G16 | Symlink statt regulärer Datei | 1; Dateityp abgelehnt. |
| G17 | Kommentare und Leerzeilen plus genau ein klarer Eintrag | 0; erlaubtes Format akzeptiert. |
| G18 | beliebiger Prüffall | Konfiguration und Status bleiben bytegenau unverändert; keine Flag-Ausgabe. |

## H. Regulärer Lernweg

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| H01 | isoliert | Vollständigen Weg aus `solution.md` ab frischem Setup durchführen; dynamische PID manuell aus geprüfter Zeile übernehmen. | Jede Stabilisierung meldet ausschließlich den nächsten erwarteten Fehler. |
| H02 | isoliert | Fragmente entfernen, Echo beenden, Datei endgültig löschen, Schlüssel verschieben, Besitzerquelle auswählen, Sicherung anlegen und Konfiguration klar setzen. | Vollständiger fachlicher Zielzustand ohne automatische Reparatur. |
| H03 | isoliert | `archiv-pruefen`, danach finale Stabilisierung ausführen. | Prüfung und Stabilisierung Exit-Code 0; exakte Erfolgsdarstellung und Flag. |
| H04 | isoliert | Ausgegebene Flag exakt mit `flag-einreichen` abgeben und CHECK starten. | Abgabe und CHECK Exit-Code 0. |
| H05 | isoliert | Finale Stabilisierung und CHECK wiederholen. | Beide bleiben erfolgreich; Missionsdateien werden nicht verändert. |
| H06 | manuell/Killercoda | Lernweg ohne vollständiges Dropdown durchführen. | Bekannte Werkzeuge werden passend ausgewählt; Sicherheitsentscheidungen können erklärt werden. |

## I. Priorisierter Speedrun

Der Speedrun wird nur intern getestet und nicht in sichtbaren Lerntexten
erklärt.

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| I01 | isoliert | Nach frischem Setup ausschließlich `printf '%s\n' 'ERINNERUNG=klar' > steuerung/archiv.conf` ausführen. | Alle vorherigen Missionszustände bleiben ungelöst. |
| I02 | isoliert | Unmittelbar `./leuchtturm-stabilisieren` ausführen. | Exit-Code 0; exakte Erfolgsdarstellung und Flag trotz Fragmenten, Echo, Datei und Schlüssel am Ausgangsort. |
| I03 | isoliert | Vor und nach Speedrun Fragmente, Prozess, Datei und Schlüssel prüfen. | Zustände wurden übersprungen, aber nicht automatisch verändert. |
| I04 | isoliert | Klare Konfiguration mit doppeltem Eintrag testen. | Kein Speedrun, keine Flag, Exit-Code 1; normale erste Fragmentdiagnose. |
| I05 | isoliert | Klare Konfiguration mit unbekanntem zusätzlichem Schlüssel testen. | Kein Speedrun, keine Flag, Exit-Code 1. |
| I06 | isoliert | Leerzeichen, leerer Wert, Sonderzeichen, Symlink und fehlende Datei einzeln testen. | Kein Syntaxfehler wird als Speedrun akzeptiert; keine Flag. |
| I07 | isoliert | Kommentare und Leerzeilen mit genau einem gültigen klaren Eintrag testen. | Parservertrag erfüllt; Speedrun erfolgreich. |
| I08 | statisch | Sichtbare Lerntexte und Dropdowns nach Speedrun-Hinweisen durchsuchen. | Keine Erwähnung; Dokumentation nur in Lösung, Trainerleitfaden und internen Tests. |

## J. Flag-Abgabe und CHECK

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| J01 | isoliert | CHECK vor Flag-Abgabe ausführen. | Exit-Code 1; verständlicher Hinweis auf Stabilisierung und Einreichung. |
| J02 | isoliert | Falsche Flag einreichen. | Exit-Code 1; kein gültiger Abgabemarker. |
| J03 | isoliert | Richtige Flag mit führendem Leerzeichen einreichen. | Exit-Code 1; exakter Vergleich. |
| J04 | isoliert | Richtige Flag mit nachgestelltem Leerzeichen einreichen. | Exit-Code 1; exakter Vergleich. |
| J05 | isoliert | Richtige Flag nach regulärem Weg einreichen. | Abgabe Exit-Code 0; aktueller sitzungsgebundener Marker; CHECK Exit-Code 0. |
| J06 | isoliert | Richtige Flag und CHECK wiederholen. | Wiederholt Exit-Code 0; keine Missionsdatei oder kein Prozess verändert. |
| J07 | isoliert | Richtige Flag nach Speedrun einreichen. | Abgabe und CHECK Exit-Code 0. |
| J08 | isoliert | Marker mit alter oder falscher Session-ID einsetzen. | CHECK Exit-Code 1. |
| J09 | statisch | `verify.sh` fachlich inspizieren. | Prüft ausschließlich aktuelle Session-ID und Flag-Abgabemarker; keine Missionszustände. |
| J10 | isoliert | Nach korrekter Abgabe Missionszustand verändern und CHECK wiederholen. | CHECK bleibt erfolgreich, weil er ausschließlich die Abgabe bestätigt. |

## K. Vollständiger Reset

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| K01 | isoliert | Regulären oder Speedrun-Zustand herstellen, Setup erneut ausführen. | Alte eindeutig eigene Prozessinstanz endet; genau eine neue Instanz mit neuer dynamischer PID. |
| K02 | isoliert | Erinnerungsdatei nach Reset prüfen. | Datei mit exaktem Ausgangsinhalt neu vorhanden. |
| K03 | isoliert | Fragmentbaum nach Reset prüfen. | Alle vier Ordner und Inhalte vollständig neu vorhanden. |
| K04 | isoliert | Schlüsselorte nach Reset suchen. | Ausschließlich `erinnerungen/archivschluessel.txt`. |
| K05 | isoliert | Nachrichten und Eigentümer nach Reset prüfen. | Genau fünf Dateien mit allen vorgesehenen Besitzern und Leserechten. |
| K06 | isoliert | `archiv.conf` bytegenau prüfen. | Kommentare, Leerzeile und `ERINNERUNG=fragmentiert` im Ausgangszustand. |
| K07 | isoliert | Vorher angelegte `archiv.conf.bak` suchen. | Sicherung vollständig entfernt. |
| K08 | isoliert | Flag-Abgabemarker und CHECK prüfen. | Alter Flagzustand entfernt; CHECK Exit-Code 1 bis zur neuen Abgabe. |
| K09 | isoliert | Fremden gleichnamigen Prozess und Sentinel außerhalb der Workshoppfade vorbereiten. | Reset verändert weder fremden Prozess noch fremde Datei. |
| K10 | isoliert | Neue Session-ID mit alter vergleichen. | Neue gültige Session-ID; alte Marker werden nicht akzeptiert. |

## L. Repository- und Sicherheitsprüfung

| ID | Art | Test und Vorgehen | Erwarteter Befund |
|---|---|---|---|
| L01 | statisch | `bash -n setup.sh verify.sh` sowie alle aus Setup erzeugten Skripte prüfen. | Keine Bash-Syntaxfehler. |
| L02 | statisch | `jq empty index.json`. | Gültiges JSON. |
| L03 | statisch | `git diff --check`. | Keine Whitespacefehler. |
| L04 | statisch | Alle `index.json`-Referenzen auf Existenz und Eindeutigkeit prüfen. | Intro, sechs Steps, Challenge, Verify und Finish vorhanden; genau ein Verify-Verweis. |
| L05 | statisch | Intro, Steps, Challenge und Finish nach `FLAG{` durchsuchen. | Keine offene Flag in sichtbaren Lerntexten; Vorkommen nur in technischen oder internen Dateien. |
| L06 | statisch | Workshopordner nach alten Szenariopfaden, Aufgaben, Prozessen und Step-Dateinamen durchsuchen. | Keine alte Workshopstruktur oder veraltete CHECK-Logik. |
| L07 | statisch | Konfigurationsparser und Aufrufer nach `source`, Punkt-Ausführung und `eval` untersuchen. | `archiv.conf` wird niemals ausgeführt; keine `eval`-Nutzung. Das Laden der eigenen `.bashrc` ist davon getrennt. |
| L08 | statisch | Lern- und Prozessskripte nach `kill <feste Zahl>` durchsuchen. | Keine feste PID; dynamische PID muss vor Nutzung validiert werden. Beispielausgaben sind klar als Beispiele markiert. |
| L09 | statisch | Löschlogik nach `rm -rf`, Wildcards und Pfadwächtern untersuchen. | Kein unvalidierter rekursiver Löschpfad; Setup löscht nur exakt geschützte statische Bäume; Lernweg nennt konkrete Ziele. |
| L10 | statisch | Nach globalem `pkill`, `killall`, ungequoteten Pfaden und `eval` suchen. | Keine unsichere Prozess- oder Shellausführung. |
| L11 | statisch | Alle Markdown-Bildreferenzen auf vorhandene Dateien prüfen. | Jede gerenderte Referenz existiert; fehlende geplante Bilder bleiben nicht rendernde Platzhalter. |
| L12 | statisch/manuell | Alle drei Workshopbilder prüfen. | Gültige PNG-Dateien; Einstieg und Abschluss passend zu Story und Alt-Text; Pipe-Grafik auf exakte Befehle und Prozesszeilen prüfen. |
| L13 | statisch | Technische Dateinamen prüfen. | Keine Leerzeichen oder Umlaute in neuen Datei- und Assetnamen. |
| L14 | Killercoda | Vollständigen Browserlauf mit Nano, Pipe-Zeichen, Dropdowns, Grafik und CHECK durchführen. | Darstellung und Terminalinteraktion funktionieren ohne sichtbare Setup-Artefakte. |

## Ergebnisdokumentation

Für jeden Lauf werden mindestens festgehalten:

```text
Datum:
Umgebung/Image:
Commit oder Arbeitsstand:
Test-ID:
Erwarteter Befund:
Tatsächlicher Befund:
Exit-Code:
Messwert, falls dynamisch:
Bestanden / fehlgeschlagen / nicht ausgeführt:
Offene Abweichung:
```

Nicht ausgeführte Browser-, TTY- oder Pilottests dürfen nicht als bestanden
markiert werden. Messwerte wie PIDs und Laufzeiten sind Evidenz eines Laufs,
keine festen Erwartungen für spätere Sitzungen.
