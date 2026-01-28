import { sudo_interactive_props, log_message, command_exists } from "./utils";

async function plymouth_setup(){
    await Bun.spawn(["sudo", "mkdir", "-p", "/etc/plymouth"], sudo_interactive_props).exited;
    if (await Bun.file("/etc/plymouth/plymouthd.conf").exists()){
        log_message("Removing current plymouth config...");
        await Bun.spawn(["sudo", "rm", "-f", "/etc/plymouth/plymouthd.conf"], sudo_interactive_props).exited;
        console.log("");
    }
    log_message("Inserting new plymouth config...");
    await Bun.spawn(["sudo", "cp", "-r", "../../plymouth/plymouthd.conf", "/etc/plymouth"], sudo_interactive_props).exited;
    await Bun.spawn(["sudo", "plymouth-set-default-theme", "-R", "catppuccin-mocha"], sudo_interactive_props).exited;
}

async function tlp_setup(){
    await Bun.spawn(["sudo", "mkdir", "-p", "/etc"], sudo_interactive_props).exited;
    if (await Bun.file("/etc/tlp.conf").exists()){
        log_message("Removing current TLP config...");
        await Bun.spawn(["sudo", "rm", "-f", "/etc/tlp.conf"], sudo_interactive_props).exited;
        console.log("");
    }
    await Bun.spawn(["sudo", "cp", "../../tlp/tlp.conf", "/etc/tlp.conf"], sudo_interactive_props).exited;
    await Bun.spawn(["sudo", "systemctl", "restart", "tlp"], sudo_interactive_props).exited;
}

async function mkinitcpio_setup(){
    await Bun.spawn(["sudo", "mkinitcpio", "-P"], sudo_interactive_props).exited;
}

if (command_exists("plymouth") && prompt("Setup plymouth (y/n):") == "y") await plymouth_setup();
if (command_exists("tlp") && prompt("Setup TLP (y/n):") == "y") await tlp_setup();
if (prompt("mkinitcpio (y/n):") == "y") await mkinitcpio_setup();