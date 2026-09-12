--                        _ _
--  _ __ ___   ___  _ __ (_) |_ ___  _ __ ___
-- | '_ ` _ \ / _ \| '_ \| | __/ _ \| '__/ __|
-- | | | | | | (_) | | | | | || (_) | |  \__ \
-- |_| |_| |_|\___/|_| |_|_|\__\___/|_|  |___/
--
-- Monitor configuration for Hyprland

-----------------------------------------------------------------
--                     DISPLAY CONFIGURATION                   --
-----------------------------------------------------------------
-- https://wiki.hyprland.org/Configuring/Basics/Monitors/
local Dell_Ultrasharp_27in_Monitor = "desc:Dell Inc. DELL U2722DE F7JMX83"
local PiKVM_Virtual_Display = "desc:The Linux Foundation PiKVM V4 Mini CAFEBABE"
local Framework_Laptop_Display = "desc:BOE NE135A1M-NY1"
local TCL_4k_TV = "desc:Sony Beyond TV 0x01010101"

-- Dell Ultrasharp 27" Monitor
local Dell_Ultrasharp_27in_Monitor_Config = {
  output = Dell_Ultrasharp_27in_Monitor,
  mode = "2560x1440@59.95Hz",
  position = "auto",
  scale = 1.25
}

-- PiKVM Virtual Display
local PiKVM_Virtual_Display_Config = {
  output = PiKVM_Virtual_Display,
  mode = "1920x1080@60.00Hz",
  position = "auto",
  scale = 1,
  mirror = Dell_Ultrasharp_27in_Monitor
}

-- Framework Laptop Display
local Framework_Laptop_Display_Config = {
  output = Framework_Laptop_Display,
  mode = "2880x1920@120.00Hz",
  position = "auto",
  scale = "auto"
}

-- TCL 4k TV
local TCL_4k_TV_Config = {
  output = TCL_4k_TV,
  mode = "4096x2160@60.00Hz",
  position = "auto",
  scale = "2",
}

-- Unknown Display
local Default_Config = {
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto"
}

hl.monitor(Dell_Ultrasharp_27in_Monitor_Config)
hl.monitor(PiKVM_Virtual_Display_Config)
hl.monitor(Framework_Laptop_Display_Config)
hl.monitor(TCL_4k_TV_Config)
hl.monitor(Default_Config)




-----------------------------------------------------------------
--                    LAPTOP LID BEHAVIOR                      --
-----------------------------------------------------------------
-- Laptop lid CLOSED
-- Disable the laptop display
hl.bind("switch:on:Lid Switch", function()
  for _, m in ipairs(hl.get_monitors()) do
    if m.name ~= Framework_Laptop_Display_Display then
      hl.monitor({ output = Framework_Laptop_Display, disabled = true })
    end
  end
end, { locked = true })

-- Laptop lid OPENED
-- Re-enable the laptop display
hl.bind("switch:off:Lid Switch", function()
  hl.monitor(laptop)
end, { locked = true })




-- Workaround for mirror-at-startup race condition:
-- https://github.com/hyprwm/Hyprland/discussions/15695
-- The mirror target lookup happens once, synchronously, at connect time, so
-- if PiKVM_Virtual_Display enumerates before Dell_Ultrasharp_27in_Monitor, the mirror silently
-- fails to resolve. Re-apply it once Dell_Ultrasharp_27in_Monitor is actually present.
hl.on("hyprland.start", function()
  local function apply_mirror()
    hl.timer(function()
      hl.monitor({ output = PiKVM_Virtual_Display, disabled = true })
      hl.timer(function()
        hl.monitor({ output = PiKVM_Virtual_Display, disabled = false, mirror = Dell_Ultrasharp_27in_Monitor })
      end, { timeout = 500, type = "oneshot" })
    end, { timeout = 500, type = "oneshot" })
  end
  if hl.get_monitor(Dell_Ultrasharp_27in_Monitor) ~= nil then apply_mirror() end
  hl.on("monitor.added", function(m)
    if m.name == Dell_Ultrasharp_27in_Monitor then apply_mirror() end
  end)
end)
