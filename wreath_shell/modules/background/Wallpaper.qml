pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Item {
    id: root

    property string source: "/home/loki/personal/dotfiles/backgrounds/Black_Hole_1.png"
    Image {
        source: root.source
        anchors.fill: parent
    }

    anchors.fill: parent
}
