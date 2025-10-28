#!/bin/bash
# ----------------------------------------------------------
# Mako Reminder Installer
# Author: Maverick 🧙‍♂️
# ----------------------------------------------------------

set -e

echo "⚙️ Installing Mako Reminder System..."

# --- Dependency check ---
check_dependency() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "❌ Missing dependency: $1"
        MISSING=true
    fi
}

MISSING=false
check_dependency mako
check_dependency systemctl
check_dependency notify-send

if [ "$MISSING" = true ]; then
    echo ""
    echo "⚠️ Some dependencies are missing!"
    echo "Please install them first:"
    echo ""
    echo "  sudo pacman -S mako upower libnotify"
    echo ""
    exit 1
fi

echo "✅ All dependencies found!"

# --- Paths ---
BIN_DIR="$HOME/.local/bin"
REMINDER_DIR="$BIN_DIR/reminder_scripts"
SYSTEMD_DIR="$HOME/.config/systemd/user"
SCRIPT_PATH="$BIN_DIR/mako_reminder.sh"

# --- Create directories ---
mkdir -p "$BIN_DIR" "$REMINDER_DIR" "$SYSTEMD_DIR"

# --- Install main script ---
cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/bash
# Mako Reminder CLI by Maverick 🧙‍♂️
# ----------------------------------------------------------

REMINDER_DIR="$HOME/.local/bin/reminder_scripts"
SYSTEMD_DIR="$HOME/.config/systemd/user"

mkdir -p "$REMINDER_DIR" "$SYSTEMD_DIR"

add_reminder() {
    local name="$1"
    local interval="$2"
    local safe_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-' | tr ' ' '-')

    local script_path="$REMINDER_DIR/${safe_name}.sh"
    local service_path="$SYSTEMD_DIR/reminder-${safe_name}.service"
    local timer_path="$SYSTEMD_DIR/reminder-${safe_name}.timer"

    cat > "$script_path" <<INNER
#!/bin/bash
export XDG_RUNTIME_DIR="/run/user/\$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=\${XDG_RUNTIME_DIR}/bus"
export DISPLAY=":0"
notify-send "$name" "⏰ Reminder: $name"
INNER
    chmod +x "$script_path"

    cat > "$service_path" <<INNER
[Unit]
Description=Reminder: $name

[Service]
Type=oneshot
ExecStart=$script_path
INNER

    cat > "$timer_path" <<INNER
[Unit]
Description=Run reminder: $name every $interval

[Timer]
OnBootSec=1min
OnUnitActiveSec=$interval
Persistent=true

[Install]
WantedBy=timers.target
INNER

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

case "$1" in
    add) add_reminder "$2" "$3" ;;
    list) list_reminders ;;
    delete) delete_reminder "$2" ;;
    toggle) toggle_reminder "$2" ;;
    help|"")
        echo ""
        echo "🕐 Mako Reminder CLI — by Maverick"
        echo "------------------------------------"
        echo "Usage:"
        echo "  reminder add \"<message>\" <interval>"
        echo "      → Create a new reminder that repeats every interval."
        echo "        Ex
