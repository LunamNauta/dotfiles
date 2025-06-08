import { bind, execAsync, Variable } from "astal";
import GLib from "gi://GLib?version=2.0";
import Gtk from "gi://Gtk"
import AstalNetwork from "gi://AstalNetwork";
import AstalBluetooth from "gi://AstalBluetooth?version=0.1";
import Notifd from "gi://AstalNotifd"
import { App, Astal, Widget } from "astal/gtk4";
import { globals } from "./Globals";

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
let current_time_fmt = () => current_time_flt(uptime => Math.floor(uptime/3600).toString() + 'h, ' + (Math.floor(uptime/60)%60).toString() + 'm')
function Uptime_Widget(){
    return Widget.Box(
        { cssClasses: ['system-tray', 'uptime'], halign: Gtk.Align.START },
        Widget.Label({label: current_time_fmt()})
    );
}

const power_options = [
    {icon: '󰐥', func: 'poweroff'},
    {icon: '󰜉', func: 'reboot'},
    {icon: '󰍃', func: 'hyprctl dispatch exit'},
    {icon: '', func: 'hyprlock'},
    {icon: '󰒲', func: 'systemctl suspend'}
]
function Power_Widget(){
    return Widget.Box(
        { halign: Gtk.Align.END },
        power_options.map(option => {
            return Widget.Button({
                cssClasses: ['system-tray', 'power-button'],
                onClicked: () => execAsync(option.func),
                label: option.icon
            });
        })
    );
}

function Basic_Widgets(){
    return Widget.CenterBox({
        start_widget: Uptime_Widget(),
        end_widget: Power_Widget()
    });
}

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
const prev_temp = Variable(0.3);
const temp = Variable(0.3);
const toggle_bluelight = () => {
    if (bluelight_enabled.get()) execAsync('hyprctl hyprsunset temperature 6000');
    else execAsync(`hyprctl hyprsunset temperature ${temp.get() * 20000}`);
    bluelight_enabled.set(!bluelight_enabled.get())
    bluelight_icon.set(bluelight_enabled.get() ? '' : '')
}

let hypridle_enabled = Variable(true)
let hypridle_icon = Variable('')
const toggle_hypridle = () => {
    if (hypridle_enabled.get()) execAsync('pkill -SIGTERM hypridle');
    else execAsync(['bash', '-c', 'hypridle & disown']);
    hypridle_enabled.set(!hypridle_enabled.get());
    hypridle_icon.set(hypridle_enabled.get() ? '' : '');
}

