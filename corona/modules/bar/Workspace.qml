import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Item {
    id: root

    required property int workspace_id

 	readonly property var switch_to_proc: Process {
		command: ["bash", "-c", "hyprctl dispatch workspace " + workspace_id]
	}
	function switch_to() {
		switch_to_proc.startDetached();
    }

    function is_occupied() {
        for (var a = 0; a < Hyprland.workspaces.values.length; a++){
            if (Hyprland.workspaces.values[a].id === workspace_id){
                return Hyprland.workspaces.values[a].toplevels.length != 0
            }
        }
        return false
    }
    function is_active() {
        if (Hyprland.focusedWorkspace != null){
            return Hyprland.focusedWorkspace.id === workspace_id
        }
        return false
    }
}
