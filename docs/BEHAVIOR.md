# FT LiveW behavior

Created by **ft_aska.90**.

This repository contains a reconstruction of the latest FT LiveW behavior used on the author's CachyOS/Xfce/X11 setup.

## Rendering pipeline

The selected source video is converted once into a lightweight local cache:

- codec: H.264 / `libx264`
- target size: `1366x768`
- target framerate: `15 FPS`
- CRF: `26`
- audio removed
- pixel format: `yuv420p`

The cache is stored in:

```text
~/.cache/livew/
```

A source signature includes the source path, size, modification time, target resolution and target FPS, so an unchanged source can reuse the existing cache.

## Hardware decode

The runtime exports:

```text
LIBVA_DRIVER_NAME=i965
```

and starts mpv with:

```text
--hwdec=vaapi
--vo=gpu
--gpu-api=opengl
```

This matches the Intel HD Graphics 3000 / Sandy Bridge setup on which LiveW was developed.

## Multi-monitor behavior

Active monitor geometry is read from `xrandr`. A separate `xwinwrap + mpv` instance is created for each active monitor using that monitor's geometry.

Each monitor therefore displays the same cached wallpaper independently while using one controller process.

## Fullscreen/maximized auto-pause

LiveW checks `_NET_ACTIVE_WINDOW` and `_NET_WM_STATE` using `xprop`.

Wallpaper playback pauses when the foreground window is either:

- `_NET_WM_STATE_FULLSCREEN`, or
- maximized both vertically and horizontally.

When the foreground window no longer matches those states, playback resumes automatically.

The pause/resume commands are sent to each mpv instance through Unix IPC sockets:

```text
/tmp/livew-mpv-*.sock
```

## Runtime state

```text
~/.config/livew/last_source
~/.config/livew/last_wallpaper
~/.cache/livew/
/tmp/livew.pid
/tmp/livew.log
/tmp/livew-encode.log
/tmp/livew-mpv-*.sock
```

`last_source` stores the original selected source file. `last_wallpaper` stores the generated cached file path.

## Commands

Interactive/file mode:

```bash
livew
livew /path/to/video.mp4
```

Restore the last source without opening the picker:

```bash
livew --auto
```

Stop all wallpaper instances managed by LiveW:

```bash
livew --stop
```

Status:

```bash
livew --status
```

## XFCE autostart

The installer creates an XFCE autostart entry that waits 10 seconds after login and then runs:

```bash
livew --auto
```

The delay gives Xfce, Xfwm4, XRandR and the desktop enough time to settle before xwinwrap windows are created.
