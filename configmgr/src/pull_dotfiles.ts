import { command_exists, log_message, pull_config } from "./utils";
import { homedir } from "node:os";

if (command_exists("starship")) await pull_config("../../starship.toml", `${homedir()}/.config/starship.toml`);
if (command_exists("bluetuith")) await pull_config("../../bluetuith", `${homedir()}/.config/bluetuith`);
if (command_exists("fuzzel")) await pull_config("../../fuzzel", `${homedir()}/.config/fuzzel`);
if (command_exists("qt6ct")) await pull_config("../../qt6ct", `${homedir()}/.config/qt6ct`);
if (command_exists("kitty")) await pull_config("../../kitty", `${homedir()}/.config/kitty`);
if (command_exists("btop")) await pull_config("../../btop", `${homedir()}/.config/btop`);
if (command_exists("hyprland")) await pull_config("../../hypr", `${homedir()}/.config/hypr`);
if (command_exists("nvim")) await pull_config("../../nvim", `${homedir()}/.config/nvim`);
if (command_exists("tmux")) await pull_config("../../tmux", `${homedir()}/.config/tmux`);
if (command_exists("tmux")) await pull_config("../../tmux/.tmux.conf", `${homedir()}/.tmux.conf`);
if (command_exists("yazi")) await pull_config("../../yazi", `${homedir()}/.config/yazi`);
if (command_exists("zsh")) await pull_config("../../zsh", `${homedir()}/.config/zsh`);
if (command_exists("zsh")) await pull_config("../../zsh/.zshenv", `${homedir()}/.zshenv`);
if (command_exists("gdu")) await pull_config("../../gdu/.gdu.yaml", `${homedir()}/.gdu.yaml`);
if (command_exists("codium")){
    await pull_config("../../codium/keybindings.json", `${homedir()}/.config/VSCodium/User/keybindings.json`);
    await pull_config("../../codium/settings.json", `${homedir()}/.config/VSCodium/User/settings.json`);
    const extensions_file = Bun.file("../../codium/extensions.txt");
    log_message("Scraping extensions from vscodium");
    const proc_get_extensions = Bun.spawnSync(["codium", "--list-extensions"]);
    extensions_file.write(proc_get_extensions.stdout.toString());
}