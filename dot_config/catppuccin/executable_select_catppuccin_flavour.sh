#!/bin/bash

FLAVOUR_DIR="$HOME/.config/catppuccin"
FLAVOUR_PICKER="$HOME/.config/rofi/launchers/type-2/flavour-picker.sh"
APPLY_FLAVOUR_SCRIPT="$FLAVOUR_DIR/apply_catppuccin_flavour.sh"

# Define flavours and their associated official emojis
declare -A icons=(
    ["latte"]="🌻"
    ["frappe"]="🪴"
    ["macchiato"]="🌺"
    ["mocha"]="🌿"
)

# List only non-hidden directories
flavours=($(find "$FLAVOUR_DIR" -mindepth 1 -maxdepth 1 -type d ! -iname ".*" -exec basename {} \; | sort))

# Generate the formatted list for rofi
options=""
for f in "${flavours[@]}"; do
    # This adds the emoji before the name
    options+="${icons[$f]}  ${f}\n"
done

# Pass to flavor picker script
flavour=$(printf "%b" "$options" | "$FLAVOUR_PICKER")
# Remove the flavor icon from the start
flavour="${flavour##* }"

# Apply selected theme if not empty
if [[ -n "$flavour" ]]; then
    if "$APPLY_FLAVOUR_SCRIPT" "$flavour" >/dev/null 2>&1; then
        notify-send -a "System" -i "color-management" "Theme Updated" "Catppuccin $flavour applied successfully"
    else
        notify-send -a "System" -u critical "Theme Error" "Failed to apply $flavour"
    fi
fi
