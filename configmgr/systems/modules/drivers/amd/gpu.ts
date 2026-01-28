import type { package_list } from "../../../../src/types";
import { sudo_interactive_props, log_message } from "../../../../src/utils";

let packages: package_list = {
    pacman: [
        "module:drivers/gpu",
        
        "lib32-vulkan-radeon",
        "xf86-video-amdgpu",
        "vulkan-radeon",
        "lact"
    ],
    aur: null,
    flatpak: null
};

async function post_install(){
    log_message("Enabling AMD GPU services...");
    await Bun.spawn(["sudo", "systemctl", "enable", "--now", "lactd"], sudo_interactive_props).exited;
    console.log("");
}

export { packages, post_install };