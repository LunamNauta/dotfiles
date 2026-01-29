import type { package_list } from "../src/types";
import { sudo_interactive_props, log_message } from "../src/utils";

let packages: package_list = {
    pacman: [
        "module:boot/grub",

        "module:general/base",
        "module:general/networking",
        "module:general/filesystems",
        "module:general/audio",
        "module:general/build",

        "module:firmware/base",
        "module:firmware/amd/cpu",

        "module:drivers/amd/gpu",
        "module:drivers/tablets",
        "module:drivers/xbox",

        "module:terminal/utilities",
        "module:terminal/apps",
        "module:terminal/zsh",

        "module:environments/hyprland/*",

        "module:gaming/minecraft",
        "module:gaming/steam",

        "module:art/drawing",
        "module:art/modeling",
        "module:art/obs",

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
        "plymouth",

        // These docker packages conflict with 'docker-desktop'
        //"docker-compose",
        //"docker-buildx",
        "docker",
    ],
    aur: [
        "docker-desktop",
        "python-validity",
        "mongodb-bin"
    ],
    flatpak: null
};

async function pre_install(){
    log_message("Enabling multilib repository...");
    Bun.spawnSync(["sudo", "sed", "-i", "-e", "'/#\[multilib\]/,+1s/^#//'", "/etc/pacman.conf"]);
    console.log("");
}

async function post_install(){
    log_message("Disabling docker autostart...");
    await Bun.spawn(["sudo", "systemctl", "disable", "--now", "docker"], sudo_interactive_props).exited;
    await Bun.spawn(["sudo", "systemctl", "disable", "--now", "docker.socket"], sudo_interactive_props).exited;
    console.log("");
}

export { packages, pre_install, post_install };