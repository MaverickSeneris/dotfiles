# ⚡ Battery Notifier (Arch + Hyprland / Wayland)

A lightweight battery monitoring system built with **Bash**, **systemd**, and **Mako notifications**.
It keeps your laptop safe from overcharging and low-battery drops — *without* running any heavy background daemons.

---

## ✨ Features

* 🔋 **Low Battery Warning** — alerts when battery ≤ 20 %.
* 🔌 **Full Battery Reminder** — notifies when charging ≥ 90 %.
* 🔔 **Native Notifications** via Mako (`notify-send`)
* 🕐 **Runs every 5 minutes** with `systemd --user` timer.
* 💻 **Wayland compatible** (Hyprland, Sway, etc.).
* 🧠 Minimal resource usage — no loops, no polling daemons.

---

## 🧰 Dependencies

Make sure these packages are installed:

```bash
sudo pacman -S upower libnotify mako
```

---

## ⚙️ Installation

Clone your dotfiles or copy the installer script to your system:

```bash
git clone https://github.com/<your-username>/battery-notifier.git
cd battery-notifier
bash install_battery_notifier.sh
```

The installer will:

1. Place `battery_notify.sh` inside `~/.local/bin/`.
2. Create and enable the `battery-notify.service` and `battery-notify.timer`.
3. Add required environment variables for Wayland.
4. Automatically start the timer.

---

## 🧪 Test Notification

You can test it anytime:

```bash
bash ~/.local/bin/battery_notify.sh
```

If the battery level meets the thresholds, a Mako popup will appear.

---

## 🧩 Directory Map

```plaintext
📂 /home/maverickseneris
├── .local/bin/
│   └── battery_notify.sh               ← 🧠 Main script
│
├── .config/systemd/user/
│   ├── battery-notify.service          ← ⚙️ Runs script once
│   └── battery-notify.timer            ← ⏱️ Runs every 5 min
│
└── Projects/dotfiles/install-scripts/
    └── install_battery_notifier.sh     ← 🪄 Installer script
```

---

## ⚙️ System Flow

```plaintext
systemd --user timer (every 5 min)
            │
            ▼
battery-notify.service
            │
            ▼
~/.local/bin/battery_notify.sh
            │
            ├─ Checks battery level (upower)
            ├─ Determines charging state
            └─ Sends notification via Mako 🔔
```

---

## 🧭 Commands

### Check status

```bash
systemctl --user status battery-notify.timer
```

### View logs

```bash
journalctl --user -u battery-notify.service -n 20 --no-pager
```

### Stop the timer

```bash
systemctl --user disable --now battery-notify.timer
```

---

## 💡 Notes

* Works with **Wayland** and **X11** (uses `notify-send`).
* Environment variables for Hyprland are automatically exported in the script:

  ```bash
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
  export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
  export DISPLAY=":0"
  ```
* You can modify thresholds (`≤ 20`, `≥ 90`) directly in the script.

---

## 🧙 Author

**Maverick** — minimalist tinkerer, Arch monk, and automator.

> “Power is nothing without awareness — even your battery should speak to you.” ⚡


