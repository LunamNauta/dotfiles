import type { package_list } from "../../../../src/types";
import { log_message } from "../../../../src/utils";

let packages: package_list = {
    pacman: [
        "papirus-icon-theme",
        "breeze",

        "qt5-graphicaleffects",
        "qt5-quickcontrols2",
        "qt6ct",

        "ttf-cascadia-code-nerd",
        "ttf-cascadia-mono-nerd",
        "noto-fonts-cjk",
        "ttf-liberation",
    ],
    aur: [
        "quickshell-git",

        "plymouth-theme-catppuccin-mocha-git",
        "catppuccin-gtk-theme-mocha",
        "catppuccin-qt5ct-git",

        "ttf-material-symbols-variable-git"
    ],
    flatpak: null
};

async function post_install(){
    log_message("Setting up GTK bullsh*t...");
    Bun.spawnSync(["gsettings", "set", "org.gnome.desktop.interface",  "gtk-theme", '"catppuccin-mocha-lavender-standard+default"']);
    Bun.spawnSync(["gsettings", "set", "org.cinnamon.desktop.default-applications.terminal", "exec", "kitty"]);
    Bun.spawnSync(["gsettings", "set", "org.gnome.desktop.interface", "icon-theme", '"Papirus-Dark"']);
    console.log("");
}

export { packages, post_install };