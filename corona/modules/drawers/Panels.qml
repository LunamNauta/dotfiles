import qs.modules.dashboard as Dashboard
import qs.modules.session as Session
import qs.config

import Quickshell
import QtQuick

Item{
    id: root

    required property PersistentProperties visibilities
    required property ShellScreen screen
    required property Item bar

    readonly property alias dashboard: dashboard
    readonly property alias session: session

    anchors.fill: parent
    anchors.margins: Config.border.thickness

    Dashboard.Wrapper{
        id: dashboard

        visibilities: root.visibilities

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }

    Session.Wrapper{
        id: session

        visibilities: root.visibilities
        panels: root

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }
}
