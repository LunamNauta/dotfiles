import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';
import { format_percent } from "./utilities";

const flt_mem_usage = Variable(0).poll(1000, () => {
    const mem_data = new GTop.glibtop_mem()
    GTop.glibtop_get_mem(mem_data)
    return mem_data.user / mem_data.total
});
const fmted_mem_usage = () => flt_mem_usage(usage => format_percent(usage, 3) + '%')

const MemMon_Widget = () =>
<box className="memmon">
    <circularprogress className={'memmon circ'}
        value={flt_mem_usage()}
        inverted={true}
        rounded={true}
    >
        <box>
            <label className={'memmon circ-icon'} label={''} />
        </box>
    </circularprogress>
    <label
        className="memmon pct"
        label={fmted_mem_usage()}
    />
</box>

export{
    MemMon_Widget
}
