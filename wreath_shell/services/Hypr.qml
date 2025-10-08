pragma Singleton

import qs.config

import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandToplevel active_toplevel: Hyprland.activeToplevel?.wayland?.activated ? Hyprland.activeToplevel : null
    readonly property HyprlandWorkspace focused_workspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focused_monitor: Hyprland.focusedMonitor
    readonly property int active_ws_id: focused_workspace?.id ?? 1

    signal configReloaded

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor{
        return Hyprland.monitorFor(screen);
    }

    Connections{
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void{
            const name = event.name;
            if (name.endsWith("v2")) return;
            if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(name)){
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            }
            else if (["openwindow", "closewindow", "movewindow"].includes(name)){
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            }
            else if (name.includes("mon")) Hyprland.refreshMonitors();
            else if (name.includes("workspace")) Hyprland.refreshWorkspaces();
            else if (name.includes("window") || name.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(name)) Hyprland.refreshToplevels();
        }
    }
}
