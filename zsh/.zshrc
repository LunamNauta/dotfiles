setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst

WORDCHARS=${WORDCHARS//\/}

bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end

# Enable completion
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Enable syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
 
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
 
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
 
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
 
    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

export EDITOR=nvim
ssh-start(){ eval "$(ssh-agent -s)"; }
ssh-add-key(){ ssh-add "$HOME/.ssh/$1" }

# bun completions
[ -s "/home/loki/.bun/_bun" ] && source "/home/loki/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history         # share command history data
alias history="history 0"

OUTPUT_NEWLINE=0
            
function clear() {
    OUTPUT_NEWLINE=0
    command clear
}

function visible_length() {
    local foo=$1
    local zero='%([BSUbfksu]|([FK]|){*})'
    echo ${#${(S%%)foo//$~zero/}}
}

function get_git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        echo "$branch"
    else
        echo ""
    fi
}

function get_git_ahead_behind() {
    # Make sure we’re in a git repo
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    # Get the upstream tracking branch (e.g., origin/main)
    local upstream
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null) || return

    # Get ahead/behind counts
    local counts ahead behind
    counts=$(git rev-list --left-right --count "''${upstream}...HEAD" 2>/dev/null) || return
    behind=''${counts%%	*}
    ahead=''${counts##*	}

    local output=""
    (( ahead > 0 )) && output+="↑''${ahead}"
    (( ahead > 0 && behind > 0)) && output+=" "
    (( behind > 0 )) && output+="↓''${behind}"

    echo "$output"
}

function get_git_info() {
    local branch ahead_behind output
    branch=$(get_git_branch)
    ahead_behind=$(get_git_ahead_behind)
    if [[ -n branch ]]; then
        output+=$branch;
    fi
    if [[ -n $ahead_behind ]]; then
        if [[ -n branch ]]; then output+=" "; fi
        output+=$ahead_behind
    fi
    if [[ -n $output ]]; then
        echo "$output │"
    else
        echo ""
    fi
}

precmd() {
    if [[ $OUTPUT_NEWLINE -eq 1 ]]; then echo; fi

    LEFT="%F{#cdd6f4}┌─(%F{#b4befe}$(whoami)@$(hostname))─%F{cdd6f4}[%F{#94e2d5}${PWD/#$HOME/~}%F{cdd6f4}]"
    RIGHT="$(get_git_info) $(date +%H:%M:%S)"
    RIGHTWIDTH=$(( $COLUMNS - $(visible_length $LEFT) ))
    print -P "$LEFT${(l:$RIGHTWIDTH:: :)RIGHT}"

    OUTPUT_NEWLINE=1
}
PROMPT="└─$ "


#source ~/.config/zsh/zsh_no_gui.zsh
