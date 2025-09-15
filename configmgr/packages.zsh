arch_packages=(
    # Base
    "linux-firmware"
    "zram-generator"
    "linuxconsole"
    "btrfs-progs"
    "base-devel"
    "efibootmgr"
    "f2fs-tools"
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
    "ttf-liberation"
    "noto-fonts-cjk"
    "breeze"
    "qt6ct"

    # Terminal Life
    "alacritty"
    "man-pages"
    "starship"
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
    "discord"
    "nemo"
    "wofi"
    "obs-studio ? desktop"
    "blender ? desktop"
    "steam ? desktop"
    "lact ? desktop"

    # Emulation
    "libretro-beetle-pce"
    "libretro-beetle-pce-fast"
    "libretro-beetle-psx"
    "libretro-beetle-psx-hw"
    "libretro-beetle-supergrafx"
    "libretro-blastem"
    "libretro-bsnes"
    "libretro-bsnes-hd"
    "libretro-bsnes2014"
    "libretro-core-info"
    "libretro-desmume"
    "libretro-dolphin"
    "libretro-flycast"
    "libretro-gambatte"
    "libretro-genesis-plus-gx"
    "libretro-kronos"
    "libretro-mame"
    "libretro-mame2016"
    "libretro-melonds"
    "libretro-mesen"
    "libretro-mesen-s"
    "libretro-mgba"
    "libretro-mupen64plus-next"
    "libretro-nestopia"
    "libretro-overlays"
    "libretro-parallel-n64"
    "libretro-picodrive"
    "libretro-play"
    "libretro-ppsspp"
    "libretro-sameboy"
    "libretro-scummvm"
    "libretro-shaders-slang"
    "libretro-snes9x"
    "libretro-yabause"
    "dolphin-emu"
    "retroarch"
    "retroarch-assets-glui"
    "retroarch-assets-ozone"
    "retroarch-assets-xmb"

    # Virtual Machines
    "virt-manager"
    "bridge-utils"
    "qemu-full"
    "dnsmasq"

    # Libraries
    "tinyxml2"
    "libgtop"
    "libnewt"
    "boost"
    "fuse2"
    "glfw"
    "lib32-vulkan-radeon ? desktop"
    "vulkan-radeon ? desktop"
    "python-dbus ? desktop"
    "lib32-mesa ? desktop"
    "mesa ? desktop"

    # Misc
    "xdg-desktop-portal-wlr"
    "pavucontrol-qt"
    "slurp"
    "7zip"
    "gdb"
    "dex"
    "zip"

    # Device Drivers
    "xpad"
)

aur_packages=(
    # Misc
    "librewolf-bin"
    "wlrobs"
    "python-validity ? laptop"
    
    # Theming
    "ttf-material-symbols-variable-git"
    "xdg-terminal-exec-mkhl"
    "aylurs-gtk-shell-git"
    "libastal-meta"
    "quickshell"
    
    # Emulation
    "libretro-bluemsx-git"
    "libretro-retrodream"
    "torzu"

    # Virtual Machines
    "cemu"

    # Device Drivers
    "opentabletdriver"
    "xpadneo-dkms"
)

flathub_packages=(
    # Misc
    "com.modrinth.ModrinthApp ? desktop"
    "org.azahar_emu.Azahar"
)

ignored_packages=(
    # Misc
    "yay"
)
