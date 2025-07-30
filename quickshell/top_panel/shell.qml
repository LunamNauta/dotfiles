import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
	Socket {
		// Create and connect a Socket to the hyprland event socket.
		// https://wiki.hyprland.org/IPC/
		path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`
		connected: true

		parser: SplitParser {
			// Regex that will return the newly focused monitor when it changes.
			property var regex: new RegExp("focusedmon>>(.+),.*");

			// Sent for every line read from the socket
			onRead: msg => {
				const match = regex.exec(msg);

				if (match != null) {
					// Filter out the right screen from the list and update the panel.
					// match[1] will always be the monitor name captured by the regex.
					panel.screen = Quickshell.screens.filter(screen => screen.name == match[1])[0];
				}
			}
		}
	}

	// The default screen a panel will be created on under hyprland is the currently
	// focused one. We use this since we don't get a focusedmon event on connect.
	PanelWindow {
		id: panel

		anchors {
			left: true
			top: true
			right: true
		}

        Text {
            id: clock
            anchors.centerIn: parent

            Process {
                // give the process object an id so we can talk
                // about it from the timer
                id: dateProc

                command: ["date", "+%H:%M:%S • %A, %d/%B/%y"]
                running: true

                stdout: StdioCollector {
                    onStreamFinished: clock.text = this.text
                }
            }

            // use a timer to rerun the process at an interval
            Timer {
                // 1000 milliseconds is 1 second
                interval: 1000

                // start the timer immediately
                running: true

                // run the timer again when it ends
                repeat: true

                // when the timer is triggered, set the running property of the
                // process to true, which reruns it if stopped.
                onTriggered: dateProc.running = true
            }
        }
    }
}
