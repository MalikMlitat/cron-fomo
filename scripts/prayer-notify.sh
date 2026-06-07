#!/bin/bash
ADDRESS="Nablus,PS"
METHOD=2
DATE=$(date +%d-%m-%Y)

# Needed when running from cron — no desktop session environment is inherited
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export PULSE_RUNTIME_PATH="/run/user/$(id -u)/pulse"

RESPONSE=$(curl -s "https://api.aladhan.com/v1/nextPrayerByAddress/${DATE}?address=${ADDRESS}&method=${METHOD}")

PRAYER=$(echo "$RESPONSE" | jq -r '.data.timings | keys[0]')
TIME=$(echo "$RESPONSE" | jq -r '.data.timings | .[keys[0]]')

notify-send "🕌 Next Prayer: $PRAYER" "Time: $TIME"
espeak "It is time to prepare for $PRAYER prayer, at $TIME."
