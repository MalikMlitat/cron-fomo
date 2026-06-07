#!/bin/bash
# Exercise 4 — Morning Briefing
# A daily spoken briefing. Schedule with: 0 8 * * * ~/scripts/morning-briefing.sh
DISK=$(df -h / | awk 'NR==2{print $5}')
MSG="Good morning. Today is $(date +%A). Disk usage is ${DISK}."
espeak-ng "$MSG"
notify-send "🌅 Morning Briefing" "$MSG"
