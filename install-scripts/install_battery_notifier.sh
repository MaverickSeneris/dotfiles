#!/bin/bash
# --------------------------------------------------------
# Battery Notifier Auto Installer (for Arch / Hyprland)
# Author: Maverick
# --------------------------------------------------------

set -e

echo "⚙️ Setting up Battery Notifier..."

# --- Paths ---
BIN_DIR="$HOME/.local/bin"
SYSTEMD_DIR="$HOME/.config/systemd/user"
SCRIPT_PATH="$BIN_DIR/battery_notify.sh"
SERVICE_PATH="$SYSTEMD_DIR/battery-notify.service"
TIMER_PATH="$SYSTEMD_DIR/battery-notify.timer"

# --- Create directories if missing ---
mkdir -p "$BIN_DIR"
mkdir -p "$SYSTEMD_DIR"

# --- Create battery_notify.sh ---
cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/bash
# --- Fix for Hyprland / Wayland notifications ---
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
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
EOF

chmod +x "$SCRIPT_PATH"

# --- Create systemd service ---
cat > "$SERVICE_PATH" <<EOF
[Unit]
Description=Battery Notification Script

[Service]
Type=oneshot
Environment=XDG_RUNTIME_DIR=/run/user/%U
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus
Environment=DISPLAY=:0
ExecStart=/usr/bin/env bash %h/.local/bin/battery_notify.sh
EOF

# --- Create systemd timer ---
cat > "$TIMER_PATH" <<EOF
[Unit]
Description=Run battery notification every 5 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
EOF

# --- Reload systemd daemon and enable timer ---
systemctl --user daemon-reload
systemctl --user enable --now battery-notify.timer

echo "✅ Battery notifier installed and running!"
systemctl --user status battery-notify.timer --no-pager
