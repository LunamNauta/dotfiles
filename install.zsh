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
set-config-link "$SCRIPTPATH/nvim" "$HOME/.config/nvim"
set-config-link "$SCRIPTPATH/tmux" "$HOME/.config/tmux"
set-config-link "$SCRIPTPATH/yazi" "$HOME/.config/yazi"
set-config-link "$SCRIPTPATH/.zsh" "$HOME/.zsh"

# Basic Config Files
set-config-link "$SCRIPTPATH/.tmux.conf" "$HOME/.tmux.conf"
set-config-link "$SCRIPTPATH/.zshrc" "$HOME/.zshrc"

unset -f set-config-link
