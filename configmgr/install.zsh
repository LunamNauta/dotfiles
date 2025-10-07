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
    sed -i '1i monitor = , 1920x1080@60, auto, 1.25' "$SCRIPTPATH/hypr/hyprland.conf"
fi

if ! [ -d "$HOME/xdg_dirs" ]; then
    mkdir -p "$HOME/xdg_dirs"
fi
xdg-user-dirs-update --set DOWNLOAD "$HOME/xdg_dirs/downloads"
xdg-user-dirs-update --set DOCUMENTS "$HOME/xdg_dirs/documents"
xdg-user-dirs-update --set TEMPLATES "$HOME/xdg_dirs/templates"
xdg-user-dirs-update --set PICTURES "$HOME/xdg_dirs/pictures"
xdg-user-dirs-update --set DESKTOP "$HOME/xdg_dirs/desktop"
xdg-user-dirs-update --set PUBLICSHARE "$HOME/xdg_dirs/public"
xdg-user-dirs-update --set VIDEOS "$HOME/xdg_dirs/videos"
xdg-user-dirs-update --set MUSIC "$HOME/xdg_dirs/music"

if [[ -f "$HOME/.face.icon" ]]; then
    rm -rf "$HOME/.face.icon"
fi
cp "$SCRIPTPATH/face.png" "$HOME/.face.icon"
setfacl -m u:sddm:x ~/
setfacl -m u:sddm:r ~/.face.icon
