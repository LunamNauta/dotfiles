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
set-config-link "$SCRIPTPATH/waybar" "$HOME/.config/waybar"
set-config-link "$SCRIPTPATH/fuzzel" "$HOME/.config/fuzzel"
set-config-link "$SCRIPTPATH/foot" "$HOME/.config/foot"
set-config-link "$SCRIPTPATH/nvim" "$HOME/.config/nvim"
set-config-link "$SCRIPTPATH/hypr" "$HOME/.config/hypr"
set-config-link "$SCRIPTPATH/sway" "$HOME/.config/sway"
set-config-link "$SCRIPTPATH/tmux" "$HOME/.config/tmux"

# Basic Config Files
set-config-link "$SCRIPTPATH/.tmux.conf" "$HOME/.tmux.conf"
set-config-link "$SCRIPTPATH/.bash_profile" "$HOME/.bash_profile"
set-config-link "$SCRIPTPATH/.bashrc" "$HOME/.bashrc"

# Special cases (QT)
if ! [ -d "$HOME/.config/qt5ct" ]; then
    mkdir "$HOME/.config/qt5ct"
fi
if ! [ -d "$HOME/.config/qt6ct" ]; then
    mkdir "$HOME/.config/qt6ct"
fi
set-config-link "$SCRIPTPATH/qt5ct/colors" "$HOME/.config/qt5ct/colors"
set-config-link "$SCRIPTPATH/qt6ct/colors" "$HOME/.config/qt6ct/colors"

unset -f set-config-link
