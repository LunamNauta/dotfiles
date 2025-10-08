pragma ComponentBehavior: Bound

import qs.components
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import Quickshell.Wayland
import QtQuick

Loader{
    id: root

    asynchronous: false //true
    active: Config.background.enabled

    sourceComponent: Variants{
        model: Quickshell.screens

        StyledWindow{
            id: win

            required property ShellScreen modelData

            screen: modelData
            name: "background"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            color: "black"

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Wallpaper{
                id: wallpaper
            }

            Loader{
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Config.appearance.padding.large

                active: Config.background.desktop_clock.enabled
                asynchronous: true

                source: "DesktopClock.qml"
            }
        }
    }
}
