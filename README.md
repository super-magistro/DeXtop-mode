# DeXtop Mode: Samsung DeX & Android Desktop Mode on Linux, macOS & Windows

[![PyPI version](https://img.shields.io/pypi/v/dextop-mode.svg?color=blue&logo=pypi&logoColor=white)](https://pypi.org/project/dextop-mode/)
[![GitHub release](https://img.shields.io/github/v/release/super-magistro/DeXtop-mode?logo=github)](https://github.com/super-magistro/DeXtop-mode/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/super-magistro/DeXtop-mode/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-informational)](https://github.com/super-magistro/DeXtop-mode/releases)
[![Python](https://img.shields.io/badge/python-3.8%2B-blue?logo=python&logoColor=white)](https://pypi.org/project/dextop-mode/)

**DeXtop Mode** is a modern, cross-platform Python GUI wrapper that launches a virtual second screen displaying your Android smartphone's desktop mode (Samsung DeX, Motorola Ready For, native Android AOSP Desktop Mode, etc.) on **Linux** (Ubuntu, Debian, Mint, Pop!_OS, Zorin OS), **macOS** (Intel & Apple Silicon M1-M4), and **Windows** (10/11).

It utilizes the powerful engine of [scrcpy](https://github.com/Genymobile/scrcpy) in the background to handle control and high-performance video/audio streaming.

---

## 🚀 Key Features

* **Cross-Platform Support (Linux, macOS, Windows)**:
  * 🐧 **Linux**: Native Debian package (`.deb`), 1-line `curl` script, taskbar integration (`StartupWMClass=dextop`), and WirePlumber/PipeWire audio routing.
  * 🍏 **macOS**: 1-line `curl` script (Launchpad app), native Disk Image (`.dmg`) with `dextop-mode.app` bundle, and 1-click Homebrew dependency installer.
  * 🪟 **Windows**: Standalone 64-bit executable (`.exe`) and 1-click Winget dependency installer.
  * 🐍 **PyPI / Pip / Pipx**: `pip install dextop-mode` / `pipx install dextop-mode` for all platforms.
* **Modern Control Center (GUI)**: A sleek CustomTkinter desktop interface in dark mode.
* **Automated Wireless Debugging (ADB Over Wi-Fi)**:
  * Integrated **Wireless Pairing (Association)** dialog with step-by-step guidance.
  * **QR Code pairing**: scan the code shown in DeXtop Mode, the phone is found automatically (mDNS).
  * Direct one-click Wi-Fi connection with smart IP & Port auto-filling.
* **Audio Forwarding**:
  * By default, the phone's audio plays on your **computer's speakers**; choose **Phone speaker** to keep the sound on the phone.
  * On Linux, pick any output device (WirePlumber/PipeWire).
* **Clipboard Sync**: copy on the phone, paste on the computer and vice versa (can be turned off in Settings).
* **Display Modes & Custom DPI Scaling**:
  * Easily toggle between **Secondary Display (DeX Mode)** and **Main Display Mirroring**.
  * Customizable desktop display density (160 DPI standard desktop, 200 DPI, 240 DPI).
* **Intelligent Power Management (Anti-Veille)**:
  * Temporarily disables the smartphone's screen timeout (`screen_off_timeout`) during a DeX session, and restores it automatically at the end (even after a lost connection, the next time the phone is detected).
  * Prevents computer sleep during a session (`systemd-inhibit` on Linux / `caffeinate` on macOS / `SetThreadExecutionState` on Windows).
  * Turns off the physical smartphone screen to save battery and avoid screen burn-in.
* **Clean Exit with the Power Button**: pressing the phone's power button during a DeX session cleanly stops it.
* **Automatic & Manual One UI Gesture Repair**:
  * Automatically resets DeX mode and restarts the One UI Home launcher (`com.sec.android.app.launcher`) at the end of a session to prevent back gesture freezes on Samsung smartphones.
  * **"Repair One UI Gestures Now"** button in the Settings tab for manual repair (only if your gestures are broken).
* **Mouse & Keyboard Capture (UHID)**:
  * Optional mouse and keyboard capture (UHID) for high precision control, customizable in the Settings tab (press `LAlt` or `Super` to release).

---

## 🛠️ Prerequisites

1. **Compatible Smartphone**:
   * Samsung Galaxy S series (S8 to S26), Note series, or Z Fold.
   * Motorola Edge or Razr series.
   * Any smartphone running Android 11+ (for wireless debugging) or Android 15+ (for native desktop mode).
2. **On your Phone**:
   * Enable **Developer Options** (Settings > About Phone, tap *Build Number* 7 times).
   * Turn on **USB Debugging** and **Wireless Debugging** in Developer Options.
3. **On your Computer**:
   * **Linux**: Any Debian/Ubuntu-based distribution (Ubuntu, Mint, Debian, Pop!_OS, Zorin OS, etc.).
   * **macOS**: macOS 11+ (Intel or Apple Silicon M1/M2/M3/M4).
   * **Windows**: Windows 10 or Windows 11 (64-bit).

---

## 📥 Installation

Choose your platform below:

### 🐧 Linux (Debian / Ubuntu / Mint / Pop!_OS / Zorin OS)

#### **Option A: Debian Package (`.deb`) — Recommended**
Download the latest `.deb` package from [GitHub Releases](https://github.com/super-magistro/DeXtop-mode/releases) and install it:
```bash
sudo apt install ./dextop-mode_1.1.5_all.deb
```

#### **Option B: One-Line Terminal Installer**
```bash
curl -fsSL https://raw.githubusercontent.com/super-magistro/DeXtop-mode/main/install_dex.sh | bash
```

---

### 🍏 macOS (Apple Silicon & Intel)

#### **Option A: One-Line Terminal Installer — Recommended**
Installs Homebrew (if needed), scrcpy, adb, Python-TK and DeXtop Mode, and adds **DeXtop Mode** to Launchpad (no security warning):
```bash
curl -fsSL https://raw.githubusercontent.com/super-magistro/DeXtop-mode/main/install_dex.sh | bash
```

#### **Option B: macOS Disk Image (`.dmg`)**
1. Download **`dextop-mode_macOS.dmg`** from [GitHub Releases](https://github.com/super-magistro/DeXtop-mode/releases).
2. Double-click the `.dmg` image and open **dextop-mode.app**!
3. If `scrcpy` or `adb` are missing, **DeXtop Mode** will offer a 1-click prompt to automatically install dependencies via Homebrew.

> **First launch:** the app is not signed by Apple, so macOS blocks it the first time. Go to **System Settings → Privacy & Security**, scroll down and click **Open Anyway** next to *dextop-mode*.

---

### 🪟 Windows (10 / 11)

#### **Option A: Standalone Executable (`.exe`) — Recommended**
1. Download **`dextop-mode_windows_x64.exe`** from [GitHub Releases](https://github.com/super-magistro/DeXtop-mode/releases).
2. Double-click **`dextop-mode_windows_x64.exe`** to launch!
3. If `scrcpy` or `adb` are missing, **DeXtop Mode** will offer a 1-click prompt to automatically install dependencies via Winget.

> **First launch:** the executable is not signed, so Windows SmartScreen may show *"Windows protected your PC"*. Click **More info → Run anyway**.

---

### 🐍 PyPI / Pip / Pipx (Universal for All OS)

```bash
pip install dextop-mode
# or via pipx
pipx install dextop-mode
```

> **macOS note:** Homebrew's Python ships without tkinter. If DeXtop Mode reports `No module named '_tkinter'`, run `brew install python-tk@3.X` (matching your Python version) — or simply use the one-line installer above, which handles it.

---

## 💡 How to Use

1. Ensure your phone and PC are on the same Wi-Fi network (or connected via USB).
2. Open **DeXtop Mode**.
3. **If using Wi-Fi for the first time**, click **Pair a New Device**, then either:
   * **With a QR code**: click **📷 Pair with QR Code instead**, and on your phone, inside *Wireless Debugging*, select *Pair device with QR code* and scan it.
   * **With a code**: on your phone, select *Pair device with pairing code*, enter the IP, the pairing port and the 6-digit code shown, then click **Start Pairing**.
4. In the main window, enter the IP and connection port shown under *Wireless Debugging* and click **Connect over Wi-Fi** (or simply plug in USB).
5. In the Audio tab, keep **Computer speakers (default)** or choose **Phone speaker (no forwarding)**.
6. Click **Start DeX**.
   * *Your phone screen will turn off, the control GUI will hide itself, and your DeX window will pop up!*
   * *Close the DeX window or press the phone's power button to stop: the control GUI will reappear.*

---

## 🗑️ Uninstallation

To remove DeXtop Mode and clean up configurations:

* **Linux (`.deb`)**:
  ```bash
  sudo apt remove dextop-mode
  ```
* **Linux (one-line installer)** — removes the package, shortcuts, config and the installer's files:
  ```bash
  bash ~/.local/share/dextop-mode/uninstall.sh
  ```
* **macOS (`.dmg`)**: drag **dextop-mode.app** from Applications to the Trash.
* **Windows (`.exe`)**: delete `dextop-mode_windows_x64.exe`.
* **Pip / Pipx / macOS one-line installer**:
  ```bash
  dextop --uninstall
  pipx uninstall dextop-mode
  ```

---

## 💳 Credits

* Engine: [scrcpy](https://github.com/Genymobile/scrcpy) by Genymobile.
* Wrapper & Configurator: super-magistro.

Licensed under the MIT License. See [LICENSE](https://github.com/super-magistro/DeXtop-mode/blob/main/LICENSE) for details.
