# Schritt 5: Kein Grund zur Panik – einen Tippfehler korrigieren

Auch im Leuchtturm vertippt man sich. Fehlermeldungen sind normale,
verwertbare Rückmeldungen. Sie zeigen, was die Shell mit deiner Eingabe nicht
tun konnte.

## Ein absichtlicher Tippfehler

1. Klicke in das Terminal.
2. Tippe `whoam`{{}}.
3. Drücke **Enter**.

## Mögliche Fehlermeldung

Die genaue Darstellung kann leicht abweichen. Sie enthält sinngemäß:

```text
bash: whoam: command not found
```

`command not found` bedeutet: Die Shell hat keinen Befehl mit dem eingegebenen
Namen gefunden. Das System ist deshalb nicht beschädigt.

## Diagnose

Vergleiche `whoam` mit dem bereits verwendeten `whoami`.

Welches Zeichen fehlt?

## Vorherige Eingabe zurückholen

1. Drücke einmal die **Pfeiltaste nach oben**.
2. Prüfe, ob `whoam` wieder in der Eingabezeile erscheint.
3. Ergänze am Ende das fehlende `i`.
4. Drücke **Enter**.

## Erwartete Ausgabe

```text
waerter
```

## Beobachtungsfrage

Welcher Teil der Fehlermeldung half dir, die fehlerhafte Eingabe zu finden?

## Merksatz

**Keine Panik vorm Terminal:** Lies zuerst, welche Eingabe nicht verarbeitet
werden konnte. Meist gibt dir die Meldung bereits einen Hinweis.
