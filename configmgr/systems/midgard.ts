import type { package_list } from "../src/types";
import { log_message } from "../src/utils";

let packages: package_list = {
    pacman: [
        "module:boot/grub",

        "module:general/base",
        "module:general/networking",
        "module:general/filesystems",
        "module:general/audio",
        "module:general/build",

        "module:firmware/base",
        "module:firmware/intel/cpu",

        "module:terminal/utilities",
        "module:terminal/apps",
        "module:terminal/zsh",

        "module:environments/hyprland/*",

        "python-dbus",
        "libmpeg2",
        "tinyxml2",
        "libgtop",
        "libnewt",
        "boost",
        "fuse2",
        "sdl2-compat",
        "sdl2_ttf",
        "sdl3",
        "glfw",

        "keepassxc",
        "syncthing",
        "tailscale",

        "vlc-plugin-ffmpeg",
        "inotify-tools",
        "moreutils",
        "plymouth"
    ],
    aur: null,
    flatpak: null
};

async function pre_install(){
    log_message("Enabling multilib repository...");
    Bun.spawnSync(["sudo", "sed", "-i", "-e", "'/#\[multilib\]/,+1s/^#//'", "/etc/pacman.conf"]);
    console.log("");
}

export { packages, pre_install };