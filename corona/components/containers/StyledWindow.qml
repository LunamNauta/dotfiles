import Quickshell
import Quickshell.Wayland

PanelWindow{
    required property string name

    WlrLayershell.namespace: `corona-${name}`
    color: "transparent"
}
