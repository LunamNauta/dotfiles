pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Item{
    id: root

    property string source: Quickshell.env("HOME") + "/personal/dotfiles/backgrounds/Sakura_Trees.jpg"

    Image{
        source: root.source
        anchors.fill: parent
    }

    anchors.fill: parent
}
