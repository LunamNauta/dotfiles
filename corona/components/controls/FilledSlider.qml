import ".."
import "../effects"
import qs.services
import qs.config
import QtQuick
import QtQuick.Templates

Slider{
    id: root

    required property string icon
    property real oldValue
    property bool initialized
    property bool modified
    property bool invert
    property real actual_value: {
        return invert ? 1.0 - value : value
    }

    orientation: Qt.Vertical

    background: StyledRect{
        color: Colors.tPalette.m3surfaceContainer
        radius: Config.appearance.rounding.full

        StyledRect{
            anchors.left: orientation == Qt.Horizontal ? anchors.left : parent.left
            anchors.right: orientation == Qt.Horizontal ? anchors.right : parent.right

            x: invert ? root.handle.x : 0
            implicitWidth: invert ? parent.width - x : root.handle.x + handle.implicitWidth

            y: invert ? 0 : root.handle.y
            implicitHeight: invert ? root.handle.y + handle.implicitHeight : parent.height - y

            color: Colors.palette.m3secondary
            radius: parent.radius
        }
    }

    handle: Item{
        id: handle

        property alias moving: icon.moving

        x: root.orientation == Qt.Horizontal ? ((!modified && invert) ? 1.0 - root.visualPosition : root.visualPosition) * (root.availableWidth - width) : 0
        y: root.orientation == Qt.Vertical ? ((!modified && invert) ? 1.0 - root.visualPosition : root.visualPosition) * (root.availableHeight - height) : 0
        implicitWidth: Math.min(root.width, root.height)
        implicitHeight: Math.min(root.width, root.height)

        Elevation{
            anchors.fill: parent
            radius: rect.radius
            level: handleInteraction.containsMouse ? 2 : 1
        }

        StyledRect{
            id: rect

            anchors.fill: parent

            color: Colors.palette.m3inverseSurface
            radius: Config.appearance.rounding.full

            CustomMouseArea{
                id: handleInteraction

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }

            MaterialIcon{
                id: icon

                property bool moving

                function update(): void {
                    animate = !moving;
                    binding.when = moving;
                    font.pointSize = moving ? Config.appearance.font.size.small : Config.appearance.font.size.larger;
                    font.family = moving ? Config.appearance.font.family.sans : Config.appearance.font.family.material;
                }

                text: root.icon
                color: Colors.palette.m3inverseOnSurface
                anchors.centerIn: parent

                onMovingChanged: anim.restart()

                Binding{
                    id: binding

                    target: icon
                    property: "text"
                    value: Math.round(root.actual_value * 100)
                    when: false
                }

                SequentialAnimation{
                    id: anim

                    Anim{
                        target: icon
                        property: "scale"
                        to: 0
                        duration: Config.appearance.anim.durations.normal / 2
                        easing.bezierCurve: Config.appearance.anim.curves.standard_accel
                    }
                    ScriptAction{
                        script: icon.update()
                    }
                    Anim{
                        target: icon
                        property: "scale"
                        to: 1
                        duration: Config.appearance.anim.durations.normal / 2
                        easing.bezierCurve: Config.appearance.anim.curves.standard_decel
                    }
                }
            }
        }
    }

    onPressedChanged: handle.moving = pressed

    onValueChanged: {
        if (!initialized) {
            initialized = true;
            return;
        }
        if (Math.abs(value - oldValue) < 0.01)
            return;
        oldValue = value;
        if (!modified) modified = true
        handle.moving = true;
        if (!invert) actual_value = root.value
        else actual_value = 1.0 - root.value
        stateChangeDelay.restart();
    }

    Timer{
        id: stateChangeDelay

        interval: 500
        onTriggered: {
            if (!root.pressed)
                handle.moving = false;
        }
    }

    Behavior on value{
        Anim{
            duration: Config.appearance.anim.durations.large
        }
    }

    Component.onCompleted: {
        root.value = root.actual_value
    }
}
