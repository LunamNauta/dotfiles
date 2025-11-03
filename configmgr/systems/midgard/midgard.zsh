local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/../../utils.zsh

midgard_packages=(
    # Base
    linux-firmware
    zram-generator
    linux-headers
    base-devel
    inetutils
    linux
    base
    sudo

    # Boot
    efibootmgr
    grub

    # Filesystems
    btrfs-progs
    dosfstools
    f2fs-tools
    lvm2

    # Firmware
    intel-ucode
    fwupd

    # Networking
    networkmanager
    bluez-utils
    blueman

    # Audio
    pipewire-pulse
    gst-libav
    rhythmbox
    pipewire
    
    # Build Tools
    cmake
    make
    gcc
    npm
    gdb

    # Terminal Theming
    zsh-syntax-highlighting
    zsh-autosuggestions

    # Terminal Utilities
    alacritty
    man-pages
    neovim
    man-db
    yazi
    btop
    tmux
    gdu
    zsh

    # Terminal Commands
    lm_sensors
    ddcutil
    unzip
    slurp
    wget
    less
    7zip
    git
    zip
    bc
    jq

    # Desktop Theming
    catppuccin-qt5ct-git=aur
    catppuccin-gtk-theme-mocha=aur
    btop-theme-catppuccin=aur
    ttf-material-symbols-variable-git=aur
    ttf-cascadia-code-nerd
    ttf-cascadia-mono-nerd
    noto-fonts-cjk
    ttf-liberation
    qt5-graphicaleffects
    qt5-quickcontrols2
    qt6ct
    papirus-icon-theme
    breeze
    sddm-silent-theme=aur
    quickshell-git=aur

    # Desktop Utilities
    xdg-terminal-exec-mkhl=aur
    xdg-desktop-portal-wlr
    xdg-user-dirs
    gnome-disk-utility
    libreoffice-fresh
    librewolf-bin=aur
    pavucontrol-qt
    thunderbird
    gwenview
    discord
    fuzzel
    nemo

    # Desktop Environment
    hyprpolkitagent
    hyprsunset
    hyprpaper
    hypridle
    hyprlock
    hyprland
    sddm

    # Virtualization
    #virt-manager
    #bridge-utils
    #qemu-full
    #cemu=aur
    #dnsmasq

    # Libraries
    python-dbus
    libmpeg2
    tinyxml2
    libgtop
    libnewt
    boost
    fuse2
    sdl2_ttf
    sdl2
    glfw

    # Misc
    vlc-plugin-ffmpeg
    brightnessctl
    inotify-tools
    wl-clipboard
    moreutils
    plymouth
    flatpak
    uwsm
    acpi
    tlp
    python-validity=aur
)

#-------------------------------------------------------------------

# Enable multilib repository (needed for some packages)
log_message "Enabling multilib repository..."
sudo sed -i -e '/#\[multilib\]/,+1s/^#//' /etc/pacman.conf # Enable multilib
#"sudo sed -i -e '/^\[multilib\]/{s/^/#/;n;s/^/#/}' /etc/pacman.conf" # Disable multilib

# Install rust. Needed for packages in the AUR (also a good thing to just have)
if ! command -v rustup &> /dev/null; then
    log_message "Installing rustup..." # Needed for xdg-terminal-exec-mkhl. Choose rustup during installation
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#-------------------------------------------------------------------
