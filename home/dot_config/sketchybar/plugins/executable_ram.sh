#!/bin/sh

# Get memory usage
MEMORY_STATS=$(vm_stat)
PAGES_FREE=$(echo "$MEMORY_STATS" | grep "Pages free" | awk '{print $3}' | tr -d '.')
PAGES_ACTIVE=$(echo "$MEMORY_STATS" | grep "Pages active" | awk '{print $3}' | tr -d '.')
PAGES_INACTIVE=$(echo "$MEMORY_STATS" | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
PAGES_WIRED=$(echo "$MEMORY_STATS" | grep "Pages wired down" | awk '{print $4}' | tr -d '.')
PAGES_COMPRESSED=$(echo "$MEMORY_STATS" | grep "Pages occupied by compressor" | awk '{print $5}' | tr -d '.')

# Page size is 4096 bytes on most systems
PAGE_SIZE=4096

# Calculate memory in GB
USED_MEM=$(echo "scale=1; (($PAGES_ACTIVE + $PAGES_INACTIVE + $PAGES_WIRED + $PAGES_COMPRESSED) * $PAGE_SIZE) / 1073741824" | bc)
TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print $1/1073741824}')
MEM_PERCENT=$(echo "scale=0; ($USED_MEM / $TOTAL_MEM) * 100" | bc)

# Set icon based on usage
if [ "$MEM_PERCENT" -ge 80 ]; then
  ICON="󰍛"  # High usage
elif [ "$MEM_PERCENT" -ge 50 ]; then
  ICON="󰍛"  # Medium usage
else
  ICON="󰍛"  # Low usage
fi

sketchybar --set "$NAME" icon="$ICON" label="${USED_MEM}GB"
