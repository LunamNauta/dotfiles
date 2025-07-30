import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
	id: root
	property color backgroundColor: "#e60c0c0c"
	property color buttonColor: "#11111b"
	property color buttonHoverColor: "#1e1e2e"
	default property list<SysmonWidget> monitors

	model: Quickshell.screens
	PanelWindow {
		id: w

		property var modelData
		screen: modelData

		exclusionMode: ExclusionMode.Ignore
		WlrLayershell.layer: WlrLayer.Overlay
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

		color: "transparent"

		contentItem {
			focus: true
			Keys.onPressed: event => {
				if (event.key == Qt.Key_Escape) Qt.quit();
				else {
					for (let i = 0; i < buttons.length; i++) {
						let button = buttons[i];
						if (event.key == button.keybind) button.exec();
					}
				}
			}
		}

		anchors {
			top: true
			left: true
			bottom: true
			right: true
        }

        
        Rectangle {
			color: backgroundColor;
			anchors.fill: parent
            Repeater {
			    model: buttons
			    delegate: Rectangle {
				    required property LogoutButton modelData;

				    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 50

			    	color: ma.containsMouse ? buttonHoverColor : buttonColor
				    border.color: "black"
				    border.width: ma.containsMouse ? 0 : 1

				    MouseArea {
					    id: ma
					    anchors.fill: parent
					    hoverEnabled: true
					    onClicked: modelData.exec()
				    }

				    Image {
					    id: icon
					    anchors.centerIn: parent
					    source: `icons/${modelData.icon}.png`
					    width: parent.width * 0.25
					    height: parent.width * 0.25
				    }

				    Text {
					    anchors {
						    top: icon.bottom
						    topMargin: 20
						    horizontalCenter: parent.horizontalCenter
					    }

					    text: modelData.text
					    font.pointSize: 15
					    color: "#cdd6f4"
				    }
			    }
		    }
        }
	}
}
