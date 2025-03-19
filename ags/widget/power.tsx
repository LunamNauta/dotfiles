import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind, exec } from "astal"
import GTop from 'gi://GTop';

import { popup } from "./popup";

let power_menu: Gtk.Window
let power_menu_exists = false
let touched_power_menu = false

const power_options = [
    {icon: '󰜉', func: 'reboot'},
    {icon: '󰍃', func: 'hyprctl dispatch exit'},
    {icon: '', func: 'hyprlock'},
    {icon: '󰒲', func: 'systemctl suspend'}
]

function hover_lost(){
    touched_power_menu = false
    setTimeout(() => {if (!touched_power_menu) kill_power_menu()}, 500)
}
function kill_power_menu(){
    if (!power_menu_exists) return
    power_menu.close()
    power_menu_exists = false
    touched_power_menu = false
}
function spawn_power_menu(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    touched_power_menu = true
    if (power_menu_exists) return
    power_menu = <window
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={RIGHT | TOP}
        application={App}
        layer={Astal.Layer.OVERLAY}>
        <eventbox className={'power dropdown'} onHover={() => touched_power_menu = true} onHoverLost={hover_lost}>
            <box orientation={Gtk.Orientation.VERTICAL}>
                {power_options.map(option => {
                    return <button className={'power button'} halign={Gtk.Align.CENTER} onClick={() => exec(option.func)}>
                        {option.icon}
                    </button>
                })}
            </box>
        </eventbox>
    </window>
    power_menu_exists = true
}

const Power = () =>
<eventbox onHover={() => spawn_power_menu()} onHoverLost={hover_lost}>
    <box className={'power'}>
        <button className={'power main_button'} onClick={() => exec('poweroff')}>
            <label label={'󰐥'} />
        </button>
    </box>
</eventbox>

export{
    Power
}
