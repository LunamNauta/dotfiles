pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config

import Quickshell
import QtQuick

Column{
    id: root

    required property PersistentProperties visibilities

    padding: Config.appearance.padding.large
    spacing: Config.appearance.spacing.large

    SessionButton{
        id: logout

        icon: "logout"
        command: Config.session.commands.logout

        KeyNavigation.down: shutdown

        Component.onCompleted: forceActiveFocus()
    }

    SessionButton{
        id: shutdown

        icon: "power_settings_new"
        command: Config.session.commands.shutdown

        KeyNavigation.up: logout
        KeyNavigation.down: suspend
    }

    SessionButton{
        id: suspend

        icon: "downloading"
        command: Config.session.commands.suspend

        KeyNavigation.up: shutdown
        KeyNavigation.down: reboot
    }

    SessionButton{
        id: reboot

        icon: "cached"
        command: Config.session.commands.reboot

        KeyNavigation.up: suspend
    }

    component SessionButton: StyledRect{
        id: button

        required property string icon
        required property list<string> command

        implicitWidth: Config.session.sizes.button
        implicitHeight: Config.session.sizes.button

        radius: Config.appearance.rounding.large
        color: Colors.palette.m3secondaryContainer 

        Keys.onEnterPressed: Quickshell.execDetached(button.command)
        Keys.onReturnPressed: Quickshell.execDetached(button.command)
        Keys.onEscapePressed: root.visibilities.session = false
        Keys.onPressed: event => {
            if (!Config.session.vimKeybinds) return;

            if (event.modifiers & Qt.ControlModifier) {
                if (event.key === Qt.Key_J && KeyNavigation.down){
                    KeyNavigation.down.focus = true;
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_K && KeyNavigation.up){
                    KeyNavigation.up.focus = true;
                    event.accepted = true;
                }
            }
            else if (event.key === Qt.Key_Tab && KeyNavigation.down){
                KeyNavigation.down.focus = true;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier))){
                if (KeyNavigation.up){
                    KeyNavigation.up.focus = true;
                    event.accepted = true;
                }
            }
        }

        StateLayer{
            radius: parent.radius
            color: Colors.palette.m3onSecondaryContainer

            function onClicked(): void{
                Quickshell.execDetached(button.command);
            }
        }

        MaterialIcon{
            anchors.centerIn: parent

            text: button.icon
            color: Colors.palette.m3onSecondaryContainer
            font.pointSize: Config.appearance.font.size.extra_large
            font.weight: 500
        }
    }
}
