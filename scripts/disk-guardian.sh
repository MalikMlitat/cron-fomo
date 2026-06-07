#!/bin/bash
# Exercise 3 — Disk Space Guardian (with voice + popup)
# Alert when disk usage exceeds THRESHOLD percent.
THRESHOLD=80
USAGE=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    notify-send "⚠️ Disk Warning" "Disk is ${USAGE}% full!" 2>/dev/null
    espeak-ng "Warning! Disk is ${USAGE} percent full"
fi
