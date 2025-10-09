import ".."
import QtQuick
import QtQuick.Effects

MultiEffect{
    property color source_color: "black"

    colorization: 1
    brightness: 1 - source_color.hslLightness

    Behavior on colorizationColor{
        CAnim{}
    }
}
