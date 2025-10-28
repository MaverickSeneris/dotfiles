#!/bin/bash
# --------------------------------------------------------
# fnmode-setup — Interactive Fn key mode selector for MacBook (Arch + Limine)
# Author: Maverick
# --------------------------------------------------------

set -e

PARAM_PATH="/sys/module/hid_apple/parameters/fnmode"
CONF_PATH="/etc/modprobe.d/hid_apple.conf"
SERVICE_PATH="/etc/systemd/system/fnmode.service"

# --- check driver ---
if [[ ! -f $PARAM_PATH ]]; then
  echo "❌ hid_apple module not loaded."
  exit 1
fi

CURRENT=$(cat $PARAM_PATH)

echo ""
echo "---------------------------------------------------------"
echo " 🧠  MacBook Fn Key Mode Configuration"
echo "---------------------------------------------------------"
echo "Current mode: $CURRENT"
echo ""
case "$CURRENT" in
  0) echo "➡️  Current behavior: Media keys by default (Fn gives F1–F12)" ;;
  1) echo "➡️  Current behavior: Smart hybrid (macOS-style: remembers last mode)" ;;
  2) echo "➡️  Current behavior: Function keys by default (Fn gives media keys)" ;;
  *) echo "⚠️  Unknown mode detected, defaulting to hybrid (1)" ;;
esac

echo ""
echo "Select your preferred mode:"
echo "  0 - Media keys by default (Fn for F1–F12)"
echo "  1 - Smart hybrid (macOS-style) [Recommended]"
echo "  2 - Function keys by default (Fn for media)"
echo ""

read -rp "Enter your choice [0/1/2]: " MODE
if [[ "$MODE" != "0" && "$MODE" != "1" && "$MODE" != "2" ]]; then
  echo "❌ Invalid selection. Exiting."
  exit 1
fi

echo ""
echo "🔄 Switching fnmode: $CURRENT → $MODE ..."
echo $MODE | sudo tee $PARAM_PATH > /dev/null

# --- update persistent config ---
echo "options hid_apple fnmode=$MODE" | sudo tee $CONF_PATH > /dev/null

# --- create/update systemd fallback service ---
sudo tee $SERVICE_PATH > /dev/null <<SERVICE
[Unit]
Description=Force Apple fnmode=$MODE on boot
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo $MODE > $PARAM_PATH'

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl enable --now fnmode.service > /dev/null

# --- rebuild initramfs for Limine ---
echo ""
echo "🧩 Rebuilding initramfs (Limine detected)..."
sudo limine-mkinitcpio > /dev/null

echo ""
echo "✅ Done! Fn key mode is now set to: $MODE"
echo ""
case "$MODE" in
  0) echo "🎹 Media keys by default. Hold Fn for F1–F12 (like everyday laptop use)." ;;
  1) echo "🍏 Smart hybrid mode. Remembers last state (true macOS style)." ;;
  2) echo "💻 Function keys by default. Hold Fn for brightness/volume (coder mode)." ;;
esac
echo ""
echo "Reboot if some keys don't react yet."
echo "To check current mode later:  cat /sys/module/hid_apple/parameters/fnmode"
echo "To rerun setup anytime:       ./fnmode-setup.sh"
echo "---------------------------------------------------------"
