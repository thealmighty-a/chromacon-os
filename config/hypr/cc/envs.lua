local home = os.getenv("HOME") or ""

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("TERMINAL", "kitty")

-- cc-* scripts live in ~/.local/bin.
local bin = home .. "/.local/bin"
local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
if not (":" .. path .. ":"):find(":" .. bin .. ":", 1, true) then
  hl.env("PATH", bin .. ":" .. path)
end

hl.config({
  xwayland = { force_zero_scaling = true },
  ecosystem = { no_update_news = true },
})
