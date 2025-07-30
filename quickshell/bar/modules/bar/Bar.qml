import QtQuick
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel

    implicitHeight: 40

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
        left: 0
        right: 0
    }

    Rectangle {
        id: bar

        anchors.fill: parent
        color: "#11111b"
        border.color: "#00000000"
        border.width: 3

        Row {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            Workspaces {
                Workspace {name: 1}
                Workspace {name: 2}
                Workspace {name: 3}
                Workspace {name: 4}
                Workspace {name: 5}
                Workspace {name: 6}
                Workspace {name: 7}
                Workspace {name: 8}
                Workspace {name: 9}
                Workspace {name: 10}
            }
        }

        /*
    Loader {
        active: true
        sourceComponent:
    }
    */

        /*
        Row {
            id: workspaces_row

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }
            spacing: 8

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: 32
                    height: 24
                    radius: 15
                    color: modelData.active ? "#4a9eff" : "#333333"
                    border.color: "#555555"
                    border.width: 2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }

                    Text {
                        text: modelData.id
                        anchors.centerIn: parent
                        color: modelData.active ? "#ffffff" : "#cccccc"
                        font.pixelSize: 12
                        font.family: "Inter, sans-serif"
                    }
                }
            }

            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#ffffff"
                font.pixelSize: 12
            }
        }
        */

        Text {
            id: timeDisplay

            anchors {
                centerIn: parent
                verticalCenter: parent.verticalCenter
                rightMargin: 16
            }

            property string currentTime: ""

            text: currentTime
            color: "#cdd6f4"
            font.pixelSize: 12
            font.family: "CaskaydiaCove NFM"
            font.bold: true

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    var now = new Date()
                    timeDisplay.currentTime = Qt.formatTime(now, "hh:mm:ss") + " • " + Qt.formatDate(now, "dddd, dd/MMMM/yy")
                }
            }

            Component.onCompleted: {
                var now = new Date()
                timeDisplay.currentTime = Qt.formatTime(now, "hh:mm:ss") + " • " + Qt.formatDate(now, "dddd, dd/MMMM/yy")
            }
        }
    }
}
