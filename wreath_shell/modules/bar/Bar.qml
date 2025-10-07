pragma ComponentBehavior: Bound

import Quickshell.Services.UPower
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components.containers
import qs.components
import qs.services
import qs.config
import qs.utils

RowLayout {
    id: root
    //name: "bar"

    /*
    anchors.right: true
    anchors.left: true
    anchors.top: true
    */
    implicitHeight: Math.max(left_widgets.height, center_widgets.height, right_widgets.height) + Config.appearance.spacing.normal

    //WlrLayershell.layer: WlrLayer.Overlay

    //color: Colors.palette.m3background

    RowLayout {
        id: left_widgets

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        spacing: Config.appearance.spacing.large

        Workspaces {
            id: workspaces

            Workspace { workspace_id: 1 }
            Workspace { workspace_id: 2 }
            Workspace { workspace_id: 3 }
            Workspace { workspace_id: 4 }
            Workspace { workspace_id: 5 }
            Workspace { workspace_id: 6 }
            Workspace { workspace_id: 7 }
            Workspace { workspace_id: 8 }
            Workspace { workspace_id: 9 }
            Workspace { workspace_id: 10 }
        }

        Loader {
            anchors.left: workspaces.right
            anchors.verticalCenter: parent.verticalCenter
            
            active: Battery.batteries.length != 0
            sourceComponent: BatteryInfoData {}
        }
    }

    component BatteryInfoData: Item {
        MaterialIcon {
            id: bat_icon
            anchors.verticalCenter: parent.verticalCenter
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
        StyledText {
            anchors.left: bat_icon.right
            anchors.verticalCenter: parent.verticalCenter
            text: {
                let perc = "";
                if (Battery.battery_perc == 1) perc = "100%";
                else if (Battery.battery_perc >= 0.1) perc = (Battery.battery_perc*100).toFixed(1) + "%";
                else perc = (Battery.battery_perc*100).toFixed(2) + "%";
                if (Battery.time_left == 0) return perc;
                return perc + " • " + Battery.time_left.toFixed(2) + "h";
            }
        }
    }

    RowLayout {
        id: center_widgets

        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter

        ActiveWindow { 
            anchors.centerIn: center_widgets
        }
    }

    RowLayout {
        id: right_widgets

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        spacing: Config.appearance.spacing.larger
        readonly property real inner_spacing: Config.appearance.spacing.small


        Column {
            anchors.verticalCenter: parent.verticalCenter
            StyledText {
                //anchors.verticalCenter: parent.verticalCenter
                //anchors.left: workspaces.right
                anchors.right: parent.right

                text: DateTime.format("hh:mm:ss")
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.small * 0.9
                font.bold: true
            }
            StyledText {
                //anchors.verticalCenter: parent.verticalCenter
                //anchors.left: workspaces.right
                id: date

                text: DateTime.format("ddd dd/MMM/yy")
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.small * 0.9
            }
        }

        Row {
            spacing: parent.inner_spacing
            anchors.verticalCenter: parent.verticalCenter
            Row {
                MaterialIcon {
                    text: "memory"
                    color: Colors.palette.m3onBackground
                    anchors.verticalCenter: parent.verticalCenter
                }
                StyledText {
                    text: (SystemUsage.cpu_perc >= 0.1 ? (SystemUsage.cpu_perc*100).toFixed(1) : (SystemUsage.cpu_perc*100).toFixed(2)) + "%"
                    color: Colors.palette.m3onBackground
                    font.pointSize: Config.appearance.font.size.small
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Row {
                MaterialIcon {
                    text: "memory_alt"
                    color: Colors.palette.m3onBackground
                    anchors.verticalCenter: parent.verticalCenter
                }
                StyledText {
                    text: (SystemUsage.mem_perc >= 0.1 ? (SystemUsage.mem_perc*100).toFixed(1) : (SystemUsage.mem_perc*100).toFixed(2)) + "%"
                    color: Colors.palette.m3onBackground
                    font.pointSize: Config.appearance.font.size.small
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Row {
            spacing: parent.inner_spacing
            anchors.verticalCenter: parent.verticalCenter
            Row {
                MaterialIcon {
                    text: "memory"
                    color: Colors.palette.m3onBackground
                    anchors.verticalCenter: parent.verticalCenter
                }
                StyledText {
                    text: (SystemUsage.cpu_temp >= 100 ? SystemUsage.cpu_temp.toFixed(0) : (SystemUsage.cpu_temp >= 10 ? SystemUsage.cpu_temp.toFixed(1) : SystemUsage.cpu_temp.toFixed(2))) + "°"
                    color: Colors.palette.m3onBackground
                    font.pointSize: Config.appearance.font.size.small
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Loader {
                active: SystemUsage.gpu_type != "NONE"
                sourceComponent: GpuTempData {}
            }
        }

        component GpuTempData: Row {
            MaterialIcon {
                text: "videogame_asset"
                color: Colors.palette.m3onBackground
                anchors.verticalCenter: parent.verticalCenter
            }
            StyledText {
                text: (SystemUsage.gpu_temp >= 100 ? SystemUsage.gpu_temp.toFixed(0) : (SystemUsage.gpu_temp >= 10 ? SystemUsage.gpu_temp.toFixed(1) : SystemUsage.gpu_temp.toFixed(2))) + "°"
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.small
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: parent.inner_spacing
            MaterialIcon {
                text: Network.active != null ? Icons.getNetworkIcon(Network.active.strength) : "signal_wifi_off"
                color: Colors.palette.m3onBackground
                anchors.verticalCenter: parent.verticalCenter

                Process {
                    id: open_network_manager
                    command: ["bash", "-c", "alacritty -e /usr/bin/zsh -c nmtui"]
                }
                StateLayer {
                    anchors.fill: undefined
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 1

                    implicitWidth: parent.implicitHeight + Config.appearance.padding.small * 2
                    implicitHeight: implicitWidth

                    radius: Config.appearance.rounding.full

                    function onClicked(): void {
                        open_network_manager.running = true
                    }
                }
            }
            MaterialIcon {
                text: {
                    if (Bluetooth.defaultAdapter == null) return "bluetooth_disabled";
                    if (!Bluetooth.defaultAdapter.enabled) return "bluetooth_disabled"
                    if (Bluetooth.defaultAdapter.discovering) return "bluetooth_searching"
                    const connected = Bluetooth.defaultAdapter.devices.values.find(dev => {
                        return dev.state == BluetoothDeviceState.Connected
                    })
                    if (connected) return "bluetooth_connected"
                    return "bluetooth"
                }    
                color: Colors.palette.m3onBackground
                anchors.verticalCenter: parent.verticalCenter

                Process {
                    id: open_bluetooth_manager
                    command: ["bash", "-c", "blueman-manager"]
                }
                StateLayer {
                    anchors.fill: undefined
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 1

                    implicitWidth: parent.implicitHeight + Config.appearance.padding.small * 2
                    implicitHeight: implicitWidth

                    radius: Config.appearance.rounding.full

                    function onClicked(): void {
                        open_bluetooth_manager.running = true
                    }
                }
            }
        }
    }
}
