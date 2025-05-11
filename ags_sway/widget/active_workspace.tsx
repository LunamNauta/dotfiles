import { bind, execAsync, Variable } from "astal"

const ACTIVE_WORKSPACE_MAX_LEN = 50;

function get_active_workspace(window_data_str: string){
    const window_data_json = JSON.parse(window_data_str);
    if (window_data_json['change'] == undefined) return '';
    if (window_data_json['change'] != 'focus' && window_data_json['change'] != 'title') return '';
    const name: string = window_data_json['container']['name'];
    if (name.length > ACTIVE_WORKSPACE_MAX_LEN) return name.substring(0, ACTIVE_WORKSPACE_MAX_LEN-3) + "...";
    return name;
}

const window_data = Variable('');
const disable_name = Variable(false);
async function update_window_data(){
    const str = await execAsync("swaymsg -t subscribe '[ \"window\" ]'");
    window_data.set(get_active_workspace(str));
    disable_name.set(false);
    update_window_data();
}
async function update_window_data_workspace(){
    disable_name.set(true);
    const str = await execAsync("swaymsg -t subscribe '[ \"workspace\" ]'");
    if (disable_name.get()) window_data.set('');
    update_window_data_workspace();
}
update_window_data_workspace();
update_window_data();

const Active_Workspace_Widget = () =>
<box className={'active-workspace'}>
    <label label={bind(window_data).as((str) => str)} />
</box>

export{
    Active_Workspace_Widget
}
