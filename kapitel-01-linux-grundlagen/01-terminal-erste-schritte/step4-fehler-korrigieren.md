# Schritt 4: Eine Fehlermeldung lesen und korrigieren

Fehlermeldungen sind verwertbare Rückmeldungen. Sie zeigen, was die Shell mit deiner Eingabe nicht tun konnte.

## Absichtlicher Tippfehler

1. Klicke in das Terminal.
2. Tippe `whoam`{{}}.
3. Drücke **Enter**.

## Mögliche Fehlermeldung

Die genaue Darstellung kann leicht abweichen. Sie enthält sinngemäß:

```text
bash: whoam: command not found
```

`command not found` bedeutet: Die Shell hat keinen Befehl mit dem eingegebenen Namen gefunden.

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
root
```

## Beobachtungsfrage

Welcher Teil der Fehlermeldung half dir, die fehlerhafte Eingabe zu finden?

## Merksatz

Eine einfache Fehlermeldung ist kein Beweis für einen Schaden. Lies zuerst, welche Eingabe nicht verarbeitet werden konnte.
