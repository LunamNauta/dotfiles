import qs.components
import qs.components.controls
import qs.services
import qs.config

import QtQuick
import QtQuick.Layouts

ColumnLayout{
    id: root

    property int current_tab: 0
    readonly property list<string> tab_list: [
        "General",
        "Display",
        "asdfasdfasfasdf"
    ]
    property int tab_column_width: 0

    Repeater{
        id: tab_repeater 
        model: root.tab_list

        CustomMouseArea{
            required property string modelData
            implicitHeight: rect.implicitHeight
            implicitWidth: rect.implicitWidth

            onPressed: {
                const index = root.tab_list.indexOf(text.text);
                if (index !== root.current_tab) root.current_tab = index;
            }

            StyledRect{
                id: rect

                color: text.text === root.tab_list[root.current_tab] ? Colors.palette.m3primary : "transparent"
                radius: Config.appearance.rounding.small

                implicitHeight: text.implicitHeight + Config.appearance.padding.large
                implicitWidth: root.tab_column_width + Config.appearance.padding.large

                StyledText{
                    id: text

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Config.appearance.padding.normal
                    text: modelData

                    color: text.text === root.tab_list[root.current_tab] ? Colors.palette.m3surfaceContainer : Colors.palette.m3primary

                    Component.onCompleted: {
                        if (implicitWidth > root.tab_column_width) root.tab_column_width = implicitWidth;
                    }
                }
            }
        }
    }
}
