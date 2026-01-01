#!/bin/sh

# Get CPU usage percentage (average across all cores)
CPU_PERCENT=$(ps -A -o %cpu | awk '{s+=$1} END {print int(s)}')

# Set icon based on usage
if [ "$CPU_PERCENT" -ge 80 ]; then
  ICON="󰻠"  # High usage
elif [ "$CPU_PERCENT" -ge 50 ]; then
  ICON="󰻠"  # Medium usage
else
  ICON="󰻠"  # Low usage
fi

sketchybar --set "$NAME" icon="$ICON" label="${CPU_PERCENT}%"
