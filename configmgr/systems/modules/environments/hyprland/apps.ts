import type { package_list } from "../../../../src/types";
import { log_message } from "../../../../src/utils";

let packages: package_list = {
    pacman: [
        "gnome-disk-utility",

        "libreoffice-fresh",
        "hunspell-en_us",
        "hunspell-de",

        "pavucontrol-qt",
        "thunderbird",
        "obsidian",
        "gwenview",
        "discord",
        "fuzzel",
        "kitty",
        "nemo"
    ],
    aur: [
        "librewolf-bin",
        "vscodium-bin"
    ],
    flatpak: null
};

async function post_install(){
    log_message("Setting default apps...");
    Bun.spawnSync(["xdg-mime", "default", "nemo.desktop", "inode/directory application/x-gnome-saved-search"]);
    console.log("");
}

export { packages, post_install };