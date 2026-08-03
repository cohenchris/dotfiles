--  _                _     _           _ _                 
-- | | _____ _   _  | |__ (_)_ __   __| (_)_ __   __ _ ___ 
-- | |/ / _ \ | | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
-- |   <  __/ |_| | | |_) | | | | | (_| | | | | | (_| \__ \
-- |_|\_\___|\__, | |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
--           |___/                               |___/     
-- Hyprland key bindings

-- https://wiki.hypr.land/Configuring/Basics/Binds/

-- hl.bind(keys, dispatcher, flags)
-- flags.locked    -> always handle binds, even when the screen is locked
-- flags.repeating -> repeat the dispatcher while the key is held
-- combine flags as needed, e.g. { locked = true, repeating = true }

-- Main modifier key
local mainMod = "ALT"                                                                                                               -- main modifier key

local hyprlandScriptsDir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr/hyprland/scripts"          -- custom hyprland-related scripts directory

-- APPLICATIONS
hl.bind(mainMod .. " + d", hl.dsp.exec_cmd("LAUNCHER"))                                                                             -- app launcher
hl.bind(mainMod .. " + w", hl.dsp.exec_cmd("BROWSER"))                                                                              -- web browser
hl.bind(mainMod .. " + n", hl.dsp.exec_cmd("FILE_BROWSER"))                                                                         -- file browser
hl.bind(mainMod .. " + SHIFT + p", hl.dsp.exec_cmd("SCREENSHOT"))                                                                   -- screenshot utility
hl.bind("Print", hl.dsp.exec_cmd("SCREENSHOT"))                                                                                     -- screenshot utility
hl.bind(mainMod .. " + e", hl.dsp.exec_cmd("MAIL_CLIENT"))                                                                          -- mail client
hl.bind(mainMod .. " + SHIFT + e", hl.dsp.exec_cmd("mailsync"))                                                                     -- sync mail
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("TERMINAL"))                                                                        -- terminal
hl.bind(mainMod .. " + t", hl.dsp.exec_cmd("TASK_MANAGER"))                                                                         -- task manager
hl.bind(mainMod .. " + b", hl.dsp.exec_cmd("BLUETOOTH_MENU"))                                                                       -- bluetooth device selection menu
hl.bind(mainMod .. " + SHIFT + w", hl.dsp.exec_cmd("WIFI_MENU"))                                                                    -- wifi selection menu
hl.bind(mainMod .. " + u", hl.dsp.exec_cmd("unicode-char-menu"))                                                                    -- unicode character selection menu
hl.bind(mainMod .. " + SHIFT + b", hl.dsp.exec_cmd("PASSWORD_MENU"))                                                                -- password selection menu

-- DESKTOP ENVIRONMENT
hl.bind(mainMod .. " + SHIFT + r", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/hyprland-reload.sh"))                                    -- reload hyprland and waybar
hl.bind(mainMod .. " + SHIFT + x", hl.dsp.exec_cmd("hyprshutdown"))                                                                 -- exit hyprland
hl.bind(mainMod .. " + CONTROL + Delete", hl.dsp.exec_cmd("hyprlock --grace 0"))                                                    -- lock screen
hl.bind(mainMod .. " + SHIFT + u", hl.dsp.exec_cmd("SET_WALLPAPER random"))                                                         -- random wallpaper

-- NIGHT LIGHT
hl.bind(mainMod .. " + Bracketright", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/night-light.sh up"), { repeating = true })            -- increase night light filter orange intensity
hl.bind(mainMod .. " + SHIFT + Bracketright", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/night-light.sh default"), { locked = true })  -- default night light temperature
hl.bind(mainMod .. " + Bracketleft", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/night-light.sh down"), { repeating = true })           -- decrease night light filter orange intensity
hl.bind(mainMod .. " + SHIFT + Bracketleft", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/night-light.sh reset"), { locked = true })     -- reset night light filter to default temperature

-- VOLUME
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("VOLUMECTL mute"), { locked = true })                                            -- volume mute toggle
hl.bind(mainMod .. " + Equal", hl.dsp.exec_cmd("VOLUMECTL up"), { repeating = true })                                               -- volume up
hl.bind(mainMod .. " + Minus", hl.dsp.exec_cmd("VOLUMECTL down"), { repeating = true })                                             -- volume down
hl.bind(mainMod .. " + SHIFT + Backspace", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })     -- microphone mute toggle

-- LAPTOP KEYS
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("VOLUMECTL mute"), { locked = true })                                                      -- volume mute toggle
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("VOLUMECTL down"), { repeating = true })                                            -- volume down
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("VOLUMECTL up"), { repeating = true })                                              -- volume up

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { repeating = true })                                               -- previous track
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { repeating = true })                                             -- play/pause track
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { repeating = true })                                                   -- next track
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 2%-"), { repeating = true })                                      -- display brightness down
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 2%+"), { repeating = true })                                        -- display brightness up
hl.bind("XF86RFKill", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/rfkill.sh"), { repeating = true })                                    -- kill radio frequency (network) connectivity

-- ELECOM HUGE FUNCTION KEYS
hl.bind("mouse:277", hl.dsp.exec_cmd("playerctl next"), { repeating = true })                                                       -- Fn1 - next track
hl.bind("mouse:278", hl.dsp.exec_cmd("playerctl previous"), { repeating = true })                                                   -- Fn2 - previous track
hl.bind("mouse:279", hl.dsp.exec_cmd("playerctl play-pause"), { repeating = true })                                                 -- Fn3 - play/pause track

-- WINDOWS AND WORKSPACES
hl.bind(mainMod .. " + SHIFT + q", hl.dsp.window.close())                                                                           -- close focused window
hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen())                                                                              -- fullscreen focused window
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.exec_cmd(hyprlandScriptsDir .. "/togglefloating.sh"))                                     -- toggle floating focused window

