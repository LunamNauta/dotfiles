import qs.config
import Quickshell.Widgets
import QtQuick

ClippingRectangle {
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
