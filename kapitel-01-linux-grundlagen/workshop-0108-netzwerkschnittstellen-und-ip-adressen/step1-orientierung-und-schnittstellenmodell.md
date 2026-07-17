# Schnittstellen im Systemmodell

## Ein einfaches Modell

Eine **Netzwerkschnittstelle** ist ein Verbindungspunkt, über den ein System Netzwerkverkehr verarbeitet.

Ein Linux-System kann mehrere Schnittstellen besitzen:

```text
Linux-System
│
├── Loopback-Schnittstelle
│   └── verweist auf das eigene System
│
└── weitere Netzwerkschnittstelle(n)
    └── verbinden das System mit einem Netzwerkweg
```

Eine Schnittstelle ist nicht zwingend eine einzelne physische Netzwerkkarte. Für diesen Workshop genügt das Modell des Verbindungspunkts.

## Loopback und weitere Schnittstellen

Die **Loopback-Schnittstelle** verweist auf das eigene System. Sie benötigt keine externe Netzwerkverbindung.

Weitere Schnittstellen können das System mit anderen Netzwerkwegen verbinden. Welche davon in diesem Workshop als **primär** gilt, wird später aus der Standardroute bestimmt.

Die erste Nicht-Loopback-Schnittstelle ist nicht automatisch die primäre Schnittstelle.

## Namen hängen von der Umgebung ab

Schnittstellennamen können je nach System unterschiedlich sein. Namen wie `eth0`, `ens3` oder andere technische Namen sind möglich.

Deshalb gilt:

- keinen Namen erraten;
- keinen Beispielnamen als allgemeine Regel verwenden;
- immer den aktuell angezeigten Namen übernehmen.

## Vorhersage

Erwartest du in der Ausgabe dieses Systems nur eine oder möglicherweise mehrere Netzwerkschnittstellen?

Formuliere vor dem nächsten Schritt eine kurze Begründung.
