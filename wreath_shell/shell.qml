import "modules/background"
import "modules/border"
import "modules/bar"

import qs.components.containers
import qs.services
import qs.config

import Quickshell.Wayland
import QtQuick.Effects
import Quickshell
import QtQuick

ShellRoot{
    StyledWindow{
        id: win
        anchors{
            left: true
            right: true
            top: true
            bottom: true
        }
        color: "transparent"
        name: "border"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        mask: Region {
            x: 0 //Config.border.thickness
            y: 0 //Config.border.thickness
            width: 0 //win.width - Config.border.thickness * 2
            height: 0 //win.height - Config.border.thickness * 2
            //intersection: Intersection.Xor
        }
        Item{
            anchors.fill: parent
            opacity: 1
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                blurMax: 10
                shadowColor: Qt.alpha(Colors.palette.m3shadow, 0.7)
            }
            Border{
                bar: bar
            }
        }
        Item{
            id: bar
            implicitHeight: bar2.implicitHeight
            Bar{
                id: bar2
            }
        }
    }
    Background{}
}
