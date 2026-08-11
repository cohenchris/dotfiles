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

**Gotcha, take 2 (fixed 2026-08-10, supersedes the 2026-08-09 note below).**
The 2026-08-09 fix (pin all of workspaces 1–10 to `desktopDisplay` via a loop
over `hl.workspace_rule`) was necessary but not sufficient — the bug came
back on the next cold boot. Verified live against the running instance
(Hyprland 0.56.1) that the real mechanism is different from what was
originally assumed:

- `hl.get_monitors()` does **not** include a monitor that is genuinely
  mirroring (confirmed empirically: with HDMI-A-1 actually mirroring DP-1,
  `hl.get_monitors()` returns only `DP-1`, and `hl.get_monitor("HDMI-A-1")`
  returns `nil`). So mirroring *does* remove a monitor from the pool eligible
  to claim a workspace — contrary to what the original gotcha note assumed.
- The actual failure is that the mirror sometimes never attaches in the
  first place. DRM connector enumeration order at boot is hardware-dependent
  and puts HDMI-A-1 ahead of DP-1 (confirmed in the Hyprland session log).
  When HDMI-A-1 connects, its `mirror = desktopDisplay` rule finds no DP-1 to
  mirror yet, so it silently comes up as a genuinely independent monitor
  (`mirrorOf: none`) — and since it's the *first* monitor Hyprland sees, it
  claims workspace 1 as its default before config's workspace rules can run.
- `display.lua` itself is evaluated before Hyprland has probed any monitors
  over DRM at all, so on the very first pass `hl.get_monitors()` is empty and
  `primaryDisplay` resolves to `""` — the workspace-pinning loop was pinning
  against an empty/invalid target on cold boot, not `desktopDisplay`.
- Re-declaring `mirror = desktopDisplay` on an already-independent monitor
  does **not** retroactively convert it — confirmed live via `hyprctl eval`.
  It has to be disabled and re-enabled with the mirror flag set to pick it
  up.
- `hyprland/scripts/hyprland-reload.sh` only runs `hyprctl reload` (plus
  restarting sibling daemons) — it does not restart Hyprland itself, so it
  never replays DRM connector order and can't be used to test this. Once
  both monitors are already known, `hyprctl reload` re-evaluates
  `is_monitor_connected`/`primaryDisplay` correctly and everything looks
  fixed — which is why the 2026-08-09 fix appeared to work but didn't
  survive an actual cold boot/reboot.

Fixed by wrapping the primary-display resolution + workspace pinning in a
function (`apply_primary_display`) that runs both at config load and on
every `hl.on("monitor.added", ...)` event, so it re-evaluates once DRM
actually reports monitors instead of running once against an empty list. It
also force-moves workspace 1 onto the primary monitor if it's already active
elsewhere (a workspace rule change alone doesn't migrate an existing
workspace), and cycles `piKVMDisplay` through `disabled = true` →
`disabled = false, mirror = desktopDisplay` if it ever comes up as
independent (`not pikvm.is_mirror`).

**Current status (2026-08-10, reapplied): this fix is live in `display.lua`**,
with two corrections found when reapplying it (see the "reapplying the fix"
session log entry below for the full trail):

- `mon:set_workspace(1)` (bare integer) throws `attempt to index a number
  value` — confirmed live via `hyprctl repl`. Must pass the workspace object
  (`mon:set_workspace(ws1)`) or a string (`"1"`) instead. Since this call was
  unguarded, the bug silently aborted the rest of `apply_primary_display()`
  whenever it triggered — including the piKVM mirror-reattach block that came
  *after* it in the function body.
- The piKVM disable/re-enable block was accordingly moved to run *before*
  the workspace-1 move, so a future regression in one can't suppress the
  other.
