#!/usr/bin/env bash
# Richtet die automatische Prüfung/Reparatur ein. Einmal im Terminal ausführen.
set -euo pipefail
cd "$(dirname "$0")"

echo "== Benutzerteil"
install -Dm755 1password-biometrie ~/.local/bin/1password-biometrie
install -Dm644 user/1password-biometrie.service ~/.config/systemd/user/1password-biometrie.service
install -Dm644 user/1password-biometrie.path    ~/.config/systemd/user/1password-biometrie.path
systemctl --user daemon-reload
systemctl --user enable --now 1password-biometrie.path
systemctl --user enable 1password-biometrie.service

echo "== Systemteil (sudo)"
tmp=$(mktemp)
sed "s/^BENUTZER=__BENUTZER__.*/BENUTZER=$(id -un)/" 1password-biometrie-system > "$tmp"
sudo install -Dm755 -o root -g root "$tmp" /usr/local/sbin/1password-biometrie-system
rm -f "$tmp"
sudo install -Dm644 polkit-1 /usr/local/share/1password-biometrie/polkit-1
sudo install -Dm644 system/1password-biometrie-system.service /etc/systemd/system/1password-biometrie-system.service
sudo install -Dm644 system/1password-biometrie-system.path    /etc/systemd/system/1password-biometrie-system.path
sudo install -Dm644 system/96-1password-biometrie.hook /etc/pacman.d/hooks/96-1password-biometrie.hook
sudo systemctl daemon-reload
sudo systemctl enable --now 1password-biometrie-system.path

echo "== Probelauf"
sudo /usr/local/sbin/1password-biometrie-system --pruefen || true
~/.local/bin/1password-biometrie            # legt auch den Startmenü-Eintrag an
~/.local/bin/1password-biometrie --pruefen || true
echo
echo "Fertig. Geprüft wird ab jetzt nach jedem pacman-Update, nach 1Password-Updates,"
echo "bei Änderungen der 1Password-Einstellungen, bei der Anmeldung und bei jedem Start"
echo "von 1Password über das Startmenü."
echo "Manuell prüfen:  1password-biometrie --pruefen"
echo "Protokoll:       journalctl -t 1password-biometrie"
