# Eine weitere Schnittstelle bestimmen

Die Loopback-Schnittstelle verbindet die Station mit sich selbst. Das Protokoll benötigt zusätzlich eine geeignete **weitere** Schnittstelle mit einer IPv4-Adresse.

## Stationsauftrag lesen

`cat stationsauftrag.txt`{{exec}}

In einer typischen Killercoda-Umgebung gibt es genau eine geeignete weitere Schnittstelle. Falls mehrere vorhanden sind, nennt der Stationsauftrag die für diesen Workshop intern ausgewählte Schnittstelle. Die technische Auswahlregel wird erst in einem späteren Workshop eingeordnet.

## Selbstständig untersuchen

Führe selbst aus:

```bash
ip address
```

Bestimme:

1. die im Stationsauftrag verlangte Nicht-Loopback-Schnittstelle;
2. eine `inet`-Zeile in genau diesem Abschnitt;
3. den IPv4-Teil vor dem Schrägstrich.

Wenn hinter einem Schnittstellennamen zusätzlich `@...` sichtbar ist, übernimm für das Protokoll nur den Namen vor `@`.

Noch nicht sicher? Die Hilfen bleiben geschlossen, bis du sie benötigst.

<details>
<summary>Hilfe 1: Konzept</summary>

Gesucht ist nicht der Abschnitt mit `127.0.0.1`, sondern eine andere Schnittstelle mit einer `inet`-Zeile.

</details>

<details>
<summary>Hilfe 2: Werkzeug</summary>

Verwende erneut:

```bash
ip address
```

Lies außerdem den bereits geöffneten `stationsauftrag.txt`.

</details>

<details>
<summary>Hilfe 3: Relevante Ausgabestelle</summary>

Suche den verlangten Schnittstellennamen am Beginn eines Abschnitts. Innerhalb dieses Abschnitts ist die Zeile mit `inet` entscheidend.

</details>

<details>
<summary>Hilfe 4: Nahezu vollständiger Weg</summary>

1. `cat stationsauftrag.txt`
2. `ip address`
3. passenden Schnittstellenabschnitt finden
4. IPv4-Adresse aus der `inet`-Zeile ablesen
5. den Teil hinter `/` weglassen

</details>

## Vor dem Abschluss

Formuliere für dich einen Satz:

> Ein Host kann mehrere Schnittstellen und mehrere Adressen besitzen, weil ...

Deine Erklärung wird im Finish noch einmal aufgegriffen.
