# Abschlussaufgabe: Netzwerkbestand dokumentieren

## Ziel

Erstelle selbstständig die Datei:

`/root/netzwerklabor/netzwerkstatus.txt`

Sie soll genau eine nicht leere Datenzeile mit vier aktuellen Werten enthalten:

```text
LOOPBACK_INTERFACE=<WERT> LOOPBACK_IPV4=<WERT> PRIMAERE_INTERFACE=<WERT> PRIMAERE_IPV4=<WERT>
```

## Erfolgskriterien

- Die Loopback-Schnittstelle stammt aus der aktuellen Adressausgabe.
- Die Loopback-IPv4-Adresse enthält ihre Präfixlänge.
- Die primäre Schnittstelle ist der Name direkt hinter `dev` in der aktuellen `default`-Zeile.
- Die primäre IPv4-Adresse stammt aus der Zeile genau dieser Schnittstelle.
- Auch die primäre IPv4-Adresse enthält ihre Präfixlänge.
- Alle vier Platzhalter wurden durch aktuelle Werte ersetzt.
- Die Statuszeile wird mit `echo`, doppelten Anführungszeichen und einem einzelnen `>` geschrieben.
- Die Datei wird anschließend mit `cat` kontrolliert.

## Erlaubte Werkzeuge

- `ip -brief addr`
- `ip route`
- `echo`
- doppelte Anführungszeichen
- ein einzelnes `>`
- `cat`

Gib alle Befehle selbst ein. Verwende keine fiktiven Beispielwerte.

Kontrolliere nach der Dateierzeugung:

- Die vollständige Statuszeile wurde geschrieben.
- Zwischen den Schlüssel-Wert-Paaren stehen Leerzeichen.
- Die doppelten Anführungszeichen stehen nicht im Dateiinhalt.

Führe danach den CHECK aus.

<details>
<summary>Hinweis 1 – Konzept</summary>

Die Adressausgabe liefert Schnittstellen und Adressen. Die Standardroute bestimmt die primäre Schnittstelle. Die Bestandsdatei benötigt vier Werte.

</details>

<details>
<summary>Hinweis 2 – Werkzeuge</summary>

Nutze `ip -brief addr` und `ip route`. Suche in der Routenausgabe `default` und `dev`. Schreibe die gemeinsame Statuszeile mit `echo`, doppelten Anführungszeichen und `>` und kontrolliere sie mit `cat`.

</details>

<details>
<summary>Hinweis 3 – Struktur</summary>

```text
LOOPBACK_INTERFACE=<WERT> LOOPBACK_IPV4=<WERT> PRIMAERE_INTERFACE=<WERT> PRIMAERE_IPV4=<WERT>
```

Beide Adressen benötigen ihre Präfixlänge. Die vier Werte werden in eine gemeinsame Textzeile geschrieben. Die doppelten Anführungszeichen begrenzen den zusammengehörigen Text.

</details>

<details>
<summary>Hinweis 4 – Vollständige Methode</summary>

1. Führe `ip -brief addr` aus.
2. Notiere die Loopback-Schnittstelle und ihre IPv4-Adresse einschließlich Präfixlänge.
3. Führe `ip route` aus.
4. Notiere in der `default`-Zeile den Namen direkt hinter `dev`.
5. Suche diesen Namen in `ip -brief addr`.
6. Notiere dort eine IPv4-Adresse einschließlich Präfixlänge.
7. Ersetze alle Platzhalter in dieser Form durch deine tatsächlichen Werte:

```bash
echo "LOOPBACK_INTERFACE=<AKTUELLER_WERT> LOOPBACK_IPV4=<AKTUELLER_WERT> PRIMAERE_INTERFACE=<AKTUELLER_WERT> PRIMAERE_IPV4=<AKTUELLER_WERT>" > /root/netzwerklabor/netzwerkstatus.txt
```

8. Kontrolliere die Datei mit `cat`.
9. Führe den CHECK erneut aus.

Die Platzhalter sind keine wörtliche Lösung.

</details>
