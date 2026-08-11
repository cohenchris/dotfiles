--      _         _
--  ___| |_ _   _| | ___
-- / __| __| | | | |/ _ \
-- \__ \ |_| |_| | |  __/
-- |___/\__|\__, |_|\___|
--          |___/
-- Styling for Hyprland

-- Color Definitions
local colorTransparent = "rgba(ffffff00)"

-- Gaps Definitions
local gapsIn = 10
local gapsOut = 20

-- https://wiki.hyprland.org/Configuring/Basics/Variables/#general
hl.config({
  general = {
    border_size = 0,                                                                                                   -- thickness of window borders
    gaps_in = gapsIn,                                                                                                  -- gaps between windows
    gaps_out = gapsOut,                                                                                                -- gaps between windows and monitor edges

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#variable-types
    col = {
      active_border = colorTransparent,                                                                                -- border color for active windows
      inactive_border = colorTransparent,                                                                              -- border color for inactive windows
    },

    -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
    layout = "dwindle",                                                                                                 -- window tiling behavior
  },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#curves
-- hl.curve(NAME, { type = "bezier", points = { {X0, Y0}, {X1, Y1} } })

hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })                                                    -- from default hyprland config
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })                                     -- from default hyprland config
hl.curve("easeOutExpo", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })                                          -- based on https://easings.net/#easeOutExpo
hl.curve("easeInOutBack", { type = "bezier", points = { {0.68, -0.3}, {0.32, 1.3} } })                                  -- based on https://easings.net/#easeInOutBack
hl.curve("easeInBack", { type = "bezier", points = { {0.36, 0}, {0.66, -0.56} } })                                      -- based on https://easings.net/#easeInBack
hl.curve("easeOutBack", { type = "bezier", points = { {0.34, 1.3}, {0.64, 1} } })                                       -- based on https://easings.net/#easeOutBack

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#animation-tree
-- hl.animation({ leaf = NAME, enabled = BOOLEAN, speed = FLOAT, bezier = STRING [, style = STRING] })

-- Windows
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "almostLinear", style = "popin" })                 -- window open/close
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "easeInOutBack" })                             -- window moving, dragging, resizing, etc.
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "almostLinear" })                                   -- window open fade
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "almostLinear" })                                  -- window close fade
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3, bezier = "almostLinear" })                               -- switch focused window fade

-- Layers
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeInOutBack", style = "slide" })               -- layer open
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "easeInOutBack", style = "popin" })              -- layer close
hl.animation({ leaf = "fadeLayersIn", enabled = false })                                                                -- layer open fade
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "almostLinear" })                            -- layer close fade

-- Borders
hl.animation({ leaf = "border", enabled = false })                                                                      -- switch focused window border
hl.animation({ leaf = "borderangle", enabled = false })                                                                 -- border gradient angle

-- Workspaces
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 5, bezier = "easeOutBack", style = "slide" })             -- switch to a populated workspace
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2, bezier = "almostLinear", style = "fade" })            -- switch to an empty workspace
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "easeInOutBack", style = "slidevert" })   -- open/close special workspace

-- https://wiki.hyprland.org/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    rounding = 10,                                                                                                      -- rounded corner radius (in layout px)
    active_opacity = 0.9,                                                                                               -- opacity of active windows. [0.0 - 1.0]
    inactive_opacity = 0.65,                                                                                            -- opacity of inactive windows. [0.0 - 1.0]
    fullscreen_opacity = 1.0,                                                                                           -- opacity of fullscreen windows. [0.0 - 1.0]

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#blur
    blur = {
      size = 5,                                                                                                         -- blur size (distance)
      passes = 2,                                                                                                       -- amount of blur passes to perform
    },

    -- https://wiki.hyprland.org/Configuring/Basics/Variables/#shadow
    shadow = {
      enabled = false,                                                                                                  -- drop shadows on windows
    },
  },
})
