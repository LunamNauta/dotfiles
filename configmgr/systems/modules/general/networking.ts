import type { package_list } from "../../../src/types";
import { sudo_interactive_props, log_message } from "../../../src/utils";

let packages: package_list = {
    pacman: [
        "networkmanager",
        "bluez-utils",
        "bluez-obex",
        "iwd"
    ],
    aur: [
        "bluetuith-bin"
    ],
    flatpak: null
};

async function post_install(){
    log_message("Enabling networking services...");
    await Bun.spawn(["sudo", "systemctl", "enable", "--now", "NetworkManager"], sudo_interactive_props).exited;
    await Bun.spawn(["sudo", "systemctl", "enable", "--now", "bluetooth"], sudo_interactive_props).exited;
    console.log("");
}

export { packages, post_install };