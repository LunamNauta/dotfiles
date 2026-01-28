import { command_exists, log_message, push_config } from "./utils";
import { homedir } from "node:os";

if (command_exists("starship")) await push_config("../../starship.toml", `${homedir()}/.config/starship.toml`);
if (command_exists("bluetuith")) await push_config("../../bluetuith",    `${homedir()}/.config/bluetuith`);
if (command_exists("fuzzel")) await push_config("../../fuzzel", `${homedir()}/.config/fuzzel`);
if (command_exists("qt6ct")) await push_config("../../qt6ct", `${homedir()}/.config/qt6ct`);
if (command_exists("kitty")) await push_config("../../kitty", `${homedir()}/.config/kitty`);
if (command_exists("btop")) await push_config("../../btop", `${homedir()}/.config/btop`);
if (command_exists("hyprland")){
    await push_config("../../hypr", `${homedir()}/.config/hypr`);
    Bun.spawnSync(["sed", "-i", "'s/monitor = , 1920x1080@60, auto, 1.25/monitor = , 1920x1080@120, auto, 1/'", `${homedir()}/.config/hypr/hyprland.conf`]);
    Bun.spawnSync(["hyprctl", "reload"]);
}
if (command_exists("nvim")) await push_config("../../nvim", `${homedir()}/.config/nvim`);
if (command_exists("tmux")) await push_config("../../tmux", `${homedir()}/.config/tmux`);
if (command_exists("tmux")) await push_config("../../tmux/.tmux.conf", `${homedir()}/.tmux.conf`);
if (command_exists("yazi")){
    await push_config("../../yazi", `${homedir()}/.config/yazi`);
    Bun.spawnSync(["rm", "-rf", `${homedir()}/.config/yazi/package.toml`]);
    Bun.spawnSync(["rm", "-rf", `${homedir()}/.config/yazi/plugins`]);
    log_message("Installing yazi plugins");
    Bun.spawnSync(["ya", "pkg", "add", "yazi-rs/plugins:full-border"]);
    Bun.spawnSync(["ya", "pkg", "add", "yazi-rs/plugins:mount"]);
    Bun.spawnSync(["ya", "pkg", "add", "yazi-rs/plugins:smart-enter"]);
    Bun.spawnSync(["ya", "pkg", "add", "dedukun/bookmarks"]);
}
if (command_exists("zsh")) await push_config("../../zsh", `${homedir()}/.config/zsh`);
if (command_exists("zsh")) await push_config("../../zsh/.zshenv", `${homedir()}/.zshenv`);
if (command_exists("gdu")) await push_config("../../gdu/.gdu.yaml", `${homedir()}/.gdu.yaml`);
if (command_exists("codium")){
    await push_config("../../codium/keybindings.json", `${homedir()}/.config/VSCodium/User/keybindings.json`);
    await push_config("../../codium/settings.json", `${homedir()}/.config/VSCodium/User/settings.json`);
    const proc_cat = Bun.spawnSync(["cat", "../../codium/extensions.txt"]);
    log_message("Installing vscodium extensions");
    const proc_install = Bun.spawn(["xargs", "-n", "1", "codium", "--install-extension"], {
        stdin: proc_cat.stdout,
        stdout: 'inherit',
        stderr: 'inherit',
    });
    await proc_install.exited;
}