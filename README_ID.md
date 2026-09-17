# ft-livew

[English](README_EN.md) | **Bahasa Indonesia**

Controller live wallpaper ringan untuk Linux/X11/XFCE menggunakan **xwinwrap + mpv**, dengan cache H.264 lokal, hardware decode VA-API, mirror multi-monitor, dan auto-pause saat aplikasi fullscreen/maximized aktif.

> Dibuat oleh **ft_aska.90**
>
> Repository ini berisi rekonstruksi baseline `livew` terakhir yang dikembangkan dan dipakai pada mesin pembuat.

## Fitur

- cache H.264 lokal **1366x768 / 15 FPS / CRF 26**;
- cache dipakai ulang jika source belum berubah;
- hardware decode mpv menggunakan **VA-API / i965**;
- satu instance `xwinwrap + mpv` untuk setiap monitor XRandR aktif;
- wallpaper yang sama dicerminkan per-monitor;
- auto-pause saat active window fullscreen;
- auto-pause saat active window maximize horizontal + vertical;
- auto-resume setelah keluar dari kondisi tersebut;
- kontrol mpv melalui IPC `/tmp/livew-mpv-*.sock`;
- `--auto`, `--stop`, dan `--status`;
- autostart XFCE dengan delay 10 detik;
- tidak ada username lokal yang di-hardcode.

## Lingkungan Pengembangan / Pengujian

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
- Graphics stack: **Mesa 26.1.6 / Crocus / i915**

## Peringatan Kompatibilitas

Project ini dibangun untuk environment di atas. Jika menggunakan distro, DE, Wayland/X11, GPU, VA-API driver, atau versi mpv yang berbeda, periksa kompatibilitas terlebih dahulu sebelum menjadikannya autostart.

## Dependency

- `mpv`
- `ffmpeg`
- `xwinwrap`
- `xrandr`
- `xprop`
- `socat`
- `sha256sum`
- `zenity` untuk file picker
- `libva-utils`
- `libva-intel-driver` / i965 untuk target Intel HD 3000

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

## Pemakaian

Pilih wallpaper:

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

Stop:

```bash
livew --stop
```

Status:

```bash
livew --status
```

## Cache

Source dikonversi menjadi:

```text
H.264
1366x768
15 FPS
CRF 26
yuv420p
no audio
```

Cache berada di `~/.cache/livew/`.

## File Runtime Lokal

```text
~/.config/livew/last_source
~/.config/livew/last_wallpaper
~/.cache/livew/
/tmp/livew.pid
/tmp/livew.log
/tmp/livew-encode.log
/tmp/livew-mpv-*.sock
```

Video/wallpaper pribadi tidak disimpan di repository.

## Multi-monitor

`livew` membaca monitor aktif dari `xrandr` dan membuat window wallpaper untuk setiap geometry monitor. Semua monitor memainkan cache yang sama secara independen.

## Auto-pause Fullscreen / Maximized

`xprop` digunakan untuk membaca `_NET_ACTIVE_WINDOW` dan `_NET_WM_STATE`. Playback pause saat window aktif fullscreen atau maximize horizontal + vertical, lalu resume otomatis saat kondisi tersebut hilang.

## Autostart

Installer membuat autostart XFCE yang menjalankan `livew --auto` setelah delay 10 detik agar Xfce, Xfwm4, dan XRandR sudah siap.

Detail runtime: [`docs/BEHAVIOR.md`](docs/BEHAVIOR.md).

## Pembuat

Dibuat oleh **ft_aska.90**.

Copyright (c) 2026 ft_aska.90.

## Lisensi

Dilindungi oleh **MIT License**. Lihat [`LICENSE`](LICENSE).
