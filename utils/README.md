## 🧾 Step-by-Step — Back Up Your Fn Mode Script

### 1️⃣ Copy your working script to your dotfiles repo

```bash
sudo cp /usr/local/bin/fnmode-setup ~/Projects/dotfiles/utils/fnmode-setup.sh
sudo chown $USER:$USER ~/Projects/dotfiles/utils/fnmode-setup.sh
chmod +x ~/Projects/dotfiles/utils/fnmode-setup.sh
```

✅ This ensures your version in `/usr/local/bin` stays working,
but now you have a **user-owned, editable backup** in your repo.

---

### 2️⃣ Create a README file next to it

```bash
nano ~/Projects/dotfiles/utils/README.md
```

Paste this 👇

````markdown
# 🧙 Fn Mode Setup Script (MacBook / Arch Linux)

## 📘 Description
This script configures the **MacBook Fn key behavior** (`hid_apple` driver).  
It lets you choose how your **F1–F12 keys** work — as media keys, function keys, or smart hybrid.

It automatically:
- Applies your chosen mode (0, 1, or 2)
- Saves it permanently in `/etc/modprobe.d/hid_apple.conf`
- Creates a persistent systemd service
- Rebuilds Limine initramfs for boot persistence

---

## ⚙️ Installation (on a new machine)

Copy the script into `/usr/local/bin` and make it executable:

```bash
sudo cp fnmode-setup.sh /usr/local/bin/fnmode-setup
sudo chmod +x /usr/local/bin/fnmode-setup
````

Then run it:

```bash
fnmode-setup
```

Follow the menu to select your preferred mode:

| Mode | Description                                        |
| ---- | -------------------------------------------------- |
| `0`  | Media keys by default (Fn gives F1–F12)            |
| `1`  | Smart hybrid (macOS-style — remembers last mode) ✅ |
| `2`  | Function keys by default (Fn gives media keys)     |

> **Recommended:** `1` for macOS-like experience.

---

## 🔍 To verify your current mode

```bash
cat /sys/module/hid_apple/parameters/fnmode
```

---

## 🧩 Notes

* Tested on **MacBook Air 2013 (A1465)** with Arch Linux + Limine
* Requires `hid_apple` kernel module
* Works on both Hyprland and Xorg setups
* Run `sudo limine-mkinitcpio` if prompted after applying changes

---

## 🧼 Uninstall

To remove from the system:

```bash
sudo rm /usr/local/bin/fnmode-setup
```

---

## 🧙 Author

**Maverick Seneris**
Arch tinkerer, believer in both science & faith ⚔️✨

````

---

### 3️⃣ Commit and push to your repo
```bash
cd ~/Projects/dotfiles
git add utils/fnmode-setup.sh utils/README.md
git commit -m "Add fnmode-setup script and setup guide"
git push
````

---

✅ **Result summary:**

* `/usr/local/bin/fnmode-setup` → still works system-wide
* `~/Projects/dotfiles/utils/fnmode-setup.sh` → backup tracked in GitHub
* `~/Projects/dotfiles/utils/README.md` → install guide for any new setup

---

Would you like me to add a short **install command snippet** for your README (like `curl` or `cp` from repo) so you can set it up quickly on new machines with one line?
