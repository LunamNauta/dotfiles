import { readdir } from "node:fs/promises";
import path from "node:path";

const reset: string = "\x1b[0m";
const blue: string = "\x1b[34m"
const bold: string = "\x1b[1m";

const sudo_interactive_props: Bun.SpawnOptions.SpawnOptions<"inherit", "inherit", "inherit"> = {
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit"
};

function log_message(msg: string){
    console.log(`${blue}${bold}[INFO] ${msg}${reset}`);
}

function command_exists(command: string){
    command = command.replace(/\p{White_Space}+/gu, "");
    return Bun.spawnSync(["sh", "-c", "command -v " + command]).exitCode == 0;
}

async function wipe_configmgr_edits(path: string){
    const file = Bun.file(path);
    const stat = await file.stat();
    if (!Boolean(stat.mode & 0o200)) return;
    if (stat.isDirectory()){
        const files = await readdir(path, { recursive: true, withFileTypes: true });
        for (let a = 0; a < files.length; a++){
            if (files[a]?.isDirectory()) continue;
            const new_path = files[a]?.parentPath + "/" + files[a]?.name;
            await wipe_configmgr_edits(new_path);
        }
        return;
    }

    const text = await Bun.file(path).text();
    const lines = text.split("\n");

    const result: string[] = [];
    let in_section = false;

    for (const line of lines){
        if (line.includes("CONFIGMGR:")){
            if (in_section){
                result.push(line);
                in_section = false;
            }
            else{
                result.push(line);
                in_section = true;
            }
        }
        else if (!in_section) result.push(line);
    }

    await Bun.write(path, result.join("\n"));
}

async function push_config(config_path: string, to_path: string){
    log_message(`Pushing config ${path.basename(config_path)} to ${to_path}`);
    await Bun.spawn(["mkdir", "-p", path.dirname(to_path)]).exited;
    if (await Bun.file(to_path).exists) Bun.spawnSync(["rm", "-rf", to_path]);
    await Bun.spawn(["cp", "-r", config_path, to_path]).exited;
}

async function pull_config(config_path: string, to_path: string){
    log_message(`Pulling config ${path.basename(to_path)} from ${config_path}`);
    if (await Bun.file(config_path).exists) Bun.spawnSync(["rm", "-rf", config_path]);
    await Bun.spawn(["cp", "-r", to_path, config_path]).exited;
    await wipe_configmgr_edits(config_path);
}

async function edit_config(config_path: string, header: string, newlines: string[]){
    const replacement = newlines.join("\n").trim();

    const text = await Bun.file(config_path).text();
    const lines = text.split("\n");

    const start = lines.findIndex(line => line.includes("CONFIGMGR: " + header));
    if (start == -1) return;
    let end = start + 1;
    for (; end < lines.length && !lines[end]?.includes("CONFIGMGR:"); end++);

    const result = [
        ...lines.slice(0, start + 1),
        replacement,
        ...lines.slice(end),
    ];

    await Bun.write(config_path, result.join("\n"));
}

export {
    sudo_interactive_props,
    log_message,
    command_exists,
    push_config,
    pull_config,
    edit_config,
    wipe_configmgr_edits
}