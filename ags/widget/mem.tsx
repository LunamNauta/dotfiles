import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';

import { format_string, round_decimal } from "./utilities";
import { userOptions } from './settings'

const memUsage = Variable(0).poll(userOptions.memory.interval, () => {
    const data = new GTop.glibtop_mem()
    GTop.glibtop_get_mem(data)
    const usage = data.user / data.total
    return usage
});
const Mem = () =>
<box className="mem">
    <CircularProgress className={'mem circ'}
        value={memUsage()}
        inverted={true}
        rounded={true}
    />
    <label
        className="mem pct"
        label={bind(memUsage).as(usage => format_string(userOptions.memory.format, {mem: round_decimal(usage, 3)}))}
    />
</box>

export{
    Mem
}
