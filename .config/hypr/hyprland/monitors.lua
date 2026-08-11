--                        _ _
--  _ __ ___   ___  _ __ (_) |_ ___  _ __ ___
-- | '_ ` _ \ / _ \| '_ \| | __/ _ \| '__/ __|
-- | | | | | | (_) | | | | | || (_) | |  \__ \
-- |_| |_| |_|\___/|_| |_|_|\__\___/|_|  |___/
--
-- Monitor configuration for Hyprland

-- https://wiki.hyprland.org/Configuring/Basics/Monitors/
local desktopDisplay = "DP-1"
local piKVMDisplay = "HDMI-A-1"
local laptopDisplay = "eDP-1"

-- Desktop monitor config
hl.monitor({ output = desktopDisplay, mode = "2560x1440@59.95", position = "auto", scale = 1.25 })                      -- desktop display
hl.monitor({ output = piKVMDisplay, mode = "1920x1080@60.00", position = "auto", scale = 1, mirror = desktopDisplay })  -- pikvm virtual display

-- Laptop monitor config
hl.monitor({ output = laptopDisplay, mode = "2880x1920@120.00", position = "auto", scale = "auto" })   -- laptop display

local function is_monitor_connected(name)
  for _, m in ipairs(hl.get_monitors()) do
    if m.name == name then
      return true
    end
  end
  return false
end

local function first_monitor_name()
  local monitors = hl.get_monitors()
  return monitors[1] and monitors[1].name or ""
end

-- Determine the machine's primary display and (re-)pin workspaces/mirroring to it
local function apply_primary_display()
  local primaryDisplay
  if is_monitor_connected(desktopDisplay) then
    primaryDisplay = desktopDisplay
  elseif is_monitor_connected(laptopDisplay) then
    primaryDisplay = laptopDisplay
  else
    primaryDisplay = first_monitor_name()
  end

  if primaryDisplay == "" then
    return
  end

  local isKnownDisplay = primaryDisplay == desktopDisplay or primaryDisplay == laptopDisplay or primaryDisplay == piKVMDisplay

  -- Neither known display is connected, configure whichever monitor comes up first
  if not (is_monitor_connected(desktopDisplay) or is_monitor_connected(laptopDisplay)) and not isKnownDisplay then
    hl.monitor({ output = primaryDisplay, mode = "highres@highrr", position = "auto", scale = 1 })
  end

  -- Pin every workspace to the primary monitor
  for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = primaryDisplay, default = (i == 1) })
  end

  -- Handle the case where piKVMDisplay comes up first and claims the primaryDisplay
  if primaryDisplay == desktopDisplay then
    local pikvm = hl.get_monitor(piKVMDisplay)
    if pikvm and not pikvm.is_mirror then
      hl.monitor({ output = piKVMDisplay, disabled = true })
      hl.monitor({ output = piKVMDisplay, mode = "1920x1080@60.00", position = "auto", scale = 1, mirror = desktopDisplay, disabled = false })
    end
  end

  -- A workspace rule change alone doesn't migrate an already-active workspace, so
  -- force workspace 1 onto the primary monitor if it ended up elsewhere. Must pass
  -- the workspace object, not a bare integer - `mon:set_workspace(1)` throws
  -- "attempt to index a number value" (confirmed live via hyprctl repl).
  local ws1 = hl.get_workspace(1)
  if ws1 and (not ws1.monitor or ws1.monitor.name ~= primaryDisplay) then
    local mon = hl.get_monitor(primaryDisplay)
    if mon then
      mon:set_workspace(ws1)
    end
  end

  -- Automatically mirror new secondary monitors in their highest resolution and refresh rate
  hl.monitor({ output = "", mode = "highres@highrr", position = "auto", scale = 1, mirror = primaryDisplay })
end

apply_primary_display()
hl.on("monitor.added", apply_primary_display)
