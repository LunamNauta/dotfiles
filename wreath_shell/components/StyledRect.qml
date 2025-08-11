import Quickshell
import QtQuick

import qs.config

Rectangle {
    id: root

    color: "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Config.appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.appearance.anim.curves.standard
        }
    }
}
