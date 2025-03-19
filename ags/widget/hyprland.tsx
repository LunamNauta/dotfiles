import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable, bind } from "astal"
import Hyprland from "gi://AstalHyprland"

const hypr = Hyprland.get_default()
const dispatch = (ws: string) => hypr.message(`dispatch workspace ${ws}`)

const workspace_names = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
function get_grouped_workspaces(occupied_workspaces){
    let out: {is_occupied: boolean, workspaces: string[]}[] = []
    for (const workspace of workspace_names){
        const is_occupied = occupied_workspaces.some(occ_workspace => occ_workspace.name == workspace)
        if (out.length != 0 && out.at(-1).is_occupied == is_occupied){
            out.at(-1).workspaces.push(workspace)
            continue
        }
        out.push({is_occupied: is_occupied, workspaces: [workspace]})
    }

    return out
}

const Workspaces = () => {
    return <box className={'workspaces'}>
        {bind(hypr, 'workspaces').as((workspaces) => {
            return <box>
                {get_grouped_workspaces(workspaces).map(workspace_group => {
                    const workspace_class = `workspace ${workspace_group.is_occupied ? 'occupied' : 'empty'}`
                    return <eventbox className={workspace_class} onScroll={(_, event) => {
                            if (hypr.get_focused_workspace().id < 10 && event.delta_y > 0) dispatch('+1')
                            if (hypr.get_focused_workspace().id > 0 && event.delta_y < 0) dispatch('-1')
                        }}>
                        <box>
                            {workspace_group.workspaces.map(workspace => {
                                if (!workspace_group.is_occupied){
                                    return <button
                                                className={'workspace button'} valign={Gtk.Align.CENTER}
                                                onClick={() => dispatch(workspace)}
                                            >
                                        {workspace}
                                    </button>
                                }
                                return <button
                                            className={bind(hypr.get_workspace_by_name(workspace)?.monitor, 'activeWorkspace').as(active_workspace => active_workspace.name == workspace ? 'workspace active' : 'workspace button')} valign={Gtk.Align.CENTER}
                                            onClick={() => dispatch(workspace)}
                                        >
                                    {workspace}
                                </button>
                            })}
                        </box>
                    </eventbox>
                })}
            </box>
        })}
    </box>
}

export{
    Workspaces
}
