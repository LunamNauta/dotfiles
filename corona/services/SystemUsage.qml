pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    id: root

    property real cpu_perc
    property real cpu_temp
    property real last_cpu_idle
    property real last_cpu_total

    property real gpu_perc
    property real gpu_temp
    property string gpu_type: "NONE"

    property real mem_used
    property real mem_total
    readonly property real mem_perc: mem_total > 0 ? mem_used / mem_total : 0

    property real storage_used
    property real storage_total
    readonly property real storage_perc: storage_total > 0 ? storage_used / storage_total : 0

    property int ref_count

    function formatKib(kib: real): var{
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        if (kib >= tib) return {
            value: kib / tib,
            unit: "TiB"
        };
        if (kib >= gib) return {
            value: kib / gib,
            unit: "GiB"
        };
        if (kib >= mib) return {
            value: kib / mib,
            unit: "MiB"
        };
        return {
            value: kib,
            unit: "KiB"
        };
    }

    Timer {
        running: root.ref_count > 0
        interval: 3000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            file_stat.reload();
            file_meminfo.reload();
            proc_storage.running = true;
            proc_gpu_usage.running = true;
            proc_sensors.running = true;
        }
    }

    FileView{
        id: file_stat

        path: "/proc/stat"
        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (data) {
                const stats = data.slice(1).map(n => parseInt(n, 10));
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3] + (stats[4] ?? 0);

                const total_diff = total - root.last_cpu_total;
                const idle_diff = idle - root.last_cpu_idle;
                root.cpu_perc = total_diff > 0 ? (1 - idle_diff / total_diff) : 0;

                root.last_cpu_idle = idle;
                root.last_cpu_total = total;
            }
        }
    }

    FileView{
        id: file_meminfo

        path: "/proc/meminfo"
        onLoaded: {
            const data = text();
            root.mem_total = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.mem_used = (root.mem_total - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process{
        id: proc_storage

        command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $1, $3, $4}'"]
        stdout: StdioCollector{
            onStreamFinished: {
                const device_map = new Map();

                for (const line of text.trim().split("\n")){
                    if (line.trim() === "") continue;

                    const parts = line.trim().split(/\s+/);
                    if (parts.length >= 3) {
                        const device = parts[0];
                        const used = parseInt(parts[1], 10) || 0;
                        const avail = parseInt(parts[2], 10) || 0;

                        // Only keep the entry with the largest total space for each device
                        if (!device_map.has(device) || (used + avail) > (device_map.get(device).used + device_map.get(device).avail)){
                            device_map.set(device, {
                                used: used,
                                avail: avail
                            });
                        }
                    }
                }

                let total_used = 0;
                let total_avail = 0;

                for (const [device, stats] of device_map) {
                    total_used += stats.used;
                    total_avail += stats.avail;
                }

                root.storage_used = total_used;
                root.storage_total = total_used + total_avail;
            }
        }
    }

    Process {
        id: proc_gpu_type_check

        running: true
        command: ["sh", "-c", "if command -v nvidia-smi &>/dev/null && nvidia-smi -L &>/dev/null; then echo NVIDIA; elif ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | grep -q .; then echo GENERIC; else echo NONE; fi"]
        stdout: StdioCollector{
            onStreamFinished: root.gpu_type = text.trim()
        }
    }

    Process{
        id: proc_gpu_usage

        command: root.gpu_type === "GENERIC" ? ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent"] : root.gpu_type === "NVIDIA" ? ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"] : ["echo"]
        stdout: StdioCollector{
            onStreamFinished: {
                if (root.gpu_type === "GENERIC"){
                    const percs = text.trim().split("\n");
                    const sum = percs.reduce((acc, d) => acc + parseInt(d, 10), 0);
                    root.gpu_perc = sum / percs.length / 100;
                }
                else if (root.gpu_type === "NVIDIA") {
                    const [usage, temp] = text.trim().split(",");
                    root.gpu_perc = parseInt(usage, 10) / 100;
                    root.gpu_temp = parseInt(temp, 10);
                }
                else {
                    root.gpu_perc = 0;
                    root.gpu_temp = 0;
                }
            }
        }
    }

    Process{
        id: proc_sensors

        command: ["sensors"]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })
        stdout: StdioCollector{
            onStreamFinished: {
                let cpu_temp = text.match(/(?:Package id [0-9]+|Tdie):\s+((\+|-)[0-9.]+)(°| )C/);
                // If AMD Tdie pattern failed, try fallback on Tctl
                if (!cpu_temp) cpu_temp = text.match(/Tctl:\s+((\+|-)[0-9.]+)(°| )C/);
                if (cpu_temp) root.cpu_temp = parseFloat(cpu_temp[1]);
                if (root.gpu_type !== "GENERIC") return;

                let eligible = false;
                let sum = 0;
                let count = 0;

                for (const line of text.trim().split("\n")){
                    if (line === "Adapter: PCI adapter") eligible = true;
                    else if (line === "") eligible = false;
                    else if (eligible){
                        let match = line.match(/^(temp[0-9]+|GPU core|edge)+:\s+\+([0-9]+\.[0-9]+)(°| )C/);
                        // Fall back to junction/mem if GPU doesn't have edge temp (for AMD GPUs)
                        if (!match) match = line.match(/^(junction|mem)+:\s+\+([0-9]+\.[0-9]+)(°| )C/);
                        if (match){
                            sum += parseFloat(match[2]);
                            count++;
                        }
                    }
                }

                root.gpu_temp = count > 0 ? sum / count : 0;
            }
        }
    }
}
