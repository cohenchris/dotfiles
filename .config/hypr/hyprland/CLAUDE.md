# Hyprland config (this directory)

This is `phrog`'s live Hyprland config, written in Hyprland's **native Lua config
API** (the `hl.*` global), not classic `.conf`/hyprlang syntax. It is **not** a
git repo.

## How the pieces fit together

- `~/.config/hypr/hyprland.lua` — entry point. `require()`s the four modules
  below, registers `hyprland.start` autostart commands, and sets misc/dwindle/
  xwayland/ecosystem options.
  - `require("hyprland/keybinds")` → `hyprland/keybinds.lua`
  - `require("hyprland/display")` → `hyprland/display.lua`
  - `require("hyprland/input")` → `hyprland/input.lua`
  - `require("hyprland/rules")` → `hyprland/rules.lua`
- `hyprland/scripts/` — helper shell scripts invoked from keybinds/autostart
  (`hyprland-reload.sh` restarts the whole userland stack after a config
  reload; `togglefloating.sh` toggles float + resizes/centers based on the
  focused monitor's logical resolution).
- Sibling files also loaded by Hyprland's ecosystem but outside this
  directory: `~/.config/hypr/hyprpaper.conf`, `hypridle.conf`,
  `hyprlock.conf` (+ `hyprlock/auth-fingerprint.conf`,
  `hyprlock/auth-password.conf`, `hyprlock/detect-auth.sh` — the latter
  symlinks `~/.local/cache/hyprlock-auth.conf` to whichever auth variant
  matches the host, run once at startup).

There is **no compiled/generated `hyprland.conf`** in `~/.config/hypr` — these
`.lua` files are read directly by Hyprland at runtime via its Lua config
support.

## The `hypr2lua` project (`~/Projects/hypr2lua`)

A separate, unrelated-by-git companion project used to convert classic
hyprlang `.conf` files to the `.lua` API using the `hyprconf2lua` pip package
(see `convert.sh`). `hypr2lua/hypr/hyprland/display.conf` is an **older
`.conf`-syntax source snapshot** — it predates the `is_monitor_connected`
fallback logic and the per-workspace monitor pinning in the live
`display.lua`. Don't treat it as authoritative for current behavior; it's a
conversion-input artifact, not the live config.

There's also a `~/Projects/dotfiles/dotfiles/.config/hypr/hyprlock/` copy
(plain directory, not a git repo, not a symlink) — a separate backup/staging
copy of the hyprlock auth scripts, not the live source.

## Monitor / workspace setup (`hyprland/display.lua`)

Three known outputs by DRM connector name:
- `desktopDisplay = "DP-1"` — real desktop monitor, 2560x1440@59.95, scale 1.25.
- `piKVMDisplay = "HDMI-A-1"` — a PiKVM's virtual/capture HDMI output, configured
  to `mirror = desktopDisplay` (streams whatever's on DP-1 out over the KVM-over-IP
  link — it is not meant to be an independent/extended desktop).
- `laptopDisplay = "eDP-1"` — laptop panel, used only when neither of the above
  is connected (different machine).

Fallback logic (`is_monitor_connected` / `first_monitor_name`) auto-mirrors any
unrecognized secondary monitor onto whichever known primary is present, or onto
the first-enumerated monitor if this is an unfamiliar machine.

**Gotcha (fixed 2026-08-09): Hyprland's `mirror` is render-only.** Setting
`mirror = desktopDisplay` on `piKVMDisplay` makes it *display* a copy of DP-1's
framebuffer, but Hyprland still keeps HDMI-A-1 as a fully independent monitor
object internally, with its own workspace slot — mirroring does not remove it
from the pool of monitors eligible to "claim" an unpinned workspace. DRM
connector enumeration order at boot is hardware-dependent and can put
HDMI-A-1 ahead of DP-1, so whichever monitor is first/focused when a given
workspace is first opened claims it as home. Originally only workspace 1 had
an explicit `workspace_rule` pin to `desktopDisplay` (guarding against exactly
this for workspace 1); workspaces 2–10 had no such rule and could land their
"home" monitor on the piKVM output instead of the desktop. Fixed by pinning
**all** of workspaces 1–10 to `desktopDisplay` via a loop over
`hl.workspace_rule`, so `piKVMDisplay` can never own a workspace — it only
ever mirrors.

`hyprpaper.conf` sets wallpaper explicitly for `DP-1` only (not HDMI-A-1),
consistent with piKVM being a pure mirror.

## Keybindings (`hyprland/keybinds.lua`)

Main modifier: `ALT`. Notable groups: app launchers/utilities (`ALT+d/w/n/e/t/b/u`
etc., mostly `hl.dsp.exec_cmd("SOME_CMD")` calling out to external scripts like
`LAUNCHER`, `BROWSER`, `HWCTL`, `SET_WALLPAPER`, `BATTERY_MONITOR` — these are
PATH-resolved external commands/scripts, not defined in this repo); window
focus/move/resize/swap (vim-style `h/j/k/l` + arrows); workspace switch/move
`ALT[+SHIFT]+1..0` (10 = workspace 10); special workspace on `ALT+Escape`.

## Rules (`hyprland/rules.lua`)

Floating popup sizes are computed as fractions of the *non-mirrored* reference
monitor's logical resolution (`get_reference_monitor()` skips any monitor with
`is_mirror = true`), so popups size correctly regardless of which physical
monitor is "first."
