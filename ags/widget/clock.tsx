import { Gtk } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"

import { userOptions } from './settings'

const time = Variable('').poll(userOptions.time.interval, () => GLib.DateTime.new_now_local().format(userOptions.time.format)!)
const date = Variable('').poll(userOptions.date.interval, () => GLib.DateTime.new_now_local().format(userOptions.date.format)!)
const Clock = () =>
////orientation={Gtk.Orientation.VERTICAL}>
<box className={'clock'}>
    <label
        className="clock time"
        onDestroy={() => time.drop()}
        label={time()}
        halign={Gtk.Align.END}
    />
    <label
        className="clock date"
        onDestroy={() => date.drop()}
        label={date()}
        halign={Gtk.Align.END}
    />
</box>

export{
    Clock
}
