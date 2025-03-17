#!/bin/bash

# Enable debugging
# set -x

# Check if any Finder windows exist
echo "Checking for Finder windows..."
FINDER_WINDOWS=$(aerospace list-windows --monitor all --app-bundle-id com.apple.finder --count 2>/dev/null || echo 0)
echo "Found $FINDER_WINDOWS Finder windows"

if [ -n "$FINDER_WINDOWS" ] && [ "$FINDER_WINDOWS" -gt 0 ]; then
  # echo "Finder windows exist, getting window ID..."
  # Get the first Finder window ID
  WINDOW_ID=$(aerospace list-windows --monitor all --app-bundle-id com.apple.finder --format "%{window-id}" | head -1)
  # echo "First Finder window ID: $WINDOW_ID"
  
  # Get current workspace
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused --format "%{workspace}")
  # echo "Current workspace: $CURRENT_WORKSPACE"
  
  # Move the window to current workspace and focus it
  # echo "Moving window to current workspace..."
  aerospace move-node-to-workspace --window-id "$WINDOW_ID" --focus-follows-window "$CURRENT_WORKSPACE"
  # echo "Window moved successfully"
    aerospace focus --window-id "$WINDOW_ID"
else
  # echo "No Finder windows found, creating a new one..."
  # No Finder windows, open a new one using AppleScript
  osascript -e 'tell application "Finder" to make new Finder window'
  osascript -e 'tell application "Finder" to activate'
  # echo "New Finder window created"
fi
