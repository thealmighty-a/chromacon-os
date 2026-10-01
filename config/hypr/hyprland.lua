-- ChromaCon Hyprland config.
-- Modules live in ~/.config/hypr/cc/. Theme colors come from
-- ~/.local/state/cc/theme/hypr-colors.lua (rendered by cc-theme-set).

require("cc.helpers")
require("cc.envs")
-- Monitors are per machine (cc/monitors.lua is never synced). Without one,
-- every screen gets its preferred mode, auto position and auto scale.
if not pcall(require, "cc.monitors") then
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
end
require("cc.input")
require("cc.looknfeel")
require("cc.windows")
require("cc.bindings")
require("cc.autostart")

-- Machine-local tweaks that shouldn't be shared go in cc/local.lua (optional).
pcall(require, "cc.local")
