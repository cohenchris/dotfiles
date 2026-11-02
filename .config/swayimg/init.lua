-- Swayimg config (Lua, swayimg >= 5.x)
-- Ported from the old INI-style `config` file in this directory.
-- API reference: /usr/share/swayimg/swayimg.lua
-- Colors are 0xAARRGGBB (the old INI format was #RRGGBBAA).

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

-- quote a string for safe use in a shell command
local function shquote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- move image by a percentage of the window size (old `step_*` actions)
local function step(mode, dx, dy)
  local win = swayimg.get_window_size()
  local pos = mode.get_position()
  mode.set_abs_position(pos.x + math.floor(win.width * dx / 100),
                        pos.y + math.floor(win.height * dy / 100))
end

-- show previous/next frame of an animation
local function prev_frame(mode)
  if mode.frame > 0 then
    mode.frame = mode.frame - 1
  end
end
local function next_frame(mode)
  mode.frame = mode.frame + 1
end

-- run a shell command on the current image, then drop it from the image list
local function move_to(dir, img)
  if not img then return end
  local cmd = "mkdir -p " .. shquote(dir) .. " && mv " .. shquote(img.path) .. " " .. shquote(dir)
  if os.execute(cmd) then
    swayimg.imagelist.remove(img.path)
    swayimg.text.status = "Moved to " .. dir .. ": " .. img.path
  else
    swayimg.text.status = "Failed to move " .. img.path
  end
end
local function delete_file(img)
  if not img then return end
  if os.remove(img.path) then
    swayimg.imagelist.remove(img.path)
    swayimg.text.status = "File removed: " .. img.path
  else
    swayimg.text.status = "Failed to remove " .. img.path
  end
end

-- rotate the image file itself (overwrites it), then reload it
-- -auto-orient first bakes in any EXIF orientation so it isn't applied twice
local function rotate_file(angle)
  local img = swayimg.viewer.get_image()
  if not img then return end
  local cmd = "magick mogrify -auto-orient -rotate " .. angle .. " " .. shquote(img.path)
  if os.execute(cmd) then
    swayimg.viewer.reload()
    swayimg.text.status = "Saved rotation " .. angle .. "°: " .. img.path
  else
    swayimg.text.status = "Failed to rotate " .. img.path
  end
end

-- cycle through fixed scales (old `zoom` with no argument)
local scales = { "optimal", "fit", "fill", "width", "height", "real" }
local scale_idx = 1
local function cycle_scale()
  scale_idx = scale_idx % #scales + 1
  swayimg.viewer.set_fix_scale(scales[scale_idx])
  swayimg.text.status = "Scale: " .. scales[scale_idx]
end

local help_text = table.concat({
  "n/Space next   p prev   Home/End first/last   Shift+r random",
  "d/Shift+d next/prev dir   o/Shift+o next/prev frame   Shift+a animation",
  "[ ] rotate & save file   m/Shift+m flip   +/- zoom   z fit   Shift+z fill   0 real",
  "w/Shift+w width/height   BackSpace optimal   k keep   Alt+s cycle scale",
  "Return gallery   s slideshow   f fullscreen   i info   r reload",
  "c skip   Ctrl+f favorites   Ctrl+t trash   Shift+Delete delete   q quit",
}, "\n")

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
swayimg.mode = "viewer"
swayimg.appid = "swayimg"
swayimg.overlay = false
swayimg.decoration = false
swayimg.antialiasing = true

--------------------------------------------------------------------------------
-- Image list
--------------------------------------------------------------------------------
swayimg.imagelist.order = "alpha"
swayimg.imagelist.reverse = false
swayimg.imagelist.recursive = false
swayimg.imagelist.adjacent = true -- old `all = yes`
swayimg.imagelist.fsmon = true

--------------------------------------------------------------------------------
-- Text overlay (old [font] and [info])
--------------------------------------------------------------------------------
swayimg.text.visible = true
swayimg.text.font = "TerminessNerdFont"
swayimg.text.size = 20
swayimg.text.color = 0xffffffff
swayimg.text.shadow = 0xff000000
swayimg.text.background = 0x00000000
swayimg.text.timeout = 0 -- old `info_timeout = 0`: never hide
swayimg.text.status_timeout = 5

--------------------------------------------------------------------------------
-- Viewer mode
--------------------------------------------------------------------------------
swayimg.viewer.default_scale = "optimal"
swayimg.viewer.default_position = "center"
swayimg.viewer.drag_button = "MouseLeft"
swayimg.viewer.loop = true
swayimg.viewer.history = 100
swayimg.viewer.preload = 100
swayimg.viewer.set_window_background(0x00000000)
swayimg.viewer.set_image_chessboard(20, 0xff333333, 0xff4c4c4c) -- old `transparency = grid`
swayimg.viewer.text = {
  topleft = {
    "{path}",
    "{format}",
    "{sizehr}",
    "{frame.width}x{frame.height}",
  },
  topright = {
    "{list.index} of {list.total}",
  },
  bottomleft = {
    "{scale}",
  },
  bottomright = {
    "{meta.Exif.Image.Model}",
    "{meta.Exif.Photo.DateTimeOriginal}",
    "{meta.Exif.Photo.ExposureTime}",
    "{meta.Exif.Photo.FNumber}",
    "{meta.Exif.Photo.ISOSpeedRatings}",
  },
}

local V = swayimg.viewer

V.on_key("F1", function() swayimg.text.status = help_text end)
V.on_key("Escape", function() swayimg.exit() end)
V.on_key("q", function() swayimg.exit() end)

-- navigation
V.on_key("Home", function() V.open("first") end)
V.on_key("End", function() V.open("last") end)
V.on_key("p", function() V.open("prev") end)
V.on_key("n", function() V.open("next") end)
V.on_key("space", function() V.open("next") end)
V.on_key("Shift+r", function() V.open("random") end)
V.on_key("Shift+d", function() V.open("prev_dir") end)
V.on_key("d", function() V.open("next_dir") end)
V.on_key("Shift+o", function() prev_frame(V) end)
V.on_key("o", function() next_frame(V) end)
V.on_key("c", function()
  local img = V.get_image()
  if img then swayimg.imagelist.remove(img.path) end
end)

-- modes and toggles
V.on_key("s", function() swayimg.mode = "slideshow" end)
V.on_key("Return", function() swayimg.mode = "gallery" end)
V.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
V.on_key("a", function() swayimg.antialiasing = not swayimg.antialiasing end)
V.on_key("Shift+a", function() V.animation = not V.animation end)
V.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
V.on_key("r", function() V.reload() end)

-- move image
V.on_key("left", function() step(V, 10, 0) end)
V.on_key("right", function() step(V, -10, 0) end)
V.on_key("up", function() step(V, 0, 10) end)
V.on_key("down", function() step(V, 0, -10) end)

-- zoom
V.on_key({ "equal", "plus" }, function() V.scale = V.scale * 1.1 end)
V.on_key("minus", function() V.scale = V.scale / 1.1 end)
V.on_key("w", function() V.set_fix_scale("width") end)
V.on_key("Shift+w", function() V.set_fix_scale("height") end)
V.on_key("z", function() V.set_fix_scale("fit") end)
V.on_key("Shift+z", function() V.set_fix_scale("fill") end)
V.on_key("0", function() V.set_fix_scale("real") end)
V.on_key("backspace", function() V.set_fix_scale("optimal") end)
V.on_key("k", function() V.set_fix_scale("keep") end)
V.on_key("Alt+s", cycle_scale)

-- rotate / flip
V.on_key("]", function() rotate_file(90) end)
V.on_key("[", function() rotate_file(270) end)
V.on_key("m", function() V.flip_vertical() end)
V.on_key("Shift+m", function() V.flip_horizontal() end)

-- file operations (relative dirs are relative to where swayimg was started)
V.on_key("Shift+Delete", function() delete_file(V.get_image()) end)
V.on_key("Ctrl+f", function() move_to("./favorites", V.get_image()) end)
V.on_key("Ctrl+t", function() move_to("./trash", V.get_image()) end)

-- mouse
V.on_mouse("MouseSide", function() V.open("prev") end)
V.on_mouse("MouseExtra", function() V.open("next") end)

V.on_scroll(function(kmods, horizontal, vertical)
  if kmods == "Ctrl" then
    -- zoom at mouse pointer
    if vertical then
      local mouse = swayimg.get_mouse_pos()
      V.set_abs_scale(V.scale - V.scale * vertical / 10.0, mouse.x, mouse.y)
    end
  elseif kmods == "Shift" then
    -- previous/next image (some compositors turn Shift+scroll into horizontal)
    local d = vertical or horizontal
    if d then V.open(d > 0 and "prev" or "next") end
  elseif kmods == "Alt" then
    local d = vertical or horizontal
    if d then
      if d > 0 then prev_frame(V) else next_frame(V) end
    end
  else
    -- move image
    local pos = V.get_position()
    V.set_abs_position(pos.x + math.floor((horizontal or 0) * 50),
                       pos.y + math.floor((vertical or 0) * 50))
  end
end)

-- signals
V.on_signal("USR1", function() V.reload() end)
V.on_signal("USR2", function() V.open("next") end)

--------------------------------------------------------------------------------
-- Slideshow mode
--------------------------------------------------------------------------------
local S = swayimg.slideshow

S.timeout = 3
S.default_scale = "fit"
S.default_position = "center"
S.set_window_background("auto")
S.set_image_background(0xff000000)
S.text = {
  bottomright = { "{dir}" },
}

-- pause: stretch the timeout, resume: restore it
local slide_timeout = S.timeout
local paused = false
S.on_key("space", function()
  paused = not paused
  S.timeout = paused and 1e9 or slide_timeout
  swayimg.text.status = paused and "Paused" or "Resumed"
end)

S.on_key("F1", function() swayimg.text.status = help_text end)
S.on_key("Home", function() S.open("first") end)
S.on_key("End", function() S.open("last") end)
S.on_key("prior", function() S.open("prev") end)
S.on_key("next", function() S.open("next") end)
S.on_key("Shift+r", function() S.open("random") end)
S.on_key("Shift+d", function() S.open("prev_dir") end)
S.on_key("d", function() S.open("next_dir") end)
S.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
S.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
S.on_key({ "Return", "s" }, function() swayimg.mode = "viewer" end)
S.on_key("Escape", function() swayimg.exit() end)
S.on_key("q", function() swayimg.exit() end)

--------------------------------------------------------------------------------
-- Gallery mode
--------------------------------------------------------------------------------
local G = swayimg.gallery

G.thumb_size = 300
G.cache = 100
G.preload = true
G.pstore = true
G.window_color = 0x00000000
G.unselected_color = 0xff202020
G.selected_color = 0xff404040
G.text = {
  topleft = { "{name}" },
  topright = { "{list.index} of {list.total}" },
}

G.on_key("F1", function() swayimg.text.status = help_text end)
G.on_key("Home", function() G.select("first") end)
G.on_key("End", function() G.select("last") end)
G.on_key("left", function() G.select("left") end)
G.on_key("right", function() G.select("right") end)
G.on_key("up", function() G.select("up") end)
G.on_key("down", function() G.select("down") end)
G.on_key("prior", function() G.select("pgup") end)
G.on_key("next", function() G.select("pgdown") end)
G.on_key("c", function()
  local img = G.get_image()
  if img then swayimg.imagelist.remove(img.path) end
end)
G.on_key("s", function() swayimg.mode = "slideshow" end)
G.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
G.on_key("Return", function() swayimg.mode = "viewer" end)
G.on_key("a", function() swayimg.antialiasing = not swayimg.antialiasing end)
G.on_key("r", function() G.reload() end)
G.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
G.on_key({ "equal", "plus" }, function() G.thumb_size = G.thumb_size + 20 end)
G.on_key("minus", function() G.thumb_size = math.max(G.thumb_size - 20, 20) end)
G.on_key("Shift+Delete", function() delete_file(G.get_image()) end)
G.on_key("Ctrl+f", function() move_to("./favorites", G.get_image()) end)
G.on_key("Ctrl+t", function() move_to("./trash", G.get_image()) end)
G.on_key("Escape", function() swayimg.exit() end)
G.on_key("q", function() swayimg.exit() end)

G.on_mouse("MouseLeft", function()
  local mouse = swayimg.get_mouse_pos()
  G.select_at(mouse.x, mouse.y)
  swayimg.mode = "viewer"
end)

G.on_scroll(function(kmods, horizontal, vertical)
  if kmods == "Ctrl" then
    if vertical then
      G.thumb_size = math.max(G.thumb_size + (vertical > 0 and 20 or -20), 20)
    end
  else
    if horizontal then
      G.select(horizontal > 0 and "left" or "right")
    end
    if vertical then
      G.select(vertical > 0 and "up" or "down")
    end
  end
end)
