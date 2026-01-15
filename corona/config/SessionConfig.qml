import Quickshell.Io

JsonObject{
    property bool enabled: true
    property Commands commands: Commands{}

    property Sizes sizes: Sizes{}

    component Commands: JsonObject{
        property list<string> logout: ["hyprctl", "dispatch exit"]
        property list<string> shutdown: ["systemctl", "poweroff"]
        property list<string> suspend: ["systemctl", "suspend"]
        property list<string> reboot: ["systemctl", "reboot"]
    }

    component Sizes: JsonObject{
        property int button: 65
    }
}
