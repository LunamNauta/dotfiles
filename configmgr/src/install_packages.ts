import { sudo_interactive_props, log_message, command_exists } from "./utils";
import type { package_list } from "./types";
import { readdir } from "node:fs/promises";

let desired_packages: package_list = {
    pacman: [],
    aur: [],
    flatpak: []
};
let ignored_packages: string[] = [
    "yay", "flatpak"
];
const pre_install_funcs: (() => Promise<void>)[] = [];
const post_install_funcs: (() => Promise<void>)[] = [];

async function read_packages(file_path: string){
    const collection = await import(file_path);
    const packages: package_list = collection.packages;
    if (collection.pre_install != null) pre_install_funcs.push(collection.pre_install);
    if (collection.post_install != null) post_install_funcs.push(collection.post_install);
    if (packages.pacman != null) for (let a = 0; a < packages.pacman.length; a++){
        let name = packages.pacman[a];
        if (name?.startsWith("module:")){
            let path = "../systems/modules/" + name.substring(name.indexOf(":") + 1);
            if (path.endsWith("*")) await read_packages_recursive(path.slice(0, -1));
            else await read_packages(path + ".ts");
        }
        else desired_packages.pacman!.push(packages.pacman[a]!);
    }
    if (packages.aur != null) for (let a = 0; a < packages.aur.length; a++){
        let name = packages.aur[a];
        if (name?.startsWith("module:")){
            let path = "../systems/modules/" + name.substring(name.indexOf(":") + 1);
            if (path.endsWith("*")) await read_packages_recursive(path.slice(0, -1));
            else await read_packages(path + ".ts");
        }
        else desired_packages.aur!.push(packages.aur[a]!);
    }
    if (packages.flatpak != null) for (let a = 0; a < packages.flatpak.length; a++){
        let flatpak = packages.flatpak[a];
        if (flatpak![0]!.startsWith("module:")){
            let path = "../systems/modules/" + flatpak![0]!.substring(flatpak![0]!.indexOf(":") + 1);
            if (path.endsWith("*")) await read_packages_recursive(path.slice(0, -1));
            else await read_packages(path + ".ts");
        }
        else desired_packages.flatpak!.push(packages.flatpak[a]!);
    }
}
async function read_packages_recursive(folder_path: string){
    const files = await readdir(folder_path, { recursive: true, withFileTypes: true });
    for (let a = 0; a < files.length; a++){
        if (files[a]?.isDirectory()) await read_packages_recursive("./" + files[a]?.parentPath + "/" + files[a]?.name);
        else await read_packages("./" + files[a]?.parentPath + "/" + files[a]?.name);
    }
}

if (Bun.argv.length != 3){
    console.log("Error: Please run this script as '${script_name} ${system_name}'");
    process.exit(1);
}
const system = "../systems/" + Bun.argv[2] + ".ts";
if (!await Bun.file(system).exists()){
    console.log(`Error: '${Bun.argv[2]}' is not a valid system`);
    process.exit(1);
}

log_message("Reading desired package list...");
await read_packages(system);
console.log("");

for (const pre_install_func of pre_install_funcs) await pre_install_func();

log_message("Reading current package list...");
const proc_curr_packages = Bun.spawnSync(["pacman", "-Qeq"]);
const curr_packages = await proc_curr_packages.stdout.toString().split("\n");

log_message("Updating system...");
const update_command: string[] = command_exists("yay") ? ["yay", "-Syu"] : ["sudo", "pacman", "-Syu"];
const proc_update = Bun.spawn(update_command, sudo_interactive_props);
await proc_update.exited;
console.log("");

log_message("Removing unused packages...");
for (const curr_package of curr_packages){
    if (curr_package.replace(/\p{White_Space}+/gu, "").length == 0) continue;
    if (curr_package.endsWith("-debug")) continue;

    const pacman_index = desired_packages.pacman?.findIndex(val => val == curr_package);
    if (pacman_index != undefined && pacman_index != -1){
        desired_packages.pacman?.splice(pacman_index, 1);
        continue;
    }
    const aur_index = desired_packages.aur?.findIndex(val => val == curr_package);
    if (aur_index != undefined && aur_index != -1){
        desired_packages.aur?.splice(aur_index, 1);
        continue;
    }
    if (ignored_packages.includes(curr_package)) continue;
    log_message(`'${curr_package}' not found in desired package list...`);
    const proc_remove_package = Bun.spawn(["sudo", "pacman", "-Rs", curr_package], sudo_interactive_props);
    await proc_remove_package.exited;
}
console.log("");

