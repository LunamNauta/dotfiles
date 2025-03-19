import { Variable, GLib  } from "astal"

import { userOptions } from './settings'

const timeFmt = Variable('').poll(userOptions.time.interval, () => GLib.DateTime.new_now_local().format(userOptions.time.format)!)
const dateFmt = Variable('').poll(userOptions.date.interval, () => GLib.DateTime.new_now_local().format(userOptions.date.format)!)

const Clock = () =>
<box className={'clock'}>
    <label
        className="clock time"
        onDestroy={() => timeFmt.drop()}
        label={timeFmt()}
    />
    <label
        className="clock date"
        onDestroy={() => dateFmt.drop()}
        label={dateFmt()}
    />
</box>

export{
    Clock
}
