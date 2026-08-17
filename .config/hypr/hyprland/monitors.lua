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

-- Desktop display
hl.monitor({
  output = desktopDisplay,
  mode = "2560x1440@59.95",
  position = "auto",
  scale = 1.25
})

-- PiKVM virtual display
hl.monitor({
  output = piKVMDisplay,
  mode = "1920x1080@60.00",
  position = "auto",
  scale = 1,
  mirror = desktopDisplay
})

-- Laptop display
hl.monitor({
  output = laptopDisplay,
  mode = "2880x1920@120.00",
  position = "auto",
  scale = "auto"
})

-- Workaround for mirror-at-startup race condition:
-- https://github.com/hyprwm/Hyprland/discussions/15695
-- The mirror target lookup happens once, synchronously, at connect time, so
-- if piKVMDisplay enumerates before desktopDisplay, the mirror silently
-- fails to resolve. Re-apply it once desktopDisplay is actually present.
hl.on("hyprland.start", function()
  local function apply_mirror()
    hl.timer(function()
      hl.monitor({ output = piKVMDisplay, disabled = true })
      hl.timer(function()
        hl.monitor({ output = piKVMDisplay, disabled = false, mirror = desktopDisplay })
      end, { timeout = 500, type = "oneshot" })
    end, { timeout = 500, type = "oneshot" })
  end
  if hl.get_monitor(desktopDisplay) ~= nil then apply_mirror() end
  hl.on("monitor.added", function(m)
    if m.name == desktopDisplay then apply_mirror() end
  end)
end)
