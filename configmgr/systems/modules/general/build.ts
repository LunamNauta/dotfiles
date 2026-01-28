import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "rustup",
        "cmake",
        "make",
        "gcc",
        "npm",
        "gdb"
    ],
    aur: null,
    flatpak: null
};

export { packages }