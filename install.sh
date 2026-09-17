#!/usr/bin/env bash
# FT LiveW installer
# Created by ft_aska.90
# Copyright (c) 2026 ft_aska.90
# SPDX-License-Identifier: MIT

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"

mkdir -p "$BIN_DIR" "$AUTOSTART_DIR"

install -m 0755 "$REPO_DIR/livew" "$BIN_DIR/livew"

cat >"$AUTOSTART_DIR/livew.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=FT LiveW
Comment=Restore the last FT LiveW wallpaper after login
Exec=sh -lc 'sleep 10; "$HOME/.local/bin/livew" --auto'
OnlyShowIn=XFCE;
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

chmod 0644 "$AUTOSTART_DIR/livew.desktop"

echo "FT LiveW installed."
echo "Binary   : $BIN_DIR/livew"
echo "Autostart: $AUTOSTART_DIR/livew.desktop"
echo
echo "Recommended dependencies on Arch/CachyOS:"
echo "  mpv ffmpeg xorg-xrandr xorg-xprop socat zenity libva-utils libva-intel-driver"
echo "  plus xwinwrap from your preferred package/AUR source"
