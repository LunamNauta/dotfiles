import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable } from "astal"
import { Clock_Widget } from "./clock"
import { Active_Workspace_Widget } from "./active_workspace"
import { Workspaces } from "./workspaces"
import { CPUMon_Widget } from "./cpumon"
import { MemMon_Widget } from "./memmon"
import { System_Menu_Widget } from "./system_menu"

const System_Monitor_Widgets = () =>
<box className={'system-monitor'}>
    <CPUMon_Widget />
    <MemMon_Widget />
</box>

const Left_Widgets = () =>
<centerbox className={'main-bar left-widgets'}>
    <box halign={Gtk.Align.START}>
        <Active_Workspace_Widget /> 
    </box>
    <box/>
    <box halign={Gtk.Align.END}> 
        <Clock_Widget />
    </box>
</centerbox>

const Center_Widgets = () =>
<box className={'main-bar center-widgets'}>
    <Workspaces />
</box>

const Right_Widgets = () =>
<centerbox className={'main-bar right-widgets'}>
    <box halign={Gtk.Align.START}> 
        <System_Monitor_Widgets />
    </box>
    <box/>
    <box halign={Gtk.Align.END}>
        <System_Menu_Widget />
    </box>
</centerbox>

export default function Bar(gdkmonitor: Gdk.Monitor) {
    return <window
        className={"main-bar"}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
        application={App}>
        <centerbox className={'main-bar center-box'}>
            <Left_Widgets />
            <Center_Widgets />
            <Right_Widgets />
        </centerbox>
    </window>
}