- Caveat, unresolved: live-tested that running the disable-then-enable-with-
  mirror pair as two statements inside one `hyprctl reload` pass does **not**
  reliably reattach the mirror (`mirrorOf` stayed `none` immediately after
  reload). Running the identical two `hl.monitor()` calls as two *separate*
  `hyprctl repl` invocations **did** work. This suggests `hyprctl reload`
  reconciles all monitor-rule declarations for a given output into one
  atomic final state rather than applying each call as a discrete live
  action, so the disable/enable "edge" needed to force reattachment may get
  collapsed away when both calls land in the same reload pass. Whether the
  same collapsing happens inside a single `hl.on("monitor.added", ...)`
  callback fired from a genuine async hotplug/cold-boot event (as opposed to
  `hyprctl reload` replaying the whole script) is **unverified** — testing
  that requires an actual Hyprland restart, which has been deliberately
  avoided twice now (2026-08-10 first pass and this pass) to not disrupt the
  live desktop. If piKVM comes up unmirrored after a real reboot and the
  automatic fix doesn't self-heal, the reliable manual remedy is the two
  separate `hyprctl repl` commands documented in the session log below.

<details>
<summary>Original 2026-08-09 gotcha note (partially incorrect, kept for history)</summary>

Hyprland's `mirror` was assumed to be render-only: setting
`mirror = desktopDisplay` on `piKVMDisplay` makes it *display* a copy of
DP-1's framebuffer, but was assumed to still keep HDMI-A-1 as a fully
independent monitor object internally, with its own workspace slot —
mirroring assumed not to remove it from the pool of monitors eligible to
"claim" an unpinned workspace. Originally only workspace 1 had an explicit
`workspace_rule` pin to `desktopDisplay`; workspaces 2–10 had no such rule.
Fixed (at the time) by pinning all of workspaces 1–10 to `desktopDisplay`.
This diagnosis turned out to be incomplete — see above.

</details>

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

## Session log

### 2026-08-10 — piKVM/workspace-1 investigation

Started from: "why is workspace 1 binding to piKVMDisplay, I thought my
2026-08-09 change to `display.lua` fixed it?"

Investigation steps, in order:
1. Read `display.lua`, `keybinds.lua`, `rules.lua` — no keybind or window
   rule references `piKVMDisplay`/`HDMI-A-1`, so the cause had to be in
   `display.lua`'s monitor/workspace logic itself.
2. Checked live state: `hyprctl monitors` showed `HDMI-A-1` with
   `mirrorOf: none` (should have been mirroring `DP-1`) and `active
   workspace: 1`; `DP-1` had `active workspace: 2`. So the mirror itself
   wasn't attached, not just a workspace-pinning miss.
3. Found `~/Projects/dotfiles/dotfiles/.config/hypr/hyprland/display.lua`, a
   stale, differently-edited copy — confirmed via `diff` and mtimes it's not
   what's deployed (`~/.config/hypr` is a plain directory, not a symlink into
   that repo) and ruled it out as a red herring.
4. Confirmed `hl.monitor`'s `mirror` field is a plain `string` (monitor
   name to mirror) per `/usr/share/hypr/stubs/hl.meta.lua` — the config's
   syntax for `mirror = desktopDisplay` was correct, so the failure had to be
   behavioral/timing, not a syntax mistake.
