pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config

import QtQuick.Effects
import QtQuick

Item{
    id: root

    required property Item bar

    anchors.fill: parent

    StyledRect{
        anchors.fill: parent
        color: Colors.palette.m3surface

        layer.enabled: true
        layer.effect: MultiEffect{
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    Item{
        id: mask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle{
            anchors.fill: parent
            anchors.margins: Config.border.thickness
            //anchors.topMargin: root.bar.implicitHeight
            anchors.leftMargin: root.bar.implicitWidth + Config.bar.padding * 2
            radius: Config.border.rounding
        }
    }
}
