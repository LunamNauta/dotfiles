import type { package_list } from "../../../src/types";

let packages: package_list = {
    pacman: [
        "linux-firmware",
        "zram-generator",
        "linux-headers",
        "base-devel",
        "inetutils",
        "linux",
        "base",
        "sudo",
        "acpi"
    ],
    aur: null,
    flatpak: null
};

export { packages };