log_message("Checking for yay...");
if (!command_exists("yay")){
    log_message("Installing yay...");
    const proc_clone = Bun.spawnSync(["git", "clone", "https://aur.archlinux.org/yay.git"], sudo_interactive_props);
    if (proc_clone.exitCode != 0){
        log_message("Failed to clone yay. Quitting.");
        process.exit(1);
    }
    const proc_makepkg = Bun.spawn(["makepkg", "-si"], sudo_interactive_props);
    await proc_makepkg.exited;
    Bun.spawnSync(["rm", "-rf", "yay"]);
    if (proc_makepkg.exitCode != 0){
        log_message("Failed to install yay. Quitting.");
        process.exit(1);
    }
    console.log("");
}
else console.log("");

log_message("Checking for flatpak...");
if (!command_exists("flatpak")){
    log_message("Installing flatpak...")
    const proc_install_flatpak = Bun.spawn(["sudo", "pacman", "-S", "flatpak"], sudo_interactive_props);
    await proc_install_flatpak.exited;
    console.log("");
}
else console.log("");

log_message("Reading current flatpak list...");
const proc_curr_flatpaks = Bun.spawnSync(["flatpak", "list", "--app", "--columns=application"]);
const curr_flatpaks = await proc_curr_flatpaks.stdout.toString().split("\n");
console.log("");

log_message("Removing unused flatpaks...");
for (const curr_flatpak of curr_flatpaks){
    if (curr_flatpak.replace(/\p{White_Space}+/gu, "").length == 0) continue;

    const flatpak_index = desired_packages.flatpak?.findIndex(flatpak => flatpak[0] == curr_flatpak);
    if (flatpak_index != undefined && flatpak_index != -1){
        desired_packages.flatpak?.splice(flatpak_index, 1);
        continue;
    }
    if (ignored_packages.includes(curr_flatpak)) continue;
    log_message(`'${curr_flatpak}' not found in desired flatpak list...`);
    const proc_remove_package = Bun.spawn(["flatpak", "uninstall", curr_flatpak], sudo_interactive_props);
    await proc_remove_package.exited;
}
console.log("");

if (desired_packages.pacman?.length != 0){
    const pacman_packages = desired_packages.pacman!.toString().split(",").map(p => p.trim()).filter(p => p.length > 0);
    log_message("Installing native packages...");
    const proc_install = Bun.spawn(["sudo", "pacman", "-S", ...pacman_packages], sudo_interactive_props);
    await proc_install.exited;
    const proc_explicit = Bun.spawn(["sudo", "pacman", "-D", "--asexplicit", ...pacman_packages], sudo_interactive_props);
    await proc_explicit.exited;
    console.log("");
}

if (desired_packages.aur?.length != 0){
    const aur_packages = desired_packages.aur!.toString().split(",").map(p => p.trim()).filter(p => p.length > 0);
    log_message("Installing aur packages...");
    const proc_install = Bun.spawn(["yay", "-S", ...aur_packages], sudo_interactive_props);
    await proc_install.exited;
    console.log("");
}

if (desired_packages.flatpak?.length != 0){
    log_message("Installing flatpak packages...");
    for (const flatpak_package of desired_packages.flatpak!){
        const proc_install = Bun.spawn(["flatpak", "install", flatpak_package[0]!, flatpak_package[1]!], sudo_interactive_props);
        await proc_install.exited;
    }
    console.log("");
}

log_message("Searching for orphaned packages...");
const proc_orphaned_packages = Bun.spawnSync(["pacman", "-Qdtq"]);
const orphaned_packages = await proc_orphaned_packages.stdout.toString().split("\n");
for (let a = 0; a < orphaned_packages.length; a++){
    const orphaned_package = orphaned_packages[a]!;
    if (orphaned_package.replaceAll(/\p{White_Space}+/gu, "").length == 0){
        orphaned_packages.splice(a--, 1);
        continue;
    }
    if (orphaned_package.endsWith("-debug")){
        orphaned_packages.splice(a--, 1);
        continue;
    }

}
console.log("");
if (orphaned_packages.length != 0){
    log_message("Removing orphaned packages...");
    const proc_remove_orphans = Bun.spawn(["sudo", "pacman", "-Rns", orphaned_packages.join(" ")], sudo_interactive_props);
    await proc_remove_orphans.exited;
    console.log("");
}

for (const post_install_func of post_install_funcs) await post_install_func();