5. `hyprctl keyword monitor ...` failed ("can't work with non-legacy
   parsers") — this instance uses the Lua config, so `hyprctl eval <lua>` and
   `hyprctl repl <lua>` are the tools for live experiments, not `keyword`.
6. Read the running instance's log
   (`/run/user/1000/hypr/<instance>/hyprland.log`): `ConfigManager`/Lua config
   load happens at log line ~10-11; DRM connector probing doesn't start until
   line ~153+, and `HDMI-A-1` (piKVM) connects (line ~184) before `DP-1`
   (line ~235). Two conclusions from this:
   - `display.lua` runs before any monitor exists, so `hl.get_monitors()` is
     empty on the first pass and `primaryDisplay` silently resolves to `""`.
   - `HDMI-A-1`'s `mirror = desktopDisplay` rule is evaluated while `DP-1`
     doesn't exist yet, so it has nothing to mirror.
7. Live-tested via `hyprctl eval`: re-declaring
   `hl.monitor({ output = "HDMI-A-1", mirror = "DP-1" })` against the
   already-independent `HDMI-A-1` did **not** attach the mirror
   (`mirrorOf` stayed `none`).
8. Live-tested: `hl.monitor({ output = "HDMI-A-1", disabled = true })` then
   `hl.monitor({ ..., mirror = "DP-1", disabled = false })` **did** attach it
   (`mirrorOf: 1`) — disable/re-enable is required to force a monitor to pick
   up a new mirror target.
9. With the mirror genuinely attached, confirmed via `hyprctl repl` that
   `hl.get_monitors()` returned only `DP-1` (not `HDMI-A-1`) and
   `hl.get_monitor("HDMI-A-1")` returned `nil` — a true mirror is excluded
   from the Lua monitor API entirely.
10. Applied a fix to `display.lua`: wrapped the primary-display resolution and
   workspace-pinning loop in a function `apply_primary_display()`, called
   once at load and again on every `hl.on("monitor.added", ...)` event; added
   a forced `monitor:set_workspace(1)` when workspace 1 isn't already on the
   resolved primary monitor (rule changes don't migrate a live workspace);
   added the disable/re-enable cycle for `piKVMDisplay` guarded by
   `not pikvm.is_mirror`. Verified via `hyprctl reload` +
   `hyprctl workspacerules`/`hyprctl monitors`: all workspace rules → `DP-1`,
   `HDMI-A-1` → `mirrorOf: 1`, no workspace left on `HDMI-A-1`.
   True cold-boot (DRM re-enumeration) behavior was **not** verified end to
   end — that requires restarting Hyprland/the session, which was
   deliberately not done to avoid disrupting the live desktop.
11. User restored this `CLAUDE.md` (it had been missing from the working
    tree). Its existing "fixed 2026-08-09" gotcha note attributed the bug to
    a different mechanism (mirror being "render-only," monitor keeping an
    independent workspace slot even while mirroring). Step 9 above directly
    contradicts that: a genuine mirror is excluded from `hl.get_monitors()`.
    Rewrote the gotcha section to the verified mechanism, kept the old note
    collapsed under a `<details>` for history.
12. `hyprland/scripts/hyprland-reload.sh` was read and confirmed to only run
    `hyprctl reload` (+ restart sibling daemons) — never a full Hyprland
    restart — so it can't replay the DRM connector race. This is why the
    2026-08-09 fix looked correct after every reload/test but didn't survive
    an actual cold boot.
13. At some point after step 10, `display.lua` reverted to the pre-fix
    version (flat `is_monitor_connected`/`primaryDisplay` code, no
    `apply_primary_display` function, no `hl.on` hook, no forced
    workspace-1 move, no mirror disable/re-enable cycle) — confirmed by
    reading the file's current contents at the time. See the next session
    log entry for reapplying it and the bugs found in the process.

### 2026-08-10 (continued) — reapplying the fix, `set_workspace` crash, reload-batching caveat

Started from: user reported the exact predicted symptom (workspace 1 on
`desktopDisplay`, workspaces 2–10 on `piKVMDisplay`) and asked (a) why, given
the file matched the known-insufficient pre-fix version from the entry
above, and (b) whether the "neither known display connected" fallback branch
should just be removed, per the Hyprland Monitors wiki.

1. Read `display.lua` — confirmed it was exactly the pre-fix version
   described in step 13 above (flat `is_monitor_connected`/`primaryDisplay`,
   no `apply_primary_display`, no `hl.on` hook).
2. Tried to fetch `https://wiki.hypr.land/Configuring/Basics/Monitors/`
   directly via WebFetch for wildcard-rule/mirror-timing/workspace-default
   semantics — the page is JS-rendered and WebFetch only got nav chrome, no
   body content. Fell back to WebSearch instead:
   - Confirmed: "Leaving the output empty [in a monitor rule] will define a
     fallback rule to use when no other rules match" — i.e. a wildcard
     `hl.monitor({ output = "", ... })` rule is only a fallback for
     otherwise-unmatched monitors; it does **not** override an explicit
     named rule (like piKVM's `mirror = desktopDisplay`) regardless of
     declaration order. So the wildcard rule was never the direct cause of
     piKVM claiming workspaces — consistent with the existing diagnosis that
     the real cause is `mirror` failing to attach in time.
   - Found and fetched GitHub discussion hyprwm/Hyprland#11513: confirmed a
     workspace rule's `default = true` is scoped to whatever `monitor` value
     is in that same rule — if that monitor isn't connected/valid, Hyprland
     does **not** fall back sensibly, it just ignores the default flag for
     that rule and falls through to Hyprland's own built-in (connection-
     order-based) workspace assignment. This is exactly what happens when
     `primaryDisplay` resolves to `""` on the pre-DRM-probe pass: all 10
     workspace rules get `monitor = ""`, which matches no real monitor, so
     none of them (including workspace 1's `default = true`) take effect,
     and whichever monitor DRM happens to enumerate first/claims a slot
     first wins the low-numbered workspaces by Hyprland's own default logic.
3. Directly answered the user's "should we remove the fallback case"
   question: no — the fallback branch (`hl.monitor({ output = primaryDisplay,
   ... })` when neither known display is connected) is correct for a
   genuinely unknown machine; the bug is that `is_monitor_connected` is
   evaluated before DRM probing, so it spuriously returns false for
   `desktopDisplay` on *this* machine too on every cold boot. The existing
   `apply_primary_display`/`hl.on("monitor.added", ...)` fix from the first
   2026-08-10 pass already gates this correctly (`isKnownDisplay` check +
   early-return when `primaryDisplay == ""`), so reapplying it (not deleting
   the fallback) was the right move.
4. Reapplied the step-10 fix verbatim to `display.lua`, then `hyprctl
   reload`'d. `hyprctl workspacerules` showed all 10 rules correctly pinned
   to `DP-1` — but `hyprctl monitors` still showed `HDMI-A-1` with
   `mirrorOf: none` and holding workspace 1; `DP-1` still on workspace 3.
   The mirror-reattach and workspace-move parts of the fix visibly did not
   take effect even though the monitor-agnostic workspace-pinning part did.
5. Debugged live via `hyprctl repl` (learned `hyprctl eval` doesn't print
   return values; `hyprctl repl` does):
   - `mon:set_workspace(1)` (bare integer) → `attempt to index a number
     value`. `mon:set_workspace(ws1)` (the workspace object from
     `hl.get_workspace(1)`) and `mon:set_workspace("1")` (string) both work
     with no error. The stub at `/usr/share/hypr/stubs/hl.meta.lua` types
     this as `fun(self: HL.Monitor, ...): any` (no real parameter typing),
     so this had to be found empirically.
   - Because that call was unguarded and un-pcall'd, and came *before* the
     piKVM mirror block in the function body, the error silently aborted the
     rest of `apply_primary_display()` on this run — explaining why neither
     the workspace-1 move nor the piKVM reattach visibly happened after the
     step-4 reload.
   - Manually ran the piKVM disable/enable-with-mirror pair as two separate
     `hyprctl repl` invocations (not from within the config file):
     `hl.monitor({ output = "HDMI-A-1", disabled = true })`, then
     (separately) `hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60.00",
     position = "auto", scale = 1, mirror = "DP-1", disabled = false })`.
     This **did** attach the mirror (`HDMI-A-1` dropped out of `hyprctl
     monitors`/`hl.get_monitors()` entirely, matching the first pass's step 9
     finding), and workspace 1 **automatically** migrated to `DP-1` with no
     explicit `set_workspace` call needed — confirms a genuinely-attached
     mirror can't hold a workspace, Hyprland evicts it on its own.
   - Tried to reproduce the "independent" state again to test further
     (`disabled = true` then `disabled = false` with no `mirror` field, as
     two statements in one `hyprctl repl` line this time): the mirror did
     **not** detach (`directScanoutBlockedBy` on `DP-1` still showed "monitor
     mirrors" afterward) — so omitting `mirror` doesn't clear a
     previously-set mirror, and/or two monitor-rule statements issued
     together in one command may already start showing the same
     non-application behavior seen in step 6 below. Did not push further
     experimentation here to avoid destabilizing the live desktop more than
     necessary — the mirror staying attached is the desired end state anyway.
6. Fixed `display.lua`: changed `mon:set_workspace(1)` to
   `mon:set_workspace(ws1)`, and moved the piKVM disable/re-enable block to
   run *before* the workspace-1 move block (defense in depth against the
   same class of bug recurring). `hyprctl reload` afterward: `hyprctl
   configerrors` empty, `hyprctl monitors`/`hyprctl workspaces` confirm
   `HDMI-A-1` mirroring, workspaces 1–3 all on `DP-1`. Live desktop state is
   correct as of this writing — but note this reflects the step-5 manual
   `hyprctl repl` fix plus the crash fix, not confirmation that the
   in-config disable/re-enable cycle itself reliably reattaches a mirror
   when run inside one `hyprctl reload` pass (see the open caveat in the
   "Gotcha, take 2" section above — still unresolved and still requires an
   actual reboot to test properly).

Current fix code, live in `display.lua` as of this entry (replaces
everything from `-- Determine the machine's primary display and (re-)pin...`
through the trailing `hl.monitor({ output = "", ... mirror = primaryDisplay
})` line):

```lua
local function apply_primary_display()
  local primaryDisplay
  if is_monitor_connected(desktopDisplay) then
    primaryDisplay = desktopDisplay
  elseif is_monitor_connected(laptopDisplay) then
    primaryDisplay = laptopDisplay
  else
    primaryDisplay = first_monitor_name()
  end

  if primaryDisplay == "" then
    return
  end

  local isKnownDisplay = primaryDisplay == desktopDisplay or primaryDisplay == laptopDisplay or primaryDisplay == piKVMDisplay

  if not (is_monitor_connected(desktopDisplay) or is_monitor_connected(laptopDisplay)) and not isKnownDisplay then
    hl.monitor({ output = primaryDisplay, mode = "highres@highrr", position = "auto", scale = 1 })
  end

  for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = primaryDisplay, default = (i == 1) })
  end

  -- Mirror reattach runs before the workspace-1 move: if the move ever
  -- breaks again, it shouldn't be able to suppress this too.
  if primaryDisplay == desktopDisplay then
    local pikvm = hl.get_monitor(piKVMDisplay)
    if pikvm and not pikvm.is_mirror then
      hl.monitor({ output = piKVMDisplay, disabled = true })
      hl.monitor({ output = piKVMDisplay, mode = "1920x1080@60.00", position = "auto", scale = 1, mirror = desktopDisplay, disabled = false })
    end
  end

  -- Must pass the workspace object, not a bare integer:
  -- mon:set_workspace(1) throws "attempt to index a number value".
  local ws1 = hl.get_workspace(1)
  if ws1 and (not ws1.monitor or ws1.monitor.name ~= primaryDisplay) then
    local mon = hl.get_monitor(primaryDisplay)
    if mon then
      mon:set_workspace(ws1)
    end
  end

  hl.monitor({ output = "", mode = "highres@highrr", position = "auto", scale = 1, mirror = primaryDisplay })
end

apply_primary_display()
hl.on("monitor.added", apply_primary_display)
```
