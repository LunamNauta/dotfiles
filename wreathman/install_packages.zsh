source "$SCRIPT_PATH/utilities.zsh"

native_packages=()
aur_packages=()
flatpak_packages=()
appimage_packages=()

# Update current packages
#------------------------------------------------------
log_message "Updating native packages..." none
sudo pacman -Syu

if ! command -v yay >/dev/null; then
    log_message "Installing yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
fi
if ! command -v flatpak >/dev/null; then
    log_message "Installing flatpak..."
    sudo pacman -S flatpak
fi
if ! command -v fusermount >/dev/null; then
    log_message "Installing fuse2..."
    sudo pacman -S fuse2
fi

log_message "Updating AUR packages..."
yay -Syu

log_message "Updating flatpak packages..."
flatpak update

# Fetch new package lists
#------------------------------------------------------
source "$SCRIPT_PATH/machines/$SYSTEM_NAME.zsh"

# Fetch current package lists
#------------------------------------------------------
current_native_packages=("${(@f)$(comm -23 <(pacman -Qeq | sort) <(pacman -Qmq | sort))}")
current_aur_packages=("${(@f)$(comm -12 <(pacman -Qeq | sort) <(pacman -Qmq | sort))}")
current_flatpak_packages=("${(@f)$(flatpak list --app --columns=application,origin | awk '{print $1 " " $2}')}")
current_appimage_packages=($HOME/applications/*.appimage(N:t:r))

# Gather unwanted packages
#------------------------------------------------------
unwanted_native_packages=($(printf "%s\n" "${current_native_packages[@]}" | grep -vxF -f <(printf "%s\n" "${native_packages[@]}")))
unwanted_aur_packages=($(printf "%s\n" "${current_aur_packages[@]}" | grep -vxF -f <(printf "%s\n" "${aur_packages[@]}")))
flatpak_names=("${flatpak_packages[@]%% *}")
current_flatpak_names=("${current_flatpak_packages[@]%% *}")
unwanted_flatpak_packages=("${(@f)$(printf "%s\n" "${current_flatpak_names[@]}" | grep -vxF -f <(printf "%s\n" "${flatpak_names[@]}"))}")
appimage_names=("${appimage_packages[@]%% *}")
unwanted_appimage_packages=($(printf "%s\n" "${current_appimage_packages[@]}" | grep -vxF -f <(printf "%s\n" "${appimage_names[@]}")))

unwanted_native_packages=(${unwanted_native_packages:#""})
unwanted_aur_packages=(${unwanted_aur_packages:#""})
unwanted_flatpak_packages=(${unwanted_flatpak_packages:#""})
unwanted_appimage_packages=(${unwanted_appimage_packages:#""})

unwanted_native_packages=(${unwanted_native_packages[@]:#flatpak})
unwanted_native_packages=(${unwanted_native_packages[@]:#fuse2})
unwanted_aur_packages=(${unwanted_aur_packages[@]:#yay})
unwanted_aur_packages=(${unwanted_aur_packages[@]:#*-debug})

# Remove unwanted packages
#------------------------------------------------------
for native_package in "${unwanted_native_packages[@]}"; do
    log_message "$native_package not found in desired native packages"
    sudo pacman -Rns $native_package
done

for aur_package in "${unwanted_aur_packages[@]}"; do
    log_message "$aur_package not found in desired AUR packages"
    yay -Rns $aur_package
done

for flatpak_package_group in "${unwanted_flatpak_packages[@]}"; do
    flatpak_package_group=("${=flatpak_package_group}")
    flatpak_package="${flatpak_package_group[1]}"
    log_message "$flatpak_package not found in desired flatpak packages"
    flatpak uninstall $flatpak_package
done

for appimage_package in "${unwanted_appimage_packages[@]}"; do
    log_message "$appimage_package not found in desired AppImage packages"
    read "REPLY?Do you want to remove this AppImage? [Y/n] "
    appimage_path="$HOME/applications/$appimage_package.appimage"
    bin_path="$HOME/.local/bin/$appimage_package"
    if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
        if [[ -f "$appimage_path" ]]; then
            rm "$appimage_path"
        fi
        if [[ -L "$bin_path" ]]; then
            rm "$bin_path"
        fi
    fi
done

# Filter out already installed packages (excluding appimages)
#------------------------------------------------------
new_native_packages=($(printf "%s\n" "${native_packages[@]}" | grep -vxF -f <(printf "%s\n" "${current_native_packages[@]}")))
new_aur_packages=($(printf "%s\n" "${aur_packages[@]}" | grep -vxF -f <(printf "%s\n" "${current_aur_packages[@]}")))
new_flatpak_packages=($(printf "%s\n" "${flatpak_packages[@]}" | grep -vxF -f <(printf "%s\n" "${current_flatpak_packages[@]}")))

# Run pre-install script
#------------------------------------------------------
if command -v pre_install >/dev/null; then
    pre_install
fi

# Install new packages
#------------------------------------------------------
if [[ "${#new_native_packages[@]}" -gt 0 ]]; then
    log_message "Installing native packages..."
    sudo pacman -S --asexplicit ${new_native_packages[@]}
fi

if [[ "${#new_aur_packages[@]}" -gt 0 ]]; then
    log_message "Install AUR packages..."
    yay -S --asexplicit ${new_aur_packages[@]}
fi

if [[ ${#new_flatpak_packages[@]} -gt 0 ]]; then
    log_message "Installing flatpak packages..."
    for package_group in ${new_flatpak_packages[@]}; do
        package_group=(${=package_group})
        package=${package_group[1]}
        repo=${package_group[2]}
        flatpak install $repo $package
    done
fi

if [[ "${#appimage_packages[@]}" -gt 0 ]]; then
    log_message "Installing appimages..."
    mkdir -p ~/applications
    mkdir -p ~/.local/bin

    for appimage_group in "${appimage_packages[@]}"; do
        appimage_group=(${=appimage_group})
        name="${appimage_group[1]}"
        url="${appimage_group[2]}"
        log_message "$name found in desired AppImage packages" none
        read "REPLY?Do you want to install this AppImage? [y/N] "
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            appimage_path="$HOME/applications/$name.appimage"
            bin_path="$HOME/.local/bin/$name"
            if [[ -f "$appimage_path" ]]; then
                rm "$appimage_path"
            fi
            if [[ -L "$bin_path" ]]; then
                rm "$bin_path"
            fi
            wget -O "$appimage_path" $url
            chmod +x "$appimage_path"
            ln -s "$appimage_path" "$bin_path"
        fi
    done
fi

# Run post-install script
#------------------------------------------------------
if command -v post_install >/dev/null; then
    post_install
fi

# Removing orphaned packages
#------------------------------------------------------
# Get orphaned packages excluding '-debug'
orphaned_packages=("${(@f)$(pacman -Qdtq | grep -v -- '-debug$')}")
orphaned_packages=(${orphaned_packages:#""})
if [[ "${#orphaned_packages[@]}" -gt 0 ]]; then
    log_message "Removing orphaned packages..."
    sudo pacman -Rns ${orphaned_packages[@]}
fi