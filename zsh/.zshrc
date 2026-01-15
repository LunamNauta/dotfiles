source ~/.config/zsh/functions.zsh

source ~/.config/zsh/options.zsh
source ~/.config/zsh/keybinds.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/autocomplete.zsh
source ~/.config/zsh/colors.zsh
source ~/.config/zsh/misc.zsh
source ~/.config/zsh/path_update.zsh

if [[ $TTY == /dev/tty1 ]]; then
    #echo $(uwsm start Hyprland) >> /tmp/hyprland_start_tty1.txt
    echo $(start-hyprland) >> /tmp/hyprland_start_tty1.txt
    logout || exit
else
    #source ~/.config/zsh/prompt.zsh
fi
