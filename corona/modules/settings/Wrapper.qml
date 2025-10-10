import qs.components
import qs.components.containers
import qs.config

import QtQuick
import QtQuick.Layouts

StyledWindow{
    id: root
    name: "test"
    visible: visibilities.settings

    required property Item bar

    focusable: true
    implicitHeight: tab_layout.implicitHeight + Config.appearance.padding.large
    implicitWidth: tab_layout.implicitWidth + Config.appearance.padding.large

    color: "#11111b"

    RowLayout{
        id: tab_layout

        anchors.centerIn: parent

        /*
        StyledRect{
            radius: Config.appearance.rounding.normal
            color: "#1e1e2e"

            implicitHeight: tab_sectional.implicitHeight + Config.appearance.padding.normal
            implicitWidth: tab_sectional.implicitWidth + Config.appearance.padding.normal

            TabColumn{
                id: tab_sectional
                anchors.centerIn: parent
            }
        }
        */

        StyledRect{
            radius: Config.appearance.rounding.normal
            color: "#1e1e2e"

            implicitHeight: general_sectional.implicitHeight + Config.appearance.padding.normal
            implicitWidth: general_sectional.implicitWidth + Config.appearance.padding.normal

            GeneralPane{
                id: general_sectional
                bar: root.bar
            }
        }
    }
}
