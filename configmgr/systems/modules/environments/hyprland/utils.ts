import type { package_list } from "../../../../src/types";
import { log_message } from "../../../../src/utils";
import { mkdir } from "node:fs/promises";
import { homedir } from "os";

let packages: package_list = {
    pacman: [
        "xdg-desktop-portal-wlr",
        "xdg-user-dirs",

        "wl-clipboard"
    ],
    aur: [
        "xdg-terminal-exec-mkhl"
    ],
    flatpak: null
};

async function post_install(){
    await mkdir(`${homedir()}/xdg_dirs`, { recursive: true });
    log_message("Setting up XDG bullsh*t...");
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "DOWNLOAD", `${homedir()}/xdg_dirs/downloads`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "DOCUMENTS", `${homedir()}/xdg_dirs/documents`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "TEMPLATES", `${homedir()}/xdg_dirs/templates`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "PICTURES", `${homedir()}/xdg_dirs/pictures`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "DESKTOP", `${homedir()}/xdg_dirs/desktop`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "PUBLICSHARE", `${homedir()}/xdg_dirs/public`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "VIDEOS", `${homedir()}/xdg_dirs/videos`]);
    Bun.spawnSync(["xdg-user-dirs-update", "--set", "MUSIC", `${homedir()}/xdg_dirs/music`]);
    console.log("");
}

export { packages, post_install };