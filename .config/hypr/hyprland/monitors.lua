--                        _ _
--  _ __ ___   ___  _ __ (_) |_ ___  _ __ ___
-- | '_ ` _ \ / _ \| '_ \| | __/ _ \| '__/ __|
-- | | | | | | (_) | | | | | || (_) | |  \__ \
-- |_| |_| |_|\___/|_| |_|_|\__\___/|_|  |___/
--
-- Monitor configuration for Hyprland

-- https://wiki.hyprland.org/Configuring/Basics/Monitors/
local desktopDisplay = "desc:Dell Inc. DELL U2722DE F7JMX83"
local piKVMDisplay = "desc:The Linux Foundation PiKVM V4 Mini CAFEBABE"
local laptopDisplay = "desc:BOE NE135A1M-NY1"

-- Desktop display
local desktopDisplayCfg = ({
  output = desktopDisplay,
  mode = "2560x1440@59.95",
  position = "auto",
  scale = 1.25
})

-- PiKVM virtual display
local piKVMDisplayCfg = ({
  output = piKVMDisplay,
  mode = "1920x1080@60.00",
  position = "auto",
  scale = 1,
  mirror = desktopDisplay
})

-- Laptop display
local laptopDisplayCfg = {
  output = laptopDisplay,
  mode = "2880x1920@120.00",
  position = "auto",
  scale = "auto"
}

-- Unknown display
local miscDisplayCfg = {
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto"
}

hl.monitor(desktopDisplayCfg)
hl.monitor(piKVMDisplayCfg)
hl.monitor(laptopDisplayCfg)
hl.monitor(miscDisplayCfg)

-- Laptop lid CLOSED
-- Disable the laptop display
hl.bind("switch:on:Lid Switch", function()
  for _, m in ipairs(hl.get_monitors()) do
    if m.name ~= laptopDisplay then
      hl.monitor({ output = laptopDisplay, disabled = true })
    end
  end
end, { locked = true })

-- Laptop lid OPENED
-- Re-enable the laptop display
hl.bind("switch:off:Lid Switch", function()
  hl.monitor(laptopDisplayCfg)
end, { locked = true })



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
