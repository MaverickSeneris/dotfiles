#!/bin/bash
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export DISPLAY=":0"
notify-send "Bed time!" "⏰ Reminder: Bed time!"
