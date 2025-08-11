pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import qs.utils

import QtQuick

Item {
    id: root

    property color color: Colors.palette.m3onBackground
    readonly property Item child: child

    implicitWidth: child.implicitWidth
    implicitHeight: child.implicitHeight

    Item {
        id: child

        property Item current: text1

        anchors.centerIn: parent

        //clip: true
        //implicitWidth: icon.implicitWidth
        implicitWidth: Math.max(icon.implicitWidth, current.implicitWidth, current.anchors.rightMargin)
        
        MaterialIcon {
            id: icon

            animate: true
            text: Hyprland.valid_top_level ? Icons.getAppCategoryIcon(Hyprland.active_top_level?.lastIpcObject.class, "desktop_windows") : "desktop_windows"
            color: root.color

            anchors.verticalCenter: parent.verticalCenter
        }

        Title {
            id: text1
        }

        Title {
            id: text2
        }

        TextMetrics {
            id: metrics

            text: Hyprland.valid_top_level ? (Hyprland.active_top_level?.title ?? qsTr("Desktop")) : qsTr("Desktop")
            font.pointSize: Config.appearance.font.size.small
            font.family: Config.appearance.font.family.mono
            elide: Qt.ElideRight
            elideWidth: Math.min(text.length, 50) * font.pointSize

            onTextChanged: {
                const next = child.current === text1 ? text2 : text1;
                next.text = elidedText;
                child.current = next;
            }
            onElideWidthChanged: child.current.text = elidedText
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: Config.appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.appearance.anim.curves.emphasized
            }
        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Config.appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.appearance.anim.curves.emphasized
            }
        }
    }

    component Title: StyledText {
        id: text

        anchors.verticalCenter: icon.verticalCenter
        anchors.horizontalCenter: icon.horizontalCenter
        anchors.right: icon.left
        //anchors.topMargin: Config.appearance.spacing.small

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.color
        opacity: child.current === this ? 1 : 0

        //width: implicitWidth
        //height: implicitWidth

        Behavior on opacity {
            NumberAnimation {
                duration: Config.appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.appearance.anim.curves.standard
            }
        }
    }
}
