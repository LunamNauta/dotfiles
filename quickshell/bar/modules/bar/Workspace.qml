import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
    id: workspace

    required property int name

 	readonly property var switch_to_proc: Process {
		command: ["bash", "-c", "hyprctl dispatch workspace " + name]
	}

	function switch_to() {
		switch_to_proc.startDetached();
    }

    function is_occupied() {
        for (var a = 0; a < Hyprland.workspaces.values.length; a++){
            if (Hyprland.workspaces.values[a].id === name){
                return Hyprland.workspaces.values[a].toplevels.length != 0
            }
        }
        return false
    }
    function is_active() {
        if (Hyprland.focusedWorkspace != null){
            return Hyprland.focusedWorkspace.id === name
        }
        return false
    }
}
