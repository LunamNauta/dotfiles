import qs.components
import qs.components.controls
import qs.services
import qs.config

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

ColumnLayout{
    id: root

    required property Item bar

    StyledText{
        Layout.alignment: Qt.AlignHCenter
        text: "--- Corona Settings ---"
        font.pointSize: Config.appearance.font.size.large
        font.bold: true
        font.italic: true
    }
    GridLayout{
        id: tmp_grid
        columns: 2

        StyledText{
            id: border_rounding_header
            Layout.alignment: Qt.AlignVCenter
            text: "Border Rounding "
        }
        FilledSlider {
            id: roundingSlider
            icon: "rounded_corner"
            value: Config.border.rounding / (Config.appearance.rounding.large * 5)
            stepSize: 0.01
            Layout.alignment: Qt.AlignHCenter
            orientation: Qt.Horizontal
            implicitHeight: border_rounding_header.implicitHeight * 1.5
            implicitWidth: 250

            onValueChanged: {
                Config.border.rounding = Config.appearance.rounding.large * 5 * actual_value
                set_hyprland_border_rounding.running = true
            }
        }
        Process{
            id: set_hyprland_border_rounding
            command: [
                "zsh",
                "/home/loki/personal/projects/corona/scripts/set_hyprland_rounding.zsh",
                Math.max(Math.floor(Config.border.rounding * 0.98), 0)
            ]
            running: true
        }

        StyledText{
            id: border_thickness_header
            Layout.alignment: Qt.AlignVCenter
            text: "Border Thickness "
        }
        FilledSlider {
            id: thicknessSlider
            icon: "border_outer"
            value: Config.border.thickness / (Config.appearance.padding.large * 5)
            stepSize: 0.01
            from: 0.015
            Layout.alignment: Qt.AlignHCenter
            orientation: Qt.Horizontal
            implicitHeight: border_thickness_header.implicitHeight * 1.5
            implicitWidth: 250

            onValueChanged: {
                Config.border.thickness = Config.appearance.padding.large * 5 * actual_value
                set_hyprland_border_thickness.running = true
            }
        }
        Process{
            id: set_hyprland_border_thickness
            command: [
                "zsh",
                "/home/loki/personal/projects/corona/scripts/set_hyprland_gaps.zsh",
                Config.border.thickness,
                Config.border.thickness,
                Config.border.thickness,
                root.bar.implicitWidth + Config.bar.padding * 2
            ]
            running: true
        }
        readonly property int border_thickness: Config.border.thickness
        onBorder_thicknessChanged: {
            set_hyprland_border_thickness.running = true
        }

        StyledText{
            id: bar_padding_header
            Layout.alignment: Qt.AlignVCenter
            text: "Bar Padding "
        }
        FilledSlider {
            id: paddingSlider
            icon: "border_left"
            value: Config.bar.padding / (Config.appearance.padding.large * 5)
            stepSize: 0.01
            Layout.alignment: Qt.AlignHCenter
            orientation: Qt.Horizontal
            implicitHeight: bar_padding_header.implicitHeight * 1.5
            implicitWidth: 250

            onValueChanged: {
                Config.bar.padding = Config.appearance.padding.large * 5 * actual_value
                set_hyprland_border_thickness.running = true
            }
        }
        readonly property int bar_padding: Config.bar.padding
        onBar_paddingChanged: {
            set_hyprland_border_thickness.running = true
        }
    }
}
