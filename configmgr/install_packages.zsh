local SCRIPT_PATH=${0:A:h}
source $SCRIPT_PATH/utils.zsh

system_tags=($@)
package_list=()

for tag in ${system_tags[@]}; do
    source $(script-path)/systems/${(L)tag}/${(L)tag}.zsh
    package_list_name=${(L)tag}_packages
    package_list+=(${(@P)package_list_name[@]})
done
for package in ${package_list[@]}; do
    if [[ $package == submodule:* ]]; then
        submodule_name=${(L)package#submodule:}
        source $(script-path)/systems/submodules/$submodule_name.zsh
        package_list_name=${submodule_name:t}_packages
        package_list+=(${(@P)package_list_name[@]})
    fi
done

native_packages=()
aur_packages=()
flatpak_packages=()
ignored_packages=(
    flatpak
    yay
)

for package in ${package_list[@]}; do
    if [[ $package == submodule:* ]]; then
        continue
    elif [[ $package == *=aur ]]; then
        aur_packages+=(${package%=aur})
    elif [[ $package == *=flatpak,* ]]; then
        name=${package%%=*}
        repo=${package#*,}
        flatpak_packages+=(${name}:${repo})
    else
        native_packages+=($package)
    fi
done

# Remove packages that were installed by anything other than this script (excluding dependencies)
log_message "Removing unused packages..."
actual_packages=($(pacman -Qeq))
for actual_package in ${actual_packages[@]}; do
    if [[ " ${native_packages[@]} " =~ " ${actual_package} " ]]; then
        continue
    elif [[ " ${aur_packages[@]} " =~ " ${actual_package} " ]]; then
        continue
    elif [[ " ${ignored_packages[@]} " =~ " ${actual_package} " ]]; then
        continue
    else
        log_message "${actual_package} not found in package list..."
        sudo pacman -Rs $actual_package
    fi
done

log_message "Removing unused flatpaks..."
actual_flatpaks=($(flatpak list --app --columns=application | tail -n +2))
for actual_flatpak in ${actual_flatpaks[@]}; do
    found=0
    for package in ${flatpak_packages[@]}; do
        name=${package%%:*}
        if [[ $name == $actual_flatpak ]]; then
            found=1
            break
        fi
    done
    if [[ $found -ne 1 ]]; then
        log_message "${actual_flatpak} not found in flatpak list..."
        flatpak uninstall $actual_flatpak
    fi
done

# Update all packages
log_message "Updating system..."
if command -v yay &> /dev/null; then 
    yay -Syu
else 
    sudo pacman -Syu
fi

if ! [[ -z ${native_packages[@]} ]]; then
    # Install packages using pacman
    log_message "Installing native packages..."
    sudo pacman -S --needed ${native_packages[@]}
fi

if ! [[ -z ${aur_packages[@]} ]]; then
    # Install yay if it is not installed
    log_message "Checking for yay..."
    if ! command -v yay &> /dev/null; then
        log_message "Installing yay..."
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ../
        sudo rm -rf yay
    fi

    # Install packages using yay
    log_message "Installing aur packages..."
    yay -S --needed ${aur_packages[@]}
fi

# Install packages (from flathub) using flatpak
if ! [[ -z ${flatpak_packages[@]} ]]; then
    if ! command -v flatpak &>/dev/null; then
        log_message "Installing flatpak..."
        sudo pacman -S flatpak
    fi
    log_message "Installing flatpak packages..."
    for package in ${flatpak_packages[@]}; do
        name=${package%%:*}
        repo=${package#*:}
        flatpak install $repo $name
    done
elif command -v flatpak &>/dev/null; then
    sudo pacman -Rs flatpak
fi

# Remove any packages that were orphaned in any previous step
orphans=$(pacman -Qdtq)
if [[ -n "$orphans" ]]; then
    log_message "Removing orphaned packages..."
    sudo pacman -Rns $(pacman -Qdtq)
else
    log_message "No orphans to remove..."
fi

for tag in ${system_tags[@]}; do
    post_install_file=$(script-path)/systems/${(L)tag}/${(L)tag}_post_install.zsh
    if [[ -f $post_install_file ]]; then
        source $post_install_file
    fi
done
