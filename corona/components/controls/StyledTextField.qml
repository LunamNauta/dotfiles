pragma ComponentBehavior: Bound

import ".."
import qs.services
import qs.config

import QtQuick
import QtQuick.Controls

TextField{
    id: root

    color: Colors.palette.m3onSurface
    placeholderTextColor: Colors.palette.m3outline
    font.family: Config.appearance.font.family.sans
    font.pointSize: Config.appearance.font.size.smaller
    renderType: TextField.NativeRendering
    cursorVisible: !readOnly

    background: null

    cursorDelegate: StyledRect{
        id: cursor

        property bool disableBlink

        implicitWidth: 2
        color: Colors.palette.m3primary
        radius: Config.appearance.rounding.normal

        Connections{
            target: root

            function onCursorPositionChanged(): void{
                if (root.activeFocus && root.cursorVisible) {
                    cursor.opacity = 1;
                    cursor.disableBlink = true;
                    enableBlink.restart();
                }
            }
        }

        Timer{
            id: enableBlink

            interval: 100
            onTriggered: cursor.disableBlink = false
        }

        Timer{
            running: root.activeFocus && root.cursorVisible && !cursor.disableBlink
            repeat: true
            triggeredOnStart: true
            interval: 500
            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }

        Binding{
            when: !root.activeFocus || !root.cursorVisible
            cursor.opacity: 0
        }

        Behavior on opacity{
            Anim {
                duration: Config.appearance.anim.durations.small
            }
        }
    }

    Behavior on color{
        CAnim{}
    }

    Behavior on placeholderTextColor{
        CAnim{}
    }
}
