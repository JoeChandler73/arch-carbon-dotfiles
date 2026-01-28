#!/usr/bin/env bash

FLAVOUR="$1"
BASE="$HOME/.config/catppuccin"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/Catppuccin"
SDDM_CONFIG_FILE="/usr/lib/sddm/sddm.conf.d/default.conf"

if [[ ! -d "$BASE/$FLAVOUR" ]]; then
  echo "Unknown catppuccin flavor: $FLAVOUR"
  exit 1
fi

case $FLAVOUR in
  latte)    WALL="$WALLPAPER_DIR/latte.png" ;;
  frappe)   WALL="$WALLPAPER_DIR/frappe.png" ;;
  macchiato) WALL="$WALLPAPER_DIR/macchiato.png" ;;
  mocha)    WALL="$WALLPAPER_DIR/mocha.png" ;;
esac

# Apply the wallpaper with a transition
swww img "$WALL" --transition-type outer --transition-pos top-right --transition-duration 2

# Repoint symlink flavour
ln -sfn "$BASE/$FLAVOUR" "$BASE/current"

# GTK Settings
sed -i "s@^gtk-theme-name[[:space:]]*=[[:space:]]*.*@gtk-theme-name=catppuccin-$FLAVOUR-blue-standard+default@" ~/.config/gtk-3.0/settings.ini

sed -i "s@^gtk-theme-name[[:space:]]*=[[:space:]]*.*@gtk-theme-name=catppuccin-$FLAVOUR-blue-standard+default@" ~/.config/gtk-4.0/settings.ini

# Update the dconf database directly
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-${FLAVOUR}-blue-standard+default"

if [[ "$FLAVOUR" == "latte" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# SDDM Greeter Theme
sed -i "s/^\(Current=[Cc]atppuccin-\)[^-]*\(-blue\)/\1$FLAVOUR\2/" "$SDDM_CONFIG_FILE"

# Set the flavour for vscode
case $FLAVOUR in
  latte)    VS_FLAVOUR="Latte" ;;
  frappe)   VS_FLAVOUR="Frapp\é" ;;
  macchiato) VS_FLAVOUR="Macchiato" ;;
  mocha)    VS_FLAVOUR="Mocha" ;;
esac

# Update VS Code settings.json
# This matches the key and replaces the value while preserving JSON syntax
sed -i "s@\"workbench.colorTheme\": \".*\"@\"workbench.colorTheme\": \"Catppuccin $VS_FLAVOUR\"@" ~/.config/Code/User/settings.json

# Update zsh syntax highlighting theme
sed -i "s/catppuccin_.*-zsh-syntax-highlighting\.zsh/catppuccin_$FLAVOUR-zsh-syntax-highlighting.zsh/" ~/.zshrc

# Reload targets
pkill -USR2 waybar
hyprctl reload

# Force Alacritty updates
touch ~/.config/alacritty/alacritty.toml

pgrep kitty | xargs -r kill -SIGUSR1 > /dev/null 2>&1

# Force swaync reload
#killall -9 swaync
#sway swaync &

# GTK3 reload
# gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-$FLAVOUR"

# Terminals (example)
# pkill -USR1 kitty