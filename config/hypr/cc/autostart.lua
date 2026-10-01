-- Waybar, mako, hypridle, elephant, walker, the wallpaper (cc-bg), the polkit
-- agent and the clipboard watcher are systemd user services tied to
-- graphical-session.target (enabled once; uwsm starts that target at login).
-- Check them with: systemctl --user status waybar walker elephant
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd(cc.launch("udiskie --automount --no-notify --no-tray"))
end)
