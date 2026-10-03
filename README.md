# ChromaCon OS

Hyprland + uwsm desktop setup, built from scratch (no Omarchy). This repo is
the **engine**: packages, Hyprland config (Lua), scripts, services, and the
theming system's templates/hooks. It deliberately does **not** include any
actual themes, colors, waybar/walker styling, or personal app configs
(browser, feeds, etc.) -- those live in a private store and get layered on
afterwards.

## What's here

| Path | What |
|---|---|
| `install.sh` | Installs everything below onto a fresh Arch + Hyprland machine |
| `packages.txt` | The full ChromaCon package list (pacman + AUR) |
| `bin/cc-*` | All the ChromaCon scripts (theme engine, launcher helpers, menu, sync, etc.) |
| `config/hypr/` | `hyprland.lua` + the `cc/` modules it requires (helpers, envs, input, looknfeel, windows, bindings, autostart) |
| `config/cc/templates/` | `.tpl` files the theme engine renders per-app (colors, not content) |
| `config/cc/hooks/theme-set.d/` | Per-app hooks run on theme change |
| `config/cc/sddm/` | Login screen theme |
| `config/systemd/user/` | Custom session units (wallpaper, OSD, walker/elephant) |
| `config/fontconfig/` | Font mapping (JetBrains Mono Nerd Font everywhere) |

Not here, on purpose: color themes, waybar/walker/hyprlock styles, qutebrowser
config, starship prompts, Claude Code settings, and anything from a NAS or
other private store. `cc-sync pull` (see below) is what brings those in, from
wherever you keep them.

## New machine

Starting from a fresh `archinstall` + base Hyprland:

1. **Packages + engine** -- no private infrastructure needed for this step:
   ```sh
   sudo pacman -S --needed git cifs-utils
   git clone https://github.com/thealmighty-a/chromacon-os ~/chromacon-os
   bash ~/chromacon-os/install.sh
   ```
   This installs the full package list, Hyprland config, `cc-*` scripts and
   services -- a working, unthemed desktop.

2. **Mount your private store** (any CIFS/SMB share -- `cc-mount-store` is
   generic and prompts for everything, nothing is hardcoded):
   ```sh
   cc-mount-store <host> <share> <mountpoint> [smb-username]
   ```

3. **Pull your personal layer**:
   ```sh
   cc-sync pull
   ```
   `cc-sync` (in `bin/`) is a thin wrapper that expects the real sync script
   and your manifests at a path under that mounted store -- keep those there,
   not in this repo. This step brings back themes, waybar/walker/hyprlock
   styles, qutebrowser config, starship prompts, and anything else you keep
   private.

4. **Apply a theme**:
   ```sh
   cc-theme-set <name>
   ```

5. **Finish up**:
   - `chmod +x ~/.local/bin/cc-*` if your sync step didn't preserve exec bits
   - drop a `~/.config/hypr/cc/monitors.lua` / `local.lua` for any
     machine-specific tweaks (both optional, never shipped here)
   - reboot and pick "Hyprland (uwsm-managed)" at the login screen

## Health, recovery and lock timing

- `cc-doctor` checks the system: Hyprland config errors, the lock screen layout,
  waybar links and module commands, services, per-app theme coverage. Exits 1 on failures.
- `cc-theme-rollback` restores the look from before the last theme change
  (`--dry-run` to preview, `list` to see snapshots). Snapshots are taken automatically.
- `cc-lock-profile normal|long|never` sets idle lock and screen-off timing.
- `cc-waybar-mode` toggles the bar/dock layout of whichever waybar theme is live.
- Editing `hyprland.lua` triggers `cc-hypr-check`, which notifies on config errors.

## Design

- **Theming**: `cc-theme-set <name>` renders `config/cc/templates/*.tpl`
  (placeholders like `{{ key }}`, keys from `cc-theme-color --all`) using a
  theme's colors, runs the hooks in `config/cc/hooks/theme-set.d/`, and
  writes everything to `~/.local/state/cc/theme/`. Every app config includes
  or imports from that output directory. Omarchy-format themes work as-is.
- **Hyprland**: `hyprland.lua` just requires the `cc/` modules in order.
  `cc/monitors.lua` and `cc/local.lua` are optional, per-machine, and never
  shipped here -- Hyprland falls back cleanly (auto layout, no local tweaks)
  when they're absent.
- **Scripts**: everything under `bin/` is self-contained; `cc-menu` is the
  entry point for most of them (apps, style, capture, toggles, keybindings).

## License

MIT -- see [LICENSE](LICENSE). Use whatever's useful, swap the theme engine
for your own colors, adapt the scripts to your own stack.
