import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"

import { Workspaces  } from './hyprland'
import { Clock } from './clock'
import { Mem } from './mem'
import { Cpu } from './cpu'
import { Power } from "./power"
import { Wifi } from "./wifi"

/*
const Right = () =>
<box 
    className={'right-widgets'} 
    halign={Gtk.Align.END}>
    <Cpu />
    <Mem />
    <Power />
</box>
*/

const Right = () =>
<box 
    className={'right-widgets'} 
    halign={Gtk.Align.END}>
    <Clock />
    <Wifi />
</box>

const Center = () =>
<box className={'center-widgets'} halign={Gtk.Align.CENTER}>
    <Workspaces />
</box>

const Left = () =>
<box className={'left-widgets'} halign={Gtk.Align.START}>
    <Power />
    <Cpu />
    <Mem />
</box>

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <centerbox>
            <Left />
            <Center />
            <Right />
        </centerbox>
    </window>
}
