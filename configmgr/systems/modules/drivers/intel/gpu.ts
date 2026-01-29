import type { package_list } from "../../../../src/types";

let packages: package_list = {
    pacman: [
        "module:drivers/gpu",
        
        "lib32-vulkan-intel",
        "xf86-video-intel",
        "vulkan-intel",
    ],
    aur: null,
    flatpak: null
};

export { packages };