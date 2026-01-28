import type { package_list } from "../../../../src/types";

let packages: package_list = {
    pacman: [
        "module:firmware/base",
 
        "amd-ucode"
    ],
    aur: null,
    flatpak: null
};

export { packages };