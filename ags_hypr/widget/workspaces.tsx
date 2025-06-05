import { Gtk } from "astal/gtk3"
import { hypr_ctx } from "./types";
import { bind } from "astal";
import { App } from "astal/gtk3";
import Bar from "./Bar";

const Workspaces_Widget = () => <box className={'workspaces'}>
    {hypr_ctx.curr_workspaces.as(workspace_groups => {
        return workspace_groups.map(workspace_group => {
            return <eventbox className={'workspace group'} onScroll={(_, event) => hypr_ctx.scroll_workspace(event.delta_y)}>
                <box>
                    {workspace_group.workspaces.map(workspace => {
                        const workspace_class2 = hypr_ctx.curr_workspace.as(focused => `workspace ${focused.id == workspace.id ? 'focused' : (workspace_group.is_occupied ? 'occupied' : 'button')}`)
                        return <button className={workspace_class2} valign={Gtk.Align.CENTER} onClick={() => hypr_ctx.set_workspace(workspace.id)}>
                            {bind(hypr_ctx.curr_workspace).as(focused => focused.id == workspace.id ? '' : (workspace_group.is_occupied ? '' : ''))}
                        </button>
                    })}
                </box>
            </eventbox>
        });
    })}
</box>

export{
    Workspaces_Widget
};
