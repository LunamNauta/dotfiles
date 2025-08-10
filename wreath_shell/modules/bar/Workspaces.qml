import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick

import qs.services

Item {
    id: root

	property color backgroundColor: "#e60c0c0c"
	property color buttonColor: "#1e1e1e"
	property color buttonHoverColor: "#3700b3"
    default property list<Workspace> workspaces

    implicitWidth: workspaces_row.implicitWidth

 	readonly property var next_workspace_proc: Process {
		command: ["bash", "-c"]
    }
    property bool isFunctionLocked: false
    Timer {
        id: throttleTimer
        interval: 50  // 1 second
        running: false
        repeat: false
        onTriggered: {
            parent.isFunctionLocked = false; // Unlock the function call after 1 second
        }
    }
    function next_workspace(dy){
        if (isFunctionLocked) {
            return; // Ignore the call if the function is locked
        }
        // Lock the function and start the timer
        isFunctionLocked = true;
        throttleTimer.start();
        var curr = Hyprland.focusedWorkspace.name
        if (dy < 0 && curr == 10) return
        var cmd = "hyprctl dispatch workspace " + (dy < 0 ? "+1" : "-1")
        next_workspace_proc.exec({command: ["bash", "-c", cmd]})
    }

    Row {
        id: workspaces_row

        anchors {
            verticalCenter: parent.verticalCenter
        }
        spacing: 3

        Repeater {
            model: workspaces

            delegate: Rectangle {
                required property Workspace modelData;

                width: 15
                height: 15
                radius: 15
                //color: Hyprland.workspaces.values[modelData.name].active ? "#4a9eff" : "#333333"
                color: "#00000000"
                border.color: "#00000000"
                border.width: 0

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.switch_to()
                    onWheel: next_workspace(wheel.angleDelta.y)
                }

                Text {
                    text: modelData.is_occupied() ? '' : ''
                    anchors.centerIn: parent
                    //color: Hyprland.workspaces.values[modelData.name].active ? "#ffffff" : "#cccccc"
                    color: modelData.is_active() ? Colors.palette.m3primary : Colors.palette.m3outlineVariant
                    font.pixelSize: 20
                    font.family: "CaskaydiaCove NFM"
                }
            }
        }
    }
}
