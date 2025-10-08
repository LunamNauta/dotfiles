import Quickshell.Io

JsonObject{
    property bool enabled: true
    property DesktopClock desktop_clock: DesktopClock{}

    component DesktopClock: JsonObject{
        property bool enabled: true
    }
}
