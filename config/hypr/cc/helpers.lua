-- Shared helpers (the `cc` global).

cc = cc or {}

function cc.quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

-- Run a GUI app as its own systemd unit (uwsm session).
function cc.launch(command)
  return "uwsm-app -- " .. command
end

-- Bind a key. `action` is a dispatcher, a Lua function, a shell string, or a
-- table: { tui = "cmd" } opens it in a terminal, { launch = "cmd" } runs it
-- through uwsm, { launch = "cmd", focus = "class-regex" } focuses it if open.
function cc.bind(keys, description, action, options)
  local opts = options or {}
  if description then
    opts.description = description
  end

  if type(action) == "table" and (action.tui or action.launch) then
    if action.tui then
      action = "cc-launch-tui " .. action.tui
    elseif action.launch and action.focus then
      action = "cc-launch-or-focus " .. cc.quote(action.focus) .. " " .. action.launch
    elseif action.launch then
      action = cc.launch(action.launch)
    end
  end

  if type(action) == "string" then
    action = hl.dsp.exec_cmd(action)
  end

  return hl.bind(keys, action, opts)
end

function cc.window(match, rules)
  rules.match = rules.match or {}
  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end
  hl.window_rule(rules)
end

-- Current theme colors, with fallbacks if no theme has been set yet.
function cc.theme_colors()
  local ok, colors = pcall(dofile, (os.getenv("HOME") or "") .. "/.local/state/cc/theme/hypr-colors.lua")
  if ok and type(colors) == "table" then
    return colors
  end
  return {
    active_border = "rgba(33ccffee)",
    inactive_border = "rgba(595959aa)",
    group_text = "rgb(ffffff)",
  }
end

-- Theme look (rounding, gaps, blur, shadows, gradients, animations, layer
-- rules) translated from the theme's hyprland.conf by cc-theme-hyprland into
-- ~/.local/state/cc/theme/hypr-theme.lua (data only). Anything this Hyprland
-- doesn't know is skipped, so a theme can never produce config errors.
local THEME_LOOK = (os.getenv("HOME") or "") .. "/.local/state/cc/theme/hypr-theme.lua"

local ANIMATION_LEAVES = {}
for _, leaf in ipairs({
  "global", "windows", "windowsIn", "windowsOut", "windowsMove", "layers", "layersIn", "layersOut",
  "fade", "fadeIn", "fadeOut", "fadeSwitch", "fadeShadow", "fadeDim", "fadeLayers", "fadeLayersIn",
  "fadeLayersOut", "fadePopups", "fadePopupsIn", "fadePopupsOut", "fadeDpms", "border", "borderangle",
  "workspaces", "workspacesIn", "workspacesOut", "specialWorkspace", "specialWorkspaceIn",
  "specialWorkspaceOut", "zoomFactor", "monitorAdded",
}) do
  ANIMATION_LEAVES[leaf] = true
end

local LAYER_RULE_PROPS = {
  blur = true, blur_popups = true, ignore_alpha = true, no_anim = true,
  animation = true, dim_around = true, xray = true, order = true,
}

-- Curves defined by looknfeel.lua (plus Hyprland's built-in "default").
cc.known_curves = cc.known_curves or { default = true }

function cc.curve(name, points)
  hl.curve(name, { type = "bezier", points = points })
  cc.known_curves[name] = true
end

-- Coerce a theme value to the type Hyprland reports for the option.
local function coerce(current, value)
  if type(current) == "number" then
    if type(value) == "boolean" then
      return value and 1 or 0
    end
    if type(value) == "string" then
      return tonumber(value) or value
    end
  elseif type(current) == "boolean" and type(value) == "number" then
    return value ~= 0
  end
  return value
end

function cc.apply_theme_look(path)
  local ok, look = pcall(dofile, path or THEME_LOOK)
  if not ok or type(look) ~= "table" then
    return
  end

  for _, option in ipairs(look.options or {}) do
    local key, value = option[1], option[2]
    local current = hl.get_config(key)
    if current ~= nil then
      local tbl, node = {}, nil
      node = tbl
      local parts = {}
      for part in key:gmatch("[^.]+") do
        table.insert(parts, part)
      end
      for i = 1, #parts - 1 do
        node[parts[i]] = {}
        node = node[parts[i]]
      end
      node[parts[#parts]] = coerce(current, value)
      pcall(hl.config, tbl)
    end
  end

  for _, curve in ipairs(look.curves or {}) do
    pcall(cc.curve, curve[1], curve[2])
  end

  for _, anim in ipairs(look.animations or {}) do
    if ANIMATION_LEAVES[anim.leaf] and (anim.bezier == nil or cc.known_curves[anim.bezier]) then
      pcall(hl.animation, anim)
    end
  end

  for _, rule in ipairs(look.layer_rules or {}) do
    local clean = { match = rule.match }
    for prop, value in pairs(rule) do
      if LAYER_RULE_PROPS[prop] then
        clean[prop] = value
      end
    end
    pcall(hl.layer_rule, clean)
  end
end
