import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: null,
    aur: [
        "minecraft-launcher"
    ],
    flatpak: [
        ["com.modrinth.ModrinthApp", "flathub"]
    ]
};

export { packages };