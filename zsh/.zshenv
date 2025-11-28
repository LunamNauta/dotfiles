. "$HOME/.cargo/env"
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CONFIG_HOME="$HOME/.config"
if ! [[ -d "$HOME/.cache/zsh" ]]; then
    mkdir "$HOME/.cache/zsh"
fi

HISTFILE="$HOME/.cache/zsh/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
