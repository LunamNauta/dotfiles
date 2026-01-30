import { command_exists, log_message, push_config, edit_config } from "./utils";
import { homedir, hostname } from "node:os";

async function hyprland_special(){
    switch (hostname()){
        case "asgard":{
            await edit_config(`${homedir()}/.config/hypr/hyprland.conf`, "MONITOR DATA", ["monitor = , 1920x1080@120, auto, 1"]);
            await edit_config(`${homedir()}/.config/hypr/hyprland.conf`, "GAPS", ["gaps_in = 0,0,0,0", "gaps_out = 4,4,4,29"]);
            await edit_config(`${homedir()}/.config/hypr/hyprland.conf`, "ROUNDING", ["rounding = 14"]);
            break;
        }
        case "midgard":{
            await edit_config(`${homedir()}/.config/hypr/hyprland.conf`, "MONITOR DATA", ["monitor = , 1920x1080@60, auto, 1.20"]);
            await edit_config(`${homedir()}/.config/hypr/hyprland.conf`, "GAPS", ["gaps_in = 0,0,0,0", "gaps_out = 2,2,2,36"]);
            await edit_config(`${homedir()}/.config/hypr/hyprland.conf`, "ROUNDING", ["rounding = 14"]);
            break;
        }
    }
    Bun.spawnSync(["hyprctl", "reload"]);
    Bun.spawnSync(["sh", `${homedir()}/.config/hypr/scripts/border_when_alone.zsh`]);
}
async function yazi_special(){
    log_message("Installing yazi plugins");
    Bun.spawnSync(["rm", "-rf", `${homedir()}/.config/yazi/package.toml`]);
    Bun.spawnSync(["rm", "-rf", `${homedir()}/.config/yazi/plugins`]);
    Bun.spawnSync(["ya", "pkg", "add", "yazi-rs/plugins:full-border"]);
    Bun.spawnSync(["ya", "pkg", "add", "yazi-rs/plugins:mount"]);
    Bun.spawnSync(["ya", "pkg", "add", "yazi-rs/plugins:smart-enter"]);
    Bun.spawnSync(["ya", "pkg", "add", "dedukun/bookmarks"]);
}

let push_info = [
  {command: "starship",  from: "../../starship.toml",           to: `${homedir()}/.config/starship.toml`},
  {command: "bluetuith", from: "../../bluetuith",               to: `${homedir()}/.config/bluetuith`},
  {command: "fuzzel",    from: "../../fuzzel",                  to: `${homedir()}/.config/fuzzel`},
  {command: "qt6ct",     from: "../../qt6ct",                   to: `${homedir()}/.config/qt6ct`},
  {command: "kitty",     from: "../../kitty",                   to: `${homedir()}/.config/kitty`},
  {command: "btop",      from: "../../btop",                    to: `${homedir()}/.config/btop`},
  {command: "hyprland",  from: "../../hypr",                    to: `${homedir()}/.config/hypr`, special: hyprland_special},
  {command: "nvim",      from: "../../nvim",                    to: `${homedir()}/.config/nvim`},
  {command: "tmux",      from: "../../tmux",                    to: `${homedir()}/.config/tmux`},
  {command: "tmux",      from: "../../tmux/.tmux.conf",         to: `${homedir()}/.tmux.conf`},
  {command: "yazi",      from: "../../yazi",                    to: `${homedir()}/.config/yazi`, special: yazi_special},
  {command: "zsh",       from: "../../zsh",                     to: `${homedir()}/.config/zsh`},
  {command: "zsh",       from: "../../zsh/.zshenv",             to: `${homedir()}/.zshenv`},
  {command: "gdu",       from: "../../gdu/.gdu.yaml",           to: `${homedir()}/.gdu.yaml`}
];
for (const info of push_info){
    if (!command_exists(info.command)) continue;
    await push_config(info.from, info.to);
    if (info.special) info.special();
}
