import qs.modules.dashboard as Dashboard
import qs.modules.session as Session
import qs.services
import qs.config

import QtQuick.Shapes
import QtQuick

Shape{
    id: root

    required property Panels panels

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    preferredRendererType: Shape.CurveRenderer

    Dashboard.Background {
        wrapper: root.panels.dashboard

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: 0
    }

    Session.Background{
        wrapper: root.panels.session

        startX: root.width
        startY: (root.height - wrapper.height) / 2 - rounding
    }
}
