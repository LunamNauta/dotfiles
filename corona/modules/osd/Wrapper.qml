pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config

import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property var visibilities
    property bool hovered
    readonly property Brightness.Monitor monitor: Brightness.getMonitorForScreen(root.screen)
    readonly property bool shouldBeActive: visibilities.osd

    property real volume
    property bool muted
    property real sourceVolume
    property bool sourceMuted
    property real brightness

    function show(): void {
        visibilities.osd = !visibilities.session;
        timer.restart();
    }

    Component.onCompleted: {
        volume = Audio.volume;
        muted = Audio.muted;
        sourceVolume = Audio.source_volume;
        sourceMuted = Audio.source_muted;
        brightness = root.monitor?.brightness ?? 0;
    }

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.shouldBeActive

        PropertyChanges {
            root.implicitWidth: content.implicitWidth
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            Anim {
                target: root
                property: "implicitWidth"
                easing.bezierCurve: Config.appearance.anim.curves.expressive_default_spatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            Anim {
                target: root
                property: "implicitWidth"
                easing.bezierCurve: Config.appearance.anim.curves.emphasized
            }
        }
    ]

    Connections {
        target: Audio

        function onMutedChanged(): void {
            root.show();
            root.muted = Audio.muted;
        }

        function onVolumeChanged(): void {
            root.show();
            root.volume = Audio.volume;
        }

        function onSource_mutedChanged(): void {
            root.show();
            root.sourceMuted = Audio.sourceMuted;
        }

        function onSource_volumeChanged(): void {
            root.show();
            root.sourceVolume = Audio.source_volume;
        }
    }

    Connections {
        target: root.monitor

        function onBrightnessChanged(): void {
            root.show();
            root.brightness = root.monitor?.brightness ?? 0;
        }
    }

    Timer {
        id: timer

        interval: Config.osd.hide_delay
        onTriggered: {
            if (!root.hovered)
                root.visibilities.osd = false;
        }
    }

    Loader {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Component.onCompleted: active = Qt.binding(() => root.shouldBeActive || root.visible)

        sourceComponent: Content {
            monitor: root.monitor
            visibilities: root.visibilities
            volume: root.volume
            muted: root.muted
            sourceVolume: root.sourceVolume
            sourceMuted: root.sourceMuted
            brightness: root.brightness
        }
    }
}
