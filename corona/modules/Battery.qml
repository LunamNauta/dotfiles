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
            if (BatteryData.time_left == 0) return "power"
            if (BatteryData.battery_perc >= 0.91) return BatteryData.charging ? "battery_charging_90" : "battery_full";
                if (BatteryData.battery_perc >= 0.78) return BatteryData.charging ? "battery_charging_80" : "battery_6_bar";
                if (BatteryData.battery_perc >= 0.65) return BatteryData.charging ? "battery_charging_60" : "battery_5_bar";
                if (BatteryData.battery_perc >= 0.52) return BatteryData.charging ? "battery_charging_50" : "battery_4_bar";
                if (BatteryData.battery_perc >= 0.39) return BatteryData.charging ? "battery_charging_30" : "battery_3_bar";
                if (BatteryData.battery_perc >= 0.26) return BatteryData.charging ? "battery_charging_20" : "battery_2_bar";
                if (BatteryData.battery_perc >= 0.13) return BatteryData.charging ? "battery_charging_full" : "battery_1_bar";
                if (BatteryData.battery_perc >= 0) return BatteryData.charging ? "battery_charging_full" : "battery_0_bar";
        }
        color: Colors.palette.m3onBackground
    }

    RowLayout{
        spacing: 12

        StyledText{
            Layout.alignment: Qt.AlignHCenter
            text: {
                let perc = "";
                if (BatteryData.battery_perc == 1) perc = "100%";
                else if (BatteryData.battery_perc >= 0.1) perc = (BatteryData.battery_perc*100).toFixed(1) + "%";
                else perc = (BatteryData.battery_perc*100).toFixed(2) + "%";
                if (BatteryData.time_left == 0) return perc;
                return perc; //+ " • " + BatteryData.time_left.toFixed(2) + "h";
            }
            font.pointSize: Config.appearance.font.size.small * 0.8
        }
        StyledText{
            Layout.alignment: Qt.AlignHCenter
            text: BatteryData.time_left.toFixed(2) + "h"
            font.pointSize: Config.appearance.font.size.small * 0.8
        }
    }
}
