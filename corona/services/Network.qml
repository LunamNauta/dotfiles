pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property AccessPoint active: networks.find(n => n.active) ?? null
    readonly property list<AccessPoint> networks: []

    readonly property bool scanning: rescan_proc.running
    property bool wifi_enabled: true

    reloadableId: "network"

    function enableWifi(enabled: bool): void {
        const cmd = enabled ? "on" : "off";
        enable_wifi_proc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function toggleWifi(): void {
        const cmd = wifi_enabled ? "off" : "on";
        enable_wifi_proc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function rescanWifi(): void {
        rescan_proc.running = true;
    }

    function connectToNetwork(ssid: string, password: string): void {
        // TODO: Implement password
        connect_proc.exec(["nmcli", "conn", "up", ssid]);
    }

    function disconnectFromNetwork(): void {
        if (active) disconnect_proc.exec(["nmcli", "connection", "down", active.ssid]);
    }

    function getWifiStatus(): void {
        wifi_status_proc.running = true;
    }

    Process {
        running: true
        command: ["nmcli", "m"]
        stdout: SplitParser {
            onRead: get_networks.running = true
        }
    }

    Process {
        id: wifi_status_proc

        running: true
        command: ["nmcli", "radio", "wifi"]
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                root.wifi_enabled = text.trim() === "enabled";
            }
        }
    }

    Process {
        id: enable_wifi_proc

        onExited: {
            root.get_wifi_status();
            get_networks.running = true;
        }
    }

    Process {
        id: rescan_proc

        command: ["nmcli", "dev", "wifi", "list", "--rescan", "yes"]
        onExited: {
            get_networks.running = true;
        }
    }

    Process {
        id: connect_proc

        stdout: SplitParser {
            onRead: get_networks.running = true
        }
        stderr: StdioCollector {
            onStreamFinished: console.warn("Network connection error:", text)
        }
    }

    Process {
        id: disconnect_proc

        stdout: SplitParser {
            onRead: get_networks.running = true
        }
    }

    Process {
        id: get_networks

        running: true
        command: ["nmcli", "-g", "ACTIVE,SIGNAL,FREQ,SSID,BSSID,SECURITY", "d", "w"]
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                const PLACEHOLDER = "STRINGWHICHHOPEFULLYWONTBEUSED";
                const rep = new RegExp("\\\\:", "g");
                const rep2 = new RegExp(PLACEHOLDER, "g");

                const all_networks = text.trim().split("\n").map(n => {
                    const net = n.replace(rep, PLACEHOLDER).split(":");
                    return {
                        active: net[0] === "yes",
                        strength: parseInt(net[1]),
                        frequency: parseInt(net[2]),
                        ssid: net[3],
                        bssid: net[4]?.replace(rep2, ":") ?? "",
                        security: net[5] || ""
                    };
                }).filter(n => n.ssid && n.ssid.length > 0);

                // Group networks by SSID and prioritize connected ones
                const network_map = new Map();
                for (const network of all_networks){
                    const existing = network_map.get(network.ssid);
                    if (!existing) network_map.set(network.ssid, network);
                    else{
                        if (network.active && !existing.active) network_map.set(network.ssid, network); // Prioritize active/connected networks
                        else if (!network.active && !existing.active)
                            if (network.strength > existing.strength)  // If both are inactive, keep the one with better signal
                                networkMap.set(network.ssid, network);
                        // If existing is active and new is not, keep existing
                    }
                }

                const networks = Array.from(network_map.values());

                const r_networks = root.networks;

                const destroyed = r_networks.filter(rn => !networks.find(n => n.frequency === rn.frequency && n.ssid === rn.ssid && n.bssid === rn.bssid));
                for (const network of destroyed) r_networks.splice(r_networks.indexOf(network), 1).forEach(n => n.destroy());

                for (const network of networks){
                    const match = r_networks.find(n => n.frequency === network.frequency && n.ssid === network.ssid && n.bssid === network.bssid);
                    if (match) match.last_ipc_object = network;
                    else r_networks.push(ap_comp.createObject(root, {
                        last_ipc_object: network
                    }));
                }
            }
        }
    }

    component AccessPoint: QtObject {
        required property var last_ipc_object
        readonly property string ssid: last_ipc_object.ssid
        readonly property string bssid: last_ipc_object.bssid
        readonly property int strength: last_ipc_object.strength
        readonly property int frequency: last_ipc_object.frequency
        readonly property bool active: last_ipc_object.active
        readonly property string security: last_ipc_object.security
        readonly property bool isSecure: security.length > 0
    }

    Component {
        id: ap_comp

        AccessPoint {}
    }
}
