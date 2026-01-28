import type { package_list } from "../../../src/types";
import { sudo_interactive_props, log_message } from "../../../src/utils";

let packages: package_list = {
    pacman: [
        "pipewire-pulse",
        "pipewire"
    ],
    aur: null,
    flatpak: null
};

async function post_install(){
    log_message("Enabling audio services...");
    await Bun.spawn(["systemctl", "--user", "start", "pipewire-pulse"], sudo_interactive_props).exited;
    console.log("");
}

export { packages };