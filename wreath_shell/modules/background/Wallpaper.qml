pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Item {
    id: root

    property string source: "/home/loki/personal/dotfiles/backgrounds/Sakura_Trees.jpg"

    Image {
        source: root.source
        anchors.fill: parent
    }

    anchors.fill: parent
}
