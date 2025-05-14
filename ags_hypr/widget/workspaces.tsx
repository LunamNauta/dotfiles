import { Gtk } from "astal/gtk3"
import { hypr_ctx } from "./types";

const Workspaces_Widget = () => <box className={'workspaces'}>
    {hypr_ctx.curr_workspaces.as(workspace_groups => {
        return workspace_groups.map(workspace_group => {
            const workspace_class1 = `workspace ${workspace_group.is_occupied ? 'occupied' : 'empty'}`;
            return <eventbox className={workspace_class1} onScroll={(_, event) => hypr_ctx.scroll_workspace(event.delta_y)}>
                <box>
                    {workspace_group.workspaces.map(workspace => {
                        const workspace_class2 = hypr_ctx.curr_workspace.as(focused => `workspace ${focused.id == workspace.id ? 'focused' : 'button'}`)
                        return <button className={workspace_class2} valign={Gtk.Align.CENTER} onClick={() => hypr_ctx.set_workspace(workspace.id)}>
                            {hypr_ctx.curr_workspace.as(focused => focused.id == workspace.id ? '•' : workspace.id.toString())}
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
