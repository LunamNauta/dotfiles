function script-path() {
    echo ${0:A:h}
}

log_message(){
    print -P "%B%F{blue}$1%f%b"
}

log_error(){
    print -P "%B%F{red}$1%f%b"
}

push-config-copy(){
    if command -v $3 &> /dev/null; then
        log_message "Pushing config '${1:t}' to '$2'..."
        if ! [[ -d ${2:h} ]]; then mkdir -p ${2:h}; fi
        if [[ -e $2 ]]; then rm -rf $2; fi
        cp -r $1 $2
    fi
}

pull-config-copy(){
    if command -v $3 &> /dev/null && [[ -e $1 ]]; then
        log_message "Pulling config '${2:t}' from '$1'..."
        if [[ -e $1 ]]; then rm -rf $1; fi
        cp -r $2 $1
    fi
}
