# Kapitelabschluss

Du hast bekannte Linux-Grundlagen in einem zusammenhängenden Auftrag
kombiniert.

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
Bind-Adresse 127.0.0.1
      +
TCP-Port 9090
      ↓
lokale HTTP-Anfrage
      ↓
HTTP-Antwort mit dem Inhalt von index.html
```

Parallel dazu blieb der Schutzbereich
`/root/abschlusslabor/schutzbereich` vollständig unverändert.

## Abruffragen

1. Warum muss die Vorlage trotz der Webkopie erhalten bleiben?
2. Warum benötigen einzelne Datei, leeres Verzeichnis und nicht leeres
   Verzeichnis unterschiedliche bekannte Löschhandlungen?
3. Warum erhält ausschließlich der Besitzer das Ausführungsrecht?
4. Welche Bedeutung hat **./** beim Start der Prüfdatei?
5. Warum werden CPU-Anzahl und Schnittstellenname nicht fest vorgegeben?
6. Warum muss der Server aus dem Webverzeichnis gestartet werden?
7. Warum beweist ein Listener noch nicht den richtigen HTTP-Inhalt?
8. Welche drei Angaben müssen zwischen Serverstart, Listener und Anfrage
   zusammenpassen?

## Grenzen des technischen CHECKs

Der CHECK kann den Endzustand untersuchen. Er beweist nicht:

- dass du die Aufgabe selbstständig geplant hast
- dass du eine bestimmte Befehlsfolge verwendet hast
- dass du die Sicherheitsroutine bewusst angewendet hast
- dass du bestimmte Befehle verwendet hast
- dass du die Wirkungskette vollständig verstanden hast

Die lokalen HTTP-Anfragen des CHECKs können eine kurz sichtbare Zugriffszeile
im laufenden Serverprozess erzeugen. Sie verändern keine Teilnehmerdatei.

## Formative Selbsteinschätzung

- Ich konnte den Auftrag ohne inhaltlichen Hinweis planen.
- Ich benötigte nur eine Erinnerung an die Teilziele.
- Ich benötigte den Befehlspool.
- Ich benötigte Befehlsstrukturen.
- Ich benötigte die nahezu vollständige Methode.

Diese Einordnung ist keine Note. Sie zeigt, welche Grundlagen du weiter
üben solltest.
