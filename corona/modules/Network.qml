pragma ComponentBehavior: Bound

import qs.services
import qs.utilities
import qs.components
import qs.config

import Quickshell.Io
import QtQuick

Item{
    id: root

    implicitWidth: Math.max(network.implicitWidth, network.implicitHeight)
    implicitHeight: Math.max(network.implicitWidth, network.implicitHeight)

    MaterialIcon{
        id: network
        
        animate: true

        text: Network.active != null ? Icons.getNetworkIcon(Network.active.strength) : "signal_wifi_off"

        Process{
            id: open_network_manager
            command: ["kitty", "--title", "network_manager", "-e", "zsh", "-i", "-c", "nmtui"]
        }
        StateLayer{
            radius: Config.appearance.rounding.normal

            function onClicked(): void{
                open_network_manager.running = true
            }
        }
    }
}
