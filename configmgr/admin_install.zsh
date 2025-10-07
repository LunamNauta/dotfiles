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

    echo ""
fi

read -q "REPLY?Setup SDDM (y/n): "
if [[ $REPLY = "y" ]]; then
    if [ -f /etc/sddm.conf ]; then
        echo "Removing SDDM config"
        sudo rm -f /etc/sddm.conf
    fi
    if [ -f /usr/share/sddm/themes/silent/configs/default.conf ]; then
        echo "Removing Silent SDDM config"
        sudo rm -f /usr/share/sddm/themes/silent/configs/default.conf 
    fi
    if [ -f /usr/share/sddm/themes/silent/backgrounds/Sakura_Trees.jpg ]; then
        echo "Removing SDDM background config"
        sudo rm -f /usr/share/sddm/themes/silent/backgrounds/Sakura_Trees.jpg
    fi
    echo "Adding SDDM config"
    sudo cp "$SCRIPTPATH/sddm/sddm.conf" /etc/
    sudo cp "$SCRIPTPATH/sddm/default.conf" /usr/share/sddm/themes/silent/configs/
    sudo cp "$SCRIPTPATH/backgrounds/Sakura_Trees.jpg" /usr/share/sddm/themes/silent/backgrounds/
    echo ""
fi

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
