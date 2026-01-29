import { command_exists, log_message, pull_config } from "./utils";
import { homedir, hostname } from "node:os";

async function vscodium_special(){
    log_message("Scraping extensions from vscodium");
    const extensions_file = Bun.file("../../codium/extensions.txt");
    const proc_get_extensions = Bun.spawnSync(["codium", "--list-extensions"]);
    extensions_file.write(proc_get_extensions.stdout.toString());
}

let push_info = [
  {command: "starship",  to: "../../starship.toml",           from: `${homedir()}/.config/starship.toml`},
  {command: "bluetuith", to: "../../bluetuith",               from: `${homedir()}/.config/bluetuith`},
  {command: "fuzzel",    to: "../../fuzzel",                  from: `${homedir()}/.config/fuzzel`},
  {command: "qt6ct",     to: "../../qt6ct",                   from: `${homedir()}/.config/qt6ct`},
  {command: "kitty",     to: "../../kitty",                   from: `${homedir()}/.config/kitty`},
  {command: "btop",      to: "../../btop",                    from: `${homedir()}/.config/btop`},
  {command: "hyprland",  to: "../../hypr",                    from: `${homedir()}/.config/hypr`},
  {command: "nvim",      to: "../../nvim",                    from: `${homedir()}/.config/nvim`},
  {command: "tmux",      to: "../../tmux",                    from: `${homedir()}/.config/tmux`},
  {command: "tmux",      to: "../../tmux/.tmux.conf",         from: `${homedir()}/.tmux.conf`},
  {command: "yazi",      to: "../../yazi",                    from: `${homedir()}/.config/yazi`},
  {command: "zsh",       to: "../../zsh",                     from: `${homedir()}/.config/zsh`},
  {command: "zsh",       to: "../../zsh/.zshenv",             from: `${homedir()}/.zshenv`},
  {command: "gdu",       to: "../../gdu/.gdu.yaml",           from: `${homedir()}/.gdu.yaml`},
  {command: "codium",    to: "../../codium/keybindings.json", from: `${homedir()}/.config/VSCodium/User/keybindings.json`},
  {command: "codium",    to: "../../codium/settings.json",    from: `${homedir()}/.config/VSCodium/User/settings.json`, special: vscodium_special},
];
for (const info of push_info){
    if (!command_exists(info.command)) continue;
    await pull_config(info.to, info.from);
    if (info.special) info.special();
}