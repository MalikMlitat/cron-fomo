# cron-fomo

Scripts from the **"From Cron to systemd"** workshop.

## Scripts

| File | Exercise | Description |
|------|----------|-------------|
| `scripts/disk-guardian.sh` | Exercise 3 | Alerts with popup + voice when disk usage exceeds 80% |
| `scripts/morning-briefing.sh` | Exercise 4 | Daily spoken briefing — disk usage + day of week |
| `scripts/prayer_notifier.py` | Final Project ⭐⭐ | Fetches prayer times from Aladhan API, notifies next prayer with popup + TTS |

## Setup

```bash
sudo apt install cron espeak-ng libnotify-bin curl jq python3 python3-pip
pip install requests
chmod +x scripts/disk-guardian.sh scripts/morning-briefing.sh
```

## Usage

```bash
# Run manually
./scripts/disk-guardian.sh
./scripts/morning-briefing.sh
python3 scripts/prayer_notifier.py

# Schedule disk guardian every minute
* * * * * ~/scripts/disk-guardian.sh

# Morning briefing daily at 8am
0 8 * * * ~/scripts/morning-briefing.sh
```
