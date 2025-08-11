source ./packages.zsh

# Get the path of this script
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../"

# Set up plymouth config
read -q "REPLY?Setup Plymouth (y/n): "
if [[ $REPLY = "y" ]]; then
    if ! [ -d /usr/share/plymouth/themes ]; then
        sudo mkdir -p /usr/share/plymouth/themes
    elif [ -d /usr/share/plymouth/themes/catppuccin-mocha ]; then
        echo "Removing plymouth catppuccin-mocha theme"
        sudo rm -rf /usr/share/plymouth/themes/catppuccin-mocha
    fi
    echo "Adding plymouth catppuccin-mocha theme"
    sudo cp -r "$SCRIPTPATH/plymouth/catppuccin-mocha" /usr/share/plymouth/themes

    if ! [ -d /etc/plymouth ]; then
        sudo mkdir -p /etc/plymouth
    elif [ -f /etc/plymouth/plymouthd.conf ]; then
        echo "Removing plymouth config"
        sudo rm -f /etc/plymouth/plymouthd.conf
    fi
    echo "Adding plymouth config"
    sudo cp -r "$SCRIPTPATH/plymouth/plymouthd.conf" /etc/plymouth
fi

echo ""

if [[ $current_tags == "laptop" ]]; then
    # Set up TLP config
    read -q "REPLY?Setup TLP (y/n): "
    if [[ $REPLY = "y" ]]; then
        if [ -f /etc/tlp.conf ]; then
            echo "Removing TLP config"
            sudo rm -rf /etc/tlp.conf
        fi
        echo "Adding TLP config"
        sudo cp "$SCRIPTPATH/tlp/tlp.conf" /etc/tlp.conf
        sudo systemctl restart tlp
    fi

    echo ""
fi

# Update initcpio
read -q "REPLY?mkinitcpio? (y/n): "
if [[ $REPLY = "y" ]]; then
    sudo mkinitcpio -P
fi
