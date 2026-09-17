# ft-livew

Lightweight live wallpaper controller for Linux/X11/XFCE using **xwinwrap + mpv**, with local H.264 caching, VA-API hardware decoding, multi-monitor mirroring, and automatic pause while fullscreen/maximized applications are active.

> Created by **ft_aska.90**
>
> This repository contains a reconstruction of the latest `livew` baseline developed and used on the author's machine.

## Features

- local H.264 wallpaper cache at **1366x768 / 15 FPS / CRF 26**;
- source cache reuse when the source file has not changed;
- mpv hardware decode using **VA-API / i965**;
- one `xwinwrap + mpv` wallpaper instance per active XRandR monitor;
- same wallpaper mirrored independently to every active monitor;
- automatic pause when the active window is fullscreen;
- automatic pause when the active window is maximized both vertically and horizontally;
- automatic resume when leaving fullscreen/maximized state;
- mpv IPC control through `/tmp/livew-mpv-*.sock`;
- `--auto` to restore the previous wallpaper;
- `--stop` for Game Mode / manual shutdown;
- `--status` for a quick controller check;
- XFCE autostart with a 10-second startup delay;
- paths use `$HOME` / XDG directories instead of a hardcoded local username.

## Development / Tested Environment

Project ini dibuat dan diuji terutama pada lingkungan berikut:

- Laptop: **Toshiba Satellite L735 (PSK0AL-010004)**
- CPU: **Intel Core i3-2350M @ 2.30 GHz**
- GPU: **Intel HD Graphics 3000 / Sandy Bridge GT2**
- GPU PCI ID: **8086:0116**
- RAM: **3.76 GiB**
- OS: **CachyOS x86_64**
- Kernel pengembangan: **Linux 7.1.8-1-cachyos**
- Desktop Environment: **Xfce 4.20**
- Window Manager: **Xfwm4**
- Display Server: **X11**
- Graphics stack yang dipakai saat pengembangan: **Mesa 26.1.6 / Crocus / i915**

### Compatibility warning

Project ini dibuat berdasarkan environment di atas, jadi **tidak disarankan untuk langsung diasumsikan kompatibel dengan semua laptop, distro, DE, display server, GPU, atau versi dependency lain**.

Silakan mencoba jika hardware dan software stack kamu sama atau cukup kompatibel. Jika berbeda, cek dependency, X11/XRandR behavior, VA-API driver, `xwinwrap`, dan konfigurasi mpv sebelum menjadikannya autostart.

## Dependencies

Runtime utama:

- `mpv`
- `ffmpeg`
- `xwinwrap`
- `xrandr`
- `xprop`
- `socat`
- `sha256sum`
- `zenity` untuk file picker interaktif

Untuk environment Intel HD 3000 pengembangan:

- `libva-utils`
- `libva-intel-driver` / i965 VA-API driver

Pada Arch/CachyOS, sebagian besar dependency dapat dipasang dari repository distro; `xwinwrap` dapat berasal dari package/AUR yang sesuai dengan sistemmu.

## Install

```bash
git clone https://github.com/ftaska90/ft-livew.git
cd ft-livew
chmod +x install.sh
./install.sh
```

Installer memasang:

```text
~/.local/bin/livew
~/.config/autostart/livew.desktop
```

## Usage

Pilih video dengan file picker:

```bash
livew
```

Atau langsung berikan file:

```bash
livew ~/Videos/wallpaper.mp4
```

Restore wallpaper terakhir:

```bash
livew --auto
```

Stop wallpaper:

```bash
livew --stop
```

Cek status:

```bash
livew --status
```

## Cache pipeline

Source video dikonversi satu kali menjadi cache ringan:

```text
H.264
1366x768
15 FPS
CRF 26
yuv420p
no audio
```

Cache berada di:

```text
~/.cache/livew/
```

Saat cache yang sesuai sudah ada, proses encode dilewati.

## Runtime files

```text
~/.config/livew/last_source
~/.config/livew/last_wallpaper
~/.cache/livew/
/tmp/livew.pid
/tmp/livew.log
/tmp/livew-encode.log
/tmp/livew-mpv-*.sock
```

Tidak ada wallpaper/video pribadi yang disimpan di repository ini. Hanya path source dan cache yang dibuat secara lokal pada mesin pengguna.

## Multi-monitor

`livew` membaca monitor aktif dari `xrandr` dan membuat wallpaper window sendiri untuk setiap geometry monitor. Setiap monitor memainkan cache yang sama sehingga hasilnya berupa mirror wallpaper per-monitor tanpa membuat satu canvas desktop raksasa.

## Fullscreen / maximized auto-pause

`xprop` dipakai untuk membaca active window dan `_NET_WM_STATE`.

Playback otomatis pause jika active window memiliki:

```text
_NET_WM_STATE_FULLSCREEN
```

atau kedua state berikut:

```text
_NET_WM_STATE_MAXIMIZED_VERT
_NET_WM_STATE_MAXIMIZED_HORZ
```

Ketika kondisi tersebut hilang, semua mpv wallpaper langsung di-resume melalui IPC.

## Autostart

Installer membuat XFCE autostart yang menjalankan:

```bash
sleep 10
livew --auto
```

Delay tersebut sengaja dipakai agar session Xfce, Xfwm4 dan XRandR sudah siap sebelum xwinwrap dibuat.

## Repository layout

```text
livew
install.sh
autostart/livew.desktop
docs/BEHAVIOR.md
LICENSE
NOTICE
```

Detail runtime ada di [`docs/BEHAVIOR.md`](docs/BEHAVIOR.md).

## Author

Created by **ft_aska.90**.

Copyright (c) 2026 ft_aska.90.

## License

Licensed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
