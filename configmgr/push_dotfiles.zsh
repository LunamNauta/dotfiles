local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/utils.zsh

system_tags=($@)

if ! [[ -d $HOME/.config ]]; then mkdir -p "$HOME/.config"; fi

push-config-copy $SCRIPT_PATH/../bluetuith          $HOME/.config/bluetuith    bluetuith
push-config-copy $SCRIPT_PATH/../fuzzel             $HOME/.config/fuzzel       fuzzel
push-config-copy $SCRIPT_PATH/../qt6ct              $HOME/.config/qt6ct        qt6ct
push-config-copy $SCRIPT_PATH/../kitty              $HOME/.config/kitty        kitty
push-config-copy $SCRIPT_PATH/../btop               $HOME/.config/btop         btop
push-config-copy $SCRIPT_PATH/../hypr               $HOME/.config/hypr         hyprland
push-config-copy $SCRIPT_PATH/../nvim               $HOME/.config/nvim         nvim
push-config-copy $SCRIPT_PATH/../tmux               $HOME/.config/tmux         tmux
push-config-copy $SCRIPT_PATH/../tmux/.tmux.conf    $HOME/.tmux.conf           tmux
push-config-copy $SCRIPT_PATH/../yazi               $HOME/.config/yazi         yazi
push-config-copy $SCRIPT_PATH/../zsh                $HOME/.config/zsh          zsh
push-config-copy $SCRIPT_PATH/../zsh/.zshenv        $HOME/.zshenv              zsh
push-config-copy $SCRIPT_PATH/../gdu/.gdu.yaml      $HOME/.gdu.yaml            gdu

for tag in ${system_tags[@]}; do
    post_install_file=$(script-path)/systems/${(L)tag}/${(L)tag}_post_dotfiles.zsh
    if [[ -f $post_install_file ]]; then
        source $post_install_file
    fi
done

hyprctl reload
