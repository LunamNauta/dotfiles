pragma Singleton

import Quickshell.Services.UPower
import Quickshell
import QtQuick

Singleton {
    id: root

    property list<UPowerDevice> batteries: UPower.devices.values.filter(dev => {
        return dev.isLaptopBattery;
    })
    property real total_energy: 0
    property real total_capacity: 0
    property real battery_perc: 0
    property real total_change: 0
    property bool charging: false
    property real time_left: 0

    function updateInfo(){
        root.total_energy = batteries.reduce((acc, dev) => {
            return acc + dev.energy
        }, 0);
        root.total_capacity = batteries.reduce((acc, dev) => {
            return acc + dev.energyCapacity;
        }, 0);
        root.battery_perc = total_energy / total_capacity;
        root.total_change = batteries.reduce((acc, dev) => {
            return acc + dev.changeRate;
        }, 0);
        if (root.total_change != 0) root.time_left = root.total_energy / root.total_change;
        let time_to_empty = batteries.reduce((acc, dev) => {
            return acc + dev.timeToEmpty;
        }, 0);
        root.charging = time_to_empty == 0;
    }

    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            updateInfo()
            interval = 10000
        }
    }
}
