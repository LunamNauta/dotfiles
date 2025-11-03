local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/../../utils.zsh

# Enable necessary services
log_message "Enabling services..."
systemctl --user start pipewire-pulse
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now python3-validity
sudo systemctl enable --now tlp
sudo systemctl enable sddm

# Set up GTK theme stuff
log_message "Setting up GTK..."
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-lavender-standard+default"
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

# Set up default app stuff
log_message "Setting up default apps..."
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

# Make sure the user shell is ZSH
log_message "Setting user shell..."
sudo chsh -s /usr/bin/zsh $(whoami)
