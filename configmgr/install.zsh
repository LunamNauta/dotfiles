local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/utils.zsh

source $(script-path)/install_packages.zsh $@
source $(script-path)/install_admin.zsh $@
source $(script-path)/push_dotfiles.zsh $@

if command -v xdg-user-dirs-update &>/dev/null; then
    if ! [ -d $HOME/xdg_dirs ]; then
        mkdir -p $HOME/xdg_dirs
    fi
    xdg-user-dirs-update --set DOWNLOAD       $HOME/xdg_dirs/downloads
    xdg-user-dirs-update --set DOCUMENTS      $HOME/xdg_dirs/documents
    xdg-user-dirs-update --set TEMPLATES      $HOME/xdg_dirs/templates
    xdg-user-dirs-update --set PICTURES       $HOME/xdg_dirs/pictures
    xdg-user-dirs-update --set DESKTOP        $HOME/xdg_dirs/desktop
    xdg-user-dirs-update --set PUBLICSHARE    $HOME/xdg_dirs/public
    xdg-user-dirs-update --set VIDEOS         $HOME/xdg_dirs/videos
    xdg-user-dirs-update --set MUSIC          $HOME/xdg_dirs/music
fi

if [[ -f $HOME/.face.icon ]]; then
    rm -rf $HOME/.face.icon
fi
cp $(script-path)/../face.png $HOME/.face.icon
if command -v setfacl &>/dev/null; then
    setfacl -m u:sddm:x ~/
    setfacl -m u:sddm:r ~/.face.icon
fi
