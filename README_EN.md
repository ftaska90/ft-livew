# ft-livew

**English** | [Bahasa Indonesia](README_ID.md)

A lightweight live wallpaper controller for Linux/X11/XFCE using **xwinwrap + mpv**, with local H.264 caching, VA-API hardware decoding, multi-monitor mirroring, and automatic pause while fullscreen/maximized applications are active.

> Created by **ft_aska.90**
>
> This repository contains a reconstruction of the latest `livew` baseline developed and used on the author's machine.

## Features

- local H.264 cache at **1366x768 / 15 FPS / CRF 26**;
- cache reuse when the source has not changed;
- mpv hardware decoding using **VA-API / i965**;
- one `xwinwrap + mpv` instance for each active XRandR monitor;
- the same wallpaper mirrored independently per monitor;
- automatic pause when the active window is fullscreen;
- automatic pause when the active window is maximized horizontally and vertically;
- automatic resume after leaving those states;
- mpv IPC control through `/tmp/livew-mpv-*.sock`;
- `--auto`, `--stop`, and `--status`;
- XFCE autostart with a 10-second delay;
- no hardcoded local username paths.

## Development / Tested Environment

- Laptop: **Toshiba Satellite L735 (PSK0AL-010004)**
- CPU: **Intel Core i3-2350M @ 2.30 GHz**
- GPU: **Intel HD Graphics 3000 / Sandy Bridge GT2**
- GPU PCI ID: **8086:0116**
- RAM: **3.76 GiB**
- OS: **CachyOS x86_64**
- Development kernel: **Linux 7.1.8-1-cachyos**
- Desktop Environment: **Xfce 4.20**
- Window Manager: **Xfwm4**
- Display Server: **X11**
- Graphics stack: **Mesa 26.1.6 / Crocus / i915**

## Compatibility Warning

This project was built around the environment above. If you use a different distribution, desktop environment, Wayland/X11 setup, GPU, VA-API driver, or mpv version, review compatibility before enabling it as an autostart application.

## Dependencies

- `mpv`
- `ffmpeg`
- `xwinwrap`
- `xrandr`
- `xprop`
- `socat`
- `sha256sum`
- `zenity` for the file picker
- `libva-utils`
- `libva-intel-driver` / i965 for the Intel HD 3000 target

## Install

```bash
git clone https://github.com/ftaska90/ft-livew.git
cd ft-livew
chmod +x install.sh
./install.sh
```

The installer creates:

```text
~/.local/bin/livew
~/.config/autostart/livew.desktop
```

## Usage

Choose a wallpaper interactively:

```bash
livew
```

Or pass the file directly:

```bash
livew ~/Videos/wallpaper.mp4
```

Restore the last wallpaper:

```bash
livew --auto
```

Stop:

```bash
livew --stop
```

Status:

```bash
livew --status
```

## Cache

The source is converted to:

```text
H.264
1366x768
15 FPS
CRF 26
yuv420p
no audio
```

Cache files are stored in `~/.cache/livew/`.

## Local Runtime Files

```text
~/.config/livew/last_source
~/.config/livew/last_wallpaper
~/.cache/livew/
/tmp/livew.pid
/tmp/livew.log
/tmp/livew-encode.log
/tmp/livew-mpv-*.sock
```

Private wallpaper/video files are not stored in this repository.

## Multi-monitor

`livew` reads active monitors through `xrandr` and creates a wallpaper window for each monitor geometry. Every monitor plays the same cached wallpaper independently.

## Fullscreen / Maximized Auto-pause

`xprop` is used to read `_NET_ACTIVE_WINDOW` and `_NET_WM_STATE`. Playback pauses while the foreground window is fullscreen or maximized both horizontally and vertically, then resumes automatically afterward.

## Autostart

The installer creates an XFCE autostart entry that runs `livew --auto` after a 10-second delay so Xfce, Xfwm4, and XRandR are ready.

Runtime details: [`docs/BEHAVIOR.md`](docs/BEHAVIOR.md).

## Author

Created by **ft_aska.90**.

Copyright (c) 2026 ft_aska.90.

## License

Licensed under the **MIT License**. See [`LICENSE`](LICENSE).
