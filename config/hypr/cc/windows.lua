cc.window(".*", { suppress_event = "maximize" })
cc.window(".*", { tag = "+default-opacity" })

-- Fix some dragging issues with XWayland.
cc.window({ class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, { no_focus = true })

-- Terminals (the universal copy/paste binds check this tag).
cc.window("(kitty|cc\\..*)", { tag = "+terminal" })

-- Floating utility windows.
cc.window({ tag = "floating-window" }, { float = true })
cc.window({ tag = "floating-window" }, { center = true })
cc.window({ tag = "floating-window" }, { size = { 875, 600 } })
cc.window("(cc\\.btop|cc\\.wiremix|cc\\.nmtui|cc\\.bluetui|cc\\.float|Wiremix|imv|mpv|org.gnome.Calculator|org.gnome.NautilusPreviewer|xdg-desktop-portal-gtk|hyprland-run)", { tag = "+floating-window" })
cc.window({ title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)" }, { tag = "+floating-window" })

-- Media apps stay fully opaque.
cc.window("^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|imv)$", { tag = "-default-opacity" })
cc.window("^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|imv)$", { opacity = "1 1" })

-- Picture-in-picture.
cc.window({ title = "(Picture.?in.?[Pp]icture)" }, { tag = "+pip" })
cc.window({ tag = "pip" }, {
  tag = "-default-opacity",
  float = true,
  pin = true,
  size = { 600, 338 },
  keep_aspect_ratio = true,
  border_size = 0,
  opacity = "1 1",
  move = { "(monitor_w-window_w-40)", "(monitor_h*0.04)" },
})

-- chromacon-style-manager (SUPER + SHIFT + CTRL + SPACE): floating, centered.
cc.window("^cc\\.style-manager$", { float = true, center = true, size = { 1500, 900 } })

cc.window({ tag = "noidle" }, { idle_inhibit = "always" })

-- qutebrowser slightly see-through (from the old setup).
cc.window("([oO]rg\\.[qQ]utebrowser\\.[qQ]utebrowser|[qQ]utebrowser)", { tag = "-default-opacity", opacity = "0.90 0.85" })

cc.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })
