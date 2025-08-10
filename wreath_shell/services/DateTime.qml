pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    id: root
    property string uptime: "0h, 0m"

    function format(fmt: string): string {
        return Qt.formatDateTime(clock.date, fmt);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            uptime_file.reload()
            const uptime_text = uptime_file.text()
            const uptime_seconds = Number(uptime_text.split(" ")[0] ?? 0)

            const days = Math.floor(uptime_seconds / 86400)
            const hours = Math.floor((uptime_seconds % 86400) / 3600)
            const minutes = Math.floor((uptime_seconds % 3600) / 60)

            let formatted = ""
            if (days > 0) formatted += `${days}d`
            if (hours > 0) formatted += `${formatted ? ", " : ""}${hours}h`
            if (minutes > 0 || !formatted) formatted += `${formatted ? ", " : ""}${minutes}m`
            root.uptime = formatted
            this.interval = 10000
        }
    }

    FileView {
        id: uptime_file
        path: "/proc/uptime"
    }
}
