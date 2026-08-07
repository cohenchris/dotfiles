--             _           
--  _ __ _   _| | ___  ___ 
-- | '__| | | | |/ _ \/ __|
-- | |  | |_| | |  __/\__ \
-- |_|   \__,_|_|\___||___/
--                         
-- Hyprland window and workspace rules


-- https://wiki.hyprland.org/Configuring/Basics/Window-Rules/

-- Floating popup sizes are computed as fractions of the reference monitor's
-- logical resolution (physical size / scale) rather than hardcoded pixels,
-- so they scale to whatever screen they're running on.
local function get_reference_monitor()
  for _, m in ipairs(hl.get_monitors()) do
    if not m.is_mirror then
      return m
    end
  end
  return nil
end

-- Fallback resolution if no monitor is found (shouldn't happen in practice)
local fallbackWidth = 1920
local fallbackHeight = 1080

local refMonitor = get_reference_monitor()
local logicalWidth = refMonitor and (refMonitor.width / refMonitor.scale) or fallbackWidth
local logicalHeight = refMonitor and (refMonitor.height / refMonitor.scale) or fallbackHeight

local function scaled_size(widthRatio, heightRatio)
  return { math.floor(logicalWidth * widthRatio), math.floor(logicalHeight * heightRatio) }
end

-- ignore maximize requests from apps
hl.window_rule({
  name = "ignore_maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- small floating generic waybar popups
hl.window_rule({
  name = "small_floating_popup",
  match = { title = "^(GPU|Audio|Bluetooth|WiFi|VPN|System Monitor)$" },
  float = true,
  size = scaled_size(0.45, 0.55),
  center = true,
})

-- large floating generic waybar popups
hl.window_rule({
  name = "large_floating_popup",
  match = { title = "^(File Browser)" },
  float = true,
  size = scaled_size(0.7, 0.7),
  center = true,
})

-- floating email popup
hl.window_rule({
  name = "email_popup",
  match = { title = "^(Email)$" },
  float = true,
  size = scaled_size(0.8, 0.8),
  center = true,
})

-- floating calendar popup
hl.window_rule({
  name = "calendar_popup_size",
  match = { title = "^(Calendar)$" },
  float = true,
  size = scaled_size(0.5, 0.8),
  center = true,
})


-- https://wiki.hyprland.org/Configuring/Basics/Workspace-Rules/

-- Special workspace outer gap size (only used here; see hyprland/display.lua for
-- the general gapsIn / gapsOut definitions)
local specialGapsOut = 80

hl.workspace_rule({ workspace = "special:special", gaps_out = specialGapsOut })  -- custom outer gap size on special workspace
