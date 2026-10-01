-- ChromaCon keybindings.
-- Ported from the old Omarchy defaults + personal overrides. The keyboard has
-- no arrow keys, so hjkl is used for everything directional. `cc-keybinds`
-- (SUPER + APOSTROPHE) lists every bind with a description.

------------------------------------------------------------------------
-- Applications
------------------------------------------------------------------------
cc.bind("SUPER + RETURN", "Terminal", cc.launch("kitty"))
cc.bind("SUPER + SHIFT + RETURN", "Browser", cc.launch("qutebrowser"))
cc.bind("SUPER + SHIFT + B", "Browser", cc.launch("qutebrowser"))
cc.bind("SUPER + SHIFT + ALT + B", "Browser (private)", cc.launch("qutebrowser --target private-window"))
cc.bind("SUPER + SHIFT + F", "File manager", { tui = "cc-spf" })
cc.bind("SUPER + ALT + SHIFT + F", "File manager (GUI)", cc.launch("nautilus --new-window"))
cc.bind("SUPER + SHIFT + SEMICOLON", "jtui", { tui = "jtui" })
cc.bind("SUPER + SHIFT + R", "eilmeldung", { tui = "eilmeldung" })
cc.bind("SUPER + SHIFT + M", "jellyfin-tui", { tui = "jellyfin-tui" })
cc.bind("SUPER + SHIFT + V", "frogmouth", { tui = "frogmouth /cloud" })
cc.bind("SUPER + SHIFT + I", "nchat", { tui = "nchat" })
cc.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })

------------------------------------------------------------------------
-- Menus and launcher
------------------------------------------------------------------------
cc.bind("SUPER + SPACE", "App launcher", "walker")
cc.bind("SUPER + ALT + SPACE", "CC menu", "cc-menu")
cc.bind("SUPER + ESCAPE", "System menu", "cc-menu system")
cc.bind("XF86PowerOff", "System menu", "cc-menu system", { locked = true })
cc.bind("SUPER + APOSTROPHE", "Keybindings", "cc-keybinds")
cc.bind("SUPER + CTRL + E", "Emojis", "walker -m symbols")
cc.bind("SUPER + CTRL + V", "Clipboard history", "walker -m clipboard")
cc.bind("SUPER + SHIFT + CTRL + SPACE", "Style manager", {
  launch = "kitty --class=cc.style-manager -e chromacon-style-manager",
  focus = "^cc\\.style-manager$",
})
cc.bind("SUPER + SHIFT + ALT + SPACE", "Quick theme menu", "cc-menu theme")
cc.bind("SUPER + CTRL + SPACE", "Next background", "cc-bg next")
cc.bind("SUPER + SHIFT + SPACE", "Toggle top bar", "cc-toggle bar")

------------------------------------------------------------------------
-- Universal clipboard (SUPER + C/V/X work in terminals and GUI apps)
------------------------------------------------------------------------
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end
  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end
  return false
end

local function universal_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

cc.bind("SUPER + C", "Universal copy", universal_shortcut("CTRL", "C", "CTRL", "Insert"))
cc.bind("SUPER + V", "Universal paste", universal_shortcut("CTRL", "V", "SHIFT", "Insert"))
cc.bind("SUPER + X", "Universal cut", send_shortcut_once("CTRL", "X"))

------------------------------------------------------------------------
-- Windows
------------------------------------------------------------------------
cc.bind("SUPER + W", "Close window", hl.dsp.window.close())
cc.bind("SUPER + SEMICOLON", "Toggle window split", hl.dsp.layout("togglesplit"))
cc.bind("SUPER + P", "Pseudo window", hl.dsp.window.pseudo())
cc.bind("SUPER + T", "Toggle floating/tiling", hl.dsp.window.float({ action = "toggle" }))
cc.bind("SUPER + BACKSPACE", "Toggle window transparency", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))
cc.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
cc.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))

cc.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))
cc.bind("SUPER + L", "Focus right", hl.dsp.focus({ direction = "r" }))
cc.bind("SUPER + K", "Focus up", hl.dsp.focus({ direction = "u" }))
cc.bind("SUPER + J", "Focus down", hl.dsp.focus({ direction = "d" }))

cc.bind("SUPER + SHIFT + H", "Swap window left", hl.dsp.window.swap({ direction = "l" }))
cc.bind("SUPER + SHIFT + L", "Swap window right", hl.dsp.window.swap({ direction = "r" }))
cc.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
cc.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

