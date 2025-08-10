import Quickshell
import QtQuick

import qs.components
import qs.services
import qs.config

Item {
    implicitWidth: time_text.implicitWidth + Config.appearance.padding.large * 2
    implicitHeight: time_text.implicitHeight + Config.appearance.padding.large * 2

    StyledText {
        id: time_text

        anchors.centerIn: parent
        text: DateTime.format("hh:mm:ss")
        font.pointSize: Config.appearance.font.size.extra_large
        font.bold: true
    }
}
