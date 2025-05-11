import { Variable, GLib  } from "astal"

const fmted_time = Variable('').poll(1000, () => GLib.DateTime.new_now_local().format('%H:%M:%S')!)
const fmted_date = Variable('').poll(1000, () => GLib.DateTime.new_now_local().format('%A, %d/%m')!)

const Clock_Widget = () =>
<box className={'clock'}>
    <label
        className="clock time"
        label={fmted_time()}
    />
    <label label={'•'}/>
    <label
        className="clock date"
        label={fmted_date()}
    />
</box>

export{
    Clock_Widget
}
