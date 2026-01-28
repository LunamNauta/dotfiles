import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "efibootmgr",
        "grub"
    ],
    aur: null,
    flatpak: null
};

export { packages };