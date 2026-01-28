import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "man-pages",
        "starship",
        "neovim",
        "man-db",
        "kitty",
        "yazi",
        "btop",
        "tmux",
        "gdu"
    ],
    aur: [
        "btop-theme-catppuccin"
    ],
    flatpak: null
};

export { packages };