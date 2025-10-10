//pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import qs.utils
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Brightness.Monitor monitor
    required property var visibilities

    required property real volume
    required property bool muted
    required property real sourceVolume
    required property bool sourceMuted
    required property real brightness

    implicitWidth: layout.implicitWidth + Config.appearance.padding.large * 2
    implicitHeight: layout.implicitHeight + Config.appearance.padding.large * 2

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Config.appearance.spacing.normal

        // Speaker volume
        CustomMouseArea {
            implicitWidth: Config.osd.sizes.slider_width
            implicitHeight: Config.osd.sizes.slider_height

            function onWheel(event: WheelEvent) {
                if (event.angleDelta.y > 0) Audio.incrementVolume();
                else if (event.angleDelta.y < 0) Audio.decrementVolume();
                audio_slider.value = Audio.volume;

            }

            FilledSlider {
                id: audio_slider
                anchors.fill: parent

                icon: Icons.getVolumeIcon(value, root.muted)
                value: root.volume
                onMoved: Audio.setVolume(value)
            }
        }

        // Microphone volume
            CustomMouseArea {
                implicitWidth: Config.osd.sizes.slider_width
                implicitHeight: Config.osd.sizes.slider_height

                function onWheel(event: WheelEvent) {
                    if (event.angleDelta.y > 0) Audio.incrementSourceVolume();
                    else if (event.angleDelta.y < 0) Audio.decrementSourceVolume();
                    microphone_slider.value = Audio.source_volume;
                }

                FilledSlider {
                    id: microphone_slider
                    anchors.fill: parent

                    icon: Icons.getMicVolumeIcon(value, root.sourceMuted)
                    value: root.sourceVolume
                    onMoved: Audio.setSourceVolume(value)
                }
            }

        // Brightness
            CustomMouseArea {
                implicitWidth: Config.osd.sizes.slider_width
                implicitHeight: Config.osd.sizes.slider_height

                function onWheel(event: WheelEvent) {
                    const monitor = root.monitor;
                    if (!monitor) return;
                    if (event.angleDelta.y > 0) monitor.setBrightness(monitor.brightness + 0.1);
                    else if (event.angleDelta.y < 0) monitor.setBrightness(monitor.brightness - 0.1);
                    brightness_slider.value = monitor.brightness
                }

                FilledSlider {
                    id: brightness_slider
                    anchors.fill: parent

                    icon: `brightness_${(Math.round(value * 6) + 1)}`
                    value: root.brightness
                    onMoved: root.monitor?.setBrightness(value)
                }
            }
        }

    Connections {
        target: Audio

        function onMutedChanged(): void {
            audio_slider.value = Audio.volume;
        }

        function onVolumeChanged(): void {
            audio_slider.value = Audio.volume;
        }

        function onSource_mutedChanged(): void {
            microphone_slider.value = Audio.source_volume;
        }

        function onSource_volumeChanged(): void {
            microphone_slider.value = Audio.source_volume;
        }
    }

    Connections {
        target: root.monitor

        function onBrightnessChanged(): void {
            const monitor = root.monitor;
            if (!monitor) return;
            brightness_slider.value = monitor.brightness
        }
    }

    component WrappedLoader: Loader {
        required property bool shouldBeActive

        Layout.preferredHeight: shouldBeActive ? Config.osd.sizes.slider_height : 0
        opacity: shouldBeActive ? 1 : 0
        active: opacity > 0
        asynchronous: true
        visible: active

        Behavior on Layout.preferredHeight {
            Anim {
                easing.bezierCurve: Config.appearance.anim.curves.emphasized
            }
        }

        Behavior on opacity {
            Anim {}
        }
    }
}
