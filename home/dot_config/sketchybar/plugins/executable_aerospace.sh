#!/bin/bash

# SOURCE DATA
if [ "$SENDER" = "aerospace_event" ] && [ "$EVENT" = "workspace_change" ]; then
    # -------------------------------------------------------------
    # INSTANT PATH: Update UI immediately, defer empty check
    # -------------------------------------------------------------
    
    # 1. Update FOCUSED instantly (no checks needed)
    [ -n "$FOCUSED_WORKSPACE" ] && \
        sketchybar --set space.$FOCUSED_WORKSPACE \
            drawing=on \
            icon.color=0xffffffff \
            label.color=0xffffffff \
            background.drawing=on

    # 2. Update PREVIOUS instantly (assume occupied, verify async)
    if [ -n "$PREV_WORKSPACE" ]; then
        # Optimistic update: show as occupied immediately
        sketchybar --set space.$PREV_WORKSPACE \
            drawing=on \
            icon.color=0xffaaaaaa \
            label.color=0xffaaaaaa \
            background.drawing=off
        
        # Background check: hide if empty (non-blocking)
        (aerospace list-windows --workspace "$PREV_WORKSPACE" --count 2>/dev/null || echo "1") | \
            grep -q '^0$' && \
            sketchybar --set space.$PREV_WORKSPACE drawing=off &
    fi
else
    # -------------------------------------------------------------
    # INIT PATH: Batch all updates in single sketchybar call
    # -------------------------------------------------------------
    
    # Single aerospace call, batch sketchybar updates
    WORKSPACES=$(aerospace list-workspaces --monitor focused --empty no --format "%{workspace} %{workspace-is-focused}")
    
    BATCH=""
    set -- $WORKSPACES
    while [ $# -ge 2 ]; do
        if [ "$2" = "true" ]; then
            BATCH="$BATCH --set space.$1 drawing=on icon.color=0xffffffff label.color=0xffffffff background.drawing=on"
        else
            BATCH="$BATCH --set space.$1 drawing=on icon.color=0xffaaaaaa label.color=0xffaaaaaa background.drawing=off"
        fi
        shift 2
    done
    
    # Single IPC call with all updates
    [ -n "$BATCH" ] && eval "sketchybar $BATCH"
fi
