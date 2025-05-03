arch_packages=(
    # Build tools
    cmake
    make
    gcc
    npm

    # Utilities
    dosfstools
    moreutils
    openssh
    flatpak
    docker
    unzip
    lact
    wget
    less
    git
    bc

    # Terminal Life
    neovim
    yazi
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
)
aur_packages=(
    xdg-terminal-exec-mkhl
)
flathub_packages=(
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

log_message "Removing orphaned packages..."
sudo pacman -Qdtq | ifne sudo pacman -Rns -
sudo pacman -Qqd | ifne sudo pacman -Rsu

log_message "Enabling services..."
sudo systemctl enable --now docker

log_message "Creating dotfile symlinks..."
zsh $SCRIPTPATH/install.zsh

log_message "Setting up default apps..."
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

log_message "Setting user shell..."
sudo chsh -s /usr/bin/zsh loki

SCRIPTDIR=${0:a:h}
cp -r $SCRIPTDIR/alacritty $APPDATA
