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

ColumnLayout {
    id: root
    //name: "bar"

    required property ShellScreen screen
    required property PersistentProperties visibilities

    function handleWheel(y: real, angleDelta: point): void{
        const ch = childAt(width / 2, y) as Item;
        if (ch?.id === "workspaces"){
            // Workspace scroll
            const mon = Hypr.monitorFor(screen);
            const specialWs = mon?.lastIpcObject.specialWorkspace.name;
            if (specialWs?.length > 0) Hypr.dispatch(`togglespecialworkspace ${specialWs.slice(8)}`);
            else if (angleDelta.y < 0 || mon.activeWorkspace?.id > 1) Hypr.dispatch(`workspace r${angleDelta.y > 0 ? "-" : "+"}1`);
        }
        else if (y < screen.height / 2) {
            // Volume scroll on top half
            if (angleDelta.y > 0) Audio.incrementVolume();
            else if (angleDelta.y < 0) Audio.decrementVolume();
        }
        else{
            // Brightness scroll on bottom half
            const monitor = Brightness.getMonitorForScreen(screen);
            if (angleDelta.y > 0) monitor.setBrightness(monitor.brightness + Config.services.brightness_increment);
            else if (angleDelta.y < 0) monitor.setBrightness(monitor.brightness - Config.services.brightness_increment);
        }
    }

    /*
    anchors.right: true
    anchors.left: true
    anchors.top: true
    */
    implicitWidth: Math.max(left_widgets.width, center_widgets.width, right_widgets.width) + Config.border.thickness

    //WlrLayershell.layer: WlrLayer.Overlay

    //color: Colors.palette.m3background

    ColumnLayout {
        id: left_widgets

        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
        Layout.topMargin: Config.appearance.padding.small

        /*
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        */

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
            /*
            anchors.left: workspaces.right
            anchors.verticalCenter: parent.verticalCenter
            */

            active: Battery.batteries.length != 0
            sourceComponent: BatteryInfoData {}
        }
    }

    component BatteryInfoData: Item {
        MaterialIcon {
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
        StyledText {
            //anchors.left: bat_icon.right
            //anchors.verticalCenter: parent.verticalCenter
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

    ColumnLayout {
        id: center_widgets

        /*
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        */
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    }

    ColumnLayout {
        id: right_widgets

        /*
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        */
        Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        Layout.bottomMargin: Config.appearance.padding.small

        spacing: Config.appearance.spacing.larger
        readonly property real inner_spacing: Config.appearance.spacing.small


        ColumnLayout {
            //anchors.verticalCenter: parent.verticalCenter
            Layout.alignment: Qt.AlignHCenter
            StyledText {
                //anchors.verticalCenter: parent.verticalCenter
                //anchors.left: workspaces.right
                //anchors.bottom: parent.bottom

                text: DateTime.format("hh\nmm")
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.large
                font.bold: true
            }
            /*
            StyledText {
                //anchors.verticalCenter: parent.verticalCenter
                //anchors.left: workspaces.right
                id: date

                text: DateTime.format("ddd dd/MMM/yy")
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.small * 0.9
            }
            */
       }

       ColumnLayout {
            //anchors.verticalCenter: parent.verticalCenter
            spacing: parent.inner_spacing
            Layout.alignment: Qt.AlignHCenter
            MaterialIcon {
                text: Network.active != null ? Icons.getNetworkIcon(Network.active.strength) : "signal_wifi_off"
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.large
                //anchors.verticalCenter: parent.verticalCenter

                Process {
                    id: open_network_manager
                    command: ["bash", "-c", "alacritty -e /usr/bin/zsh -c nmtui"]
                }
                StateLayer {
                    //anchors.fill: undefined
                    //anchors.centerIn: parent
                    //anchors.horizontalCenterOffset: 1

                    //implicitWidth: parent.implicitHeight + Config.appearance.padding.small * 2
                    //implicitHeight: implicitWidth

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
                font.pointSize: Config.appearance.font.size.large
                color: Colors.palette.m3onBackground
                //anchors.verticalCenter: parent.verticalCenter

                Process {
                    id: open_bluetooth_manager
                    command: ["bash", "-c", "blueman-manager"]
                }
                StateLayer {
                    //anchors.fill: undefined
                    //anchors.centerIn: parent
                    //anchors.horizontalCenterOffset: 1

                    //implicitWidth: parent.implicitHeight + Config.appearance.padding.small * 2
                    //implicitHeight: implicitWidth

                    radius: Config.appearance.rounding.full

                    function onClicked(): void {
                        open_bluetooth_manager.running = true
                    }
                }
            }

            MaterialIcon {
                text: "power_settings_new"   
                color: Colors.palette.m3onBackground
                font.pointSize: Config.appearance.font.size.large
                font.bold: true
                //anchors.verticalCenter: parent.verticalCenter

                StateLayer {
                    //anchors.fill: undefined
                    //anchors.centerIn: parent
                    //anchors.horizontalCenterOffset: 1

                    //implicitWidth: parent.implicitHeight + Config.appearance.padding.small * 2
                    //implicitHeight: implicitWidth

                    radius: Config.appearance.rounding.full

                    function onClicked(): void {
                        root.visibilities.session = !root.visibilities.session;
                    }
                }
            }
        }
    }
}
