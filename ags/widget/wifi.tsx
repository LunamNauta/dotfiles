import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind, exec, execAsync } from "astal"
import GTop from 'gi://GTop';
import AstalNetwork from "gi://AstalNetwork";
import { Gtk, Gdk } from "astal/gtk3";
import Astal from "gi://Astal";

import { format_string, format_percent } from "./utilities";
import { userOptions } from './settings'

const network = AstalNetwork.get_default()
const wifi = network.get_wifi()

let network_icon = Variable('󰖪')
let wifi_ssid = Variable('')
let wifi_enabled = Variable(wifi?.get_enabled())

const update_wifi_by_strength = (strength: number) => {
    if (strength > 75) network_icon.set('󰤨')
    else if (strength > 50) network_icon.set('󰤥')
    else if (strength > 25) network_icon.set('󰤢')
    else if (strength > 0) network_icon.set('󰤟')
    else network_icon.set('󰖪')
}
const update_wifi_by_connection = (connection: AstalNetwork.Internet) => {
    if (connection == AstalNetwork.Internet.DISCONNECTED){
        network_icon.set('󰖪')
        wifi_ssid.set('No Connection')
    }
    else if (connection == AstalNetwork.Internet.CONNECTING) network_icon.set('󱛆')
    else if (connection == AstalNetwork.Internet.CONNECTED){
        update_wifi_by_strength(wifi?.strength)
        wifi_ssid.set(wifi?.ssid)
    }
}
const toggle_wifi = () => {
    if (wifi_enabled.get()){
        network_icon.set('󱛅')
        wifi_ssid.set('No Connection')
    } else{
        network_icon.set('󰖪')
    }
    wifi_enabled.set(!wifi_enabled.get())
    wifi?.set_enabled(wifi_enabled.get())
}

if (wifi){
    bind(wifi, 'strength').subscribe(strength => update_wifi_by_strength(strength))
    bind(wifi, 'internet').subscribe(connection => update_wifi_by_connection(connection))
    bind(wifi, 'enabled').subscribe(enabled => wifi_enabled.set(enabled))
    update_wifi_by_connection(wifi.internet)
}

const wifi_submenus = () => [
    <box>
        <button className={'wifi menu-toggle-icon'} onClick={toggle_wifi}>
            <label label={bind(network_icon).as(str => str)} />
        </button>
        <button className={'wifi menu-ssid'} onClick={() => execAsync('alacritty -e nmtui')}>
            <label label={bind(wifi_ssid).as(str => `[${str}]`)} />
        </button>
    </box>
]

const default_screen = Gdk.Screen.get_default()
let screen_width = 0
let screen_height = 0
if (default_screen){
    screen_width = default_screen.get_width()
    screen_height = default_screen.get_height()
}

let wifi_menu: Gtk.Window
let showing_wifi_menu = false
let touched_wifi_menu = false

const close_wifi_menu = () => {
    if (!showing_wifi_menu) return
    showing_wifi_menu = false
    touched_wifi_menu = false
    wifi_menu.close()
}
const hide_wifi_menu = () => {
    touched_wifi_menu = false
    setTimeout(() => {if (!touched_wifi_menu) close_wifi_menu()}, 500)
}
const show_wifi_menu = () => {
    touched_wifi_menu = true
    if (showing_wifi_menu) return
    wifi_menu = <window 
        anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
        width_request={250}
        layer={Astal.Layer.OVERLAY}
        >
        <eventbox className={'wifi menu'} onHover={() => touched_wifi_menu = true} onHoverLost={hide_wifi_menu}>
            <box orientation={Gtk.Orientation.VERTICAL}>
                {wifi_submenus().map(num => <box>
                    {num}
                </box>)}
            </box>
        </eventbox>
    </window>
    showing_wifi_menu = true
}

const Wifi = () => {
    const widget = <eventbox className="wifi" onHover={() => touched_wifi_menu = true} onHoverLost={hide_wifi_menu}>
        <box>
            <button className={'wifi button'} onClick={show_wifi_menu}>
                <label label={bind(network_icon).as(str => str)} />
            </button>
        </box>
    </eventbox>
    return widget
}

export{
    Wifi
}
