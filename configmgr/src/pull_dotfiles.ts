import { command_exists, log_message, pull_config } from "./utils";
import { homedir } from "node:os";

async function hyprland_special(){
    log_message("Scraping settings from Noctalia shell");
    await pull_config("../../noctalia/colors.json", `${homedir()}/.config/noctalia/colors.json`);
    await pull_config("../../noctalia/plugins.json", `${homedir()}/.config/noctalia/plugins.json`);
    await pull_config("../../noctalia/settings.json", `${homedir()}/.config/noctalia/settings.json`);
    await pull_config("../../noctalia/colorschemes", `${homedir()}/.config/noctalia/colorschemes`);

}
async function vscode_special(){
    log_message("Scraping extensions from vscode");
    const extensions_file = Bun.file("../../vscode/extensions.txt");
    const proc_get_extensions = Bun.spawnSync(["code", "--list-extensions"]);
    extensions_file.write(proc_get_extensions.stdout.toString());
}

let push_info = [
  {command: "starship",  to: "../../starship.toml",           from: `${homedir()}/.config/starship.toml`},
  {command: "bluetuith", to: "../../bluetuith",               from: `${homedir()}/.config/bluetuith`},
  {command: "fuzzel",    to: "../../fuzzel",                  from: `${homedir()}/.config/fuzzel`},
  {command: "qt6ct",     to: "../../qt6ct",                   from: `${homedir()}/.config/qt6ct`},
  {command: "kitty",     to: "../../kitty",                   from: `${homedir()}/.config/kitty`},
  {command: "btop",      to: "../../btop",                    from: `${homedir()}/.config/btop`},
  {command: "hyprland",  to: "../../hypr",                    from: `${homedir()}/.config/hypr`, special: hyprland_special},
  {command: "nvim",      to: "../../nvim",                    from: `${homedir()}/.config/nvim`},
  {command: "tmux",      to: "../../tmux",                    from: `${homedir()}/.config/tmux`},
  {command: "tmux",      to: "../../tmux/.tmux.conf",         from: `${homedir()}/.tmux.conf`},
  {command: "yazi",      to: "../../yazi",                    from: `${homedir()}/.config/yazi`},
  {command: "zsh",       to: "../../zsh",                     from: `${homedir()}/.config/zsh`},
  {command: "zsh",       to: "../../zsh/.zshenv",             from: `${homedir()}/.zshenv`},
  {command: "gdu",       to: "../../gdu/.gdu.yaml",           from: `${homedir()}/.gdu.yaml`},
  {command: "code",    to: "../../vscode/keybindings.json", from: `${homedir()}/.config/Code/User/keybindings.json`},
  {command: "code",    to: "../../vscode/settings.json",    from: `${homedir()}/.config/Code/User/settings.json`, special: vscode_special},
];
for (const info of push_info){
    if (!command_exists(info.command)) continue;
    await pull_config(info.to, info.from);
    if (info.special) info.special();
}
