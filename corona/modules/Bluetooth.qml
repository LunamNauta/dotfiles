pragma ComponentBehavior: Bound

import qs.components
import qs.config

import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

Item{
    id: root

    implicitWidth: bluetooth.implicitWidth
    implicitHeight: bluetooth.implicitHeight

    MaterialIcon{
        id: bluetooth

        animate: true

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

        Process{
            id: open_bluetooth_manager
            command: ["kitty", "--title", "bluetooth_manager", "-e", "zsh", "-i", "-c", "bluetuith"]
        }
        StateLayer{
            radius: Config.appearance.rounding.normal

            function onClicked(): void{
                open_bluetooth_manager.running = true
            }
        }
    }
}
