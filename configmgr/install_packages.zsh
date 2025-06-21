source ./packages.zsh

log_message(){
    print -P "%B%F{blue}$1%f%b"
}

log_message "Updating system..."
if command -v yay &> /dev/null; then
    yay -Syu
else
    sudo pacman -Syu
fi

log_message "Removing unused packages..."
actual_packages=($(pacman -Qeq))
for actual_package in "${actual_packages[@]}"; do
    if [[ " ${arch_packages[@]} " =~ " ${actual_package} " ]]; then
        continue
    elif [[ " ${aur_packages[@]} " =~ " ${actual_package} " ]]; then
        continue
    elif [[ " ${ignored_packages[@]} " =~ " ${actual_package} " ]]; then
        continue
    else
        log_message "${actual_package} not found in package list..."
        sudo pacman -Rs $actual_package
    fi
done

log_message "Installing native packages..."
sudo pacman -S --needed ${arch_packages[@]}

log_message "Checking for yay..."
if ! command -v yay &> /dev/null; then
    log_message "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ../
    sudo rm -rf yay
fi

if ! command -v rustup &> /dev/null; then
    log_message "Installing rustup..." # Needed for xdg-terminal-exec-mkhl. Choose rustup during installation
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

log_message "Installing aur packages..."
yay -S --needed ${aur_packages[@]}

log_message "Installing flathub packages"
flatpak install flathub ${flathub_packages[@]}

log_message "Instsalling yazi extensions"
ya pack -a yazi-rs/plugins:full-border
ya pack -a yazi-rs/plugins:mount
ya pack -a imsi32/yatline
ya pack -a yazi-rs/plugins:smart-enter

log_message "Removing orphaned packages..."
sudo pacman -Qdtq | ifne sudo pacman -Rns -
sudo pacman -Qqd | ifne sudo pacman -Rsu

log_message "Enabling services..."
systemctl --user start pipewire-pulse
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now lactd
sudo systemctl enable --now tlp
sudo systemctl enable --now python3-validity
# sudo systemctl enable sddm

log_message "Setting up GTK..."
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-lavender-standard+default"
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

log_message "Setting up default apps..."
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

log_message "Setting user shell..."
sudo chsh -s /usr/bin/zsh loki
