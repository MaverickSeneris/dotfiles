#!/bin/bash

# --- Fix for Hyprland / Wayland notifications ---
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export DISPLAY=":0"
# --- Get battery info ---
BATTERY=$(upower -e | grep BAT)
BATTERY_LEVEL=$(upower -i "$BATTERY" | grep -E "percentage" | awk '{print $2}' | tr -d '%' | awk -F'.' '{print int($1)}')
STATUS=$(upower -i "$BATTERY" | grep -E "state" | awk '{print $2}')

# --- Debug print ---
echo "Battery: $BATTERY_LEVEL% | Status: $STATUS"

# --- Conditions ---
if [ "$STATUS" = "discharging" ] && [ "$BATTERY_LEVEL" -le 20 ]; then
    paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga 2>/dev/null
    notify-send "🔋 Battery Low" "Battery is at ${BATTERY_LEVEL}%. Plug in your charger."

elif [ "$STATUS" = "charging" ] && [ "$BATTERY_LEVEL" -ge 90 ]; then
    paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga 2>/dev/null
    notify-send "🔌 Battery Full" "Battery is at ${BATTERY_LEVEL}%. Unplug to preserve battery health."
fi
