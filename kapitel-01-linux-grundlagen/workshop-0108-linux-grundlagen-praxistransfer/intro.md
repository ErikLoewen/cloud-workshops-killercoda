# 01.08 – Das fragmentierte Archiv

Der Lichtstrahl wandert über Deich und Küste. Im Regen wird eine verlassene
Laterne sichtbar. Daneben führen Fußspuren vom Leuchtturm fort.

Du folgst ihnen. Sie enden vor einer Wand am Fundament des Turms – an einem
Zugang, der dort zuvor nicht zu sehen war. Dahinter führt eine Treppe in ein
Archiv unter dem Leuchtturm.

Je tiefer du hinabsteigst, desto weniger stimmen deine Wahrnehmungen überein.
Schwarze und weiße Schlieren überlagern sich. Regenbogenfarben brechen durch
Wände, obwohl es hier keine Lichtquelle gibt. An einigen Stellen fällt Regen
innerhalb des Turms. Entfernungen und Winkel passen nicht zusammen. Bekannte
Räume wirken, als wären ihre Teile falsch zusammengesetzt.

Du kannst nicht mehr sicher sagen, ob du den Turm gerade betrittst oder an
einen Ort zurückkehrst, den du schon kennst.

> **Bildplatzhalter:** `assets/0108-einstieg-fragmentiertes-archiv.png`
>
> *Ein zunehmend abstraktes Archiv unter dem Leuchtturm, in dem schwarze und
> weiße Schlieren sowie unmögliche Farbspektren Räume und Gegenstände
> überlagern.*

## Ein überprüfbarer Zustand

Im Archiv findest du einen Stabilisierungsplan, ein ausführbares
Stabilisierungskommando, widersprüchliche Dateien und mehrere fremde
Fragmentbereiche.

Die Wahrnehmung liefert keine verlässliche Reihenfolge mehr. Die Dateien und
Prozesse des Systems lassen sich dagegen beobachten und erneut prüfen.

> Wenn die Wahrnehmung unzuverlässig wird, beginne mit einem überprüfbaren
> Zustand.

## Deine Mission

Stelle eine eindeutige Archivstruktur her und stabilisiere den Leuchtturm.
Das Stabilisierungskommando untersucht immer den aktuellen Zustand. Es
repariert nichts selbst, sondern meldet den nächsten erkannten Fehler. Nach
jeder begründeten Korrektur führst du es erneut aus.

Dies ist die Abschlussmission des Kapitels „Linux-Grundlagen“. Du kombinierst
Werkzeuge aus den bisherigen Workshops und entscheidest selbst, welches davon
zum beobachteten Problem passt. Neu kommt nur eine kleine Kombination hinzu:
Du leitest eine Prozessausgabe mit einer Pipe an `grep` weiter, um passende
Zeilen herauszufiltern.

> Dieser Workshop führt dich weniger stark als die bisherigen Übungen. Lies
> Fehlermeldungen vollständig, prüfe den aktuellen Zustand und entscheide,
> welches bekannte Werkzeug zum Problem passt.

## Lernziele

Am Ende kannst du:

- einen dokumentierten Sollzustand mit dem aktuellen Istzustand vergleichen,
- auffällige Dateien und Verzeichnisse kontrolliert untersuchen,
- Fehlermeldungen als nächsten Arbeitsauftrag nutzen,
- einen verursachenden Prozess identifizieren,
- Prozessausgaben mit `grep` filtern,
- Dateien ihrem vorgesehenen Bereich richtig zuordnen,
- den Besitzer einer Datei als Metadatum verwenden,
- eine Konfiguration sichern und gezielt bearbeiten,
- den Gesamtzustand nach jeder Änderung erneut prüfen.

## Erste Diagnose

Du startest als `waerter@leuchtturm` direkt im Archiv. Führe jetzt erstmals
das zentrale Diagnosekommando aus und lies seine vollständige Ausgabe:

`./leuchtturm-stabilisieren`{{exec}}
