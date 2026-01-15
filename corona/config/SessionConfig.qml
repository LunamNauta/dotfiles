import Quickshell.Io

JsonObject{
    property bool enabled: true
    property Commands commands: Commands{}

    property Sizes sizes: Sizes{}

    component Commands: JsonObject{
        property list<string> shutdown: ["systemctl", "poweroff"]
        property list<string> suspend: ["systemctl", "suspend-then-hibernate"]
        property list<string> reboot: ["systemctl", "reboot"]
    }

    component Sizes: JsonObject{
        property int button: 65
    }
}
