local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/../../utils.zsh

asgard_packages=(
    submodule:base

    submodule:boot/grub

    submodule:networking

    submodule:filesystems

    submodule:audio
    
    submodule:build

    submodule:firmware/base
    submodule:firmware/amd_cpu
    submodule:firmware/amd_gpu

    submodule:terminal/utility
    submodule:terminal/apps
    submodule:terminal/zsh

    submodule:tiling_desktop/hyprland
    submodule:tiling_desktop/theming
    submodule:tiling_desktop/apps

    submodule:art

    submodule:device_drivers/xbox_controller
    submodule:device_drivers/tablets

    submodule:gaming/minecraft
    submodule:gaming/emulation
    submodule:gaming/steam

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

    arduino-ide-bin=aur
    bluetuith-bin=aur
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
