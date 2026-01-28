import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "dolphin-emu",
        "libretro"
    ],
    aur: [
        "libretro-bluemsx-git"
    ],
    flatpak: [
        ["org.azahar_emu.Azahar", "flathub"]
    ]
};

export { packages };