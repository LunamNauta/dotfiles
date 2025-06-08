import { App, Astal, Gtk, Gdk, Widget } from "astal/gtk4"
import { Clock_Widget } from "./Clock_Widget";
import { Sysmon_Widget } from "./Sysmon_Widget";
import { Workspaces_Widget } from "./Workspaces_Widget";
import { Sysmenu_Widget } from "./Sysmenu_Widget";

function Left_Widgets(){
    return Widget.CenterBox(
        { cssClasses: ['main-bar', 'left-widgets'] },
        Widget.Box(
            { halign: Gtk.Align.START },
            Workspaces_Widget()
        ),
        Widget.Box({ halign: Gtk.Align.CENTER }),
        Widget.Box({ halign: Gtk.Align.END }),
    );
}
function Center_Widgets(){
    return Widget.CenterBox(
        { cssClasses: ['main-bar', 'center-widgets'] },
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
        { cssClasses: ['main-bar', 'right-widgets'] },
        Widget.Box({ halign: Gtk.Align.START }),
        Widget.Box({ halign: Gtk.Align.CENTER }),
        Widget.Box(
            { halign: Gtk.Align.END },
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
            { cssClasses: ['main-bar', 'center-box'] },
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
