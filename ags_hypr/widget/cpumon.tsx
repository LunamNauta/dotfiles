import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';
import { format_percent } from "./utilities";
import Gtk from "gi://Gtk";

const prev_cpu_data = Variable(new GTop.glibtop_cpu())
const flt_cpu_usage = Variable(0).poll(1000, () => {
    const curr_cpu_data = new GTop.glibtop_cpu()
    GTop.glibtop_get_cpu(curr_cpu_data)
    const total_dif = curr_cpu_data.total - prev_cpu_data.get().total;
    const idle_dif = curr_cpu_data.idle - prev_cpu_data.get().idle;
    prev_cpu_data.set(curr_cpu_data)
    if (total_dif <= 0) return 0;
    return (total_dif - idle_dif) / total_dif;
})
const fmted_cpu_usage = () => flt_cpu_usage(usage =>  format_percent(usage, 3) + '%')

const CPUMon_Widget = () =>
<box className="cpumon">
    <circularprogress className={'cpumon circ'}
        value={flt_cpu_usage()}
        inverted={true}
        rounded={true}
    >
        <box halign={Gtk.Align.START} valign={Gtk.Align.START}>
            <label className={'cpumon circ-icon'} label={''} />
        </box>
    </circularprogress>
    <label
        className="cpumon pct"
        label={fmted_cpu_usage()}
    />
</box>

export{
    CPUMon_Widget
}
