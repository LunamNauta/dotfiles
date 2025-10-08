pragma ComponentBehavior: Bound

import qs.components
import qs.config

import Quickshell
import QtQuick

Item{
    id: root

    readonly property real non_anim_width: content.implicitWidth
    required property PersistentProperties visibilities
    required property var panels

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State{
        name: "visible"
        when: root.visibilities.session

        PropertyChanges{
            root.implicitWidth: root.non_anim_width
        }
    }

    transitions: [
        Transition{
            from: ""
            to: "visible"

            Anim{
                target: root
                property: "implicitWidth"
                easing.bezierCurve: Config.appearance.anim.curves.expressive_default_spatial
            }
        },
        Transition{
            from: "visible"
            to: ""

            Anim{
                target: root
                property: "implicitWidth"
                easing.bezierCurve: Config.appearance.anim.curves.emphasized
            }
        }
    ]

    Loader{
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Component.onCompleted: active = Qt.binding(() => root.visibilities.session || root.visible)

        sourceComponent: Content{
            visibilities: root.visibilities
        }
    }
}
