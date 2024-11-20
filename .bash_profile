#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ "$(tty)" = "/dev/tty1" ]; then
    export TERMINAL="foot"
    export EDITOR="nvim"
fi

ssh-start(){ eval "$(ssh-agent -s)"; }
ssh-add-key(){ ssh-add "$HOME/.ssh/$1"; }