hl.bind(mainMod .. " + left", hl.dsp.layout("preselect l"))                                                                         -- next window will split to the left
hl.bind(mainMod .. " + down", hl.dsp.layout("preselect d"))                                                                         -- next window will split below
hl.bind(mainMod .. " + up", hl.dsp.layout("preselect u"))                                                                           -- next window will split above
hl.bind(mainMod .. " + right", hl.dsp.layout("preselect r"))                                                                        -- next window will split to the right

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }), { repeating = true })                                                 -- move focus left
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }), { repeating = true })                                                 -- move focus down
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }), { repeating = true })                                                 -- move focus up
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }), { repeating = true })                                                 -- move focus right

hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })                  -- increase window width by 50px
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })                 -- decrease window width by 50px
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })                  -- decrease window height by 50px
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })                 -- increase window height by 50px

hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }))                                                        -- swap window with one above
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }))                                                      -- swap window with one below
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }))                                                      -- swap window with one to the left
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))                                                     -- swap window with one to the right

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))                                                                         -- switch to workspace 1
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))                                                                         -- switch to workspace 2
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))                                                                         -- switch to workspace 3
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))                                                                         -- switch to workspace 4
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))                                                                         -- switch to workspace 5
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))                                                                         -- switch to workspace 6
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))                                                                         -- switch to workspace 7
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))                                                                         -- switch to workspace 8
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))                                                                         -- switch to workspace 9
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))                                                                        -- switch to workspace 10
hl.bind(mainMod .. " + Escape", hl.dsp.workspace.toggle_special("special"))                                                         -- switch to special workspace

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))                                                           -- move focused window to workspace 1
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))                                                           -- move focused window to workspace 2
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))                                                           -- move focused window to workspace 3
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))                                                           -- move focused window to workspace 4
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))                                                           -- move focused window to workspace 5
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))                                                           -- move focused window to workspace 6
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))                                                           -- move focused window to workspace 7
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))                                                           -- move focused window to workspace 8
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))                                                           -- move focused window to workspace 9
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))                                                          -- move focused window to workspace 10
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.window.move({ workspace = "special:special" }))                                      -- move focused window to special workspace
