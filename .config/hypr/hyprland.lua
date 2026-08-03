--  _                      _                 _ 
-- | |__  _   _ _ __  _ __| | __ _ _ __   __| |
-- | '_ \| | | | '_ \| '__| |/ _` | '_ \ / _` |
-- | | | | |_| | |_) | |  | | (_| | | | | (_| |
-- |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
--        |___/|_|                             
--
-- General hyprland config

-- Configs for various parts of hyprland
require("hyprland/keybinds")                               -- key bindings
require("hyprland/display")                                -- display settings
require("hyprland/input")                                  -- input settings
require("hyprland/rules")                                  -- window and workspace rules

-- Startup Programs
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
  hl.exec_cmd("~/.config/hypr/hyprlock/detect-auth.sh")    -- point hyprlock-auth.conf at the fingerprint or password variant
  hl.exec_cmd("dunst")                                     -- notification daemon
  hl.exec_cmd("hyprpaper")                                 -- wallpaper manager
  hl.exec_cmd("hypridle")                                  -- idle management (auto-lock screen)
  hl.exec_cmd("~/.config/waybar/scripts/waybar.sh")        -- taskbar
  hl.exec_cmd("hyprsunset")                                -- blue light filter daemon
  hl.exec_cmd("sleep 0.5 && SET_WALLPAPER random")         -- set random wallpaper
  hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")  -- polkit agent for fingerprint login
  hl.exec_cmd("BATTERY_MONITOR")                           -- battery monitor daemon
  hl.exec_cmd("swayosd-server")                            -- visual volume control indicator daemon
end)

-- https://wiki.hyprland.org/Configuring/Basics/Variables/#misc
hl.config({
  misc = {
    force_default_wallpaper = 0,                           -- enforce any of the 3 default wallpapers
    disable_hyprland_logo = true,                          -- random Hyprland logo background
    disable_splash_rendering = true,                       -- disable splash message rendering
    font_family = "TerminessNerdFont",                     -- global default font for text rendering

    -- Splash
    splash_font_family = "TerminessNerdFont",              -- font for splash text rendering

    -- Wake monitor on event
    mouse_move_enables_dpms = true,                        -- wake up the monitors if the mouse moves
    key_press_enables_dpms = true,                         -- wake up the monitors if a key is pressed
  },
})

-- https://wiki.hyprland.org/Configuring/Layouts/Dwindle-Layout/#config
hl.config({
  dwindle = {
    preserve_split = true,                                 -- window split direction always preserved
  },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
hl.config({
  xwayland = {
    enabled = false,                                       -- pure wayland - no xwayland compatibility layer!
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#ecosystem
hl.config({
  ecosystem = {
    no_update_news = true,                                 -- disable news popup when hyprland is updated
    no_donation_nag = true,                                -- disable bi-yearly donation popup
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#debug
-- hl.config({
--   debug = {
--     disable_logs = false,
--     disable_time = false,
--     enable_stdout_logs = true,
--     colored_stdout_logs = true,
--   },
-- })
