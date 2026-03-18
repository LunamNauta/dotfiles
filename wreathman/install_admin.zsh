source "$SCRIPT_PATH/utilities.zsh"

plymouth_setup(){
    sudo mkdir -p "/etc/plymouth"
    if [[ -f "/etc/plymouth/plymouthd.conf" ]]; then
        log_message "Removing current plymouth config..." none
        sudo rm -f "/etc/plymouth/plymouthd.conf"
        echo ""
    fi
    log_message "Inserting new plymouth config..." none
    sudo cp -r "$SCRIPT_PATH/../plymouth/plymouthd.conf" "/etc/plymouth"
    sudo plymouth-set-default-theme -R "catppuccin-mocha"
}

tlp_setup(){
    sudo mkdir -p "/etc"
    if [[ -f "/etc/tlp.conf" ]]; then
        log_message "Removing current TLP config..." none
        sudo rm -f "/etc/tlp.conf"
        echo ""
    fi
    log_message "Inserting new TLP config..." none
    sudo cp "$SCRIPT_PATH/../tlp/tlp.conf" "/etc/tlp.conf"
    sudo systemctl restart tlp
}

mkinitcpio_setup(){
    sudo mkinitcpio -P
}

if command -v plymouth >/dev/null 2>&1; then
    read "REPLY?Do you want to install Plymouth configuration? [y/N] "
    if [[ $REPLY =~ ^[Yy]$ ]]; then plymouth_setup; fi
fi
if command -v tlp >/dev/null 2>&1; then
    read "REPLY?Do you want to install TLP configuration? [y/N] "
    if [[ $REPLY =~ ^[Yy]$ ]]; then tlp_setup; fi
fi
read "REPLY?Do you want to mkinitcpio? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then mkinitcpio_setup; fi