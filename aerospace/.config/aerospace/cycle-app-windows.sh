#!/bin/bash

# Ensure we're using the full path to aerospace
AEROSPACE_CMD="/opt/homebrew/bin/aerospace"
if [ ! -f "$AEROSPACE_CMD" ]; then
    AEROSPACE_CMD=$(which aerospace)
fi

# Get the focused window information
focused_window=$("$AEROSPACE_CMD" list-windows --focused --format "%{window-id}|%{app-bundle-id}|%{app-name}")

# Extract the app bundle ID from the focused window
app_bundle_id=$(echo "$focused_window" | cut -d'|' -f2)

# Get the ID of the focused window
focused_id=$(echo "$focused_window" | cut -d'|' -f1)

# Get all windows with the same app bundle ID
same_app_windows=$("$AEROSPACE_CMD" list-windows --all --format "%{window-id}|%{app-bundle-id}" | grep "|$app_bundle_id$")

# Find the next window ID
next_window_id=""
found_current=false

while IFS= read -r line; do
    id=$(echo "$line" | cut -d'|' -f1)
    if [ "$found_current" = true ]; then
        next_window_id=$id
        break
    fi
    if [ "$id" = "$focused_id" ]; then
        found_current=true
    fi
done <<< "$same_app_windows"

# If we didn't find a next window, wrap around to the first one
if [ -z "$next_window_id" ] && [ "$found_current" = true ]; then
    next_window_id=$(echo "$same_app_windows" | head -n1 | cut -d'|' -f1)
fi

# Focus the next window if we found one
if [ -n "$next_window_id" ]; then
    "$AEROSPACE_CMD" focus --window-id "$next_window_id"
fi
