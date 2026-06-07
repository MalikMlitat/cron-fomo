#!/usr/bin/env python3

import logging
import subprocess
import sys
import zoneinfo
from datetime import datetime
from functools import partial

import requests

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger(__name__)

notify = partial(subprocess.run, stderr=subprocess.DEVNULL)

# --- Configuration ---
CITY = "Nablus"
COUNTRY = "Palestine"
METHOD = 2  # ISNA — see aladhan.com/calculation-methods
PRAYERS = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
# ADHAN_SOUND = "/home/user/sounds/adhan.mp3"

# --- Fetch today's timings ---
date = datetime.now().strftime("%d-%m-%Y")
url = f"https://api.aladhan.com/v1/timingsByCity/{date}"
log.info("Fetching prayer times for %s, %s (date: %s)", CITY, COUNTRY, date)

try:
    response = requests.get(url, params={"city": CITY, "country": COUNTRY, "method": METHOD}, timeout=10)
    data = response.json()
except Exception as e:
    log.error("Network error: %s", e)
    notify(["notify-send", "🕌 Prayer Notifier", f"Network error: {e}"])
    sys.exit(1)

if data.get("code") != 200:
    log.error("API error: %s", data.get("status"))
    notify(["notify-send", "🕌 Prayer Notifier", "Could not fetch prayer times."])
    sys.exit(1)

timings = data["data"]["timings"]
timezone = data["data"]["meta"]["timezone"]
log.info("Timezone: %s | Timings: %s", timezone, {p: timings[p] for p in PRAYERS})

# --- Find next upcoming prayer ---
tz = zoneinfo.ZoneInfo(timezone)
now = datetime.now(tz)

for prayer in PRAYERS:
    prayer_time = datetime.strptime(timings[prayer], "%H:%M").replace(
        year=now.year, month=now.month, day=now.day, tzinfo=tz
    )
    diff_minutes = int((prayer_time - now).total_seconds() / 60)
    log.debug("%-10s at %s — %d min away", prayer, timings[prayer], diff_minutes)

    if diff_minutes > 0:
        if diff_minutes >= 60:
            hours, minutes = divmod(diff_minutes, 60)
            time_left = f"{hours}h {minutes}m" if minutes else f"{hours}h"
        else:
            time_left = f"{diff_minutes} minutes"

        log.info("Next prayer: %s at %s (in %s)", prayer, timings[prayer], time_left)
        message = f"Time: {timings[prayer]} — in {time_left}"
        notify(["notify-send", f"🕌 Next Prayer: {prayer}", message])

        for tts in ["espeak-ng", "espeak"]:
            if subprocess.run(["which", tts], capture_output=True).returncode == 0:
                subprocess.run([tts, f"Next prayer is {prayer} at {timings[prayer]}, in {time_left}"])
                break
        # subprocess.run(["paplay", ADHAN_SOUND])
        sys.exit(0)

log.info("All prayers for today are done.")
notify(["notify-send", "🕌 Prayer Notifier", "All prayers for today are done. See you tomorrow."])
for tts in ["espeak-ng", "espeak"]:
    if subprocess.run(["which", tts], capture_output=True).returncode == 0:
        subprocess.run([tts, "All prayers for today are complete."])
        break
