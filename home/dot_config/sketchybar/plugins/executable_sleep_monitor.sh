#!/bin/sh

# Get scheduled sleep time
RAW_SCHED=$(pmset -g sched | grep "sleep at" | head -n 1)

if [ -z "$RAW_SCHED" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Extract and normalize time format
RAW_TIME=$(echo "$RAW_SCHED" | grep -oE "[0-9]{1,2}:[0-9]{2}(AM|PM)")
TIME=$(date -j -f "%I:%M%p" "$RAW_TIME" +"%H:%M:%S")

# Calculate target epoch
CURR_DATE=$(date +%Y-%m-%d)
TARGET=$(date -j -f "%Y-%m-%d %H:%M:%S" "$CURR_DATE $TIME" +%s)
NOW=$(date +%s)

# If time has passed today, target is tomorrow
if [ "$TARGET" -lt "$NOW" ]; then
  TARGET=$((TARGET + 86400))
fi

# Calculate difference and set display
DIFF=$(((TARGET - NOW) / 60))

# Set icon and color based on urgency
if [ "$DIFF" -le 15 ]; then
  ICON="󰒲"
  ICON_COLOR=0xffed8796
  LABEL="${DIFF}m"
elif [ "$DIFF" -le 60 ]; then
  ICON="󰥔"
  ICON_COLOR=0xfff5a97f
  LABEL="${DIFF}m"
else
  ICON="󰒲"
  ICON_COLOR=0xffa6da95
  LABEL=$(date -r "$TARGET" +"%H:%M")
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" label="$LABEL" drawing=on
