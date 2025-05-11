import { execAsync, Variable } from "astal";

const sway_data = {
    occupied_workspaces: [true, false, false, false, false, false, false, false, false],
    active_workspace: 0,
    active_window_name: Variable(''),
};

const ACTIVE_WORKSPACE_MAX_LEN = 50;

const disable_name = Variable(false);
async function update_from_workspace_subscription(){
    disable_name.set(true);
    const workspace_data_str = await execAsync("swaymsg -t subscribe '[ \"workspace\" ]'");
    if (disable_name.get()) sway_data.active_window_name.set('');
    const workspace_data_json = JSON.parse(workspace_data_str);
    if (workspace_data_json['change'] != 'init' && workspace_data_json['change'] != 'focus') return;
    sway_data.occupied_workspaces[workspace_data_json['current']['num']] = true;
    sway_data.active_workspace = workspace_data_json['current']['num'];
    if (workspace_data_json['change'] == 'focus') sway_data.occupied_workspaces[workspace_data_json['old']['num']] = false;
    update_from_workspace_subscription()
}

async function update_from_window_subscription(){
    const window_data_str = await execAsync("swaymsg -t subscribe '[ \"window\" ]'");
    const window_data_json = JSON.parse(window_data_str);
    if (window_data_json['change'] != 'focus' && window_data_json['change'] != 'title') return;
    const window_name = window_data_json['container']['name'];
    if (window_name.length > ACTIVE_WORKSPACE_MAX_LEN) return window_name.substring(0, ACTIVE_WORKSPACE_MAX_LEN-3) + "...";
    sway_data.active_window_name.set(window_name);
    disable_name.set(false);
    console.log(sway_data.active_window_name);
    update_from_window_subscription()
}

function get_active_window_name(){
    return sway_data.active_window_name;
}

export{
    sway_data,
    update_from_workspace_subscription,
    update_from_window_subscription,
    get_active_window_name
};
