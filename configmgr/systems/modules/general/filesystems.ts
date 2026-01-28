import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "btrfs-progs",
        "dosfstools",
        "f2fs-tools",
        "sshfs",
        "lvm2"
    ],
    aur: null,
    flatpak: null
};

export { packages };