let toggles = {
    wifi: wifi ? wifi.get_enabled() : false,
    bluetooth: bluetooth.get_is_powered(),
    bluelight: false,
}
function Toggle_Widgets(){
    return Widget.CenterBox(
        { cssClasses: ['system-tray', 'toggles'] },
        Widget.Box(
            { halign: Gtk.Align.START, orientation: Gtk.Orientation.VERTICAL },
            Widget.Button(
                { onClicked: toggle_wifi },
                Widget.Box(
                    { width_request: 200, cssClasses: wifi_enabled(enabled => enabled ? ['system-tray', 'toggled'] : ['system-tray', 'untoggled']), halign: Gtk.Align.START},
                    Widget.Label({ cssClasses: wifi_enabled(enabled => enabled ? ['system-tray', 'icon', 'toggled'] : ['system-tray', 'icon', 'untoggled']), label: network_icon() }),
                    Widget.Box(
                        { cssClasses: wifi_enabled(enabled => enabled ? ['system-tray', 'text', 'toggled'] : ['system-tray', 'text', 'untoggled']), orientation: Gtk.Orientation.VERTICAL},
                        Widget.Label({ halign: Gtk.Align.START, label: 'Wifi' }),
                        Widget.Label({ halign: Gtk.Align.START, label: wifi_enabled(enabled => enabled ? "On" : "Off") })
                    )
                )
            ),
            Widget.Button(
                { onClicked: toggle_bluelight },
                Widget.Box(
                    { width_request: 200, cssClasses: bluelight_enabled(enabled => enabled ? ['system-tray', 'toggled'] : ['system-tray', 'untoggled']), halign: Gtk.Align.START},
                    Widget.Label({ cssClasses: bluelight_enabled(enabled => enabled ? ['system-tray', 'icon', 'toggled'] : ['system-tray', 'icon', 'untoggled']), label: bluelight_icon() }),
                    Widget.Box(
                        { cssClasses: bluelight_enabled(enabled => enabled ? ['system-tray', 'text', 'toggled'] : ['system-tray', 'text', 'untoggled']), orientation: Gtk.Orientation.VERTICAL},
                        Widget.Label({ halign: Gtk.Align.START, label: 'Bluelight' }),
                        Widget.Label({ halign: Gtk.Align.START, label: bluelight_enabled(enabled => enabled ? "On" : "Off") })
                    )
                )
            )
        ),
        Widget.Box(),
        Widget.Box(
            { halign: Gtk.Align.END, orientation: Gtk.Orientation.VERTICAL },
            Widget.Button(
                { onClicked: toggle_bluetooth },
                Widget.Box(
                    { width_request: 200, cssClasses: bluetooth_enabled(enabled => enabled ? ['system-tray', 'toggled'] : ['system-tray', 'untoggled']), halign: Gtk.Align.START},
                    Widget.Label({ cssClasses: bluetooth_enabled(enabled => enabled ? ['system-tray', 'icon', 'toggled'] : ['system-tray', 'icon', 'untoggled']), label: bluetooth_icon() }),
                    Widget.Box(
                        { cssClasses: bluetooth_enabled(enabled => enabled ? ['system-tray', 'text', 'toggled'] : ['system-tray', 'text', 'untoggled']), orientation: Gtk.Orientation.VERTICAL},
                        Widget.Label({ halign: Gtk.Align.START, label: 'Bluetooth' }),
                        Widget.Label({ halign: Gtk.Align.START, label: bluetooth_enabled(enabled => enabled ? "On" : "Off") })
                    )
                )
            ),
            Widget.Button(
                { onClicked: toggle_hypridle },
                Widget.Box(
                    { width_request: 200, cssClasses: hypridle_enabled(enabled => enabled ? ['system-tray', 'toggled'] : ['system-tray', 'untoggled']), halign: Gtk.Align.START},
                    Widget.Label({ cssClasses: hypridle_enabled(enabled => enabled ? ['system-tray', 'icon', 'toggled'] : ['system-tray', 'icon', 'untoggled']), label: hypridle_icon() }),
                    Widget.Box(
                        { cssClasses: hypridle_enabled(enabled => enabled ? ['system-tray', 'text', 'toggled'] : ['system-tray', 'text', 'untoggled']), orientation: Gtk.Orientation.VERTICAL},
                        Widget.Label({ halign: Gtk.Align.START, label: 'Autolock' }),
                        Widget.Label({ halign: Gtk.Align.START, label: hypridle_enabled(enabled => enabled ? "On" : "Off") })
                    )
                )
            )
        )
    );
}

type notification_data_t = {
    id: number;
    summary: string;
    body: string;
    time: string;
};
const notifd = Notifd.get_default();
const active_notifications = Variable<notification_data_t[]>([]);
notifd.connect("notified", (_, id) => {
    let n = notifd.get_notification(id);
    const active_notifications_tmp = active_notifications.get();
    active_notifications_tmp[id] = {
        id: id,
        summary: n.summary,
        body: n.body,
        time: GLib.DateTime.new_now_local().format('%H:%M:%S')!
    };
    active_notifications.set(active_notifications_tmp);
});
function insert_newlines(str: string, n: number){
    if (str == null || str.length == 0) return ''
    const regex = new RegExp(`.{1,${n}}`, 'g');
    return str.match(regex).join('\n');
}
const Notification_Widget = () =>
<box 
    cssClasses={['notifications']} 
    halign={Gtk.Align.START}
    orientation={Gtk.Orientation.VERTICAL}
    width_request={420}
