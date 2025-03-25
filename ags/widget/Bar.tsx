import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable } from "astal"

import { Clock } from "./clock"
import { Cpu } from "./cpu"
import { Mem } from "./mem"
import { Workspaces } from "./hyprland"
import { System_Tray } from "./system_tray"
import { Color_Picker } from "./color_picker"

const System_Monitor = () =>
<box className={'system-monitor'}>
    <Cpu />
    <Mem />
</box>

const Left_Widgets = () =>
<box className={'left-widgets'} halign={Gtk.Align.START}>
    <Clock />
</box>

const Center_Widgets = () =>
<box className={'center-widgets'} halign={Gtk.Align.CENTER}>
    <Workspaces />
</box>

const Right_Widgets = () =>
<box className={'right-widgets'} halign={Gtk.Align.END}>
    <System_Monitor />
    <Color_Picker />
    <System_Tray />
</box>

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="bar"
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <centerbox className={'bar box'}
            startWidget={<Left_Widgets />}
            centerWidget={<Center_Widgets />}
            endWidget={<Right_Widgets />}
        >
        </centerbox>
    </window>
}
