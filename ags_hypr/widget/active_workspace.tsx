import { bind, Variable } from "astal"
import Hyprland from "gi://AstalHyprland"

const hypr = Hyprland.get_default()
const current_client = bind(hypr, 'focused_client')
const client_name = current_client.as(client => client == null ? '' : client.class)

const Active_Workspace_Widget = () =>
<box className={'active-workspace'}>
    <label label={client_name} />
</box>

export{
    Active_Workspace_Widget
}
