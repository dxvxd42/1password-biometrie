# 1Password-Entsperren per Gesicht/Fingerabdruck – Selbstprüfung

Prüft nach Updates, ob 1Password sich weiterhin per Howdy (Gesicht) und fprintd
(Fingerabdruck) ohne Klick entsperren lässt, und repariert, was sich reparieren lässt.

| Was | Prüfung | Reparatur |
|---|---|---|
| `/etc/pam.d/polkit-1` mit `pam_howdy` + `pam_fprintd` | System + Benutzer | Systemteil stellt Vorlage wieder her (Sicherung `.bak-…`) |
| polkit-Regel von 1Password | System + Benutzer | `install_biometrics_policy.sh -f` |
| `security.authenticatedUnlock.automatic` in settings.json | Benutzer | wird eingetragen, sobald 1Password nicht läuft |
| „Mit Systemauthentifizierung entsperren“ an | Benutzer | nur Meldung (Einstellung hat Prüfsumme) |
| 1Password kennt die versteckte Einstellung noch | Benutzer | nur Meldung |
| PAM-Module, eingelernter Fingerabdruck | beide | nur Meldung |

Auslöser: pacman-Hook, systemd-Pfad-Units (1Password-Update in /opt, geänderte
Einstellungen), Anmeldung, Start von 1Password über das Startmenü (eigener
Startmenü-Eintrag ruft `1password-biometrie --start`).

    ./installieren.sh                 # einrichten
    1password-biometrie --pruefen     # Zustand ansehen
    journalctl -t 1password-biometrie # Protokoll
    ./rueckgaengig.sh                 # entfernen
