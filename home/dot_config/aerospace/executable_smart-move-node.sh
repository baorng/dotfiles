#!/bin/bash

# Usage: ./smart-move-node.sh <direction>
# direction: left, down, up, right

DIRECTION=$1

if [ -z "$DIRECTION" ]; then
    echo "Usage: $0 <direction>"
    exit 1
fi

SNAPSHOT_CMD="aerospace list-windows --workspace focused --json"

STATE_1=$($SNAPSHOT_CMD)
aerospace move "$DIRECTION"
STATE_2=$($SNAPSHOT_CMD)

if [ "$STATE_1" == "$STATE_2" ]; then
    aerospace move-node-to-monitor --wrap-around "$DIRECTION"
    # Ensure we follow the window to the new monitor
    aerospace focus-monitor "$DIRECTION" --wrap-around 2>/dev/null
fi

exit 0
