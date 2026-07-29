# Schritt 2: Lösungsplan und Schutzgrenzen

## Aufgabencluster

Ordne die bekannten Werkzeuge diesen Teilaufgaben zu:

1. Standort und Struktur untersuchen
2. Vorlage als eigenständige Datei kopieren
3. einzelne Altdatei entfernen
4. leeres Altverzeichnis entfernen
5. ausschließlich das freigegebene nicht leere Verzeichnis entfernen
6. Rechte der Prüfdatei lesen und minimal ergänzen
7. Prüfdatei aus ihrem Verzeichnis ausführen
8. CPU-Anzahl und primäre Schnittstelle bestimmen
9. eine Statuszeile erzeugen und kontrollieren
10. lokalen Server im Hintergrund starten
11. Listener und HTTP-Antwort getrennt prüfen

## Bekannter Befehlspool

**Orientierung und Dateiarbeit**

- pwd
- ls
- cd
- cat
- cp
- rm
- rmdir
- rm -r

**Rechte und Ausführung**

- ls -l
- chmod u+x
- ./dateiname

**System und Netzwerk**

- nproc
- ip route

**Dokumentation**

- echo
- doppelte Anführungszeichen
- ein einzelnes Größer-als-Zeichen

**Server und Prüfung**

- python3 -m http.server
- --bind
- 127.0.0.1
- 9090
- Hintergrundoperator
- ss -ltn
- curl

An dieser Stelle werden noch keine vollständigen Befehle mit allen Pfaden
gezeigt.

## Sicherheitsroutine vor jeder Löschhandlung

1. Standort prüfen.
2. Zielpfad lesen.
3. Zielobjekt bestätigen.
4. erwartete Wirkung vorhersagen.
5. Befehl ausführen.
6. Ergebnis und Schutzbereich kontrollieren.

Das einzige freigegebene rekursive Ziel ist:

`/root/abschlusslabor/web/temp-build`

Der Schutzbereich gehört in keinen verändernden Befehl.

## Rechteanforderung

Die Prüfdatei startet mit:

```text
-rw-r--r--
```

Am Ende benötigt der Besitzer zusätzlich das Ausführungsrecht. Gruppe und
andere behalten ausschließlich ihr Leserecht. Dateiinhalt, Besitzer und
Gruppe bleiben unverändert.

## Serveranforderung

Der Server wird als letzter verändernder Kernschritt aus folgendem
Arbeitsverzeichnis gestartet:

`/root/abschlusslabor/web`

Adresse und Port sind verbindlich:

```text
127.0.0.1:9090
```

Ein Listener zeigt, dass ein Prozess Verbindungen annehmen kann. Erst die
HTTP-Anfrage zeigt, welcher Inhalt tatsächlich geliefert wird.
