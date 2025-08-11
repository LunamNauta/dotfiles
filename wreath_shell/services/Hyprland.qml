pragma Singleton

import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    readonly property HyprlandToplevel active_top_level: Hyprland.activeToplevel
    readonly property HyprlandWorkspace focused_workspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focused_monitor: Hyprland.focusedMonitor
    readonly property int active_ws_id: focused_workspace?.id ?? 1
    property string kb_layout: "?"
    property bool valid_top_level: active_top_level != null ? active_top_level.workspace.id == active_ws_id : false // When changing to a workspace that does not aleady exist, Hyprland keeps the old toplevel, despite the fact that toplevel should now be null

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (n.endsWith("v2")) return;

            if (n === "activelayout") root.kb_layout = event.parse(2)[1].slice(0, 2).toLowerCase();
            else if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(n)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            } 
            else if (["openwindow", "closewindow", "movewindow"].includes(n)) {
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            } 
            else if (n.includes("mon")) Hyprland.refreshMonitors();
            else if (n.includes("workspace")) Hyprland.refreshWorkspaces();
            else if (n.includes("window") || n.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(n)) Hyprland.refreshToplevels();
        }
    }

    Process {
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: root.kb_layout = JSON.parse(text).keyboards.find(k => k.main).active_keymap.slice(0, 2).toLowerCase()
        }
    }
}
