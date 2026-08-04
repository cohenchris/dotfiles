--             _           
--  _ __ _   _| | ___  ___ 
-- | '__| | | | |/ _ \/ __|
-- | |  | |_| | |  __/\__ \
-- |_|   \__,_|_|\___||___/
--                         
-- Hyprland window and workspace rules


-- https://wiki.hyprland.org/Configuring/Basics/Window-Rules/

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
  size = { 900, 600 },
  center = true,
})

-- large floating generic waybar popups
hl.window_rule({
  name = "large_floating_popup",
  match = { title = "^(File Browser)" },
  float = true,
  size = { 1400, 800 },
  center = true,
})

-- floating email popup
hl.window_rule({
  name = "email_popup",
  match = { title = "^(Email)$" },
  float = true,
  size = { 1600, 900 },
  center = true,
})

-- floating calendar popup
hl.window_rule({
  name = "calendar_popup_size",
  match = { title = "^(Calendar)$" },
  float = true,
  size = { 1000, 900 },
  center = true,
})


-- https://wiki.hyprland.org/Configuring/Basics/Workspace-Rules/

-- Special workspace outer gap size (only used here; see hyprland/display.lua for
-- the general gapsIn / gapsOut definitions)
local specialGapsOut = 80

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })         -- set default workspace, pinned to the real desktop display so the PiKVM mirror can never claim it on startup
hl.workspace_rule({ workspace = "special:special", gaps_out = specialGapsOut })  -- custom outer gap size on special workspace
