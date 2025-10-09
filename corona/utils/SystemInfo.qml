pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    id: root

    property string os_name: ""
    property string os_pretty_name: ""
    property string os_id: ""
    property list<string> os_id_like: []
    property string os_logo: ""

    property string uptime: ""
    readonly property string user: Quickshell.env("USER")
    readonly property string wm: Quickshell.env("XDG_CURRENT_DESKTOP").split(";")[0] || ""
    readonly property string shell: Quickshell.env("SHELL").split("/").pop()

    FileView{
        id: file_os_release

        path: "/etc/os-release"
        onLoaded: {
            const lines = text().split("\n");

            const find = key => lines.find(line => line.startsWith(`${key}=`))?.split("=")[1].replace(/"/g, "") ?? "";

            root.os_name = find("NAME");
            root.os_pretty_name = find("PRETTY_NAME");
            root.os_id = find("ID");
            root.os_id_like = find("ID_LIKE").split(" ");
            root.os_logo = Quickshell.iconPath(find("LOGO"), true) ?? "";
        }
    }

    Timer{
        running: true
        repeat: true
        interval: 60000
        onTriggered: file_uptime.reload()
    }
    FileView{
        id: file_uptime
        path: "/proc/uptime"
        onLoaded: {
            const uptime = parseInt(text().split(" ")[0] ?? 0);

            const days = Math.floor(uptime / 86400);
            const hours = Math.floor((uptime % 86400) / 3600);
            const minutes = Math.floor((uptime % 3600) / 60);

            let str = "";
            if (days > 0) str += `${days} day${days === 1 ? "" : "s"}`;
            if (hours > 0) str += `${str ? ", " : ""}${hours} hour${hours === 1 ? "" : "s"}`;
            if (minutes > 0 || !str) str += `${str ? ", " : ""}${minutes} minute${minutes === 1 ? "" : "s"}`;
            root.uptime = str;
        }
    }

    Text{
        text: root.uptime
    }
}
