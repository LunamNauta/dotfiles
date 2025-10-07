import Quickshell.Wayland
import Quickshell
import QtQuick

import qs.components.containers
import qs.config

Loader {
    asynchronous: false
    active: Config.background.enabled

    sourceComponent: Variants {
        model: Quickshell.screens

        StyledWindow {
            id: win

            required property ShellScreen modelData

            screen: modelData
            name: "background"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            color: "black"

            anchors.bottom: true
            anchors.right: true
            anchors.left: true
            anchors.top: true

            Wallpaper {}

            Loader {
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
