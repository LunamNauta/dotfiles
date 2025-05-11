import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable, bind, exec, execAsync } from "astal"

const workspace_names = [1, 2, 3, 4, 5, 6, 7, 8, 9]

const last_active_workspace = Variable(0);
const occupied_workspaces = Variable({foc: 0, occ: [true, false, false, false, false, false, false, false, false]});

function set_workspace(ws){
    if (ws < 1) ws = 1;
    else if (ws > 9) ws = 9;
    last_active_workspace.set(ws);
    exec('swaymsg workspace ' + ws);
}
function shift_workspace(delta){
    let ws = last_active_workspace.get() + delta;
    set_workspace(ws);
}
function get_grouped_workspaces(occupied_workspaces){
    let out: {is_occupied: boolean, workspaces: int[]}[] = []
    for (const workspace of workspace_names){
        const is_occupied = occupied_workspaces[workspace-1];
        if (out.length != 0 && out.at(-1).is_occupied == is_occupied){
            out.at(-1).workspaces.push(workspace)
            continue
        }
        out.push({is_occupied: is_occupied, workspaces: [workspace]})
    }

    return out
}
function get_workspaces(){
    let out = []
    for (const name of workspace_names) out.push({name: name, is_occupied: false});
    out[last_active_workspace.get()] = {name: last_active_workspace.get() + 1, is_occupied: true};
    return out
}
function set_active_workspace(data){
    if (data['change'] != 'focus' && data['change'] != 'init') return;
    const new_num = data['current']['num'] - 1;
    workspaces.set(get_workspaces());
}
async function update_active_workspace(){
    const str = await execAsync("swaymsg -t subscribe '[ \"workspace\" ]'");
    const data = JSON.parse(str);
    set_active_workspace(data);
    update_occupied_workspace();
    update_active_workspace();
}
update_active_workspace();

async function update_occupied_workspace2(){
    const str = await execAsync("swaymsg -t subscribe '[ \"window\" ]'");
    const json = JSON.parse(str);
    if (json['change'] == 'new') update_active_workspace();
    update_occupied_workspace2();
}
async function update_occupied_workspace(){
    const str = await execAsync("swaymsg -t get_workspaces");
    const json = JSON.parse(str);
    let occupied_workspaces_arr = [false, false, false, false, false, false, false, false, false];
    let focused = 0;
    for (const occ of json){
        if (occ.focused) focused = occ.num - 1;
        occupied_workspaces_arr[occ.num - 1] = true;
    }
    occupied_workspaces.set({foc: focused, occ: occupied_workspaces_arr});
}
update_occupied_workspace2();

const workspaces = Variable(get_workspaces());

const focused_workspace = bind(last_active_workspace);
const Workspaces = () => {
    return <box className={'workspaces'}>
        {bind(occupied_workspaces).as((occupied_workspaces) => {
            return <box>
                {get_grouped_workspaces(occupied_workspaces.occ).map(workspace_group => {
                const workspace_class = workspace_group.is_occupied ? 'workspace occupied' : 'empty'
                return <eventbox className={workspace_class} onScroll={(_, event) => {
                            if (event.delta_y > 0) shift_workspace(1)
                            if (event.delta_y < 0) shift_workspace(-1)
                        }}>
                        <box>
                            {workspace_group.workspaces.map(workspace => {
                                return <button
                                            className={occupied_workspaces.foc+1 == workspace ? 'workspace active' : 'workspace button'}
                                            valign={Gtk.Align.CENTER}
                                            onClick={() => set_workspace(workspace)}
                                        >
                                            {occupied_workspaces.foc+1 == workspace ? '•' : workspace}
                                        </button>
                            })}
                        </box>
                        </eventbox>
                })}
            </box>
        })}
    </box>
}

/*
const Workspaces = () => {
    return <box className={'workspaces'}>
        {bind(workspaces).as((workspaces_data) => {
            return <box>
                {workspaces_data.map(workspace => {
                    const workspace_class = `workspace ${workspace.is_occupied ? 'occupied' : 'empty'}`
                    const workspace_name = workspace.is_occupied ? '•' : workspace.name.toString();
                    return <eventbox className={workspace_class} onScroll={(_, event) => {
                            if (event.delta_y > 0) shift_workspace(1)
                            if (event.delta_y < 0) shift_workspace(-1)
                        }}>
                        <button 
                            className={workspace.is_occupied ? 'workspace active' : 'workspace button'}
                            onClick={() => set_workspace(workspace.name)}
                        >
                            <label label={workspace_name}> </label>
                        </button>
                    </eventbox>
                })}
            </box>
        })}
    </box>
}
*/

export{
    Workspaces
}
