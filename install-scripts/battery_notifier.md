# 🔋 Battery Notifier for Arch / Hyprland

A lightweight **battery notification system** built for **Arch Linux + Hyprland** users.  
It runs silently in the background using a **systemd timer** and **notifies you** when your battery is **low (≤20%)** or **fully charged (≥90%)** — helping you extend your battery’s lifespan.

---

## ✨ Features

- 🪶 Lightweight (pure Bash + systemd)
- 🔔 Uses `mako` for Wayland notifications  
- 🔋 Alerts when battery is low or fully charged
- 🔁 Runs automatically every 5 minutes
- 🔧 Auto-installs `mako` if missing
- 🧠 Smart environment fix for Hyprland / Wayland notifications

---

## ⚙️ Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/yourusername/battery-notifier.git
cd battery-notifier
chmod +x install.sh
./install.sh
