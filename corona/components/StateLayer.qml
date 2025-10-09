import qs.services
import qs.config

import QtQuick

MouseArea{
    id: root

    property bool disabled
    property color color: Colors.palette.m3onSurface
    property real radius: parent?.radius ?? 0
    property alias rect: hover_layer

    function onClicked(): void{}

    anchors.fill: parent

    enabled: !disabled
    cursorShape: disabled ? undefined : Qt.PointingHandCursor
    hoverEnabled: true

    onPressed: event => {
        if (disabled) return;

        ripple_anim.x = event.x;
        ripple_anim.y = event.y;

        const dist = (ox, oy) => ox * ox + oy * oy;
        ripple_anim.radius = Math.sqrt(Math.max(dist(event.x, event.y), dist(event.x, height - event.y), dist(width - event.x, event.y), dist(width - event.x, height - event.y)));

        ripple_anim.restart();
    }

    onClicked: event => !disabled && onClicked(event)

    SequentialAnimation{
        id: ripple_anim

        property real x
        property real y
        property real radius

        PropertyAction{
            target: ripple
            property: "x"
            value: ripple_anim.x
        }
        PropertyAction{
            target: ripple
            property: "y"
            value: ripple_anim.y
        }
        PropertyAction{
            target: ripple
            property: "opacity"
            value: 0.08
        }
        Anim{
            target: ripple
            properties: "implicitWidth,implicitHeight"
            from: 0
            to: ripple_anim.radius * 2
            easing.bezierCurve: Config.appearance.anim.curves.standard_decel
        }
        Anim{
            target: ripple
            property: "opacity"
            to: 0
        }
    }

    StyledClippingRect{
        id: hover_layer

        anchors.fill: parent

        color: Qt.alpha(root.color, root.disabled ? 0 : root.pressed ? 0.1 : root.containsMouse ? 0.08 : 0)
        radius: root.radius

        StyledRect{
            id: ripple

            radius: Config.appearance.rounding.full
            color: root.color
            opacity: 0

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }
}
