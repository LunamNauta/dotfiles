pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Widgets

IconImage{
    id: root

    required property color color

    asynchronous: true

    layer.enabled: true
    layer.effect: Colorizer{
        source_color: "#b4befe" //analyser.dominantColour
        colorizationColor: root.color
    }
}
