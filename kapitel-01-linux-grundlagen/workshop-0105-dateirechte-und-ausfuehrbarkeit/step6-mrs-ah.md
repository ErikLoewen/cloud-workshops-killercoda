# Zu Mrs. A. H. wechseln

Wechsle mit der abgeleiteten Zugangsinformation:

```bash
su - mrs_ah
```

Verwende bei der Passwortabfrage `tabitha`. Kontrolliere anschließend wieder:

```bash
whoami
pwd
```

Erwartet werden `mrs_ah` und `/home/mrs_ah`. Der erneute Check verhindert,
dass du Rechte unter der falschen Identität veränderst.
