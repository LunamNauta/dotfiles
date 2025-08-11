pragma ComponentBehavior: Bound
pragma Singleton


import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    id: root

    reloadableId: "brightness"

    readonly property list<Monitor> monitors: variants.instances
    property bool apple_display_present: false
    property list<var> ddc_monitors: []

    function getMonitorForScreen(screen: ShellScreen): var {
        return monitors.find(m => m.modelData === screen);
    }

    function increaseBrightness(): void {
        const focused_name = Hyprland.focused_monitor.name;
        const monitor = monitors.find(m => focused_name === m.modelData.name);
        if (monitor) monitor.setBrightness(monitor.brightness + 0.1);
    }

    function decreaseBrightness(): void {
        const focused_name = Hyprland.focused_monitor.name;
        const monitor = monitors.find(m => focused_name === m.modelData.name);
        if (monitor) monitor.setBrightness(monitor.brightness - 0.1);
    }

    onMonitorsChanged: {
        ddc_monitors = [];
        ddc_proc.running = true;
    }

    Variants {
        id: variants

        model: Quickshell.screens

        Monitor {}
    }

    Process {
        running: true
        command: ["sh", "-c", "asdbctl get"] // To avoid warnings if asdbctl is not installed
        stdout: StdioCollector {
            onStreamFinished: root.apple_display_present = text.trim().length > 0
        }
    }

    Process {
        id: ddc_proc

        command: ["ddcutil", "detect", "--brief"]
        stdout: StdioCollector {
            onStreamFinished: root.ddc_monitors = text.trim().split("\n\n").filter(d => d.startsWith("Display ")).map(d => ({
                model: d.match(/Monitor:.*:(.*):.*/)[1],
                bus_num: d.match(/I2C bus:[ ]*\/dev\/i2c-([0-9]+)/)[1]
            }))
        }
    }

    component Monitor: QtObject {
        id: monitor

        required property ShellScreen modelData
        readonly property bool is_ddc: root.ddc_monitors.some(m => m.model === modelData.model)
        readonly property string bus_num: root.ddc_monitors.find(m => m.model === modelData.model)?.bus_num ?? ""
        readonly property bool is_apple_display: root.apple_display_present && modelData.model.startsWith("StudioDisplay")
        property real queued_brightness: NaN
        property real brightness

        readonly property Process init_proc: Process {
            stdout: StdioCollector {
                onStreamFinished: {
                    if (monitor.is_apple_display){
                        const val = parseInt(text.trim());
                        monitor.brightness = val / 101;
                    } 
                    else{
                        const [, , , cur, max] = text.split(" ");
                        monitor.brightness = parseInt(cur) / parseInt(max);
                    }
                }
            }
        }

        readonly property Timer timer: Timer {
            interval: 500
            onTriggered: {
                if (!isNaN(monitor.queued_brightness)) {
                    monitor.setBrightness(monitor.queued_brightness);
                    monitor.queued_brightness = NaN;
                }
            }
        }

        function set_brightness(value: real): void {
            value = Math.max(0, Math.min(1, value));
            const rounded = Math.round(value * 100);
            if (Math.round(brightness * 100) === rounded) return;

            if (is_ddc && timer.running) {
                queued_brightness = value;
                return;
            }

            brightness = value;

            if (is_apple_display) Quickshell.execDetached(["asdbctl", "set", rounded]);
            else if (is_ddc) Quickshell.execDetached(["ddcutil", "-b", busNum, "setvcp", "10", rounded]);
            else Quickshell.execDetached(["brightnessctl", "s", `${rounded}%`]);

            if (is_ddc) timer.restart();
        }

        function initBrightness(): void {
            if (is_apple_display) init_proc.command = ["asdbctl", "get"];
            else if (is_ddc) init_proc.command = ["ddcutil", "-b", busNum, "getvcp", "10", "--brief"];
            else init_proc.command = ["sh", "-c", "echo a b c $(brightnessctl g) $(brightnessctl m)"];
            init_proc.running = true;
        }

        onBus_numChanged: initBrightness()
        Component.onCompleted: initBrightness()
    }
}
