import qs.modules
import qs.components
import qs.config

import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow{
    anchors.left: true
    anchors.right: true
    anchors.top: true

    implicitWidth: right_block.implicitWidth + Config.appearance.padding.small
    implicitHeight: right_block.implicitHeight + Config.appearance.padding.small

    StyledRect{
        anchors.fill: parent
        color: "#11111b"
        radius: 0
    }

    StyledRect{
        id: left_block

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.appearance.padding.small

        implicitWidth: left_elements.implicitWidth + Config.appearance.padding.smaller
        implicitHeight: left_elements.implicitHeight + Config.appearance.padding.smaller

        color: "#1e1e2e"
        radius: 8

        RowLayout{
            id: left_elements

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            anchors.margins: 5
            spacing: 10

            Workspaces {
                id: worksspaces

                Layout.alignment: Qt.AlignVCenter

                Workspace { workspace_id: 1 }
                Workspace { workspace_id: 2 }
                Workspace { workspace_id: 3 }
                Workspace { workspace_id: 4 }
                Workspace { workspace_id: 5 }
                Workspace { workspace_id: 6 }
                Workspace { workspace_id: 7 }
                Workspace { workspace_id: 8 }
                Workspace { workspace_id: 9 }
                Workspace { workspace_id: 10 }
            }
        }
    }

    StyledRect{
        id: right_block

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Config.appearance.padding.small

        implicitWidth: right_elements.implicitWidth + Config.appearance.padding.smaller
        implicitHeight: right_elements.implicitHeight + Config.appearance.padding.smaller

        color: "#1e1e2e"
        radius: 8

        RowLayout{
            id: right_elements

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            anchors.margins: 5
            spacing: 10

            Clock{}
            StyledText{
                color: "#cdd6f4"
                text: "|"
            }
            Network{}
            Bluetooth{}
        }
    }
}
