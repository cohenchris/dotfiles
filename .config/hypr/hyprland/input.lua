--  _                   _              _   _   _                 
-- (_)_ __  _ __  _   _| |_   ___  ___| |_| |_(_)_ __   __ _ ___ 
-- | | '_ \| '_ \| | | | __| / __|/ _ \ __| __| | '_ \ / _` / __|
-- | | | | | |_) | |_| | |_  \__ \  __/ |_| |_| | | | | (_| \__ \
-- |_|_| |_| .__/ \__,_|\__| |___/\___|\__|\__|_|_| |_|\__, |___/
--         |_|                                         |___/     
-- Hyprland input settings

-- https://wiki.hypr.land/Hypr-Ecosystem/hyprcursor/
hl.env("HYPRCURSOR_SIZE", "30")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#follow-mouse-cursor
    follow_mouse = 1,                       -- cursor movement affects window focus
    sensitivity = -0.4,                     -- cursor sensitivity [-1.0 - 1.0]
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
hl.config({
  cursor = {
    sync_gsettings_theme = true,            -- sync xcursor theme with gsettings
    enable_hyprcursor = true,               -- whether to enable hyprcursor support
    use_cpu_buffer = 1,                     -- makes HW cursors use a CPU buffer
  },
})

hl.device({
  name = "pixa3854:00-093a:0274-touchpad",  -- Framework trackpad
  sensitivity = 0,                          -- override default setting above
  natural_scroll = true,                    -- invert scrolling
  accel_profile = "flat",
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures
hl.gesture({
  fingers = 3,                              -- 3 finger swipe
  direction = "horizontal",                 -- horizontally
  action = "workspace"                      -- switches the active workspace
})

hl.gesture({
  fingers = 3,                              -- 3 finger swipe
  direction = "vertical",                   -- vertically
  action = "special",                       -- toggles the special workspace
  workspace_name = "special"
})
