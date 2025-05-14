import Gtk from "gi://Gtk?version=3.0";
import { hypr_ctx, utilities_ctx } from "./types"

const Active_Workspace_Widget = () =>
<box className={'active-workspace'} orientation={Gtk.Orientation.VERTICAL}>
    <label label={hypr_ctx.curr_client.as(client => client == null ? '' : utilities_ctx.string_max(client.class, 50))} halign={Gtk.Align.START} />
    <label label={hypr_ctx.curr_client.as(client => client == null ? '' : utilities_ctx.string_max(client.title, 50))} halign={Gtk.Align.START} />
</box>

export{
    Active_Workspace_Widget
};
