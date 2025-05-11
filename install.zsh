#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if ! [ -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
fi

set-config-link(){
    if ! [ -d "$2" ] && ! [ -f "$2" ]; then
        ln -s $1 $2
    else
        echo "$2 already exists. Skipping."
    fi
}

# Basic Config Folders
mkdir "$HOME/.config"
set-config-link "$SCRIPTPATH/alacritty" "$HOME/.config/alacritty"
set-config-link "$SCRIPTPATH/qt6ct" "$HOME/.config/qt6ct"
set-config-link "$SCRIPTPATH/swaylock" "$HOME/.config/swaylock"
set-config-link "$SCRIPTPATH/sway" "$HOME/.config/sway"
set-config-link "$SCRIPTPATH/hypr" "$HOME/.config/hypr"
set-config-link "$SCRIPTPATH/wofi" "$HOME/.config/wofi"
set-config-link "$SCRIPTPATH/nvim" "$HOME/.config/nvim"
set-config-link "$SCRIPTPATH/tmux" "$HOME/.config/tmux"
set-config-link "$SCRIPTPATH/yazi" "$HOME/.config/yazi"
set-config-link "$SCRIPTPATH/.zsh" "$HOME/.zsh"

# Basic Config Files
set-config-link "$SCRIPTPATH/.tmux.conf" "$HOME/.tmux.conf"
set-config-link "$SCRIPTPATH/.zshrc" "$HOME/.zshrc"

# GTK Bull
mkdir "$HOME/.local"
mkdir "$HOME/.local/share"
mkdir "$HOME/.local/share/themes"
set-config-link "$SCRIPTPATH/gtk/themes/catppuccin-mocha-lavender-standard+default" "$HOME/.local/share/themes/catppuccin-mocha-lavender-standard+default"
set-config-link "$SCRIPTPATH/gtk/themes/catppuccin-mocha-lavender-standard+default-hdpi" "$HOME/.local/share/themes/catppuccin-mocha-lavender-standard+default-hdpi"
set-config-link "$SCRIPTPATH/gtk/themes/catppuccin-mocha-lavender-standard+default-xhdpi" "$HOME/.local/share/themes/catppuccin-mocha-lavender-standard+default-xhdpi"

unset -f set-config-link
