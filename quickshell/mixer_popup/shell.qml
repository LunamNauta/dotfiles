import QtQuick
import Quickshell
import Quickshell.Io

PanelWindow {
    id: toplevel

    anchors {
        top: true
        left: true
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

    Sysmon {

    }

    /*
    PopupWindow {
        anchor.window: toplevel
        anchor.rect.x: parentWindow.width - width / 2
        anchor.rect.y: parentWindow.height
        implicitWidth: 450
        implicitHeight: screen.height - parentWindow.height - 50
        visible: true
        color: "#000000"
    }
    */
}
