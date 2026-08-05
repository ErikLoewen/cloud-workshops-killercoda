# Die Anschlüsse der Station: `ip address`

Eine **Netzwerkschnittstelle** ist die vom Betriebssystem dargestellte Verbindungsmöglichkeit eines Hosts. Ein Host kann mehrere Schnittstellen besitzen.

Eine **IPv4-Adresse** besteht aus vier durch Punkte getrennten Zahlen, zum Beispiel in der Form:

```text
<Zahl>.<Zahl>.<Zahl>.<Zahl>
```

## Neuer Befehl

`ip address` beantwortet vier Fragen:

1. **Was macht der Befehl?**  
   Er zeigt Netzwerkschnittstellen und die ihnen zugeordneten Adressen.
2. **Warum brauchen wir ihn?**  
   Das Stationsprotokoll benötigt eine Schnittstelle und die dazugehörige IPv4-Adresse.
3. **Welche Ausgabe erwarten wir?**  
   Mehrere Abschnitte. Ein Abschnitt beginnt mit einer Schnittstelle. IPv4-Zeilen beginnen mit `inet`.
4. **Welche Fehlinterpretation ist typisch?**  
   Nicht jede Zahl ist eine IPv4-Adresse. Für diesen Workshop sind die Zeilen mit `inet` relevant. Zeilen mit `inet6` dürfen sichtbar sein, gehören aber nicht zum Lernziel.

## Reduzierte Beispielausgabe

```text
1: rueckkanal: <weitere Angaben>
    inet 127.0.0.1/8 <weitere Angaben>
2: signal0: <weitere Angaben>
    inet <IPv4-Adresse>/<Zahl> <weitere Angaben>
```

So liest du das Beispiel:

- `rueckkanal` und `signal0` stehen an den Anfängen zweier Schnittstellenabschnitte.
- `inet` kündigt eine IPv4-Adresse an.
- Hinter der Adresse kann ein `/` mit einer Zahl folgen. Für das Stationsprotokoll übernimmst du nur den Teil **vor** dem Schrägstrich. Die Zahl wird in diesem Workshop nicht berechnet oder erklärt.

## Tatsächliche Ausgabe beobachten

`ip address`{{exec}}

Die wirkliche Ausgabe ist länger als das Beispiel. Suche zunächst nur:

- die Anfänge der Schnittstellenabschnitte;
- Zeilen, die mit `inet` beginnen.

<details>
<summary>Hilfe: IPv4 und IPv6 auseinanderhalten</summary>

- `inet` kennzeichnet hier eine IPv4-Adresse.
- `inet6` kennzeichnet eine IPv6-Adresse.

IPv6 darf sichtbar bleiben. Du musst es weder dokumentieren noch erklären.

</details>

## Beobachtungsfrage

Siehst du mindestens zwei Schnittstellenabschnitte oder mindestens zwei Adresszeilen?
