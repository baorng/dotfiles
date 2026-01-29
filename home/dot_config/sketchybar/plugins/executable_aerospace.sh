#!/bin/bash

# Load shared colors
source "$CONFIG_DIR/colors.sh"

# SOURCE DATA
if [ "$SENDER" = "aerospace_event" ] && [ "$EVENT" = "workspace_change" ]; then
    # -------------------------------------------------------------
    # INSTANT PATH: Update UI immediately, defer empty check
    # -------------------------------------------------------------
    
    # 1. Update FOCUSED instantly (no checks needed)
    [ -n "$FOCUSED_WORKSPACE" ] && \
        sketchybar --set space.$FOCUSED_WORKSPACE \
            drawing=on \
            icon.color=$WORKSPACE_FOCUSED_ICON \
            label.color=$WORKSPACE_FOCUSED_LABEL \
            background.drawing=on \
            background.color=$WORKSPACE_FOCUSED_BG

    # 2. Update PREVIOUS instantly (assume occupied, verify async)
    if [ -n "$PREV_WORKSPACE" ]; then
        # Check if PREV workspace is still visible (on another monitor)
        if aerospace list-workspaces --monitor all --visible | grep -q "^$PREV_WORKSPACE$"; then
            # VISIBLE (but not focused): White/Grey
            sketchybar --set space.$PREV_WORKSPACE \
                drawing=on \
                icon.color=$WORKSPACE_VISIBLE_ICON \
                label.color=$WORKSPACE_VISIBLE_LABEL \
                background.drawing=on \
                background.color=$WORKSPACE_VISIBLE_BG
        else
            # HIDDEN: Dim
            # Optimistic update: show as occupied (dim) immediately
            sketchybar --set space.$PREV_WORKSPACE \
                drawing=on \
                icon.color=$WORKSPACE_HIDDEN_ICON \
                label.color=$WORKSPACE_HIDDEN_LABEL \
                background.drawing=off \
                background.color=$WORKSPACE_HIDDEN_BG
            
            # Background check: hide if empty (non-blocking)
            (aerospace list-windows --workspace "$PREV_WORKSPACE" --count 2>/dev/null || echo "1") | \
                grep -q '^0$' && \
                sketchybar --set space.$PREV_WORKSPACE drawing=off &
        fi
    fi
else
    # -------------------------------------------------------------
    # INIT PATH: Batch all updates in single sketchybar call
    # -------------------------------------------------------------
    
    # Single aerospace call, batch sketchybar updates
    WORKSPACES=$(aerospace list-workspaces --monitor all --empty no --format "%{workspace} %{monitor-appkit-nsscreen-screens-id} %{workspace-is-visible} %{workspace-is-focused}")
    
    BATCH=""
    while read -r sid mid visible focused; do
        # Isolate workspace to its monitor
        BATCH="$BATCH --set space.$sid display=$mid"
        
        if [ "$focused" = "true" ]; then
            # FOCUSED: Blue/Bold
            BATCH="$BATCH drawing=on icon.color=$WORKSPACE_FOCUSED_ICON label.color=$WORKSPACE_FOCUSED_LABEL background.drawing=on background.color=$WORKSPACE_FOCUSED_BG"
        elif [ "$visible" = "true" ]; then
            # VISIBLE (but not focused): White/Grey
            BATCH="$BATCH drawing=on icon.color=$WORKSPACE_VISIBLE_ICON label.color=$WORKSPACE_VISIBLE_LABEL background.drawing=on background.color=$WORKSPACE_VISIBLE_BG"
        else
            # HIDDEN: Dim
            BATCH="$BATCH drawing=on icon.color=$WORKSPACE_HIDDEN_ICON label.color=$WORKSPACE_HIDDEN_LABEL background.drawing=off background.color=$WORKSPACE_HIDDEN_BG"
        fi
    done <<< "$WORKSPACES"
    
    # Single IPC call with all updates
    [ -n "$BATCH" ] && eval "sketchybar $BATCH"
fi
