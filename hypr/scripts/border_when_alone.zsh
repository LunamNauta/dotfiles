#!/usr/bin/env zsh

# Get active workspace ID
WS=$(hyprctl activeworkspace -j | jq '.id')

# Count windows in that workspace
COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS)] | length")

if [ "$COUNT" -eq 1 ]; then
    # One window → black border
    hyprctl keyword general:col.active_border "rgba(11111bff)"
else
    # More than one → normal border (change to your theme)
    hyprctl keyword general:col.active_border "rgba(b4befeff)"
fi
