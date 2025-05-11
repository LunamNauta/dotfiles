import { bind, exec, execAsync, Variable } from "astal";
import { App, Astal } from "astal/gtk3";
import GLib from "gi://GLib?version=2.0";
import Gtk from "gi://Gtk"
import AstalNetwork from "gi://AstalNetwork";
import AstalBluetooth from "gi://AstalBluetooth?version=0.1";

type SystemMenu = {
    menu: Gtk.Window | undefined;
    touched: boolean;
}
let system_menu: SystemMenu = {
    menu: undefined,
    touched: false,
}

let start_time = GLib.DateTime.new_now_local().to_unix()
let current_time_flt = Variable(start_time).poll(1000, () => GLib.DateTime.new_now_local().to_unix() - start_time)
let current_time_fmt = () => current_time_flt(uptime => Math.floor(uptime/3600).toString() + 'h, ' + Math.floor(uptime/60).toString() + 'm')
const Uptime_Widget = () =>
<box className={'system-tray uptime'} halign={Gtk.Align.START}>
    <label label={current_time_fmt()} />
</box>

const power_options = [
    {icon: '󰐥', func: 'poweroff'},
    {icon: '󰜉', func: 'reboot'},
    {icon: '󰍃', func: 'swaymsg exit'},
    {icon: '󰒲', func: 'systemctl suspend'}
]
const Power_Widget = () =>
<box halign={Gtk.Align.END}>
    {power_options.map(option => {
        return <button className={'system-tray power-button'} onClick={() => {execAsync(['bash', '-c', option.func])}}>
            {option.icon}
        </button>
    })}
</box>

const Basic_Widgets = () =>
<centerbox
    start_widget={<Uptime_Widget />}
    end_widget={<Power_Widget />}
>
</centerbox>

const network = AstalNetwork.get_default()
const bluetooth = AstalBluetooth.get_default()
const wifi = network.get_wifi()

let bluetooth_enabled = Variable(bluetooth.get_is_powered())
let bluetooth_icon = Variable(bluetooth.get_is_powered() ? '󰂯' : '󰂲')
const toggle_bluetooth = () => {
    bluetooth.toggle()
    bluetooth_enabled.set(!bluetooth_enabled.get())
    bluetooth_icon.set(bluetooth_enabled.get() ? '󰂯' : '󰂲')
}

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

let bluelight_enabled = Variable(false)
let bluelight_icon = Variable('')
const toggle_bluelight = async () => {
    if (bluelight_enabled.get()) execAsync('pkill -SIGTERM gammastep');
    else execAsync('gammastep -O 3750')
    bluelight_enabled.set(!bluelight_enabled.get())
    bluelight_icon.set(bluelight_enabled.get() ? '' : '')
}

let toggles = {
    wifi: wifi ? wifi.get_enabled() : false,
    bluetooth: bluetooth.get_is_powered(),
    bluelight: false,
}
const Toggle_Widgets = () =>
<box className={'system-tray toggles'} halign={Gtk.Align.CENTER}>
    <button className={wifi_enabled(enabled => enabled ? 'system-tray toggled' : 'system-tray untoggled')} onClick={toggle_wifi}>
        <label label={network_icon()} />
    </button>
    <button className={bluetooth_enabled(enabled => enabled ? 'system-tray toggled' : 'system-tray untoggled')} onClick={toggle_bluetooth}>
        <label label={bluetooth_icon()} />
    </button>
    <button className={bluelight_enabled(enabled => enabled ? 'system-tray toggled' : 'system-tray untoggled')} onClick={toggle_bluelight}>
        <label label={bluelight_icon()} />
    </button>    
</box>

function hide_system_menu(){
    system_menu.touched = false
    setTimeout(() => {if (!system_menu.touched) close_system_menu()}, 500)
}
function close_system_menu(){
    if (!system_menu.menu) return
    system_menu.touched = false
    system_menu.menu.close()
    system_menu.menu = undefined
}
function spawn_system_menu() {
    system_menu.touched = true
    if (system_menu.menu) return
    system_menu.menu = <window className={'system-tray window'}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT}
        application={App}
        layer={Astal.Layer.OVERLAY}
        width_request={450}>
        <eventbox onHover={() => system_menu.touched = true} onHoverLost={hide_system_menu}>
            <box className={'system-tray menu'} orientation={Gtk.Orientation.VERTICAL}>
                <Basic_Widgets />
                <Toggle_Widgets />
            </box>
        </eventbox>
    </window>
}

const System_Menu_Widget = () =>
<eventbox className={'system-tray'} onHover={() => system_menu.touched = true} onHoverLost={hide_system_menu} onClick={spawn_system_menu}>
    <box>
        <label className={'system-tray network-icon'} label={network_icon()} />
        <label className={'system-tray bluetooth-icon'} label={bluetooth_icon()} />
    </box>
</eventbox>

export{
    System_Menu_Widget
}
