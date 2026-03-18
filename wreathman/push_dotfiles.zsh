source "$SCRIPT_PATH/utilities.zsh"

for dotfile_info in ${dotfile_mapping[@]}; do
    dotfile_info=("${=dotfile_info}")
    condition=(${(s,:,)dotfile_info[1]})
    condition_type=${condition[1]}
    condition_value=${condition[2]}

    if [[ $condition_type == "cmd" ]]; then
        if [[ ! $(command -v $condition_value 2>/dev/null) ]]; then continue; fi
    elif [[ $condition_type == "dir" ]]; then 
        if [[ ! -d $condition_value ]]; then continue; fi
    else
        log_error "Error: Invalid condition for dotfile push"
        continue
    fi

    local_path=${${dotfile_info[2]}[2, -2]}
    remote_path=${${dotfile_info[3]}[2, -2]}
    log_message "Pushing from $local_path to $remote_path" none
    rm -rf $remote_path
    cp -r $local_path $remote_path

    if [[ ! -z ${dotfile_info[4]} ]]; then
        ${dotfile_info[4]} push
    fi
done