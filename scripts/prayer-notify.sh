#!/bin/bash
ADDRESS="Nablus,PS"
METHOD=2
DATE=$(date +%d-%m-%Y)

TIMINGS=$(
    curl -s "https://api.aladhan.com/v1/nextPrayerByAddress/${DATE}?address=${ADDRESS}&method=${METHOD}" \
    | jq '.data.timings' \
    | tr -d "{}" \
    | xargs
)

notify-send "Next Prayer" "$TIMINGS"
