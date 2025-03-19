import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';

import { format_string, format_percent } from "./utilities";
import { userOptions } from './settings'

const memUsageFlt = Variable(0).poll(userOptions.memory.interval, () => {
    const memData = new GTop.glibtop_mem()
    GTop.glibtop_get_mem(memData)
    return memData.user / memData.total
});
const memUsageFmt = () => memUsageFlt(usage => format_string(userOptions.memory.format, {mem: format_percent(usage, 3)}))

const Mem = () =>
<box className="mem">
    <CircularProgress className={'mem circ'}
        value={memUsageFlt()}
        inverted={true}
        rounded={true}
    />
    <label
        className="mem pct"
        label={memUsageFmt()}
    />
</box>

export{
    Mem
}
