/*
import { Widget } from "astal/gtk4";
import { globals } from "./Globals";
import { bind } from "astal";

function Workspaces_Widget(){
    return Widget.Box(
        { 
            cssClasses: ['workspaces'],
            onScroll: (_1, _2, dy) => globals.hypr.scroll_workspace(dy)
        },
        globals.hypr.curr_workspaces.as(workspaces => globals.hypr.processed_workspaces(workspaces).map(workspace => {
            //console.log(workspace.id + ", " + (workspace.is_occupied || workspace.is_focused));
            if (workspace.is_focused) console.log(workspace.id);
            const workspace_class = ['workspace', workspace.is_focused ? 'focused' : (workspace.is_occupied ? 'occupied' : 'button')];
            const workspace_icon = (workspace.is_focused || workspace.is_occupied) ? '' : '';
            return Widget.Button(
                {
                    cssClasses: workspace_class,
                    label: workspace_icon,
                    onClicked: () => globals.hypr.set_workspace(workspace.id)
                }
            );
        }))
    )
}

export { Workspaces_Widget };
*/

import { Gtk } from "astal/gtk4"
import { globals } from "./Globals";
import { bind, Variable } from "astal";
import { Widget } from "astal/gtk4";

function Workspaces_Widget(){
    return Widget.Box(
        { cssClasses: ['workspaces'], onScroll: (_1, _2, dy) => globals.hypr.scroll_workspace(dy) },
        [1,2,3,4,5,6,7,8,9,10].map(workspace_id => {
            const workspace_class = Variable.derive(
                [bind(globals.hypr.hypr, 'focused_workspace'), bind(globals.hypr.hypr, 'clients')],
                (focused, _) => {
                    if (focused.id == workspace_id) return ['workspace', 'focused'];
                    else if (globals.hypr.hypr.get_workspace(workspace_id)?.get_clients.length > 0) return ['workspace', 'occupied'];
                    return ['workspace', 'button']
                }
            );
            const workspace_symbol = Variable.derive(
                [bind(globals.hypr.hypr, 'focused_workspace'), bind(globals.hypr.hypr, 'clients')],
                (focused, _) => {
			        const active = focused.id == workspace_id;
			        const occupied = globals.hypr.hypr.get_workspace(workspace_id)?.get_clients().length > 0;
                    return (active || occupied) ? '' : '';

                }
            );
            return Widget.Button({
                cssClasses: workspace_class(),
                valign: Gtk.Align.CENTER,
                onClicked: () => globals.hypr.set_workspace(workspace_id),
                onDestroy: () => {
                    workspace_class.drop();
                    workspace_symbol.drop();
                },
                label: workspace_symbol()
            });
        })
    );
}

/*
const Workspaces_Widget = () => 
     <box>
                <box cssClasses={['workspace group']} onScroll={(_1, _2, dy) => globals.hypr.scroll_workspace(dy)} >
                    {[1,2,3,4,5,6,7,8,9,10].map(workspace_id => {
                        const classNames = Variable.derive(
		                    [bind(globals.hypr.hypr, "focusedWorkspace"), bind(globals.hypr.hypr, "clients")],
		                    (fws, _) => {
			                    const classes = ["workspace-button"];

			                    const active = fws.id == workspace_id;
			                    active && classes.push("active");

			                    const occupied = globals.hypr.hypr.get_workspace(workspace_id)?.get_clients().length > 0;
			                    occupied && classes.push("occupied");
			                    return classes;
		                    },
	                    );
                        const symbol = Variable.derive(
                            [bind(globals.hypr.hypr, "focusedWorkspace"), bind(globals.hypr.hypr, "clients")],
		                    (fws, _) => {
			                    const classes = ["workspace-button"];
			                    const active = fws.id == workspace_id;
			                    const occupied = globals.hypr.hypr.get_workspace(workspace_id)?.get_clients().length > 0;
                                return (active || occupied) ? '' : '';
		                    },
                        )

                        return <button 
                            cssClasses={classNames} 
                            valign={Gtk.Align.CENTER}
                            onClicked={() => globals.hypr.set_workspace(workspace_id)}
                            onDestroy={() => {
                                classNames.drop();
                                symbol.drop();
                            }}
                            label={symbol()}
                        >
                        </button>
                    })}
                </box>
            </box>
*/


//{bind(globals.hypr.curr_workspace).as(focused => focused.id == workspace.id ? '' : (workspace_group.is_occupied ? '' : ''))}

export { Workspaces_Widget };

/*

function WorkspaceButton({ ws, ...props }: WsButtonProps) {
	const hyprland = AstalHyprland.get_default();
	const classNames = Variable.derive(
		[bind(hyprland, "focusedWorkspace"), bind(hyprland, "clients")],
		(fws, _) => {
			const classes = ["workspace-button"];

			const active = fws.id == ws.id;
			active && classes.push("active");

			const occupied = hyprland.get_workspace(ws.id)?.get_clients().length > 0;
			occupied && classes.push("occupied");
			return classes;
		},
	);

	return (
		<button
			cssClasses={classNames()}
			onDestroy={() => classNames.drop()}
			valign={Gtk.Align.CENTER}
			halign={Gtk.Align.CENTER}
			onClicked={() => ws.focus()}
			{...props}
		/>
	);
}
*/

/*
function Workspaces_Widget(){
    return Widget.Box(
    );
}
*/
//
