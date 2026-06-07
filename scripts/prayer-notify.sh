#!/bin/bash
ADDRESS="Nablus,PS"
METHOD=2
DATE=$(date +%d-%m-%Y)

# Needed when running from cron — no desktop session environment is inherited
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

TIMINGS=$(
    curl -s "https://api.aladhan.com/v1/nextPrayerByAddress/${DATE}?address=${ADDRESS}&method=${METHOD}" \
    | jq '.data.timings' \
    | tr -d "{}" \
    | xargs
)

notify-send "Next Prayer" "$TIMINGS"
