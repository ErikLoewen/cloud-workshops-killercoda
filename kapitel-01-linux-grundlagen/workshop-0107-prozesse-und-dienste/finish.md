# Workshop abgeschlossen

Du hast:

- ein Lab-Programm gestartet und seine laufende Instanz als Prozess betrachtet;
- Prozessname und momentane PID unterschieden;
- die Wirkung von `&` beobachtet;
- den Prozess gezielt gefunden und kontrolliert beendet;
- Prozess, Dienst und Service-Unit unterschieden;
- den Demo-Dienst gestoppt und wieder gestartet;
- den aktiven Endzustand geprüft.

## Fachlicher Abruf

Beantworte zum Abschluss:

1. Was ist der Unterschied zwischen einem Programm und einem Prozess?
2. Warum kann `lab-worker` nach einem neuen Start eine andere PID besitzen?
3. Was bewirkt `&` am Ende einer Eingabe?
4. Warum beweist ein sichtbarer Prompt nicht das Ende eines Hintergrundprozesses?
5. Warum ist `lab-demo.service` keine PID?
6. Welche drei Aktionen der `systemctl`-Befehlsfamilie hast du verwendet?
7. Was bedeuten `active` und `inactive` in diesem Workshop?

## Grenze des technischen CHECKs

Der CHECK hat technisch nur nachgewiesen:

- `lab-worker` wurde in der aktuellen Szenariositzung mindestens einmal gestartet;
- am Ende lief keine eigene `lab-worker`-Instanz;
- der isolierte Dienst durchlief einen registrierten Stop und einen danach registrierten Start;
- der Dienst war am Ende aktiv und besaß einen gültigen eigenen Prozess.

Der CHECK kann nicht technisch beweisen, dass du `&`, `ps`, `pgrep` oder `kill` verwendet, die PID selbstständig abgelesen oder die Begriffe richtig erklärt hast. Diese Lernziele werden durch deine tatsächlichen Handlungen und Antworten geprüft.
