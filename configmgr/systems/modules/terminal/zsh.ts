import type { package_list } from "../../../src/types";
import { sudo_interactive_props, log_message } from "../../../src/utils";
import os from "os";

let packages: package_list = {
    pacman: [
        "zsh-syntax-highlighting",
        "zsh-autosuggestions",
        "zsh"
    ],
    aur: null,
    flatpak: null
};

async function post_install(){
    log_message("Setting user shell...");
    await Bun.spawn(["sudo", "chsh", "-s", "/usr/bin/zsh", os.userInfo().username], sudo_interactive_props).exited;
    console.log("");
}

export { packages, post_install };