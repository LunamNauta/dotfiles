pragma ComponentBehavior: Bound

import qs.components
import qs.config
import qs.utils

import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    readonly property real nonAnimHeight: state === "visible" ? (content.item?.nonAnimHeight ?? 0) : 0

    visible: height > 0
    implicitHeight: 0
    implicitWidth: content.implicitWidth

    onStateChanged: {
        if (state === "visible" && timer.running) {
            timer.triggered();
            timer.stop();
        }
    }

    states: State {
        name: "visible"
        when: root.visibilities.dashboard

        PropertyChanges {
            root.implicitHeight: content.implicitHeight
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            Anim {
                target: root
                property: "implicitHeight"
                duration: Config.appearance.anim.durations.expressive_default_spatial
                easing.bezierCurve: Config.appearance.anim.curves.expressive_default_spatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            Anim {
                target: root
                property: "implicitHeight"
                easing.bezierCurve: Config.appearance.anim.curves.emphasized
            }
        }
    ]

    Timer {
        id: timer

        running: true
        interval: Config.appearance.anim.durations.extra_large
        onTriggered: {
            content.active = Qt.binding(() => root.visibilities.dashboard || root.visible);
            content.visible = true;
        }
    }

    Loader {
        id: content

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        visible: false
        active: true

        sourceComponent: Content {
            visibilities: root.visibilities
        }
    }
}
