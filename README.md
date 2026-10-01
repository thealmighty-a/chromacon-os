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

```sh
git clone https://github.com/thealmighty-a/chromacon-os ~/chromacon-os
bash ~/chromacon-os/install.sh
```

That installs packages, Hyprland config, scripts and services -- a working
(unthemed) ChromaCon desktop, no private infrastructure required.

Then bring in your own personal layer:

```sh
cc-mount-store <host> <share> /cloud [smb-username]   # mount your private store (any CIFS/SMB share)
cc-sync pull                                           # pull your themes, styles, dotfiles
cc-theme-set <name>                                    # apply a theme
```

Reboot and pick "Hyprland (uwsm-managed)" at the login screen.

`cc-mount-store` is generic -- point it at whatever server holds your own
config. `cc-sync` (in `bin/`) is a thin wrapper that expects the real sync
script and manifest at a path under your mounted store; keep that script and
your personal manifests there, not in this repo.

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
