#!/usr/bin/env bash
# ChromaCon install: turn a fresh Arch + Hyprland install into ChromaCon.
#
# On the new machine (logged in as your normal user, network up):
#
#   git clone https://github.com/thealmighty-a/chromacon-os ~/chromacon-os
#   bash ~/chromacon-os/install.sh
#
# This script installs the ChromaCon *engine*: packages, Hyprland config,
# scripts, and services. It does NOT install your personal themes, colors,
# or app configs (qutebrowser, feeds, etc.) -- those are kept in your own
# private store and layered on afterwards with `cc-sync pull` (see step 6).
#
# Safe to re-run; each step skips what is already done.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="${CC_THEME:-}"

step() { printf '\n\033[1;36m== %s\033[0m\n' "$*"; }
[[ $EUID -ne 0 ]] || { echo "Run as your normal user (it uses sudo when needed)." >&2; exit 1; }

# ---------------------------------------------------------------------------
step "1/6 ChromaCon packages"
mkdir -p ~/.local/bin
cp -f "$REPO_DIR"/bin/* ~/.local/bin/
chmod +x ~/.local/bin/cc-*
~/.local/bin/cc-install-packages "$REPO_DIR/packages.txt"

# ---------------------------------------------------------------------------
step "2/6 Hyprland + ChromaCon config"
mkdir -p ~/.config/hypr/cc ~/.config/cc ~/.config/systemd/user ~/.config/fontconfig
cp -f "$REPO_DIR"/config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua
cp -f "$REPO_DIR"/config/hypr/cc/*.lua ~/.config/hypr/cc/
rsync -a "$REPO_DIR/config/cc/templates/" ~/.config/cc/templates/
rsync -a "$REPO_DIR/config/cc/hooks/" ~/.config/cc/hooks/
rsync -a "$REPO_DIR/config/cc/sddm/" ~/.config/cc/sddm/
rsync -a "$REPO_DIR/config/cc/waybar/" ~/.config/cc/waybar/
rsync -a "$REPO_DIR/config/cc/lock-profiles/" ~/.config/cc/lock-profiles/
cp -f "$REPO_DIR"/config/systemd/user/*.service "$REPO_DIR"/config/systemd/user/*.path ~/.config/systemd/user/
mkdir -p ~/.config/systemd/user/waybar.service.d
cp -f "$REPO_DIR"/config/systemd/user/waybar.service.d/*.conf ~/.config/systemd/user/waybar.service.d/
cp -f "$REPO_DIR"/config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
chmod +x ~/.config/cc/hooks/theme-set.d/* ~/.config/cc/waybar/scripts/*.sh 2>/dev/null || true

# Monitors (per-machine, never shipped here) and local.lua (optional machine
# tweaks) are left alone if present; Hyprland falls back cleanly without them.

# ---------------------------------------------------------------------------
step "3/6 Shell + PATH"
grep -q '.local/bin' ~/.bashrc 2>/dev/null ||
  sed -i '1i # ChromaCon scripts\nexport PATH="$HOME/.local/bin:$PATH"\n' ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
step "4/6 Session services"
systemctl --user daemon-reload
systemctl --user mask dunst.service 2>/dev/null || true
systemctl --user enable waybar.service mako.service hypridle.service hyprpolkitagent.service \
  cliphist.service elephant.service walker.service cc-bg.service cc-swayosd.service 2>/dev/null || true
systemctl --user enable --now cc-hypr-check.path 2>/dev/null || true
sudo systemctl enable --now swayosd-libinput-backend.service 2>/dev/null || true
if ! systemctl is-enabled -q display-manager.service 2>/dev/null; then
  sudo systemctl enable sddm.service
fi

# ---------------------------------------------------------------------------
step "5/6 Fonts + default apps"
fc-cache -f >/dev/null
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font Bold 11" 2>/dev/null || true
gsettings set org.gnome.desktop.interface document-font-name "JetBrainsMono Nerd Font Bold 11" 2>/dev/null || true
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Bold 11" 2>/dev/null || true
cc-set-defaults 2>/dev/null || true
cc-sddm-install 2>/dev/null || echo "login screen theme not installed; run cc-sddm-install later"

# ---------------------------------------------------------------------------
step "6/6 Your personal layer (themes, colors, dotfiles)"
cat <<'DONE'

The ChromaCon engine is installed: packages, Hyprland config, scripts and
services are in place. You have no theme applied yet -- that's expected,
it's kept in your own private config store, not this public repo.

To finish:
  1. Mount your private config store, e.g.:
       cc-mount-store <host> <share> /cloud [smb-username]
     (nothing here is specific to any one server -- it just prompts for
     whatever you point it at). Skip this if it's already mounted.
  2. Run `cc-sync pull` to pull down your themes, waybar/walker styles,
     qutebrowser config, starship prompts, etc.
  3. Run `cc-theme-set <name>` to apply a theme.
  4. Reboot (or log out) and pick "Hyprland (uwsm-managed)" at the login
     screen.

Machine-only Hyprland tweaks (monitor layout, touchpad) go in
~/.config/hypr/cc/local.lua and ~/.config/hypr/cc/monitors.lua -- both are
optional and never synced anywhere.
DONE
