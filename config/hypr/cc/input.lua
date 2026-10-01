hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "compose:caps,shift:both_capslock_cancel",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,
    touchpad = {
      natural_scroll = false,
      clickfinger_behavior = true,
      scroll_factor = 0.4,
    },
  },
  misc = {
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})

cc.window("(kitty|cc\\..*)", { scroll_touchpad = 1.5 })
