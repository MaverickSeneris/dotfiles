
#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$status" == "Charging" ]; then
  icon=" "
  if [ "$capacity" -ge 90 ]; then
    state="charging-full"   # blinking green
  else
    state="charging"        # solid mint
  fi
else
  if   [ "$capacity" -ge 95 ]; then icon=" 󰁹"
  elif [ "$capacity" -ge 80 ]; then icon=" 󰂁"
  elif [ "$capacity" -ge 50 ]; then icon=" 󰁿"
  elif [ "$capacity" -ge 40 ]; then icon=" 󰁾"
  elif [ "$capacity" -ge 30 ]; then icon=" 󰁽"
  elif [ "$capacity" -ge 25 ]; then icon=" 󰁼"
  elif [ "$capacity" -ge 20 ]; then icon=" 󰂎"
  else icon=" "
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

echo "{\"text\": \"$icon$capacity%\", \"class\": \"$state\"}"

