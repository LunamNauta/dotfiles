source install_dotfiles.zsh
source install_packages.zsh
source admin_install.zsh

current_tags=$1

# Get the path of this script
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../"

sed -i '/^monitor =/d' "$SCRIPTPATH/hypr/hyprland.conf"
if [[ $current_tags = "desktop" ]]; then
    sed -i '1i monitor = , 1920x1080@120, auto, 1' "$SCRIPTPATH/hypr/hyprland.conf"
elif [[ $current_tags = "laptop" ]]; then
    sed -i '1i monitor = , 1920x1080@60, auto, 1' "$SCRIPTPATH/hypr/hyprland.conf"
fi
