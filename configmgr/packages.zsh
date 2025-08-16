current_tags="desktop"

arch_packages=(
    # Base
    "linux-firmware"
    "zram-generator"
    "linuxconsole"
    "btrfs-progs"
    "base-devel"
    "efibootmgr"
    "linux"
    "base"
    "grub"
    "lvm2"
    "sudo"
    "intel-ucode ? laptop"
    "amd-ucode ? desktop"

    # Build / Package Management
    "cmake"
    "make"
    "gcc"
    "npm"

    # Music
    "rhythmbox"
    "gst-libav"

    # Networking
    "networkmanager"
    "pipewire-pulse"
    "bluez-utils"
    "pipewire"
    "blueman"
    "dhcp"

    # Misc
    "brightnessctl"
    "inotify-tools"
    "wl-clipboard"
    "dosfstools"
    "moreutils"
    "plymouth"
    "flatpak"
    "uwsm"
    "acpi"
    "fwupd ? laptop"
    "tlp ? laptop"

    # Terminal Utilities
    "lm_sensors"
    "unzip"
    "wget"
    "less"
    "bc"
    "jq"

    # Theming
    "zsh-syntax-highlighting"
    "ttf-cascadia-code-nerd"
    "ttf-cascadia-mono-nerd"
    "qt5-graphicaleffects"
    "zsh-autosuggestions"
    "papirus-icon-theme"
    "qt5-quickcontrols2"
    "breeze"
    "qt6ct"


    # Terminal Life
    "alacritty"
    "man-pages"
    "neovim"
    "man-db"
    "yazi"
    "btop"
    "tmux"
    "gdu"
    "git"
    "zsh"

    # Desktop Utilities
    "gnome-disk-utility"
    "libreoffice-fresh"
    "hyprpolkitagent"
    "thunderbird"
    "hyprsunset"
    "hyprpaper"
    "hypridle"
    "hyprlock"
    "hyprland"
    "gwenview"
    "nemo"
    "wofi"
    "blender ? desktop"
    "steam ? desktop"
    "lact ? desktop"

    # Libraries
    "libgtop"
    "libnewt"
    "glfw"
    "lib32-vulkan-radeon ? desktop"
    "vulkan-radeon ? desktop"
    "python-dbus ? desktop"
    "lib32-mesa ? desktop"
    "mesa ? desktop"
)

aur_packages=(
    # Misc
    "ttf-material-symbols-variable-git"
    "xdg-terminal-exec-mkhl"
    "aylurs-gtk-shell-git"
    "libastal-meta"
    "librewolf-bin"
    "quickshell"
    "python-validity ? laptop"
)

flathub_packages=(
    # Misc
    "com.modrinth.ModrinthApp ? desktop"
)

ignored_packages=(
    # Misc
    "yay"
)
