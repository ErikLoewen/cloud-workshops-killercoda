# Den Dienst stoppen

Du hast den aktiven Ausgangszustand beobachtet. Jetzt veränderst du genau diesen isolierten Demo-Dienst.

## Dienst stoppen

Gib selbst ein:

`systemctl stop lab-demo.service`{{}}

Bei Erfolg erscheint häufig keine Ausgabe.

## Inaktiven Zustand anzeigen

Gib danach selbst ein:

`systemctl status lab-demo.service`{{}}

Betrachte wieder ausschließlich:

- den Unit-Namen;
- die Zeile `Active`;
- das Wort `inactive`.

Eine relevante Ausgabe sieht ungefähr so aus:

```text
● lab-demo.service - LabForge Demo-Dienst
     Active: inactive (dead) since ...
```

Der inaktive Zustand ist hier beabsichtigt und kein Szenariofehler.

## Erkläre die Zustandsänderung

Vervollständige:

> Vor dem Stoppen war die Unit …  
> Nach dem Stoppen ist die Unit …

## Dienst-Inaktiv-Teilcheck

Starte jetzt den CHECK dieses Schritts.

Der Teilcheck prüft ausschließlich:

- ein gültiger Stop der aktuellen Szenariositzung wurde registriert;
- `lab-demo.service` ist aktuell inaktiv.

Der CHECK startet den Dienst nicht wieder. Der inaktive Zustand ist die Ausgangslage der Abschlussaufgabe.
