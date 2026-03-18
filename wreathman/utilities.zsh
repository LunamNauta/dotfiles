function log_message(){
    if [[ $2 != "none" ]]; then echo; fi
    echo "$(tput bold)$(tput setaf 4)$1$(tput sgr0)"
}
function log_error(){
    if [[ $2 != "none" ]]; then echo; fi
    echo "$(tput bold)$(tput setaf 1)$1$(tput sgr0)"
}

edit_config() {
    local config_path="$1"
    local header="$2"
    shift 2
    local replacement="${(j:\n:)@}"
    local marker="CONFIGMGR: $header"

    if [[ ! -f "$config_path" ]] || ! grep -q "$marker" "$config_path"; then
        return 1
    fi

    sed -i "/$marker/ {
        n
        :loop
        /CONFIGMGR:/ !{
            N
            b loop
        }
        s/\n.*CONFIGMGR:/\nCONFIGMGR:/
        i\\
        $replacement
    }" "$config_path"

    sed -i "/$marker/,/CONFIGMGR:/ { /^$/d; /CONFIGMGR: $header/G; }" "$config_path"
}
clear_config_edits(){
    sed -i '/CONFIGMGR: .*/,/# CONFIGMGR:$/ {
        /CONFIGMGR: .*/b
        /# CONFIGMGR:$/b
        d
    }' "$1"
}

function hyprland_special(){
    if [[ $1 == "push" ]]; then
        log_message "Fixing hyprland configuration..." none
        if [[ $SYSTEM_NAME == "asgard" ]]; then
            edit_config "$HOME/.config/hypr/hyprland.conf" "MONITOR DATA" "monitor = , 1920x1080@120, auto, 1"
            edit_config "$HOME/.config/hypr/hyprland.conf" "GAPS" "gaps_in = 0,0,0,0" "gaps_out = 2,2,2,2"
            edit_config "$HOME/.config/hypr/hyprland.conf" "ROUNDING" "rounding = 14"
        elif [[ $SYSTEM_NAME == "midgard" ]]; then
            edit_config "$HOME/.config/hypr/hyprland.conf" "MONITOR DATA" "monitor = , 1920x1080@60, auto, 1.20"
            edit_config "$HOME/.config/hypr/hyprland.conf" "GAPS" "gaps_in = 0,0,0,0" "gaps_out = 2,2,2,2"
            edit_config "$HOME/.config/hypr/hyprland.conf" "ROUNDING" "rounding = 14"
        fi

        log_message "Fixing Noctalia configuration..." none
        cp "$SCRIPT_PATH/../noctalia/colors.json" "$HOME/.config/noctalia/colors.json"
        cp "$SCRIPT_PATH/../noctalia/plugins.json" "$HOME/.config/noctalia/plugins.json"
        cp "$SCRIPT_PATH/../noctalia/settings.json" "$HOME/.config/noctalia/settings.json"
        rm -rf "$HOME/.config/noctalia/colorschemes"
        cp -r "$SCRIPT_PATH/../noctalia/colorschemes" "$HOME/.config/noctalia/colorschemes"

        log_message "Reloading hyprland..." none
        hyprctl reload >/dev/null 2>&1
        sh "$HOME/.config/hypr/scripts/border_when_alone.zsh" >/dev/null 2>&1
    elif [[ $1 == "pull" ]]; then
        log_message "Fixing hyprland configuration..." none
        clear_config_edits "$SCRIPT_PATH/../hypr/hyprland.conf"

        log_message "Scraping settings from Noctalia configuration..." none
        cp "$HOME/.config/noctalia/colors.json" "$SCRIPT_PATH/../noctalia/colors.json"
        cp "$HOME/.config/noctalia/plugins.json" "$SCRIPT_PATH/../noctalia/plugins.json"
        cp "$HOME/.config/noctalia/settings.json" "$SCRIPT_PATH/../noctalia/settings.json"
        rm -rf "$SCRIPT_PATH/../noctalia/colorschemes"
        cp -r "$HOME/.config/noctalia/colorschemes" "$SCRIPT_PATH/../noctalia/colorschemes"
    fi
}

function yazi_special(){
    if [[ $1 == "push" ]]; then
        log_message "Installing yazi plugins..." none
        rm -rf "$HOME/.config/yazi/package.toml"
        rm -rf "$HOME/.config/yazi/plugins"
        ya pkg add "yazi-rs/plugins:full-border"
        ya pkg add "yazi-rs/plugins:mount"
        ya pkg add "yazi-rs/plugins:smart-enter"
        ya pkg add "dedukun/bookmarks"
    fi
}

function vscode_special(){
    if [[ $1 == "push" ]]; then
        log_message "Installing VSCode extensions..." none
        xargs -n 1 code --force --install-extension < "$SCRIPT_PATH/../vscode/extensions.txt"
    elif [[ $1 == "pull" ]]; then
        log_message "Scraping extensions from VSCode..." none
        code --list-extensions > "$SCRIPT_PATH/../vscode/extensions.txt"
    fi
}

function zsh_special(){
    if [[ $1 == "push" ]]; then
        cp "$SCRIPT_PATH/../services/bin/battery_status.sh" "$HOME/.local/services/battery_status.sh"
        cp "$SCRIPT_PATH/../services/systemd/battery_status.service" "$HOME/.config/systemd/user/battery_status.service"
        systemctl --user enable --now battery_status
    elif [[ $1 == "pull" ]]; then
        cp "$HOME/.local/services/battery_status.sh" "$SCRIPT_PATH/../services/bin/battery_status.sh"
        cp "$HOME/.config/systemd/user/battery_status.service" "$SCRIPT_PATH/../services/systemd/battery_status.service"
    fi
}

dotfile_mapping=(
    "cmd:bluetuith '$SCRIPT_PATH/../bluetuith'               '$HOME/.config/bluetuith'"
    "cmd:fuzzel    '$SCRIPT_PATH/../fuzzel'                  '$HOME/.config/fuzzel'"
    "cmd:qt6ct     '$SCRIPT_PATH/../qt6ct'                   '$HOME/.config/qt6ct'"
    "cmd:kitty     '$SCRIPT_PATH/../kitty'                   '$HOME/.config/kitty'"
    "cmd:btop      '$SCRIPT_PATH/../btop'                    '$HOME/.config/btop'"      
    "cmd:hyprland  '$SCRIPT_PATH/../hypr'                    '$HOME/.config/hypr'                       hyprland_special"
    "cmd:nvim      '$SCRIPT_PATH/../nvim'                    '$HOME/.config/nvim'"
    "cmd:tmux      '$SCRIPT_PATH/../tmux'                    '$HOME/.config/tmux'"
    "cmd:tmux      '$SCRIPT_PATH/../tmux/.tmux.conf'         '$HOME/.tmux.conf'"
    "cmd:yazi      '$SCRIPT_PATH/../yazi'                    '$HOME/.config/yazi'                       yazi_special"
    "cmd:zsh       '$SCRIPT_PATH/../zsh'                     '$HOME/.config/zsh'"
    "cmd:zsh       '$SCRIPT_PATH/../zsh/.zshenv'             '$HOME/.zshenv'"
    "cmd:gdu       '$SCRIPT_PATH/../gdu/.gdu.yaml'           '$HOME/.gdu.yaml'"
    "cmd:code      '$SCRIPT_PATH/../vscode/keybindings.json' '$HOME/.config/Code/User/keybindings.json' vscode_special"
    "cmd:code      '$SCRIPT_PATH/../vscode/settings.json'    '$HOME/.config/Code/User/settings.json'"
)
