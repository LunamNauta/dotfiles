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

    Session.Background{
        wrapper: root.panels.session

        startX: root.width
        startY: (root.height - wrapper.height) / 2 - rounding
    }
}
