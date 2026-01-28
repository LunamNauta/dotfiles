import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "lib32-mesa",
        "mesa"
    ],
    aur: null,
    flatpak: null
};

export { packages };