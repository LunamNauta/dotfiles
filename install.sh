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
set-config-link "$SCRIPTPATH/alacritty" "$HOME/.config/alacritty"
set-config-link "$SCRIPTPATH/hypr" "$HOME/.config/hypr"
set-config-link "$SCRIPTPATH/wofi" "$HOME/.config/wofi"
set-config-link "$SCRIPTPATH/nvim" "$HOME/.config/nvim"
set-config-link "$SCRIPTPATH/tmux" "$HOME/.config/tmux"
set-config-link "$SCRIPTPATH/eww" "$HOME/.config/eww"
set-config-link "$SCRIPTPATH/ags" "$HOME/.config/ags"
set-config-link "$SCRIPTPATH/.zsh" "$HOME/.zsh"

# Basic Config Files
set-config-link "$SCRIPTPATH/.tmux.conf" "$HOME/.tmux.conf"
set-config-link "$SCRIPTPATH/.zshrc" "$HOME/.zshrc"

unset -f set-config-link
