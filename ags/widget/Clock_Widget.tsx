import { Widget } from "astal/gtk4";
import { bind, } from "astal";
import { globals } from "./Globals";

function Clock_Widget(){
    return Widget.Box(
        { cssClasses: ['clock'] },
        Widget.Label({ cssClasses: ['clock', 'time'], label: bind(globals.datetime).as(datetime => datetime.format('%H:%M:%S')!) }),
        Widget.Label({ cssClasses: ['clock', 'separator'], label: ' • '}),
        Widget.Label({ cssClasses: ['clock', 'date'], label: bind(globals.datetime).as(datetime => datetime.format('%A, %d/%B/%y')!) })
    );
}

export { Clock_Widget };
