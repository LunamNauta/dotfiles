import { bind } from "astal";
import { App, Astal, Gtk, Gdk, Widget } from "astal/gtk4"
import { Clock_Widget } from "./Clock_Widget";
import { Sysmon_Widget } from "./Sysmon_Widget";
import { Workspaces_Widget } from "./Workspaces_Widget";
import { Sysmenu_Widget } from "./Sysmenu_Widget";
import { globals } from "./Globals";

function BatMon_Widget(){
    return Widget.Box(
        { cssClasses: ['batmon'] },
        Widget.Label({ cssClasses: ['batmon', 'icon'], label: globals.sysmon.battery_icon() }),
        Widget.Label({ cssClasses: ['batmon', 'percent'], label: bind(globals.sysmon.battery_usage).as(usage => globals.utilities.format_percent(usage, 3, 100) + "%") }),
        Widget.Label({ cssClasses: ['batmon', 'percent'], label: '•'}),
        Widget.Label({ cssClasses: ['batmon', 'percent'], label: bind(globals.sysmon.battery_time).as(time => globals.utilities.format_percent(time, 3, 1) + "h") })
    );
}

function Left_Widgets(){
    return Widget.CenterBox(
        { cssClasses: ['main-bar', 'left-widgets'], halign: Gtk.Align.START, hexpand: false},
        Widget.Box(
            { halign: Gtk.Align.START },
            Workspaces_Widget(),
            BatMon_Widget()
        ),
        Widget.Box({ halign: Gtk.Align.CENTER }),
        Widget.Box({ halign: Gtk.Align.END }),
    );
}
function Center_Widgets(){
    return Widget.CenterBox(
        { cssClasses: ['main-bar', 'center-widgets'], halign: Gtk.Align.START, vexpand: false },
        Widget.Box({ halign: Gtk.Align.START }),
        Widget.Box(
            { halign: Gtk.Align.CENTER },
            Clock_Widget()
        ),
        Widget.Box({ halign: Gtk.Align.END }),
    );
}
function Right_Widgets(){
    return Widget.CenterBox(
        { cssClasses: ['main-bar', 'right-widgets'], halign: Gtk.Align.END, hexpand: true },
        Widget.Box({ }),
        Widget.Box({ }),
        Widget.Box(
            { },
            Sysmon_Widget(),
            Sysmenu_Widget()
        ),
    );
}

export default function Bar(gdkmonitor: Gdk.Monitor){
    return Widget.Window(
        {
            cssClasses: ['main-bar'],
            gdkmonitor: gdkmonitor,
            exclusivity: Astal.Exclusivity.EXCLUSIVE,
            anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT,
            application: App,
            visible: true
        },
        Widget.CenterBox(
            { cssClasses: ['main-bar', 'center-box'], shrink_center_last: true },
            Left_Widgets(),
            Center_Widgets(),
            Right_Widgets()
        )
    );
}

/*
import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { Variable } from "astal"

const time = Variable("").poll(1000, "date")

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        visible
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <centerbox cssName="centerbox">
            <button
                onClicked="echo hello"
                hexpand
                halign={Gtk.Align.CENTER}
            >
                Welcome to AGS!
            </button>
            <box />
            <menubutton
                hexpand
                halign={Gtk.Align.CENTER}
            >
                <label label={time()} />
                <popover>
                    <Gtk.Calendar />
                </popover>
            </menubutton>
        </centerbox>
    </window>
}
*/
