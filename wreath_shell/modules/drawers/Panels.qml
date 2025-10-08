import qs.modules.session as Session
import qs.config

import Quickshell
import QtQuick

Item{
    id: root

    required property PersistentProperties visibilities
    required property ShellScreen screen
    required property Item bar

    readonly property alias session: session

    anchors.fill: parent
    anchors.margins: Config.border.thickness

    Session.Wrapper{
        id: session

        visibilities: root.visibilities
        panels: root

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }
}