>
    <label label={'Notifications'}> </label>
    {bind(active_notifications).as(active_notifications => active_notifications.map(n => {
        return <box cssClasses={['notifications', 'entry']} orientation={Gtk.Orientation.VERTICAL}>
            <centerbox cssClasses={['notificiations', 'entry', 'summary']} orientation={Gtk.Orientation.HORIZONTAL}>
                <label label={globals.utilities.string_max(n.summary, 19)} halign={Gtk.Align.START}> </label>
                <label halign={Gtk.Align.CENTER}> </label>
                <box halign={Gtk.Align.END}>
                    <label label={n.time}> </label>
                    <button 
                        cssClasses={['notifications', 'exit']}
                        label={''}
                        halign={Gtk.Align.END}
                        onClicked={() => delete active_notifications[n.id]}
                    >
                    </button>
                </box>
            </centerbox>
            <box cssClasses={['notifications', 'entry', 'body']}>
                <label label={insert_newlines(n.body, 39)}></label>
            </box>
        </box>
    }))}
</box>

const prev_gamma = Variable(1);
const gamma = Variable(1);
function Gamma_Slider_Widget(){
    return Widget.Box(
        { orientation: Gtk.Orientation.VERTICAL },
        Widget.Label({ cssClasses: ['gamma-slider', 'text'], halign: Gtk.Align.START, label: 'Screen Brightness' }),
        Widget.Slider(
            {
                cssClasses: ['gamma-slider', 'slider'],
                visible: true,
                value: gamma(),
                min: 0.1,
                hexpand: true,
                onChangeValue: self => {
                    if (Math.abs(prev_gamma.get() - self.value) >= 1/100){
                        prev_gamma.set(gamma.get());
                        gamma.set(self.value);
                        execAsync(`hyprctl hyprsunset gamma ${self.value * 100}`)
                    }
                }
            }
        )
    );
}

function Temp_Slider_Widget(){
    return Widget.Box(
        { orientation: Gtk.Orientation.VERTICAL },
        Widget.Label({ cssClasses: ['temp-slider', 'text'], halign: Gtk.Align.START, label: 'Screen Temperature' }),
        Widget.Slider(
            {
                cssClasses: ['temp-slider', 'slider'],
                visible: true,
                value: temp(),
                min: 0.05,
                hexpand: true,
                onChangeValue: self => {
                    if (Math.abs(prev_temp.get() - self.value) >= 1/100){
                        prev_temp.set(temp.get());
                        temp.set(self.value);
                        if (!bluelight_enabled.get()) return;
                        execAsync(`hyprctl hyprsunset temperature ${self.value * 20000}`)
                    }
                }
            }
        )
    );
}

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

function spawn_sysmenu(){
    system_menu.touched = true;
    if (system_menu.menu) return;
    system_menu.menu = Widget.Window(
        {
            cssClasses: ['system-tray', 'window'],
            exclusivity: Astal.Exclusivity.NORMAL,
            anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT,
            application: App,
            layer: Astal.Layer.OVERLAY,
            width_request: 50,
            visible: true
        },
        Widget.Box(
            { onHoverEnter: () => system_menu.touched = true, onHoverLeave: hide_system_menu },
            Widget.CenterBox(
                { cssClasses: ['system-tray', 'menu'], orientation: Gtk.Orientation.VERTICAL },
                Widget.Box(
                    { valign: Gtk.Align.START, orientation: Gtk.Orientation.VERTICAL },
                    Basic_Widgets(),
                    Toggle_Widgets(),
                    Gamma_Slider_Widget(),
                    Temp_Slider_Widget(),
                    Notification_Widget()
                ),
                Widget.Box(),
                Widget.Box()
            )
        )

    );
}

function Sysmenu_Widget(){
    return Widget.Button(
        { cssClasses: ['system-tray', 'bar'], onHoverEnter: () => system_menu.touched = true, onHoverLeave: hide_system_menu, onClicked: spawn_sysmenu },
        Widget.Box(
            {},
            Widget.Label({ cssClasses: ['system-tray', 'network-icon'], label: network_icon() }),
            Widget.Label({ cssClasses: ['system-tray', 'bluetooth-icon'], label: bluetooth_icon() }),
        )
    )
}

export{
    Sysmenu_Widget
}
