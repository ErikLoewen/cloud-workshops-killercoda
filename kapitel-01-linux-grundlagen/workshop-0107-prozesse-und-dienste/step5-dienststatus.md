# Den aktiven Dienststatus untersuchen

## Die `systemctl`-Befehlsfamilie

`systemctl` ist das Verwaltungswerkzeug.

Die Eingaben besitzen drei Bestandteile:

```text
systemctl          status          lab-demo.service
Verwaltungswerkzeug Aktion         verwaltete Unit
```

In diesem Workshop verwendest du nur drei Aktionen derselben Befehlsfamilie:

- `status`: Zustand anzeigen;
- `stop`: Dienst stoppen;
- `start`: Dienst starten.

## Aktiven Zustand anzeigen

Der Demo-Dienst wurde durch das Setup im aktiven Ausgangszustand vorbereitet.

Gib selbst ein:

`systemctl status lab-demo.service`{{}}

Betrachte ausschließlich:

- den Unit-Namen `lab-demo.service`;
- die Zeile `Active`;
- das Wort `active`.

Eine relevante Ausgabe sieht ungefähr so aus:

```text
● lab-demo.service - LabForge Demo-Dienst
     Active: active (running) since ...
```

Weitere sichtbare Angaben werden in diesem Workshop nicht systematisch ausgewertet.

## Beobachtung

1. Welches Wort steht in der `Active`-Zeile?
2. Ist `lab-demo.service` eine PID oder ein Unit-Name?
3. Was erwartest du für die `Active`-Zeile, nachdem der Dienst gestoppt wurde?
