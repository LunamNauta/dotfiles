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
fi

: '
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
'

source ~/.config/zsh/prompt.zsh

export EDITOR=nvim

export NEWT_COLORS="
    root=#1e1e2e,#1e1e2e
    border=#b4befe,#1e1e2e
    window=#1e1e2e,#1e1e2e
    shadow=#11111b,#11111b
    title=#b4befe,#1e1e2e
    button=#1e1e2e,#b4befe
    button_active=#1e1e2e,#FFFF00
    actbutton=#FFFF00,#1e1e2e
    compactbutton=#b4befe,#1e1e2e
    checkbox=#eba0ac,#1e1e2e
    entry=#a6e3a1,#1e1e2e
    disentry=#1e1e2e,#000000
    textbox=#a6e3a1,#1e1e2e
    acttextbox=#FF00FF,#1e1e2e
    label=#b4befe,#1e1e2e
    listbox=#cdd6f4,#1e1e2e
    actlistbox=#cba6f7,#1e1e2e
    sellistbox=#eba0ac,#1e1e2e
    actsellistbox=#1e1e2e,#b4befe
"
