#!/usr/bin/env bash
# Entfernt die automatische Prüfung wieder (die Entsperr-Einrichtung selbst bleibt).
set -uo pipefail
systemctl --user disable --now 1password-biometrie.path 1password-biometrie.service 2>/dev/null
rm -f ~/.config/systemd/user/1password-biometrie.{service,path} ~/.local/bin/1password-biometrie \
      ~/.local/share/applications/com.onepassword.OnePassword.desktop
systemctl --user daemon-reload
sudo systemctl disable --now 1password-biometrie-system.path 2>/dev/null
sudo rm -f /etc/systemd/system/1password-biometrie-system.{service,path} /etc/pacman.d/hooks/96-1password-biometrie.hook \
           /usr/local/sbin/1password-biometrie-system
sudo rm -rf /usr/local/share/1password-biometrie
sudo systemctl daemon-reload
echo "Automatische Prüfung entfernt."
