import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';

import { format_string, format_percent } from "./utilities";
import { userOptions } from './settings'

const prevCpuData = Variable(new GTop.glibtop_cpu())
const cpuUsageFlt = Variable(0).poll(userOptions.cpu.interval, () => {
    const currCpuData = new GTop.glibtop_cpu()
    GTop.glibtop_get_cpu(currCpuData)
    const totalDiff = currCpuData.total - prevCpuData.get().total;
    const idleDiff = currCpuData.idle - prevCpuData.get().idle;
    prevCpuData.set(currCpuData)
    return totalDiff > 0 ? (totalDiff - idleDiff) / totalDiff : 0;
})
const cpuUsageFmt = () => cpuUsageFlt(usage => format_string(userOptions.cpu.format, {cpu: format_percent(usage, 3)}))

const Cpu = () =>
<box className="cpu">
    <CircularProgress className={'cpu circ'}
        value={cpuUsageFlt()}
        inverted={true}
        rounded={true}
    />
    <label
        className="cpu pct"
        label={cpuUsageFmt()}
    />
</box>

export{
    Cpu
}
