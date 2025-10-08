import Quickshell.Io

JsonObject{
    property bool enabled: true
    property Commands commands: Commands{}

    property Sizes sizes: Sizes{}

    component Commands: JsonObject{
        property list<string> logout: ["uwsm", "stop"]
        property list<string> shutdown: ["systemctl", "poweroff"]
        property list<string> hibernate: ["systemctl", "hibernate"]
        property list<string> reboot: ["systemctl", "reboot"]
    }

    component Sizes: JsonObject{
        property int button: 65
    }
}
