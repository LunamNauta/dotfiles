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

    # Networking
    networkmanager
    dhcp

    # Utilities
    moreutils
    unzip
    qt6ct
    git

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

    # Desktop
    hyprland
    hyprpaper
    nemo
    ly

    # Libraries
    libgtop
)
aur_packages=(
    librewolf-bin
    aylurs-gtk-shell-git
    xdg-terminal-exec
    #ros2-jazzy
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
    rm -r yay
fi

log_message "Installing aur packages..."
yay -S --needed ${aur_packages[@]}

log_message "Removing orphaned packages..."
sudo pacman -Qdtq | ifne sudo pacman -Rns -
sudo pacman -Qqd | ifne sudo pacman -Rsu

log_message "Enabling services..."
sudo systemctl enable ly

log_message "Creating dotfile symlinks..."
zsh $SCRIPTPATH/install.zsh

log_message "Setting up GTK..."
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-lavender-standard+default"
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

log_message "Setting up default apps..."
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
