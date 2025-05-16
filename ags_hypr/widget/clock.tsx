import { bind  } from "astal"
import { datetime_ctx } from "./types"
import Gtk from "gi://Gtk?version=3.0";

const Clock_Widget = () =>
<box className={'clock'}>
    <label
        className="clock time"
        label={bind(datetime_ctx).as(datetime => datetime.format('%H:%M:%S')!)}
    />
    <label label={' • '}/>
    <label
        className="clock date"
        label={bind(datetime_ctx).as(datetime => datetime.format('%A, %d/%m')!)}
    />
</box>

/*
const Clock_Widget = () =>
<box className={'clock'} orientation={Gtk.Orientation.VERTICAL}>
    <label
        className="clock date"
        label={bind(datetime_ctx).as(datetime => datetime.format('%A, %d/%m')!)}
    />
    <label
        halign={Gtk.Align.END}
        className="clock time"
        label={bind(datetime_ctx).as(datetime => datetime.format('%H:%M:%S')!)}
    />
</box>
*/

export{
    Clock_Widget
};
