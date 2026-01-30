
import qs.services
import qs.components

import Quickshell
import QtQuick
import QtQuick.Layouts

RowLayout{
    Layout.alignment: Qt.AlignHCenter

    MaterialIcon{
        Layout.alignment: Qt.AlignHCenter
        id: bat_icon
        //anchors.verticalCenter: parent.verticalCenter
        text: {
            if (Battery.time_left == 0) return "power"
            if (Battery.battery_perc >= 0.91) return Battery.charging ? "battery_charging_90" : "battery_full";
                if (Battery.battery_perc >= 0.78) return Battery.charging ? "battery_charging_80" : "battery_6_bar";
                if (Battery.battery_perc >= 0.65) return Battery.charging ? "battery_charging_60" : "battery_5_bar";
                if (Battery.battery_perc >= 0.52) return Battery.charging ? "battery_charging_50" : "battery_4_bar";
                if (Battery.battery_perc >= 0.39) return Battery.charging ? "battery_charging_30" : "battery_3_bar";
                if (Battery.battery_perc >= 0.26) return Battery.charging ? "battery_charging_20" : "battery_2_bar";
                if (Battery.battery_perc >= 0.13) return Battery.charging ? "battery_charging_full" : "battery_1_bar";
                if (Battery.battery_perc >= 0) return Battery.charging ? "battery_charging_full" : "battery_0_bar";
        }
        color: Colors.palette.m3onBackground
    }
    StyledText{
        Layout.alignment: Qt.AlignHCenter
        text: {
            let perc = "";
            if (Battery.battery_perc == 1) perc = "100%";
            else if (Battery.battery_perc >= 0.1) perc = (Battery.battery_perc*100).toFixed(1) + "%";
            else perc = (Battery.battery_perc*100).toFixed(2) + "%";
            if (Battery.time_left == 0) return perc;
            return perc; //+ " • " + Battery.time_left.toFixed(2) + "h";
        }
        font.pointSize: Config.appearance.font.size.small * 0.8
    }
    StyledText{
        Layout.alignment: Qt.AlignHCenter
        text: Battery.time_left.toFixed(2) + "h"
        font.pointSize: Config.appearance.font.size.small * 0.8
    }
}
