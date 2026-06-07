#!/bin/bash
# Exercise 4 — Morning Briefing
# A daily spoken briefing. Schedule with: 0 8 * * * ~/scripts/morning-briefing.sh
# Needed when running from cron — no desktop session environment is inherited
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export PULSE_RUNTIME_PATH="/run/user/$(id -u)/pulse"

DISK=$(df -h / | awk 'NR==2{print $5}')
MSG="Good morning. Today is $(date +%A). Disk usage is ${DISK}."
espeak-ng "$MSG"
notify-send "🌅 Morning Briefing" "$MSG"
