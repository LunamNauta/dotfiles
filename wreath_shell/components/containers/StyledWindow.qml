import Quickshell.Wayland
import Quickshell

PanelWindow {
    required property string name

    WlrLayershell.namespace: `wreath-${name}`
    color: "transparent"
}
