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

set-config-link "$SCRIPTPATH/waybar" "$HOME/.config/waybar"
set-config-link "$SCRIPTPATH/foot" "$HOME/.config/foot"
set-config-link "$SCRIPTPATH/nvim" "$HOME/.config/nvim"
set-config-link "$SCRIPTPATH/hypr" "$HOME/.config/hypr"
set-config-link "$SCRIPTPATH/tmux" "$HOME/.config/tmux"
set-config-link "$SCRIPTPATH/.tmux.conf" "$HOME/.tmux.conf"
set-config-link "$SCRIPTPATH/fuzzel" "$HOME/.config/fuzzel"
set-config-link "$SCRIPTPATH/.bash_profile" "$HOME/.bash_profile"
set-config-link "$SCRIPTPATH/.bashrc" "$HOME/.bashrc"

unset -f set-config-link
