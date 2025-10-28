# 🕐 Mako Reminder CLI

A lightweight, offline reminder system for Linux built with **systemd**, **Bash**, and **Mako notifications**.  
No apps, no clutter — just minimal Arch-style reminders that *respect your flow*.

---

## ✨ Features

- 💧 Set custom reminders that repeat every X minutes/hours/days  
- ⚙️ Powered by `systemd --user` timers (no background daemons)  
- 📬 Native desktop notifications via Mako  
- 💤 Pause, resume, delete, or list reminders easily  
- 💻 100% offline and shell-native  

---

## 🧰 Dependencies

Make sure these are installed:

```bash
sudo pacman -S mako libnotify upower

