local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/utils.zsh

# Set up plymouth config
if command -v plymouth &>/dev/null; then
    read -q "REPLY?Setup Plymouth (y/n): "
    if [[ $REPLY = "y" ]]; then
        echo
        if ! [[ -d /etc/plymouth ]]; then
            sudo mkdir -p /etc/plymouth
        elif [[ -e /etc/plymouth/plymouthd.conf ]]; then
            log_message "Removing plymouth config..."
            sudo rm -f /etc/plymouth/plymouthd.conf
        fi
        log_message "Adding plymouth config..."
        sudo cp -r "$(script-path)/../plymouth/plymouthd.conf" /etc/plymouth
        sudo plymouth-set-default-theme -R catppuccin-mocha
    else
        echo
    fi
fi

if command -v sddm &>/dev/null; then
    read -q "REPLY?Setup SDDM (y/n): "
    if [[ $REPLY = "y" ]]; then
        echo
        if [ -f /etc/sddm.conf ]; then
            log_message "Removing SDDM config..."
            sudo rm -f /etc/sddm.conf
        fi
        if [ -f /usr/share/sddm/themes/silent/configs/default.conf ]; then
            log_message "Removing Silent SDDM config..."
            sudo rm -f /usr/share/sddm/themes/silent/configs/default.conf 
        fi
        if [ -f /usr/share/sddm/themes/silent/backgrounds/Sakura_Trees.jpg ]; then
            log_message "Removing SDDM background config..."
            sudo rm -f /usr/share/sddm/themes/silent/backgrounds/Sakura_Trees.jpg
        fi
        log_message "Adding SDDM config..."
        sudo cp "$(script-path)/../sddm/sddm.conf" /etc/
        sudo cp "$(script-path)/../sddm/default.conf" /usr/share/sddm/themes/silent/configs/
        sudo cp "$(script-path)/../backgrounds/Sakura_Trees.jpg" /usr/share/sddm/themes/silent/backgrounds/
    else
        echo
    fi
fi

if command -v tlp &>/dev/null; then
    # Set up TLP config
    read -q "REPLY?Setup TLP (y/n): "
    if [[ $REPLY = "y" ]]; then
        echo
        if [ -f /etc/tlp.conf ]; then
            log_message "Removing TLP config..."
            sudo rm -rf /etc/tlp.conf
        fi
        log_message "Adding TLP config..."
        sudo cp "$(script-path)/../tlp/tlp.conf" /etc/tlp.conf
        sudo systemctl restart tlp
    else
        echo
    fi
fi

# Update initcpio
read -q "REPLY?mkinitcpio? (y/n): "
if [[ $REPLY = "y" ]]; then
    echo
    sudo mkinitcpio -P
else
    echo
fi
