OUTPUT_NEWLINE=0
            
clear() {
    OUTPUT_NEWLINE=0
    command clear
}

visible_length() {
    local foo=$1
    local zero='%([BSUbfksu]|([FK]|){*})'
    echo ${#${(S%%)foo//$~zero/}}
}

get_git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        echo "$branch"
    else
        echo ""
    fi
}

get_git_ahead_behind() {
    # Make sure we’re in a git repo

    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    # Get the upstream tracking branch (e.g., origin/main)
    local upstream
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null) || return

    # Get ahead/behind counts
    local counts ahead behind
    counts=$(git rev-list --left-right --count "${upstream}...HEAD" 2>/dev/null) || return
    behind=''${counts%%	*}
    ahead=''${counts##*	}

    local output=""
    (( ahead > 0 )) && output+="↑${ahead}"
    (( ahead > 0 && behind > 0)) && output+=" "
    (( behind > 0 )) && output+="↓${behind}"

    echo "$output"
}

get_git_info() {
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

    if [ -d /tmp/battery_status ]; then
        source /tmp/battery_status
    
        LEFT="%F{#cdd6f4}┌─(%F{#b4befe}$(whoami)@$(hostname))─%F{cdd6f4}[%F{#94e2d5}${PWD/#$HOME/~}%F{cdd6f4}]"
        RIGHT="$(get_git_info) $(date +%H:%M:%S) | $symbol $percent%%  $time  $state"
        RIGHTWIDTH=$(( $COLUMNS - $(visible_length $LEFT) ))
    else
        LEFT="%F{#cdd6f4}┌─(%F{#b4befe}$(whoami)@$(hostname))─%F{cdd6f4}[%F{#94e2d5}${PWD/#$HOME/~}%F{cdd6f4}]"
        RIGHT="$(get_git_info) $(date +%H:%M:%S)"
        RIGHTWIDTH=$(( $COLUMNS - $(visible_length $LEFT) ))
    fi
    print -P "$LEFT${(l:$RIGHTWIDTH:: :)RIGHT}"

    OUTPUT_NEWLINE=1
}
PROMPT="└─$ "

