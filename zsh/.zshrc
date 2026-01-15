source ~/.config/zsh/functions.zsh

source ~/.config/zsh/options.zsh
source ~/.config/zsh/keybinds.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/autocomplete.zsh
source ~/.config/zsh/colors.zsh
source ~/.config/zsh/misc.zsh
source ~/.config/zsh/path_update.zsh

if [[ $TTY == /dev/tty1 ]]; then
    echo $(start-hyprland) >> /tmp/hyprland_start_tty1.txt
    logout || exit
elif ! [[ -z $(tty | grep pts) ]]; then
    eval "$(starship init zsh)"
    PROMPT_NEEDS_NEWLINE=false
    precmd(){
        if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
            echo
        fi
        PROMPT_NEEDS_NEWLINE=true
    }
    clear(){
        PROMPT_NEEDS_NEWLINE=false
        command clear
    }
else
    source ~/.config/zsh/prompt.zsh
fi
