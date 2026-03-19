source "$SCRIPT_PATH/utilities.zsh"

native_packages=()
aur_packages=()
flatpak_packages=()
appimage_packages=()

# Boot
#------------------------------------------------------
native_packages+=(
    "efibootmgr"
    "grub"
)

# General
#------------------------------------------------------
# Base
native_packages+=(
    "linux-firmware"
    "zram-generator"
    "linux-headers"
    "base-devel"
    "inetutils"
    "linux"
    "base"
    "sudo"
    "acpi"
)
# Networking
native_packages+=(
    "networkmanager"
    "bluez-utils"
    "bluez-obex"
    "iwd"
)
aur_packages+=(
    "bluetuith-bin"
)
# Filesystems
native_packages+=(
    "btrfs-progs"
    "dosfstools"
    "f2fs-tools"
    "sshfs"
    "lvm2"
)
# Audio
native_packages+=(
    "pipewire-pulse"
    "pipewire"
)
# Build
native_packages+=(
    "rustup"
    "cmake"
    "make"
    "gcc"
    "npm"
    "gdb"
)

# Firmware
#------------------------------------------------------
# Base
native_packages+=(
    "fwupd"
)
# Intel CPU
native_packages+=(
    "intel-ucode"
)

# Drivers
#------------------------------------------------------
# Base
native_packages+=(
    "lib32-mesa"
    "mesa"
)
# Intel GPU
native_packages+=(
    "lib32-vulkan-intel"
    "xf86-video-intel"
    "vulkan-intel"
)

# Terminal
#------------------------------------------------------
# Utilities
native_packages+=(
    # General
    "lm_sensors"
    "ripgrep"
    "socat"
    "slurp"
    "rsync"
    "wget"
    "less"
    "curl"
    "fzf"
    "git"
    "bat"
    "bc"
    "jq"
    # Compression
    "unrar"
    "unzip"
    "7zip"
    "zip"
    # Brightness
    "brightnessctl"
    "ddcutil"
    # Audio
    "playerctl"
)
# Apps
native_packages+=(
    "man-pages"
    "neovim"
    "man-db"
    "kitty"
    "yazi"
    "btop"
    "tmux"
    "gdu"
)
# Zsh
native_packages+=(
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh"
)

# Environment
#------------------------------------------------------
# Base
native_packages+=(
    "hyprpolkitagent"
    "hyprsunset"
    "hyprpaper"
    "hypridle"
    "hyprlock"
    "hyprland"
    "hyprshot"
    "wlsunset"

    "niri"
    "xwayland-satellite"
)
# Utilities
native_packages+=(
    "xdg-desktop-portal-wlr"
    "xdg-user-dirs"
    "wl-clipboard"
)
aur_packages+=(
    "xdg-terminal-exec-mkhl"
)
# Apps
native_packages+=(
    # General
    "obsidian"
    "gwenview"
    "kitty"
    "nemo"
    # Office
    "libreoffice-fresh"
    "hunspell-en_us"
    "hunspell-de"
    # Communication
    "thunderbird"
    "discord"
    # System Control
    "gnome-disk-utility"
    "pavucontrol-qt"
)
aur_packages+=(
    "librewolf-bin"
    "visual-studio-code-bin"
)
# Theming
native_packages+=(
    # Icons
    "papirus-icon-theme"
    "breeze"
    # QT5/6
    "qt5-graphicaleffects"
    "qt5-quickcontrols2"
    "qt6ct"
    # Fonts
    "ttf-cascadia-code-nerd"
    "ttf-cascadia-mono-nerd"
    "noto-fonts-cjk"
    "ttf-liberation"
)
aur_packages+=(
    # Desktop Shell
    "noctalia-shell"
    # QT5/6 and GTK
    "catppuccin-gtk-theme-mocha"
    "catppuccin-qt5ct-git"
    # Fonts
    "ttf-material-symbols-variable-git"
    # Misc.
    "plymouth-theme-catppuccin-mocha-git"
    "btop-theme-catppuccin"
)

# Misc.
#------------------------------------------------------
native_packages+=(
    "docker"
    "tlp"

    "python-dbus"
    "libmpeg2"
    "tinyxml2"
    "libgtop"
    "libnewt"
    "boost"
    "sdl2-compat"
    "sdl2_ttf"
    "sdl3"
    "glfw"

    "keepassxc"
    "syncthing"
    "tailscale"

    "vlc-plugin-ffmpeg"
    "inotify-tools"
    "moreutils"
    "plymouth"
)
aur_packages+=(
    "arduino-avr-core"
    "arduino-ide-bin"
    "docker-desktop"
    "python-validity"
    "mongodb-bin"
)

function pre_install(){
    log_message "Enabling multilib repository..."
    sudo sed -i -e "/#\[multilib\]/,+1s/^#//" /etc/pacman.conf
}

function post_install(){
    log_message "Enabling networking services..."
    sudo systemctl enable --now NetworkManager
    sudo systemctl enable --now bluetooth

    log_message "Enabling audio services..."
    systemctl --user enable --now pipewire-pulse
    systemctl --user enable --now wireplumber
    systemctl --user enable --now pipewire

    log_message "Setting default apps..."
    xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

    log_message "Setting up XDG..."
    mkdir -p "$HOME/xdg_dirs"
    xdg-user-dirs-update --set DOWNLOAD "$HOME/xdg_dirs/downloads"
    xdg-user-dirs-update --set DOCUMENTS "$HOME/xdg_dirs/documents"
    xdg-user-dirs-update --set TEMPLATES "$HOME/xdg_dirs/templates"
    xdg-user-dirs-update --set PICTURES "$HOME/xdg_dirs/pictures"
    xdg-user-dirs-update --set DESKTOP "$HOME/xdg_dirs/desktop"
    xdg-user-dirs-update --set PUBLICSHARE "$HOME/xdg_dirs/public"
    xdg-user-dirs-update --set VIDEOS "$HOME/xdg_dirs/videos"
    xdg-user-dirs-update --set MUSIC "$HOME/xdg_dirs/music"

    log_message "Setting up GTK..."
    gsettings set org.gnome.desktop.interface gtk-theme catppuccin-mocha-lavender-standard+default
    gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty
    gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark

    log_message "Enabling TLP..."
    sudo systemctl enable --now tlp
}
