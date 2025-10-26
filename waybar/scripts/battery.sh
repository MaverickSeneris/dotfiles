
#!/bin/bash

capacity=$(upower -i $(upower -e | grep BAT) | awk '/percentage:/ {gsub("%",""); printf("%.0f", $2)}')
status=$(cat /sys/class/power_supply/BAT0/status)
health=$(upower -i $(upower -e | grep BAT) | awk '/capacity:/ {gsub("%",""); printf("%.0f", $2)}')
cycles=$(upower -i $(upower -e | grep BAT) | awk '/charge-cycles:/ {print $2}')

if [ "$status" == "Charging" ]; then
  # Granular charging icons
  if   [ "$capacity" -ge 100 ]; then icon=" 󰂄"  # charging full
  elif [ "$capacity" -ge 90 ]; then icon=" 󰂉 "
  elif [ "$capacity" -ge 75 ]; then icon=" 󰂉 "
  elif [ "$capacity" -ge 60 ]; then icon=" 󰂇 "
  elif [ "$capacity" -ge 50 ]; then icon=" 󰂇 "
  elif [ "$capacity" -ge 40 ]; then icon=" 󰂇 "
  elif [ "$capacity" -ge 30 ]; then icon=" 󰂇 "
  else icon="  󰂆"
  fi

  # Keep your states
  if [ "$capacity" -ge 95 ]; then
    state="charging-full"   # solid green
  else
    state="charging"        # blinking orange
  fi

else
  if   [ "$capacity" -ge 100 ]; then icon=" 󰁹"
  elif [ "$capacity" -ge 95 ]; then icon=" 󰂁"
  elif [ "$capacity" -ge 80 ]; then icon=" 󰂀"
  elif [ "$capacity" -ge 50 ]; then icon=" 󰁿"
  elif [ "$capacity" -ge 40 ]; then icon=" 󰁾"
  elif [ "$capacity" -ge 30 ]; then icon=" 󰁽"
  elif [ "$capacity" -ge 25 ]; then icon=" 󰁻"
  elif [ "$capacity" -ge 20 ]; then icon=" 󰂃"
  else icon=" 󰂃"
  fi

  if [ "$capacity" -le 20 ]; then
    state="critical"
  elif [ "$capacity" -le 25 ]; then
    state="warning"
  elif [ "$capacity" -le 50 ]; then
    state="mid"
  else
    state="normal"
  fi
fi
# Tooltip (escaped for JSON — must use double backslash for Waybar)
tooltip="Battery Health: ${health}%\\nCharge Cycles: ${cycles}\\nState: ${status^}"

# Final JSON output
echo "{\"text\": \"$icon$capacity%\", \"tooltip\": \"$tooltip\", \"class\": \"$state\"}"


#󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰂃 󰂄 󰂅 󰂆 󰂇 󰂈 󰂉

