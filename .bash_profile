#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export TERMINAL="foot"
export EDITOR="nvim"

read -p "Start dhcpcd (You will be asked for your passwd) (y/n): " res
if [[ "$res" =~ ^[Yy]$ ]] then
    echo "Starting dhcpcd..."
    sudo dhcpcd
fi

read -p "Start Hyprland (y/n): " res
if [[ "$res" =~ ^[Yy]$ ]] then
    echo "Starting Hyprland..."
    hyprland
fi