cc.bind("ALT + TAB", "Focus next window", hl.dsp.window.cycle_next())
cc.bind("ALT + SHIFT + TAB", "Focus previous window", hl.dsp.window.cycle_next({ next = false }))
cc.bind("ALT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
cc.bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

-- Resize: code:20 is minus, code:21 is equals.
cc.bind("SUPER + code:20", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
cc.bind("SUPER + code:21", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
cc.bind("SUPER + SHIFT + code:20", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
cc.bind("SUPER + SHIFT + code:21", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
cc.bind("SUPER + ALT + code:20", "Expand window left a little", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
cc.bind("SUPER + ALT + code:21", "Shrink window left a little", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
cc.bind("SUPER + CTRL + code:20", "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
cc.bind("SUPER + CTRL + code:21", "Shrink window left a lot", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))

cc.bind("SUPER + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
cc.bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

------------------------------------------------------------------------
-- Groups
------------------------------------------------------------------------
cc.bind("SUPER + G", "Toggle window grouping", hl.dsp.group.toggle())
cc.bind("SUPER + ALT + G", "Move window out of group", hl.dsp.window.move({ out_of_group = true }))
cc.bind("SUPER + ALT + H", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
cc.bind("SUPER + ALT + L", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
cc.bind("SUPER + ALT + K", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
cc.bind("SUPER + ALT + J", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))
cc.bind("SUPER + CTRL + H", "Group focus left", hl.dsp.group.prev())
cc.bind("SUPER + CTRL + L", "Group focus right", hl.dsp.group.next())
cc.bind("SUPER + ALT + TAB", "Next window in group", hl.dsp.group.next())
cc.bind("SUPER + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())
cc.bind("SUPER + ALT + mouse_down", "Next window in group", hl.dsp.group.next())
cc.bind("SUPER + ALT + mouse_up", "Previous window in group", hl.dsp.group.prev())
for index = 1, 5 do
  cc.bind("SUPER + ALT + code:" .. tostring(index + 9), "Switch to group window " .. index, hl.dsp.group.active({ index = index }))
end

------------------------------------------------------------------------
-- Workspaces and monitors
------------------------------------------------------------------------
-- code:10..19 are the number row keys 1..0.
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  cc.bind("SUPER + " .. key, "Workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  cc.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
  cc.bind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

cc.bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
cc.bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

cc.bind("SUPER + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
cc.bind("SUPER + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
cc.bind("SUPER + CTRL + TAB", "Former workspace", hl.dsp.focus({ workspace = "previous" }))
cc.bind("SUPER + mouse_down", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
cc.bind("SUPER + mouse_up", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

cc.bind("SUPER + SHIFT + ALT + H", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
cc.bind("SUPER + SHIFT + ALT + L", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
cc.bind("SUPER + SHIFT + ALT + K", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
cc.bind("SUPER + SHIFT + ALT + J", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))
cc.bind("CTRL + ALT + TAB", "Focus next monitor", hl.dsp.focus({ monitor = "+1" }))
cc.bind("CTRL + ALT + SHIFT + TAB", "Focus previous monitor", hl.dsp.focus({ monitor = "-1" }))

------------------------------------------------------------------------
-- System
------------------------------------------------------------------------
cc.bind("SUPER + CTRL + BACKSLASH", "Lock system", "cc-lock")
cc.bind("SUPER + CTRL + I", "Toggle idle lock", "cc-toggle idle")
cc.bind("SUPER + CTRL + N", "Toggle nightlight", "cc-toggle nightlight")

cc.bind("SUPER + comma", "Dismiss last notification", "makoctl dismiss")
cc.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "makoctl dismiss --all")
cc.bind("SUPER + ALT + comma", "Invoke last notification", "makoctl invoke")
cc.bind("SUPER + SHIFT + ALT + comma", "Restore last notification", "makoctl restore")
cc.bind("SUPER + CTRL + comma", "Toggle do-not-disturb", "makoctl mode -t do-not-disturb")

cc.bind("PRINT", "Screenshot (region)", "cc-screenshot")
cc.bind("SHIFT + PRINT", "Screenshot (screen)", "cc-screenshot screen")
cc.bind("SUPER + SHIFT + PRINT", "Screenshot + annotate", "cc-screenshot edit")
cc.bind("ALT + PRINT", "Screen recording (toggle)", "cc-screenrecord")
cc.bind("ALT + SHIFT + PRINT", "Screen recording region (toggle)", "cc-screenrecord region")
cc.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")

cc.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)
cc.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

------------------------------------------------------------------------
-- Media keys
------------------------------------------------------------------------
-- cc-osd shows a themed popup (swayosd) and falls back to wpctl/brightnessctl.
cc.bind("XF86AudioRaiseVolume", "Volume up", "cc-osd volume up", { locked = true, repeating = true })
cc.bind("XF86AudioLowerVolume", "Volume down", "cc-osd volume down", { locked = true, repeating = true })
cc.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", "cc-osd volume up 1", { locked = true, repeating = true })
cc.bind("ALT + XF86AudioLowerVolume", "Volume down precise", "cc-osd volume down 1", { locked = true, repeating = true })
cc.bind("XF86AudioMute", "Mute", "cc-osd volume mute", { locked = true })
cc.bind("XF86AudioMicMute", "Mute microphone", "cc-osd mic mute", { locked = true })
cc.bind("XF86MonBrightnessUp", "Brightness up", "cc-osd brightness up", { locked = true, repeating = true })
cc.bind("XF86MonBrightnessDown", "Brightness down", "cc-osd brightness down", { locked = true, repeating = true })
cc.bind("XF86AudioNext", "Next track", "playerctl next", { locked = true })
cc.bind("XF86AudioPrev", "Previous track", "playerctl previous", { locked = true })
cc.bind("XF86AudioPlay", "Play/pause", "playerctl play-pause", { locked = true })
cc.bind("XF86AudioPause", "Play/pause", "playerctl play-pause", { locked = true })
