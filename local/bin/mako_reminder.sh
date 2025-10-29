#!/bin/bash
# ----------------------------------------------------------
# mako_reminder.sh — Create, list, delete, or toggle reminders
# Author: Maverick 🧙‍♂️
# ----------------------------------------------------------

REMINDER_DIR="$HOME/.local/bin/reminder_scripts"
SYSTEMD_DIR="$HOME/.config/systemd/user"

mkdir -p "$REMINDER_DIR" "$SYSTEMD_DIR"

# --- Functions ---

add_reminder() {
    local name="$1"
    local interval="$2"
    local safe_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-' | tr ' ' '-')

    local script_path="$REMINDER_DIR/${safe_name}.sh"
    local service_path="$SYSTEMD_DIR/reminder-${safe_name}.service"
    local timer_path="$SYSTEMD_DIR/reminder-${safe_name}.timer"

    # Create reminder script
    cat > "$script_path" <<EOF
#!/bin/bash
export XDG_RUNTIME_DIR="/run/user/\$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=\${XDG_RUNTIME_DIR}/bus"
export DISPLAY=":0"
notify-send "$name" "⏰ Reminder: $name"
EOF
    chmod +x "$script_path"

    # Create systemd service
    cat > "$service_path" <<EOF
[Unit]
Description=Reminder: $name

[Service]
Type=oneshot
ExecStart=$script_path
EOF

    # Create systemd timer
    cat > "$timer_path" <<EOF
[Unit]
Description=Run reminder: $name every $interval

[Timer]
OnBootSec=1min
OnUnitActiveSec=$interval
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now reminder-${safe_name}.timer

    echo "✅ Reminder added: \"$name\" (every $interval)"
}

list_reminders() {
    echo "📋 Active reminders:"
    systemctl --user list-timers | grep reminder- || echo "No active reminders."
}

delete_reminder() {
    local name="$1"
    local safe_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-' | tr ' ' '-')

    systemctl --user disable --now reminder-${safe_name}.timer >/dev/null 2>&1 || true
    systemctl --user disable --now reminder-${safe_name}.service >/dev/null 2>&1 || true
    rm -f "$REMINDER_DIR/${safe_name}.sh" "$SYSTEMD_DIR/reminder-${safe_name}.service" "$SYSTEMD_DIR/reminder-${safe_name}.timer"

    echo "🗑️ Reminder deleted: \"$name\""
}

toggle_reminder() {
    local name="$1"
    local safe_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-' | tr ' ' '-')

    if systemctl --user is-active reminder-${safe_name}.timer >/dev/null 2>&1; then
        systemctl --user disable --now reminder-${safe_name}.timer
        echo "⏸️ Reminder paused: \"$name\""
    else
        systemctl --user enable --now reminder-${safe_name}.timer
        echo "▶️ Reminder resumed: \"$name\""
    fi
}

# --- CLI options ---
case "$1" in
    add)
        add_reminder "$2" "$3"
        ;;
    list)
        list_reminders
        ;;
    delete)
        delete_reminder "$2"
        ;;
    toggle)
        toggle_reminder "$2"
        ;;
   
    help)
        echo ""
        echo "🕐 Mako Reminder CLI — by Maverick"
        echo "------------------------------------"
        echo "Usage:"
        echo "  reminder add \"<message>\" <interval>"
        echo "      → Create a new reminder that repeats every interval."
        echo "        Example: reminder add \"💧 Drink Water\" 1h"
        echo ""
        echo "  reminder list"
        echo "      → Show all active reminder timers."
        echo ""
        echo "  reminder toggle \"<message>\""
        echo "      → Pause or resume a reminder."
        echo "        Example: reminder toggle \"💧 Drink Water\""
        echo ""
        echo "  reminder delete \"<message>\""
        echo "      → Remove a reminder completely."
        echo "        Example: reminder delete \"💧 Drink Water\""
        echo ""
        echo "🧩 Supported intervals:"
        echo "   30s   = every 30 seconds"
        echo "   10m   = every 10 minutes"
        echo "   1h    = every 1 hour"
        echo "   1h30m = every 1 hour 30 minutes"
        echo "   1d    = every 1 day"
        echo ""
        echo "💡 Tip: Use emojis or short phrases for names!"
        echo "   Example: reminder add \"🙏 Pray\" 6h"
        echo ""
        ;;
    *)
        echo "Usage: reminder [add|list|delete|toggle|help]"
        echo "Type 'reminder help' for detailed commands."
        ;;

esac
