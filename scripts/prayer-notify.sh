#!/bin/bash
notify-send "Next Prayer" "$(curl -s "https://api.aladhan.com/v1/nextPrayerByAddress/$(date +%d-%m-%Y)?address=Nablus,PS&method=2" | jq '.data.timings' | tr -d "{}" | xargs)"
