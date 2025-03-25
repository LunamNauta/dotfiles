import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';
import AstalBattery from "gi://AstalBattery"

import { format_string, format_percent } from "./utilities";
import { userOptions } from './settings'

const battery = AstalBattery.get_default()
const has_battery = battery.get_online()
const battery_icon = Variable('󱃍')
const battery_discharge = Variable(battery.get_energy_rate())
const battery_pct = Variable(0).poll(userOptions.battery.interval, () => {
    battery_discharge.set(battery.get_energy_rate())
    const pct = battery.get_energy() / battery.get_energy_full()
    if (battery.get_charging()){
        if (pct > 0.9) battery_icon.set('󰂅')
        else if (pct > 0.8) battery_icon.set('󰂋')
        else if (pct > 0.7) battery_icon.set('󰂊')
        else if (pct > 0.6) battery_icon.set('󰢞')
        else if (pct > 0.5) battery_icon.set('󰂉')
        else if (pct > 0.4) battery_icon.set('󰢝')
        else if (pct > 0.3) battery_icon.set('󰂈')
        else if (pct > 0.2) battery_icon.set('󰂇')
        else if (pct > 0.1) battery_icon.set('󰂆')
        else battery_icon.set('󰢜')
    }
    else{
        if (pct > 0.9) battery_icon.set('󰁹')
        else if (pct > 0.8) battery_icon.set('󰂂')
        else if (pct > 0.7) battery_icon.set('󰂁')
        else if (pct > 0.6) battery_icon.set('󰂀')
        else if (pct > 0.5) battery_icon.set('󰁿')
        else if (pct > 0.4) battery_icon.set('󰁾')
        else if (pct > 0.3) battery_icon.set('󰁽')
        else if (pct > 0.2) battery_icon.set('󰁼')
        else if (pct > 0.1) battery_icon.set('󰁻')
        else battery_icon.set('󱃍')
    }
    return pct
});
const battery_pct_format = () => battery_pct(full => format_string(userOptions.battery.format_pct, {battery: format_percent(full, 3)}))
const battery_dis_format = () => {
    return battery_discharge(dis => `${dis} W - ${Math.floor(battery.get_energy() / dis)}h, ${Math.floor(60 * ((battery.get_energy() / dis) % 1))}m`)
}

const Battery = () =>
<box className="bat">
    <circularprogress className={'bat circ'}
        value={battery_pct()}
        inverted={true}
        rounded={true}
    >
        <box>
            <label className={'bat circ-icon'} label={battery_icon()} />
        </box>
    </circularprogress>
    <eventbox tooltip_text={battery_dis_format()}>
        <label
            className="bat pct"
            label={battery_pct_format()}
        />
    </eventbox>
</box>

export{
    Battery,
    has_battery
}
