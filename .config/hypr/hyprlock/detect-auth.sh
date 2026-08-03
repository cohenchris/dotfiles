#!/usr/bin/env bash
# Symlinks hyprlock-auth.conf to the fingerprint or password variant depending on
# whether a fprintd-managed fingerprint reader is present on this host. Run once at
# Hyprland startup (see hyprland.lua) since the hardware doesn't change mid-session.
set -euo pipefail

hyprlock_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/hypr/hyprlock"
hyprlock_auth_conf="${XDG_CACHE_HOME:-${HOME}/.local/cache}/hyprlock-auth.conf"

device_count=0
if command -v busctl &>/dev/null; then
  reply=$(busctl call net.reactivated.Fprint /net/reactivated/Fprint/Manager \
    net.reactivated.Fprint.Manager GetDevices 2>/dev/null) || reply=""
  device_count=$(awk '{print $2}' <<<"$reply")
  device_count=${device_count:-0}
fi

if [[ "$device_count" -gt 0 ]]; then
  ln -sf "$hyprlock_dir/auth-fingerprint.conf" "$hyprlock_auth_conf"
else
  ln -sf "$hyprlock_dir/auth-password.conf" "$hyprlock_auth_conf"
fi
