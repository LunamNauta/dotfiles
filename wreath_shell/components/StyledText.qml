pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import qs.services
import qs.config

Text {
    id: root

    property bool animate: false
    property string animate_prop: "scale"
    property real animate_from: 0
    property real animate_to: 1
    property int animate_duration: Config.appearance.anim.durations.normal

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Colors.palette.m3onSurface
    font.family: Config.appearance.font.family.sans
    font.pointSize: Config.appearance.font.size.smaller

    Behavior on color {
        ColorAnimation {
            duration: Config.appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.appearance.anim.curves.standard
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animate_from
                easing.bezierCurve: Config.appearance.anim.curves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animate_to
                easing.bezierCurve: Config.appearance.anim.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animate_prop
        duration: root.animate_duration / 2
        easing.type: Easing.BezierSpline
    }
}
