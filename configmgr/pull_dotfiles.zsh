local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/utils.zsh

if ! [[ -d $HOME/.config ]]; then exit; fi

pull-config-copy $SCRIPT_PATH/../starship.toml      $HOME/.config/starship.toml bluetuith
pull-config-copy $SCRIPT_PATH/../bluetuith          $HOME/.config/bluetuith     bluetuith
pull-config-copy $SCRIPT_PATH/../fuzzel             $HOME/.config/fuzzel        fuzzel
pull-config-copy $SCRIPT_PATH/../qt6ct              $HOME/.config/qt6ct         qt6ct
pull-config-copy $SCRIPT_PATH/../kitty              $HOME/.config/kitty         kitty
pull-config-copy $SCRIPT_PATH/../btop               $HOME/.config/btop          btop
pull-config-copy $SCRIPT_PATH/../hypr               $HOME/.config/hypr          hyprland
pull-config-copy $SCRIPT_PATH/../nvim               $HOME/.config/nvim          nvim
pull-config-copy $SCRIPT_PATH/../tmux               $HOME/.config/tmux          tmux
pull-config-copy $SCRIPT_PATH/../tmux/.tmux.conf    $HOME/.tmux.conf            tmux
pull-config-copy $SCRIPT_PATH/../yazi               $HOME/.config/yazi          yazi
pull-config-copy $SCRIPT_PATH/../zsh                $HOME/.config/zsh           zsh
pull-config-copy $SCRIPT_PATH/../zsh/.zshenv        $HOME/.zshenv               zsh
pull-config-copy $SCRIPT_PATH/../gdu/.gdu.yaml      $HOME/.gdu.yaml             gdu
