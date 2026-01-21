#!/usr/bin/env bash
top_margin=120
bottom_margin=120

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
hypr_scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')

wlogout -C $HOME/.config/wlogout/style.css \
        -l $HOME/.config/wlogout/layout \
        --protocol layer-shell \
        -b 5 \
        -T $(awk "BEGIN {printf \"%.0f\", $top_margin * 1440 * $hypr_scale / $resolution}") \
        -B $(awk "BEGIN {printf \"%.0f\", $bottom_margin * 1440 * $hypr_scale / $resolution}") &

