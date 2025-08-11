import Quickshell.Io
import Quickshell
import QtQuick

JsonObject {
    property bool enabled: true
    property DesktopClock desktop_clock: DesktopClock {}

    component DesktopClock: JsonObject {
        property bool enabled: true
    }
}
