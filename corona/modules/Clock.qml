pragma ComponentBehavior: Bound

import qs.services
import qs.components
import qs.config

import QtQuick

Item{
    id: root

    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight

    StyledText{
        id: clock

        text: DateTime.format("HH:mm:ss ddd MMM dd")

        font.pointSize: Config.appearance.font.size.small

        Timer{
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = DateTime.format("HH:mm:ss ddd MMM dd")
        }
    }
}
