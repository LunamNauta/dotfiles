local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/../../utils.zsh

midgard_packages=(
    submodule:base

    submodule:boot/grub

    submodule:networking

    submodule:filesystems

    submodule:audio

    submodule:build

    submodule:firmware/base
    submodule:firmware/intel_cpu

    submodule:terminal/utility
    submodule:terminal/apps
    submodule:terminal/zsh

    submodule:tiling_desktop/hyprland
    submodule:tiling_desktop/theming
    submodule:tiling_desktop/apps

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
    acpi
    tlp
    python-validity=aur

    arduino-ide-bin=aur
    bluetuith=aur
    bluez-obex
    #libreoffice-impress-templates
    keepassxc
    picard
    rsync
    sshfs
    syncthing
    tailscale

    hunspell-de
    hunspell-en_us
    hyprshot
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
