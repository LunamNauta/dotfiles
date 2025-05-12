# Make sure to enable the multilib repository

arch_packages=(
    # System requirements
    base
    base-devel
    linux
    linux-firmware
    grub
    efibootmgr

    # Build tools
    cmake
    make
    gcc
    npm

    # Networking / Bluetooth
    networkmanager
    pipewire-pulse
    pipewire
    blueman
    dhcp

    # Utilities
    dosfstools
    moreutils
    flatpak
    docker
    unzip
    qt6ct
    lact
    wget
    less
    git
    bc
    jq
    btop
    gdu

    docker
    docker-buildx

    # Fonts
    ttf-cascadia-code-nerd
    ttf-cascadia-mono-nerd

    # Icons
    papirus-icon-theme

    # Terminal Life
    alacritty
    neovim
    yazi
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    tmux
    man-db
    man-pages

    # Desktop
    libreoffice-fresh
    gnome-disk-utility
    hyprpolkitagent
    thunderbird
    hyprsunset
    hyprpaper
    hypridle
    hyprlock
    hyprland
    nemo
    wofi
    ly

    swayidle
    swaybg
    sway

    # Gaming
    steam

    # Libraries
    python-dbus
    libgtop
    mesa
    lib32-mesa
    vulkan-radeon
    lib32-vulkan-radeon
    glfw
)
aur_packages=(
    librewolf-bin
    aylurs-gtk-shell-git
    xdg-terminal-exec-mkhl
    swaylock-effects
    #ros2-jazzy
)
flathub_packages=(
    com.modrinth.ModrinthApp
)

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

log_message(){
    print -P "%B%F{blue}$1%f%b"
}

log_message "Updating system..."
if command -v yay &> /dev/null; then
    yay -Syu
else
    sudo pacman -Syu
fi

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
sudo systemctl enable --now bluetooth
sudo systemctl enable --now docker
sudo systemctl enable --now lactd
sudo systemctl enable ly

log_message "Creating dotfile symlinks..."
zsh $SCRIPTPATH/install.zsh

log_message "Setting up GTK..."
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-lavender-standard+default"
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

log_message "Setting up default apps..."
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

log_message "Setting user shell..."
sudo chsh -s /usr/bin/zsh loki
