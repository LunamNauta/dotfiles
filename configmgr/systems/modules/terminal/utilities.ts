import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "lm_sensors",
        "ripgrep",
        "socat",
        "slurp",
        "rsync",
        "wget",
        "less",
        "curl",
        "fzf",
        "git",
        "bat",
        "bc",
        "jq",

        "unrar-free",
        "unzip",
        "7zip",
        "zip",

        "brightnessctl",
        "ddcutil"
    ],
    aur: null,
    flatpak: null
};

export { packages };